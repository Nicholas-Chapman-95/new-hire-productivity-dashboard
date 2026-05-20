import { spawn } from 'node:child_process';
import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.resolve(__dirname, '..');
const configPath = path.join(projectRoot, 'evidence.config.yaml');

function getRepoName() {
  const explicit = process.env.GITHUB_PAGES_REPO_NAME ?? process.argv[2];
  if (explicit) return explicit;

  const githubRepository = process.env.GITHUB_REPOSITORY;
  if (githubRepository?.includes('/')) {
    return githubRepository.split('/')[1];
  }

  throw new Error(
    'Missing repo name. Set GITHUB_PAGES_REPO_NAME or pass the repo name as the first argument.'
  );
}

function normalizeBasePath(value) {
  if (value === undefined) return undefined;
  if (value === '' || value === '/') return '';

  const trimmed = value.endsWith('/') ? value.slice(0, -1) : value;
  return trimmed.startsWith('/') ? trimmed : `/${trimmed}`;
}

function withDeploymentBasePath(content, basePath) {
  const lines = content.replace(/\r\n/g, '\n').split('\n');
  const output = [];

  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index];
    if (!line.startsWith('deployment:')) {
      output.push(line);
      continue;
    }

    index += 1;
    while (
      index < lines.length &&
      (lines[index].startsWith(' ') || lines[index].startsWith('\t') || lines[index] === '')
    ) {
      index += 1;
    }
    index -= 1;
  }

  let nextContent = output.join('\n').trimEnd();
  if (basePath) {
    nextContent = `${nextContent}\n\ndeployment:\n  basePath: ${basePath}\n`;
  } else {
    nextContent = `${nextContent}\n`;
  }

  return nextContent;
}

function runEvidenceBuild(buildDir) {
  return new Promise((resolve, reject) => {
    const child = spawn('npx', ['evidence', 'build'], {
      cwd: projectRoot,
      stdio: 'inherit',
      env: {
        ...process.env,
        EVIDENCE_BUILD_DIR: buildDir
      }
    });

    child.on('exit', (code) => {
      if (code === 0) {
        resolve();
        return;
      }
      reject(new Error(`evidence build exited with code ${code ?? 'unknown'}`));
    });

    child.on('error', reject);
  });
}

const repoName = getRepoName();
const basePath = normalizeBasePath(process.env.GITHUB_PAGES_BASE_PATH ?? `/${repoName}`);
const buildDir = process.env.EVIDENCE_BUILD_DIR ?? `./build/${repoName}`;
const originalConfig = await fs.readFile(configPath, 'utf8');

await fs.writeFile(configPath, withDeploymentBasePath(originalConfig, basePath), 'utf8');

try {
  await runEvidenceBuild(buildDir);
} finally {
  await fs.writeFile(configPath, originalConfig, 'utf8');
}
