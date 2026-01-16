# Building the Book

## Quick Start

```bash
# Check dependencies
make setup

# Build HTML
make html

# Start development server
make serve
```

Then open http://localhost:8000 in your browser.

## Dependencies

**Required:**
- `pandoc` — Markdown to HTML/PDF conversion

**Optional (for PDF generation):**
- `texlive-xetex` and `fonts-linuxlibertine` — for `make pdf`
- `wkhtmltopdf` — for `make pdf-wk`

**Optional (for development):**
- `python3` — for `make serve`
- `inotify-tools` — for `make watch`

Install all on Debian/Ubuntu:

```bash
sudo apt install pandoc texlive-xetex fonts-linuxlibertine wkhtmltopdf inotify-tools python3
```

## Make Targets

| Command | Description |
|---------|-------------|
| `make` or `make html` | Build HTML output |
| `make pdf` | Build PDF using LaTeX (best quality) |
| `make pdf-wk` | Build PDF using wkhtmltopdf |
| `make serve` | Build and start local server at :8000 |
| `make watch` | Watch files and rebuild on changes |
| `make clean` | Remove build directory |
| `make setup` | Check installed dependencies |

## Writing Content

Add markdown files to `src/`. Files are processed in alphabetical order:

- `src/index.md` — Landing page (title only)
- `src/01-introduction.md` — First chapter
- `src/02-basic-combinators.md` — Second chapter
- etc.

The Table of Contents is auto-generated from headings (`#`, `##`, `###`).

## Project Structure

```
.
├── src/                # Markdown content
│   ├── index.md        # Landing page
│   └── *.md            # Chapters
├── templates/
│   └── base.html       # HTML template
├── assets/
│   ├── css/
│   │   └── style.css   # Styling
│   └── js/
│       └── toc.js      # TOC interaction
├── fonts/              # (optional) self-hosted fonts
├── build/              # Generated output
│   ├── index.html
│   └── assets/
├── Makefile
└── BUILDING.md
```
