.PHONY: dev refresh check doctor

SHELL := /bin/zsh
REPO_ROOT := $(abspath ../..)
NVM_DIR ?= $(HOME)/.nvm
NVM_INIT = export NVM_DIR="$(NVM_DIR)"; [ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh" || true
NODE_VERSION_CHECK = node -e "const v=process.versions.node.split('.')[0]; if (v !== '22') { console.error('Expected Node 22 from .nvmrc, got ' + process.version + '. Load nvm or switch Node before running the dashboard.'); process.exit(1); }"

dev:
	@$(NVM_INIT); \
	nvm use >/dev/null 2>&1 || true; \
	$(NODE_VERSION_CHECK); \
	npm run dev

refresh:
	@$(NVM_INIT); \
	nvm use >/dev/null 2>&1 || true; \
	$(NODE_VERSION_CHECK); \
	DUCKDB_EXTENSION_DIRECTORY=.duckdb_extensions npm run sources:strict && npm run dev

check:
	$(MAKE) -C $(REPO_ROOT) site-check

doctor:
	@$(NVM_INIT); \
	nvm use >/dev/null 2>&1 || true; \
	echo "node $$(node -v)"; \
	echo "npm $$(npm -v)"; \
	echo "expected node $$(cat .nvmrc)"
