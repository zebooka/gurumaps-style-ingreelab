.PHONY: help dark-colors build prerelease release clean
.DEFAULT := help

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(dir $(MAKEFILE_PATH))
RELEASE := $$(git describe --tags --candidates=0 2>/dev/null || (git describe --all | sed 's|^heads/||'; git log -1 --format="dev-%ad-%h" --date=short) | tr '\n ' '--' | sed 's|-$$||')
TAG := $$(git describe --tags --candidates=0 2>/dev/null)
BUILD_DIR := "$(CURRENT_DIR)build"
ASSET := "Ingreelab-$(RELEASE)"
INGREELAB_DIR := "Ingreelab HD.style/"

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
	git status --short; test -z "$$(git status --porcelain)" || (echo "\033[1;7;31m > Please commit changes. < \033[0m" && exit 1)
	test -d $(BUILD_DIR) || mkdir -p $(BUILD_DIR)
	awk -v ver=$(TAG) '/^## / { if (p) { exit }; if ($$2 == ver) { p=1; next } } p && NF' CHANGELOG.md > $(BUILD_DIR)/$(ASSET).CHANGELOG.md
	test -s $(BUILD_DIR)/$(ASSET).CHANGELOG.md || awk -v ver=$$(echo $(RELEASE) | tr '-' ' ' | awk '{ print $$1 }' | tr v. '  ' | awk '{ printf "v%d.%d.%d", $$1, $$2, $$3 }') '/^## / { if (p) { exit }; if ($$2 == ver) { p=1; next } } p && NF' CHANGELOG.md > $(BUILD_DIR)/$(ASSET).CHANGELOG.md
	cp {CHANGELOG.md,README.md,screenshot.jpg} $(INGREELAB_DIR)
	tar -czvf $(BUILD_DIR)/$(ASSET).tar.gz $(INGREELAB_DIR)
	zip -r $(BUILD_DIR)/$(ASSET).zip $(INGREELAB_DIR)

prerelease: build ## Publish new prerelease to GitHub
	git describe --tags --candidates=0 || (echo "\033[1;7;31m > Please create and push tag to make prerelease. < \033[0m" >&2 && exit 1)
	cd $(BUILD_DIR) && gh release create "$(TAG)" -p -F $(BUILD_DIR)/$(ASSET).CHANGELOG.md "$(ASSET).tar.gz#PreRelease (tar.gz)" "$(ASSET).zip#PreRelease (zip)"

release: build ## Publish new release to GitHub
	git describe --tags --candidates=0 || (echo "\033[1;7;31m > Please create and push tag to make release. < \033[0m" >&2 && exit 1)
	cd $(BUILD_DIR) && gh release create "$(TAG)" -F $(BUILD_DIR)/$(ASSET).CHANGELOG.md "$(ASSET).tar.gz#Release (tar.gz)" "$(ASSET).zip#Release (zip)"

clean: ## Clean
	rm -fv $(BUILD_DIR)/{*.CHANGELOG.md,*.tar.gz,*.zip} $(INGREELAB_DIR)/{CHANGELOG.md,README.md,screenshot.jpg}
