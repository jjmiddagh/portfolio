# Joshua J. Middagh â€” Portfolio

A plug-and-play Quarto portfolio for AI, ML, and data science projects.

## Requirements

- [Quarto](https://quarto.org/docs/get-started/)
- Optional: Git, GitHub CLI

## Local Preview

\\\ash
quarto preview
\\\

## Build

\\\ash
quarto render
\\\

## GitHub Pages Deployment

\\\ash
git init
git add .
git commit -m \"Initial portfolio scaffold\"
git remote add origin https://github.com/<your-username>/<your-repo>.git
git branch -M main
git push -u origin main
\\\

In GitHub repo:  
Settings â†’ Pages â†’ Source: GitHub Actions (workflow auto-deploys).

### Custom Domain (optional)

- Add \CNAME\ in repo root with \portfolio.yourdomain.com\
- Point DNS CNAME to \<username>.github.io\

## Daily Use

- Add/swap projects with \	ools/add-project.ps1\
- Feature on homepage: set \eatured: true\
- Reorder homepage: tweak \priority\

## Troubleshooting

- **Old build on GitHub Pages:** Clear cache or confirm Actions completed.
- **Missing images:** Ensure \	humbnail.png\ exists next to each projectâ€™s \index.qmd\.
- **Homepage order wrong:** All featured projects must have unique integer \priority\.
- **Quarto not found in CI:** Check \quarto-dev/quarto-actions/setup@v2\ and runner logs.
