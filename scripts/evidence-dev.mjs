import fs from 'fs-extra';
import { spawn } from 'child_process';
import * as chokidar from 'chokidar';
import path from 'path';
import { fileURLToPath } from 'url';
import { loadEnv } from 'vite';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.resolve(__dirname, '..');
const evidencePackageDir = path.resolve(projectRoot, 'node_modules', '@evidence-dev', 'evidence');
const templateSrc = path.join(evidencePackageDir, 'template');
const templateDest = path.join(projectRoot, '.evidence', 'template');
const generatedStateDirs = [
  path.join(templateDest, '.svelte-kit'),
  path.join(templateDest, 'node_modules', '.vite')
];

const keepers = new Set(['.profile.json', 'static', '.evidence-queries']);
const ignoredFiles = [
  '**/.DS_Store',
  '**/.git/**',
  '**/.*/**',
  '**/pages/explore/**',
  '**/pages/settings/**',
  '**/pages/api/**'
];

const watchPatterns = [
  { sourceRelative: 'pages', targetRelative: path.join('.evidence', 'template', 'src', 'pages') },
  { sourceRelative: 'static', targetRelative: path.join('.evidence', 'template', 'static') },
  { sourceRelative: 'sources', targetRelative: path.join('.evidence', 'template', 'sources') },
  { sourceRelative: 'queries', targetRelative: path.join('.evidence', 'template', 'queries') },
  { sourceRelative: 'components', targetRelative: path.join('.evidence', 'template', 'src', 'components') },
  { sourceRelative: 'partials', targetRelative: path.join('.evidence', 'template', 'partials') },
  { sourceRelative: '.', filePattern: 'app.css', targetRelative: path.join('.evidence', 'template', 'src') }
];
const generatedStateErrorPatterns = [
  "Cannot find module '__SERVER__/internal.js'",
  'Failed to load url /.svelte-kit/generated/server/internal.js',
  'generated/server/internal.js',
  '__SERVER__/internal.js'
];

function increaseNodeMemoryLimit() {
  if (process.env.NODE_OPTIONS?.includes('--max-old-space-size')) return;
  process.env.NODE_OPTIONS = `${process.env.NODE_OPTIONS || ''} --max-old-space-size=4096`.trim();
}

function loadEnvFile() {
  const envFile = loadEnv('', projectRoot, ['EVIDENCE_', 'VITE_']);
  Object.assign(process.env, envFile);
}

function clearQueryCache() {
  fs.removeSync(path.join(templateDest, '.evidence-queries', 'cache'));
}

function populateTemplate() {
  clearQueryCache();
  fs.ensureDirSync(templateDest);

  for (const entry of fs.readdirSync(templateDest)) {
    if (!keepers.has(entry)) {
      fs.removeSync(path.join(templateDest, entry));
    }
  }

  fs.copySync(templateSrc, templateDest);
}

function rebuildTemplateState() {
  populateTemplate();
  initialSync();
}

function clearGeneratedState() {
  for (const dir of generatedStateDirs) {
    fs.removeSync(dir);
  }
}

function pagePath(targetPath) {
  if (!targetPath.includes(`${path.sep}src${path.sep}pages${path.sep}`) && !targetPath.endsWith(`${path.sep}pages`)) {
    return targetPath;
  }
  if (targetPath.endsWith('index.md')) {
    return targetPath.replace(/index\.md$/, '+page.md');
  }
  return targetPath.replace(/\.md$/, `${path.sep}+page.md`);
}

function targetPath(pattern, sourceFile) {
  const sourceRoot = path.join(projectRoot, pattern.sourceRelative);
  const targetRoot = path.join(projectRoot, pattern.targetRelative);
  return path.join(targetRoot, path.relative(sourceRoot, sourceFile));
}

function syncFile(pattern, sourceFile) {
  const fullSourceFile = path.resolve(sourceFile);
  if (!fs.existsSync(fullSourceFile) || !fs.statSync(fullSourceFile).isFile()) return;

  const targetFile = pagePath(targetPath(pattern, fullSourceFile));
  fs.ensureDirSync(path.dirname(targetFile));

  if (path.basename(fullSourceFile) === 'app.css') {
    const baseCssPath = path.join(templateSrc, 'src', 'app.css');
    const baseCss = fs.existsSync(baseCssPath) ? fs.readFileSync(baseCssPath, 'utf8').trimEnd() : '';
    const customCss = fs.readFileSync(fullSourceFile, 'utf8').trim();
    const mergedCss = customCss ? `${baseCss}\n\n/* Project overrides */\n${customCss}\n` : `${baseCss}\n`;
    fs.writeFileSync(targetFile, mergedCss);
    return;
  }

  fs.copyFileSync(fullSourceFile, targetFile);
}

function removeFile(pattern, sourceFile) {
  const targetFile = pagePath(targetPath(pattern, path.resolve(sourceFile)));
  fs.removeSync(targetFile);
}

function initialSync() {
  for (const pattern of watchPatterns) {
    const sourceRoot = path.join(projectRoot, pattern.sourceRelative);
    if (!fs.existsSync(sourceRoot)) continue;

    if (pattern.filePattern === 'app.css') {
      const appCssPath = path.join(sourceRoot, 'app.css');
      if (fs.existsSync(appCssPath)) syncFile(pattern, appCssPath);
      continue;
    }

    for (const sourceFile of fs.readdirSync(sourceRoot, { recursive: true })) {
      const fullSourceFile = path.join(sourceRoot, sourceFile);
      if (!fs.existsSync(fullSourceFile)) continue;
      const stat = fs.statSync(fullSourceFile);
      if (!stat.isFile()) continue;
      if (pattern.sourceRelative === 'pages' && path.extname(fullSourceFile) !== '.md') continue;
      syncFile(pattern, fullSourceFile);
    }
  }
}

function runFileWatchers() {
  const pendingRemovals = new Map();
  const watchers = [];

  const scheduleRemoval = (key, fn) => {
    const existing = pendingRemovals.get(key);
    if (existing) clearTimeout(existing);
    pendingRemovals.set(
      key,
      setTimeout(() => {
        pendingRemovals.delete(key);
        fn();
      }, 1000)
    );
  };

  const cancelRemoval = (key) => {
    const existing = pendingRemovals.get(key);
    if (existing) {
      clearTimeout(existing);
      pendingRemovals.delete(key);
    }
  };

  for (const pattern of watchPatterns) {
    const watchTarget =
      pattern.filePattern === 'app.css'
        ? path.join(projectRoot, pattern.filePattern)
        : path.join(projectRoot, pattern.sourceRelative, '**');

    const watcher = chokidar.watch(watchTarget, {
      cwd: projectRoot,
      ignoreInitial: true,
      ignored: ignoredFiles,
      atomic: true,
      awaitWriteFinish: {
        stabilityThreshold: 200,
        pollInterval: 50
      }
    });

    watcher
      .on('add', (file) => {
        cancelRemoval(`${pattern.sourceRelative}:${file}`);
        syncFile(pattern, file);
      })
      .on('change', (file) => {
        cancelRemoval(`${pattern.sourceRelative}:${file}`);
        syncFile(pattern, file);
      })
      .on('unlink', (file) => {
        scheduleRemoval(`${pattern.sourceRelative}:${file}`, () => removeFile(pattern, file));
      })
      .on('addDir', (dir) => {
        cancelRemoval(`${pattern.sourceRelative}:${dir}`);
        fs.ensureDirSync(targetPath(pattern, path.resolve(dir)));
      })
      .on('unlinkDir', (dir) => {
        scheduleRemoval(`${pattern.sourceRelative}:${dir}`, () =>
          fs.removeSync(targetPath(pattern, path.resolve(dir)))
        );
      });

    watchers.push(watcher);
  }

  return watchers;
}

function runDevServer(args) {
  const manifestPath = path.join(templateDest, 'static', 'data', 'manifest.json');
  if (!fs.existsSync(manifestPath)) {
    console.warn('[!] Unable to load source manifest. Run `npm run sources` if data is missing.');
  }

  clearGeneratedState();

  return spawn('npx', ['vite', 'dev', '--port', '3000', ...args], {
    shell: false,
    cwd: templateDest,
    stdio: ['ignore', 'pipe', 'pipe'],
    env: {
      ...process.env,
      EVIDENCE_DATA_URL_PREFIX: process.env.EVIDENCE_DATA_URL_PREFIX ?? 'static/data',
      EVIDENCE_DATA_DIR: process.env.EVIDENCE_DATA_DIR ?? './static/data'
    }
  });
}

increaseNodeMemoryLimit();
loadEnvFile();
rebuildTemplateState();

const forwardedArgs = process.argv.slice(2);
const watchers = runFileWatchers();
let shuttingDown = false;
let restarting = false;
let child = runDevServer(forwardedArgs);

const shutdown = () => {
  shuttingDown = true;
  if (child && !child.killed) {
    child.kill();
  }
  for (const watcher of watchers) watcher.close();
};

const attachChildHandlers = () => {
  const attachStream = (stream, target) => {
    if (!stream) return;
    stream.on('data', (chunk) => {
      const text = chunk.toString();
      target.write(chunk);

      if (
        !restarting &&
        generatedStateErrorPatterns.some((pattern) => text.includes(pattern))
      ) {
        restarting = true;
        console.error('[evidence-dev] Detected broken generated state. Restarting Vite...');
        if (child && !child.killed) {
          child.kill();
        }
      }
    });
  };

  attachStream(child.stdout, process.stdout);
  attachStream(child.stderr, process.stderr);

  child.on('error', (error) => {
    console.error('[evidence-dev] Vite process error:', error);
  });

  child.on('exit', (code, signal) => {
    if (shuttingDown) {
      return;
    }

    console.error(
      `[evidence-dev] Vite exited unexpectedly${code !== null ? ` with code ${code}` : ''}${
        signal ? ` (signal ${signal})` : ''
      }. Restarting...`
    );

    setTimeout(() => {
      if (shuttingDown) return;
      restarting = false;
      rebuildTemplateState();
      child = runDevServer(forwardedArgs);
      attachChildHandlers();
    }, 500);
  });
};

attachChildHandlers();

process.on('SIGINT', () => {
  shutdown();
  process.exit(130);
});

process.on('SIGTERM', () => {
  shutdown();
  process.exit(143);
});

process.on('uncaughtException', (error) => {
  console.error('[evidence-dev] Uncaught exception:', error);
});

process.on('unhandledRejection', (error) => {
  console.error('[evidence-dev] Unhandled rejection:', error);
});
