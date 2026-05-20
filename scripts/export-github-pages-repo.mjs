import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.resolve(__dirname, '..');
const repoRoot = path.resolve(projectRoot, '..', '..');
const defaultOutputDir = path.resolve(projectRoot, '..', 'github-pages-export');
const outputDir = path.resolve(process.argv[2] ?? defaultOutputDir);

const ignoredNames = new Set([
  '.DS_Store',
  '.duckdb_extensions',
  '.evidence',
  'build',
  'node_modules',
  'test-results'
]);

async function copyDirectory(sourceDir, targetDir) {
  await fs.mkdir(targetDir, { recursive: true });
  const entries = await fs.readdir(sourceDir, { withFileTypes: true });

  for (const entry of entries) {
    if (ignoredNames.has(entry.name)) continue;

    const sourcePath = path.join(sourceDir, entry.name);
    const targetPath = path.join(targetDir, entry.name);

    if (entry.isDirectory()) {
      await copyDirectory(sourcePath, targetPath);
      continue;
    }

    await fs.copyFile(sourcePath, targetPath);
  }
}

async function main() {
  await fs.rm(outputDir, { recursive: true, force: true });
  await copyDirectory(projectRoot, outputDir);

  const sourceDuckDb = path.join(repoRoot, '04_outputs', 'data', 'productivity.duckdb');
  const targetDuckDb = path.join(outputDir, 'data', 'productivity.duckdb');
  await fs.mkdir(path.dirname(targetDuckDb), { recursive: true });
  await fs.copyFile(sourceDuckDb, targetDuckDb);

  const connectionPath = path.join(outputDir, 'sources', 'productivity', 'connection.yaml');
  await fs.writeFile(
    connectionPath,
    ['name: productivity', 'type: duckdb', 'options:', '  filename: ../../data/productivity.duckdb', ''].join('\n'),
    'utf8'
  );

  console.log(`Standalone GitHub Pages repo staged at ${outputDir}`);
  console.log('Next steps: create a new GitHub repo, copy this folder into it, then push and enable GitHub Pages via Actions.');
}

await main();
