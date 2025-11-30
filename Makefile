# ai-feed runner Makefile

# Read version from .ai-feed-version file
VERSION := $(shell cat .ai-feed-version)

# Detect OS and architecture
OS := $(shell uname -s)
ARCH := $(shell uname -m)

# GitHub release URL base
GITHUB_REPO := canpok1/ai-feed
RELEASE_URL := https://github.com/$(GITHUB_REPO)/releases/download/$(VERSION)

# Directories and file names
BINDIR := bin
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
	mkdir -p $(BINDIR)
	tar -xzf $(ARCHIVE) -C $(BINDIR)
	chmod +x $(BINDIR)/$(BINARY)
	rm -f $(ARCHIVE)
	@echo "Download complete: $(BINDIR)/$(BINARY)"

# Run the ai-feed binary with configuration
run:
	./$(BINDIR)/$(BINARY) run --config config.yaml --sources sources.yaml

# Clean up downloaded artifacts
clean:
	rm -rf $(BINDIR) $(ARCHIVE)
	@echo "Cleaned up $(BINDIR)/ and $(ARCHIVE)"
