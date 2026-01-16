# Combinators and Algorithms - E-Book Build System
# Requires: pandoc, optionally wkhtmltopdf or xelatex for PDF generation

SHELL := /bin/bash
JOBS := $(shell nproc)

# Directories
SRC_DIR := src
BUILD_DIR := build
TEMPLATE_DIR := templates
ASSETS_DIR := assets

# Source files (in order)
CHAPTERS := $(SRC_DIR)/index.md \
            $(wildcard $(SRC_DIR)/[0-9]*.md)

# Output files
HTML_OUTPUT := $(BUILD_DIR)/index.html
PDF_OUTPUT := $(BUILD_DIR)/combinators-and-algorithms.pdf

# Pandoc settings
PANDOC_FLAGS := --from=markdown \
                --to=html5 \
                --template=$(TEMPLATE_DIR)/base.html \
                --toc \
                --toc-depth=3 \
                --standalone \
                --metadata=lang:en

.PHONY: all html pdf clean serve watch dev setup

all: html

# Build HTML
html: $(HTML_OUTPUT)

$(HTML_OUTPUT): $(CHAPTERS) $(TEMPLATE_DIR)/base.html $(ASSETS_DIR)/css/style.css
	@mkdir -p $(BUILD_DIR)
	@echo "Building HTML..."
	pandoc $(PANDOC_FLAGS) \
		$(CHAPTERS) \
		-o $(HTML_OUTPUT)
	@cp -r $(ASSETS_DIR) $(BUILD_DIR)/
	@echo "Built: $(HTML_OUTPUT)"

# Build PDF via wkhtmltopdf (if installed)
pdf-wk: html
	@echo "Building PDF with wkhtmltopdf..."
	wkhtmltopdf \
		--enable-local-file-access \
		--page-size A4 \
		--margin-top 25mm \
		--margin-bottom 25mm \
		--margin-left 25mm \
		--margin-right 25mm \
		$(HTML_OUTPUT) $(PDF_OUTPUT)
	@echo "Built: $(PDF_OUTPUT)"

# Build PDF via pandoc + LaTeX (requires xelatex)
# Uses Linux Libertine if available, falls back to Noto Serif
MAINFONT := $(shell fc-list : family | grep -q "Linux Libertine" && echo "Linux Libertine O" || echo "Noto Serif")

pdf: $(CHAPTERS)
	@mkdir -p $(BUILD_DIR)
	@echo "Building PDF with LaTeX (font: $(MAINFONT))..."
	pandoc $(CHAPTERS) \
		--from=markdown \
		--to=pdf \
		--pdf-engine=xelatex \
		--toc \
		--toc-depth=3 \
		-V mainfont="$(MAINFONT)" \
		-V geometry:margin=1.25in \
		-V documentclass=book \
		-V title="Combinators and Algorithms" \
		-V author="Conor Shakory" \
		-V date="© 2026" \
		-V fontsize=11pt \
		-V linestretch=1.25 \
		-o $(PDF_OUTPUT)
	@echo "Built: $(PDF_OUTPUT)"

# Clean build directory
clean:
	rm -rf $(BUILD_DIR)
	@echo "Cleaned build directory"

# Development server (requires python3)
serve: html
	@echo "Serving at http://localhost:8000"
	@cd $(BUILD_DIR) && python3 -m http.server 8000

# Watch for changes and rebuild (uses fswatch if available, falls back to polling)
watch: html
	@echo "Watching for changes... (Ctrl+C to stop)"
	@if command -v fswatch >/dev/null 2>&1; then \
		while true; do \
			fswatch -1 -r -l 2 $(SRC_DIR) $(TEMPLATE_DIR) $(ASSETS_DIR); \
			echo "[`date +%H:%M:%S`] Rebuilding..."; \
			$(MAKE) -s html; \
			echo "Done."; \
		done; \
	else \
		echo "fswatch not found, using polling (install with: brew install fswatch)"; \
		while true; do \
			sleep 2; \
			$(MAKE) -s html; \
		done; \
	fi

# Development mode: just an alias for running serve and watch in separate terminals
dev:
	@echo "Run in separate terminals:"
	@echo "  Terminal 1: make serve"
	@echo "  Terminal 2: make watch"
	@echo ""
	@echo "Or use: ./dev.sh"

# Setup - check dependencies
setup:
	@echo "Checking dependencies..."
	@which pandoc > /dev/null || (echo "ERROR: pandoc not found. Install with: brew install pandoc" && exit 1)
	@echo "✓ pandoc found"
	@which python3 > /dev/null || echo "⚠ python3 not found (needed for 'make serve')"
	@which fswatch > /dev/null || echo "⚠ fswatch not found (needed for 'make watch'). Install with: brew install fswatch"
	@which xelatex > /dev/null || echo "⚠ xelatex not found (needed for 'make pdf')"
	@which wkhtmltopdf > /dev/null || echo "⚠ wkhtmltopdf not found (alternative for 'make pdf-wk')"
	@echo ""
	@echo "Install with Homebrew:"
	@echo "  brew install pandoc fswatch"
