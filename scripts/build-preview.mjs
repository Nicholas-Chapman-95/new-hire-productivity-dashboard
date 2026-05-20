import fs from 'fs-extra';
import path from 'path';
import { spawn } from 'child_process';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.resolve(__dirname, '..');
const evidencePackageDir = path.resolve(projectRoot, 'node_modules', '@evidence-dev', 'evidence');
const templateSrc = path.join(evidencePackageDir, 'template');
const templateDest = path.join(projectRoot, '.evidence', 'template');
const previewBuildDir = path.join(projectRoot, 'build');

const keepers = new Set(['.profile.json', 'static', '.evidence-queries']);
const syncPatterns = [
  {
    sourceRelative: 'static',
    targetRelative: path.join('.evidence', 'template', 'static')
  },
  {
    sourceRelative: 'sources',
    targetRelative: path.join('.evidence', 'template', 'sources')
  },
  {
    sourceRelative: 'queries',
    targetRelative: path.join('.evidence', 'template', 'queries')
  },
  {
    sourceRelative: 'components',
    targetRelative: path.join('.evidence', 'template', 'src', 'components')
  },
  {
    sourceRelative: 'partials',
    targetRelative: path.join('.evidence', 'template', 'partials')
  }
];

function pagePath(targetPath) {
  if (!targetPath.includes(`${path.sep}pages${path.sep}`) && !targetPath.endsWith(`${path.sep}pages`)) {
    return targetPath;
  }
  if (targetPath.endsWith('index.md')) {
    return targetPath.replace(/index\.md$/, '+page.md');
  }
  return targetPath.replace(/\.md$/, `${path.sep}+page.md`);
}

function populateTemplate() {
  fs.ensureDirSync(templateDest);
  for (const entry of fs.readdirSync(templateDest)) {
    if (!keepers.has(entry)) {
      fs.removeSync(path.join(templateDest, entry));
    }
  }
  fs.copySync(templateSrc, templateDest);
}

function syncProjectFiles() {
  for (const pattern of syncPatterns) {
    const sourcePath = path.join(projectRoot, pattern.sourceRelative);
    if (!fs.existsSync(sourcePath)) continue;

    fs.copySync(sourcePath, path.join(projectRoot, pattern.targetRelative), {
      filter: (src) => {
        const relative = path.relative(sourcePath, src);
        if (!relative || relative === '') return true;
        return !relative.split(path.sep).some((segment) => segment.startsWith('.'));
      }
    });
  }

  const appCssSource = path.join(projectRoot, 'app.css');
  if (fs.existsSync(appCssSource)) {
    const templateAppCss = path.join(templateDest, 'src', 'app.css');
    const baseCss = fs.existsSync(templateAppCss) ? fs.readFileSync(templateAppCss, 'utf8').trimEnd() : '';
    const customCss = fs.readFileSync(appCssSource, 'utf8').trim();
    const mergedCss = customCss ? `${baseCss}\n\n/* Project overrides */\n${customCss}\n` : `${baseCss}\n`;
    fs.writeFileSync(templateAppCss, mergedCss);
  }

  const pagesRoot = path.join(projectRoot, 'pages');
  if (fs.existsSync(pagesRoot)) {
    const targetRoot = path.join(templateDest, 'src', 'pages');
    for (const sourceFile of fs.readdirSync(pagesRoot, { recursive: true })) {
      const fullSourceFile = path.join(pagesRoot, sourceFile);
      const stat = fs.statSync(fullSourceFile);
      if (!stat.isFile() || path.extname(fullSourceFile) !== '.md') continue;
      const targetFile = pagePath(path.join(targetRoot, sourceFile));
      fs.ensureDirSync(path.dirname(targetFile));
      fs.copyFileSync(fullSourceFile, targetFile);
    }
  }
}

function runBuild() {
  fs.ensureDirSync(path.join(templateDest, '.svelte-kit', 'output', 'server'));
  fs.removeSync(previewBuildDir);

  return new Promise((resolve, reject) => {
    const child = spawn('npx vite build', {
      shell: true,
      cwd: templateDest,
      stdio: 'inherit',
      env: {
        ...process.env,
        EVIDENCE_DATA_URL_PREFIX: process.env.EVIDENCE_DATA_URL_PREFIX ?? 'static/data',
        EVIDENCE_DATA_DIR: process.env.EVIDENCE_DATA_DIR ?? './static/data',
        EVIDENCE_BUILD_DIR: previewBuildDir,
        EVIDENCE_IS_BUILDING: 'true'
      }
    });

    child.on('exit', (code) => {
      if (code === 0) {
        resolve();
        return;
      }
      reject(new Error(`vite build exited with code ${code}`));
    });
  });
}

populateTemplate();
syncProjectFiles();
await runBuild();
