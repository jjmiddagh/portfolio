param(
    [Parameter(Mandatory = $true)][string]$Slug,                 # e.g. "project-d"
    [Parameter(Mandatory = $true)][string]$Title,                # e.g. "Fraud Model Risk Dashboard"
    [Parameter(Mandatory = $true)][string]$Description,          # one-liner
    [string]$Date = (Get-Date -Format "yyyy-MM-dd"),
    [string]$Categories = "ML, Portfolio",
    [bool]$Featured = $true,
    [int]$Priority = 10,
    [string]$RepoUrl = "https://github.com/you/repo",
    [string]$DemoUrl = "https://your-demo.app"
)

# Validate slug
if ($Slug -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
    throw "Slug must be kebab-case (e.g., project-d)."
}

$projRoot = Join-Path "projects" $Slug
New-Item -ItemType Directory -Path $projRoot -Force | Out-Null

# Create thumbnail placeholder if not present
$thumb = Join-Path $projRoot "thumbnail.png"
if (-not (Test-Path $thumb)) {
    # 1x1 transparent pixel
    [byte[]]$png = [Convert]::FromBase64String(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4////fwAJ+wP9zS6ZbQAAAABJRU5ErkJggg=="
    )
    [IO.File]::WriteAllBytes($thumb, $png)
}

# Write index.qmd
$index = @"
---
title: "$Title"
description: "$Description"
date: $Date
categories: [$Categories]
image: thumbnail.png
featured: $Featured
priority: $Priority
repo_url: "$RepoUrl"
demo_url: "$DemoUrl"
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

$index | Set-Content (Join-Path $projRoot "index.qmd") -Encoding UTF8
Write-Host "✅ Created $projRoot"
Write-Host "→ Add screenshots, update copy, commit & push. Quarto listings will auto-update."
