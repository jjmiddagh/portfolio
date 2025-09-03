# Idempotently scaffold portfolio site and starter projects
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Definition

function Ensure-Dir($path) {
  if (!(Test-Path $path)) { New-Item -ItemType Directory -Path $path | Out-Null }
}

function Ensure-File($path, $content) {
  if (!(Test-Path $path)) { $content | Set-Content -Path $path -Encoding UTF8 }
}

function Ensure-Image($path, $color) {
  if (!(Test-Path $path)) {
    Add-Type -AssemblyName System.Drawing
    $bmp = New-Object System.Drawing.Bitmap 64, 64
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear($color)
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
  }
}

# Directories
Ensure-Dir "$root/assets/images"
Ensure-Dir "$root/projects/project-a"
Ensure-Dir "$root/projects/project-b"
Ensure-Dir "$root/projects/project-c"
Ensure-Dir "$root/.github/workflows"
Ensure-Dir "$root/tools"

# Files
Ensure-File "$root/_quarto.yml" @"
project:
  type: website
  output-dir: _site

website:
  title: \"Joshua J. Middagh — Portfolio\"
  navbar:
    right:
      - href: index.qmd
        text: Home
      - href: projects.qmd
        text: Projects
      - href: about.qmd
        text: About
      - href: files/Joshua_Middagh_Resume.pdf
        text: Résumé
  page-footer:
    center: \"© {{< year >}} Joshua J. Middagh\"
  favicon: assets/images/favicon.png

format:
  html:
    theme: cosmo
    toc: false
    smooth-scroll: true
"@

Ensure-File "$root/index.qmd" @"
---
title: \"AI Solutions Architect & Data Science Leader\"
listing:
  contents: projects
  sort: \"priority\"
  fields: [title, image, description, categories]
  type: grid
  image-placeholder: true
  filter:
    - featured: true
---

Welcome! I build practical AI systems and model-risk programs. Below are a few highlights.
"@

Ensure-File "$root/projects.qmd" @"
---
title: \"Projects\"
listing:
  contents: projects
  sort: [\"-date\", \"priority\"]
  type: table
  fields: [title, description, date, categories]
---
"@

Ensure-File "$root/about.qmd" @"
---
title: \"About Me\"
---

# About Me
Hi, I'm Josh — an AI Solutions Architect and Data Science Executive.
This portfolio showcases selected projects, case studies, and experiments.
"@

Ensure-File "$root/README.md" @"
# Joshua J. Middagh — Portfolio

A plug-and-play Quarto portfolio for AI, ML, and data science projects.

## Requirements

- [Quarto](https://quarto.org/docs/get-started/)
- Optional: Git, GitHub CLI

## Local Preview

\`\`\`bash
quarto preview
\`\`\`

## Build

\`\`\`bash
quarto render
\`\`\`

## GitHub Pages Deployment

\`\`\`bash
git init
git add .
git commit -m \"Initial portfolio scaffold\"
git remote add origin https://github.com/<your-username>/<your-repo>.git
git branch -M main
git push -u origin main
\`\`\`

In GitHub repo:  
Settings → Pages → Source: GitHub Actions (workflow auto-deploys).

### Custom Domain (optional)

- Add \`CNAME\` in repo root with \`portfolio.yourdomain.com\`
- Point DNS CNAME to \`<username>.github.io\`

## Daily Use

- Add/swap projects with \`tools/add-project.ps1\`
- Feature on homepage: set \`featured: true\`
- Reorder homepage: tweak \`priority\`

## Troubleshooting

- **Old build on GitHub Pages:** Clear cache or confirm Actions completed.
- **Missing images:** Ensure \`thumbnail.png\` exists next to each project’s \`index.qmd\`.
- **Homepage order wrong:** All featured projects must have unique integer \`priority\`.
- **Quarto not found in CI:** Check \`quarto-dev/quarto-actions/setup@v2\` and runner logs.
"@

Ensure-File "$root/.github/workflows/quarto-publish.yml" @"
name: Publish Quarto site
on:
  push:
    branches: [ main ]
permissions:
  contents: write
jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: quarto-dev/quarto-actions/setup@v2
      - run: quarto render
      - uses: actions/configure-pages@v5
      - uses: actions/upload-pages-artifact@v3
        with:
          path: _site
      - uses: actions/deploy-pages@v4
"@

# Placeholder images
Ensure-Image "$root/assets/images/favicon.png" ([System.Drawing.Color]::LightGray)
Ensure-Image "$root/projects/project-a/thumbnail.png" ([System.Drawing.Color]::LightBlue)
Ensure-Image "$root/projects/project-b/thumbnail.png" ([System.Drawing.Color]::LightGreen)
Ensure-Image "$root/projects/project-c/thumbnail.png" ([System.Drawing.Color]::LightCoral)

# Project templates
function Write-ProjectQmd($slug, $title, $desc, $date, $categories, $featured, $priority, $repo, $demo) {
  $path = "$root/projects/$slug/index.qmd"
  $content = @"
---
title: \"$title\"
description: \"$desc\"
date: $date
categories: [$categories]
image: thumbnail.png
featured: $featured
priority: $priority
repo_url: \"$repo\"
demo_url: \"$demo\"
---

## Problem
Short description of the business or technical challenge.

## Approach
Summary of methods, tools, and design choices.

## Results
Key outcomes, metrics, or visuals.

**Code:** [GitHub]({{< meta repo_url >}})
**Live Demo:** [Open]({{< meta demo_url >}})
"@
  Ensure-File $path $content
}

Write-ProjectQmd "project-a" "Telecom Churn Prediction" "Predicting customer churn for telecom using ML." "2025-08-01" "ML, Portfolio" "true" "1" "https://github.com/your/repo" "https://your-demo.app"
Write-ProjectQmd "project-b" "AI Bias Auditing" "Auditing ML models for bias and fairness." "2025-07-15" "ML, Portfolio" "true" "2" "https://github.com/your/repo" "https://your-demo.app"
Write-ProjectQmd "project-c" "Airbnb Dynamic Pricing" "Optimizing Airbnb pricing with ML." "2025-06-20" "ML, Portfolio" "true" "3" "https://github.com/your/repo" "https://your-demo.app"
