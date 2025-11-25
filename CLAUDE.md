# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal blog built with Jekyll 4.4.1, using the Minima theme. The blog is containerized with Docker for local development and automatically deploys to GitHub Pages via GitHub Actions on every push to master.

## Development Workflow

### Local Development with Docker

**Build the Docker image** (only needed after modifying Dockerfile or Gemfile):
```bash
docker build -t jekyll-blog .
```

**Run the site locally**:
```bash
docker run --rm -v "$(pwd):/site" -p 4000:4000 jekyll-blog
```

Or use Docker Compose for enhanced features (live reload on port 35729):
```bash
docker compose up
```

Site will be available at `http://localhost:4000`. Changes to files are detected automatically.

**Important**: After modifying `_config.yml`, restart the server as config changes are not auto-reloaded.

### Creating Blog Posts

- All posts go in `_posts/` directory
- Filename format: `YYYY-MM-DD-title-of-post.md` or `.markdown`
- Required front matter:
  ```yaml
  ---
  layout: post
  title: "Post Title"
  date: YYYY-MM-DD
  categories: category-name
  ---
  ```

### Deployment

The site deploys automatically via GitHub Actions (`.github/workflows/pages.yml`) on every push to `master`. The workflow:
1. Builds the site using Ruby 3.2 and Jekyll
2. Uploads artifacts to GitHub Pages
3. Deploys to `https://tobybull.github.io`

**Do not manually build** for deployment - GitHub Actions handles it.

## Configuration

### Site Settings (`_config.yml`)

Key settings:
- Site metadata: title, email, description
- Base URL: Currently empty (root domain)
- Theme: minima
- Plugins: jekyll-feed, jekyll-paginate, jekyll-seo-tag

### Dependencies (`Gemfile`)

Core dependencies:
- Jekyll 4.4.1
- Minima theme
- Jekyll plugins: jekyll-feed, jekyll-paginate, jekyll-seo-tag

After modifying Gemfile, rebuild the Docker image.

## Docker Architecture

The Dockerfile uses `ruby:3.3-slim` base image and:
- Installs build dependencies (build-essential, nodejs, git)
- Copies Gemfile/Gemfile.lock and runs `bundle install`
- Mounts the working directory as a volume at runtime
- Serves with `--watch`, `--drafts`, `--livereload`, and `--host 0.0.0.0` flags

The site is developed entirely in Docker - no local Ruby installation required.

## Common Issues

- **Config changes not showing**: Restart the Jekyll server
- **Gem/plugin errors**: Rebuild the Docker image after Gemfile changes
- **GitHub Pages not updating**: Check the Actions tab for workflow failures
