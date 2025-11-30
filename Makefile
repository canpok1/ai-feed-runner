# ai-feed runner Makefile

# Read version from .ai-feed-version file
VERSION := $(shell cat .ai-feed-version)

# Detect OS and architecture (normalize: aarch64 -> arm64, amd64 -> x86_64)
OS := $(shell uname -s)
ARCH := $(shell uname -m | sed -e 's/aarch64/arm64/' -e 's/amd64/x86_64/')

# GitHub release URL base
GITHUB_REPO := canpok1/ai-feed
RELEASE_URL := https://github.com/$(GITHUB_REPO)/releases/download/$(VERSION)

# Directories and file names
BINDIR := bin
BINARY := ai-feed
ARCHIVE := ai-feed.tar.gz
TARGET := $(BINDIR)/$(BINARY)

# Construct download URL based on OS and architecture
DOWNLOAD_URL := $(RELEASE_URL)/ai-feed_$(OS)_$(ARCH).tar.gz

.PHONY: download version clean init check

# Download the ai-feed binary for the current OS/architecture
download: $(TARGET)

$(TARGET):
	@echo "Downloading ai-feed $(VERSION) for $(OS)/$(ARCH)..."
	@echo "URL: $(DOWNLOAD_URL)"
	curl -fL -o $(ARCHIVE) $(DOWNLOAD_URL)
	mkdir -p $(BINDIR)
	tar -xzf $(ARCHIVE) -C $(BINDIR)
	chmod +x $(TARGET)
	rm -f $(ARCHIVE)
	@echo "Download complete: $(TARGET)"

# Show the ai-feed version
version: $(TARGET)
	@./$(TARGET) version

# Clean up downloaded artifacts
clean:
	rm -rf $(BINDIR) $(ARCHIVE)
	@echo "Cleaned up $(BINDIR)/ and $(ARCHIVE)"

# Initialize config file (config/config.yml)
init: $(TARGET)
	@if [ -f config/config.yml ]; then \
		echo "config/config.yml already exists, skipping initialization"; \
	else \
		echo "Initializing config/config.yml..."; \
		./$(TARGET) init; \
		mkdir -p config; \
		mv config.yml config/; \
		echo "Config file created at config/config.yml"; \
	fi

# Check config file validity
check: $(TARGET)
	@echo "Checking config/config.yml..."
	@./$(TARGET) --config config/config.yml version > /dev/null
	@echo "Config file is valid"
