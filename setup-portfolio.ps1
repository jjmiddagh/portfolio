# setup-portfolio.ps1
# Creates folder structure and starter files for Quarto portfolio

param (
    [string]$BasePath = ".\portfolio"
)

# --- Create folders ---
$folders = @(
    "$BasePath\projects\project-a",
    "$BasePath\projects\project-b",
    "$BasePath\projects\project-c",
    "$BasePath\assets\images",
    "$BasePath\.github\workflows"
)

foreach ($f in $folders) {
    if (-not (Test-Path $f)) {
        New-Item -ItemType Directory -Path $f | Out-Null
    }
}

# --- Create _quarto.yml ---
$quartoYml = @"
project:
  type: website
  output-dir: _site

website:
  title: "Joshua J. Middagh — Portfolio"
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
    center: "© {{< year >}} Joshua J. Middagh"
  favicon: assets/images/favicon.png

format:
  html:
    theme: cosmo
    toc: false
    smooth-scroll: true
"@

Set-Content "$BasePath\_quarto.yml" $quartoYml -Encoding UTF8

# --- Create homepage (index.qmd) ---
$indexQmd = @"
---
title: "AI Solutions Architect & Data Science Leader"
listing:
  contents: projects
  sort: "priority"
  fields: [title, image, description, categories]
  type: grid
  image-placeholder: true
  filter:
    - featured: true
---

Welcome! I build practical AI systems and model-risk programs. Below are a few highlights.
"@
Set-Content "$BasePath\index.qmd" $indexQmd -Encoding UTF8

# --- Create projects.qmd (all projects listing) ---
$projectsQmd = @"
---
title: "Projects"
listing:
  contents: projects
  sort: ["-date", "priority"]
  type: table
  fields: [title, description, date, categories]
---
"@
Set-Content "$BasePath\projects.qmd" $projectsQmd -Encoding UTF8

# --- Create about.qmd ---
$aboutQmd = @"
---
title: "About Me"
---

# About Me
Hi, I'm Josh — an AI Solutions Architect and Data Science Executive.
This portfolio showcases selected projects, case studies, and experiments.
"@
Set-Content "$BasePath\about.qmd" $aboutQmd -Encoding UTF8

# --- Create sample project pages ---
$projectTemplate = @"
---
title: "{0}"
description: "{1}"
date: 2025-09-01
categories: [ML, Portfolio]
image: thumbnail.png
featured: true
priority: {2}
repo_url: "https://github.com/your/repo"
demo_url: "https://your-demo.app"
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

$projects = @(
    @{ name="project-a"; title="Telecom Churn Prediction"; desc="End-to-end churn pipeline with SMOTE, XGBoost, and Streamlit."; priority=1 },
    @{ name="project-b"; title="AI Bias Auditing"; desc="Bias detection & fairness scoring for HR resume screening."; priority=2 },
    @{ name="project-c"; title="Airbnb Dynamic Pricing"; desc="Flagstaff-focused dynamic pricing engine using market data."; priority=3 }
)

foreach ($p in $projects) {
    $content = $projectTemplate -f $p.title, $p.desc, $p.priority
    Set-Content "$BasePath\projects\$($p.name)\index.qmd" $content -Encoding UTF8
}

# --- GitHub Actions workflow ---
$workflow = @"
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
Set-Content "$BasePath\.github\workflows\quarto-publish.yml" $workflow -Encoding UTF8

Write-Host "Portfolio scaffold created at $BasePath"
