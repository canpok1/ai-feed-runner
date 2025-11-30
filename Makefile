# ai-feed runner Makefile

# Read version from .ai-feed-version file
VERSION := $(shell cat .ai-feed-version)

# Detect OS and architecture
OS := $(shell uname -s)
ARCH := $(shell uname -m)

# GitHub release URL base
GITHUB_REPO := canpok1/ai-feed
RELEASE_URL := https://github.com/$(GITHUB_REPO)/releases/download/$(VERSION)

# Binary and archive names
BINARY := ai-feed
ARCHIVE := ai-feed.tar.gz

# Construct download URL based on OS and architecture
DOWNLOAD_URL := $(RELEASE_URL)/ai-feed_$(OS)_$(ARCH).tar.gz

.PHONY: download run clean

# Download the ai-feed binary for the current OS/architecture
download:
	@echo "Downloading ai-feed $(VERSION) for $(OS)/$(ARCH)..."
	@echo "URL: $(DOWNLOAD_URL)"
	curl -L -o $(ARCHIVE) $(DOWNLOAD_URL)
	tar -xzf $(ARCHIVE)
	chmod +x $(BINARY)
	@echo "Download complete: $(BINARY)"

# Run the ai-feed binary with configuration
run:
	./$(BINARY) run --config config.yaml --sources sources.yaml

# Clean up downloaded artifacts
clean:
	rm -f $(BINARY) $(ARCHIVE)
	@echo "Cleaned up $(BINARY) and $(ARCHIVE)"
