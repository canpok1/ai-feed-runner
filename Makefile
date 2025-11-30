# ai-feed runner Makefile

# Read version from .ai-feed-version file
VERSION := $(shell cat .ai-feed-version)

# Detect OS and architecture
OS := $(shell uname -s)
ARCH_RAW := $(shell uname -m)

# Normalize architecture name (aarch64 -> arm64, amd64 -> x86_64)
ifeq ($(ARCH_RAW),aarch64)
	ARCH := arm64
else ifeq ($(ARCH_RAW),amd64)
	ARCH := x86_64
else
	ARCH := $(ARCH_RAW)
endif

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

.PHONY: download run clean

# Download the ai-feed binary for the current OS/architecture
download: $(TARGET)

$(TARGET):
	@echo "Downloading ai-feed $(VERSION) for $(OS)/$(ARCH)..."
	@echo "URL: $(DOWNLOAD_URL)"
	curl -L -o $(ARCHIVE) $(DOWNLOAD_URL)
	mkdir -p $(BINDIR)
	tar -xzf $(ARCHIVE) -C $(BINDIR)
	chmod +x $(TARGET)
	rm -f $(ARCHIVE)
	@echo "Download complete: $(TARGET)"

# Run the ai-feed binary with configuration
run: $(TARGET)
	./$(TARGET) run --config config.yaml --sources sources.yaml

# Clean up downloaded artifacts
clean:
	rm -rf $(BINDIR) $(ARCHIVE)
	@echo "Cleaned up $(BINDIR)/ and $(ARCHIVE)"
