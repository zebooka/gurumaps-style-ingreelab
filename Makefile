.PHONY: help dark-colors build publish clean
.DEFAULT := help

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(dir $(MAKEFILE_PATH))
RELEASE := $$(git describe --tags --candidates=0 2>/dev/null)
BUILD_DIR := $(CURRENT_DIR)build
ASSET := test-$(RELEASE)

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ \
	{ printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)



##@ Development

dark-colors:
	php ./generate-dark-colors.php
	git status --short

##@ Release

build: clean ## Build new release assets
	git status --short
	git describe --tags --candidates=0
	#test -z "$$(git status --porcelain)" && exit $?
	awk -v ver=$(RELEASE) '/^## / { if (p) { exit }; if ($$2 == ver) { p=1; next } } p && NF' CHANGELOG.md > $(BUILD_DIR)/$(ASSET).CHANGELOG.md
	cp CHANGELOG.md "Ingreelab HD.style/"
	cp README.md "Ingreelab HD.style/"
	tar -czvf $(BUILD_DIR)/$(ASSET).tar.gz "Ingreelab HD.style/"
	zip -r $(BUILD_DIR)/$(ASSET).zip "Ingreelab HD.style/"

publish: build ## Publish new release to GitHub
	cd $(BUILD_DIR) && gh release create "$(RELEASE)" -F $(BUILD_DIR)/$(ASSET).CHANGELOG.md "$(ASSET).tar.gz#Release (tar.gz)" "$(ASSET).zip#Release (zip)"

clean: ## Clean
	test -d $(BUILD_DIR) || mkdir -p $(BUILD_DIR)
	rm -rfv cd $(BUILD_DIR)/*.CHANGELOG.md $(BUILD_DIR)/*.tar.gz $(BUILD_DIR)/*.zip
