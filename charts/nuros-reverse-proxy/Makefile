# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

# Makefile for Helm chart version management
.PHONY: version-show version-bump-patch version-bump-minor version-bump-major set-chart-version set-app-version

CHART_FILE := Chart.yaml

# Get current versions
CURRENT_CHART_VERSION := $(shell grep "^version:" $(CHART_FILE) | cut -d' ' -f2)
CURRENT_APP_VERSION := $(shell grep "^appVersion:" $(CHART_FILE) | cut -d' ' -f2 | tr -d '"')

# Show current versions
version-show:
	@echo "Chart version: $(CURRENT_CHART_VERSION)"
	@echo "App version: $(CURRENT_APP_VERSION)"

# Bump versions
version-bump-patch:
	@$(eval VERSION_PARTS := $(subst ., ,$(CURRENT_CHART_VERSION)))
	@$(eval MAJOR := $(word 1,$(VERSION_PARTS)))
	@$(eval MINOR := $(word 2,$(VERSION_PARTS)))
	@$(eval PATCH := $(word 3,$(VERSION_PARTS)))
	@$(eval NEW_VERSION := $(MAJOR).$(MINOR).$(shell echo $$(($(PATCH) + 1))))
	@sed -i 's/^version: .*/version: $(NEW_VERSION)/' $(CHART_FILE)
	@echo "Chart version bumped: $(CURRENT_CHART_VERSION) -> $(NEW_VERSION)"

version-bump-minor:
	@$(eval VERSION_PARTS := $(subst ., ,$(CURRENT_CHART_VERSION)))
	@$(eval MAJOR := $(word 1,$(VERSION_PARTS)))
	@$(eval MINOR := $(word 2,$(VERSION_PARTS)))
	@$(eval NEW_VERSION := $(MAJOR).$(shell echo $$(($(MINOR) + 1))).0)
	@sed -i 's/^version: .*/version: $(NEW_VERSION)/' $(CHART_FILE)
	@echo "Chart version bumped: $(CURRENT_CHART_VERSION) -> $(NEW_VERSION)"

version-bump-major:
	@$(eval VERSION_PARTS := $(subst ., ,$(CURRENT_CHART_VERSION)))
	@$(eval MAJOR := $(word 1,$(VERSION_PARTS)))
	@$(eval NEW_VERSION := $(shell echo $$(($(MAJOR) + 1))).0.0)
	@sed -i 's/^version: .*/version: $(NEW_VERSION)/' $(CHART_FILE)
	@echo "Chart version bumped: $(CURRENT_CHART_VERSION) -> $(NEW_VERSION)"

# Set specific versions (usage: make set-chart-version VERSION=1.0.0)
set-chart-version:
	@if [ -z "$(VERSION)" ]; then echo "Usage: make set-chart-version VERSION=x.y.z"; exit 1; fi
	@sed -i 's/^version: .*/version: $(VERSION)/' $(CHART_FILE)
	@echo "Chart version set to: $(VERSION)"

set-app-version:
	@if [ -z "$(VERSION)" ]; then echo "Usage: make set-app-version VERSION=x.y.z"; exit 1; fi
	@sed -i 's/^appVersion: .*/appVersion: "$(VERSION)"/' $(CHART_FILE)
	@echo "App version set to: $(VERSION)"

# Combined operations
release-patch: version-bump-patch
	@echo "Ready for patch release: $(shell grep "^version:" $(CHART_FILE) | cut -d' ' -f2)"

release-minor: version-bump-minor
	@echo "Ready for minor release: $(shell grep "^version:" $(CHART_FILE) | cut -d' ' -f2)"

release-major: version-bump-major
	@echo "Ready for major release: $(shell grep "^version:" $(CHART_FILE) | cut -d' ' -f2)"
