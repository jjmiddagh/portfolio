param(
    [Parameter(Mandatory)]
    [string]$Slug,
    [Parameter(Mandatory)]
    [string]$Title,
    [Parameter(Mandatory)]
    [string]$Description,
    [Parameter(Mandatory)]
    [string]$Date,
    [Parameter(Mandatory)]
    [string]$Categories,
    [Parameter(Mandatory)]
    [bool]$Featured,
    [Parameter(Mandatory)]
    [int]$Priority,
    [Parameter(Mandatory)]
    [string]$RepoUrl,
    [Parameter(Mandatory)]
    [string]$DemoUrl
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Definition

if ($Slug -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
    Write-Error "Slug must be kebab-case (lowercase, hyphens)."
}
if ($Date -notmatch '^\d{4}-\d{2}-\d{2}$') {
    Write-Error "Date must be ISO format YYYY-MM-DD."
}
if ($Priority -notmatch '^\d+$') {
    Write-Error "Priority must be an integer."
}

$projDir = "$root/projects/$Slug"
if (!(Test-Path $projDir)) { New-Item -ItemType Directory -Path $projDir | Out-Null }

$imgPath = "$projDir/thumbnail.png"
if (!(Test-Path $imgPath)) {
    Add-Type -AssemblyName System.Drawing
    $bmp = New-Object System.Drawing.Bitmap 64,64
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::LightGray)
    $bmp.Save($imgPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

$indexPath = "$projDir/index.qmd"
$content = @"
---
title: \"$Title\"
description: \"$Description\"
date: $Date
categories: [$Categories]
image: thumbnail.png
featured: $Featured
priority: $Priority
repo_url: \"$RepoUrl\"
demo_url: \"$DemoUrl\"
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
$content | Set-Content -Path $indexPath -Encoding UTF8
