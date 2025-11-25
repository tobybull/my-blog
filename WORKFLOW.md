# Jekyll Blog Workflow (Idiot‑Proof Guide)

This guide walks you through **everything you need to do** to:

1. Create a blog post
2. Run your site locally inside Docker
3. Tweak the design / config
4. Push changes to GitHub
5. Deploy automatically via GitHub Pages + GitHub Actions

Works with:

* **WSL**
* **Docker**
* **No local Ruby installation**

---

# 📁 1. Create a New Blog Post

All blog posts live in the `_posts/` folder.

Each post must use this filename format:

```
YYYY-MM-DD-title-of-post.md
```

Example:

```
_posts/2025-11-24-my-first-blog-post.md
```

Inside the file, add "front matter" at the top:

```yaml
---
layout: post
title: "My First Blog Post"
date: 2025-11-24
---
```

Then add your content below the `---`.

---

# 🚀 2. Serve the Site Locally (Docker)

From inside your project directory:

### **Build (only needed after modifying the Dockerfile):**

```bash
docker build -t jekyll-blog .
```

### **Run your site:**

```bash
docker run --rm -v "$(pwd):/site" -p 4000:4000 jekyll-blog
```

Then visit:

```
http://localhost:4000
```

The site updates when you save files.

---

# 🎨 3. Tweak Appearance / Config

Most of the site behavior is controlled in `_config.yml`.

Things you commonly change:

### **Site title + description**

```yaml
title: "My Blog"
description: "Thoughts, notes, ideas."
```

### **Theme**

The default theme is:

```yaml
theme: minima
```

You can replace it with any Jekyll theme.

### **Plugins**

Example:

```yaml
plugins:
  - jekyll-feed
  - jekyll-seo-tag
```

After editing plugins, rebuild your container:

```bash
docker build -t jekyll-blog .
```

---

# 🧪 4. Test Your Site Locally

Every time you:

* edit posts
* tweak config
* change themes

You can view the results instantly:

```
docker run --rm -v "$(pwd):/site" -p 4000:4000 jekyll-blog
```

Open `http://localhost:4000`.

---

# 📤 5. Push Your Changes to GitHub

1. Check what changed:

```bash
git status
```

2. Add updates:

```bash
git add .
```

3. Commit:

```bash
git commit -m "Update blog"
```

4. Push:

```bash
git push
```

---

# 🌐 6. GitHub Pages Deployment (Automatic)

Your repo already contains a GitHub Actions workflow:

```
.github/workflows/pages.yml
```

Every push to `master` triggers:

1. GitHub builds your site
2. Uploads the `_site/` content
3. Publishes to GitHub Pages

Your live site will be at:

```
https://tobybull.github.io
```

You do **not** need to run `jekyll build` yourself — GitHub Actions handles it.

---

# 🩹 Troubleshooting

### **Site doesn't update locally?**

Rebuild Docker image:

```bash
docker build -t jekyll-blog .
```

### **GitHub Pages not updating?**

Check Actions tab → ensure workflow succeeded.

### **Missing gems or plugin errors?**

After changing Gemfile:

```
docker build -t jekyll-blog .
```

---

# ✅ Summary Cheat Sheet

### **Create a post**

```
_posts/YYYY-MM-DD-title.md
```

### **Run locally**

```
docker run --rm -v "$(pwd):/site" -p 4000:4000 jekyll-blog
```

### **Modify theme/config**

Edit `_config.yml` → rebuild image.

### **Deploy**

```
git add .
git commit -m "Update"
git push
```

Pages deploy automatically.

---

If you ever forget steps, just come back to this file — it lists everything you need. 🚀

# 🔧 Additional Setup Files & Improvements

Below are the requested components:

* A **clean docker-compose.yml**
* A **better incremental Dockerfile** (fast builds)
* A **prebuilt minimal Jekyll blog template** (no starter-cruft)
* **Next steps** for posts, themes, collections, and TailwindCSS

---

# 🐳 docker-compose.yml

```yaml
version: "3.9"
services:
  jekyll:
    build: .
    container_name: jekyll-blog
    command: bundle exec jekyll serve --watch --drafts --livereload --host 0.0.0.0
    ports:
      - "4000:4000"
      - "35729:35729"   # LiveReload
    volumes:
      - .:/site
    restart: unless-stopped
```

Usage:

```
docker compose up
```

Visit:
[http://localhost:4000](http://localhost:4000)

---

# 🐳 Improved Dockerfile (Incremental + Fast)

This version:

* Leverages Docker layer caching
* Installs dependencies only when Gemfile changes
* Keeps builds FAST

```dockerfile
FROM ruby:3.3-slim

# Install OS packages
RUN apt-get update && \
    apt-get install -y build-essential nodejs git && \
    gem install bundler

WORKDIR /site

# Copy Gemfile early to enable caching layers
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy rest of site
COPY . .

# Default command
CMD ["bundle", "exec", "jekyll", "serve", "--watch", "--drafts", "--livereload", "--host", "0.0.0.0"]
```

---

# 📁 Prebuilt Minimal Jekyll Blog Template

A **much cleaner** version than the Jekyll default.

Directory structure:

```
.
├── _posts/
├── _layouts/
│   ├── default.html
│   └── post.html
├── _includes/
│   └── head.html
├── index.md
├── about.md
├── Gemfile
├── _config.yml
```

### `_config.yml`

```yaml
title: "My Blog"
description: "Thoughts and notes."
baseurl: ""
url: ""
theme: minima
plugins:
  - jekyll-feed
  - jekyll-seo-tag
markdown: kramdown
```

### `Gemfile`

```ruby
source "https://rubygems.org"
gem "jekyll", "~> 4.4"
gem "minima", "~> 2.5"
gem "jekyll-feed"
gem "jekyll-seo-tag"
```

### `index.md`

```markdown
---
layout: default
title: Home
---

# Welcome

Here are my latest posts:

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a> – {{ post.date | date: "%Y-%m-%d" }}
    </li>
  {% endfor %}
</ul>
```

### `_layouts/default.html`

```html
<!DOCTYPE html>
<html>
<head>
  {% include head.html %}
</head>
<body>
  <main class="container">
    {{ content }}
  </main>
</body>
</html>
```

### `_layouts/post.html`

```html
---
layout: default
---
<article>
  <h1>{{ page.title }}</h1>
  <p><small>{{ page.date | date_to_string }}</small></p>
  {{ content }}
</article>
```

### `_includes/head.html`

```html
<meta charset="utf-8">
<title>{{ page.title }} | {{ site.title }}</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
{% seo %}
```

---

# 📝 Next Steps

## 1️⃣ Create posts

```
_posts/YYYY-MM-DD-title.md
```

With front matter:

```yaml
---
layout: post
title: "My Post"
---
```

## 2️⃣ Themes

You can switch from Minima to any theme:

```
gem "jekyll-theme-cayman"
```

Then in `_config.yml`:

```
theme: jekyll-theme-cayman
```

Rebuild:

```
docker compose build
```

## 3️⃣ Collections

Example: add `notes` collection.

In `_config.yml`:

```yaml
collections:
  notes:
    output: true
```

Create folder:

```
mkdir _notes
```

Add a file:

```
_notes/test.md
```

Front matter:

```yaml
---
layout: default
title: Test Note
---
```

Access at:

```
/notes/test
```

## 4️⃣ TailwindCSS

### Add Tailwind via standalone executable

(No Node pipeline needed!)

1. Install Tailwind binary inside Dockerfile:

```dockerfile
RUN curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64 \
    && chmod +x tailwindcss-linux-x64 \
    && mv tailwindcss-linux-x64 /usr/local/bin/tailwindcss
```

2. Add Tailwind config:

```
tailwind.config.js
```

```javascript
module.exports = {
  content: [
    "./_layouts/**/*.html",
    "./_includes/**/*.html",
    "./_posts/*.md",
    "./*.md"
  ],
  theme: { extend: {} },
  plugins: []
}
```

3. Create `assets/css/tailwind.css`:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

4. Build CSS (inside Docker container):

```bash
tailwindcss -i ./assets/css/tailwind.css -o ./assets/css/site.css --watch
```

5. Include in `_layouts/default.html`:

```html
<link rel="stylesheet" href="/assets/css/site.css">
```

---

If you'd like, I can now:

* Package all of this into a downloadable repo
* Add pagination and archive pages
* Add a dark mode
* Add syntax highlighting
* Create a fully custom theme
* Integrate search (Lunr.js)

Just say the word!
