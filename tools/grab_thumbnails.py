# tools/grab_thumbnails.py
import asyncio, os
from playwright.async_api import async_playwright

# Map each project to the URL you want to capture.
# Use localhost while generating, then switch to prod later if needed.
PROJECTS = [
    #("fraud-risk-simulation", "http://localhost:8501"),
    ("churn-prediction", "http://localhost:8502"),
    # ("airbnb-pricing", "http://localhost:8503"),
]

OUT_DIR = "assets/images/thumbnails"
WIDTH, HEIGHT = 1200, 675  # 16:9 thumbnail

STEALTH_JS = """
// Minimal stealth: reduce obvious automation fingerprints
Object.defineProperty(navigator, 'webdriver', {get: () => false});
window.chrome = { runtime: {} };
Object.defineProperty(navigator, 'plugins', {get: () => [1, 2]});
Object.defineProperty(navigator, 'languages', {get: () => ['en-US', 'en']});
"""

async def grab(page, slug, url):
    print(f"Capturing {slug} → {url}")
    await page.goto(url, wait_until="networkidle", timeout=60000)

    # Streamlit sometimes lazy-loads; small settle wait
    await page.wait_for_timeout(1200)

    # Viewport snapshot (not full page) to get consistent 16:9
    await page.screenshot(path=f"{OUT_DIR}/{slug}.png")

async def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        context = await browser.new_context(
            viewport={"width": WIDTH, "height": HEIGHT},
            device_scale_factor=2,
            user_agent=("Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                        "AppleWebKit/537.36 (KHTML, like Gecko) "
                        "Chrome/123.0.0.0 Safari/537.36"),
        )
        await context.add_init_script(STEALTH_JS)
        page = await context.new_page()

        for slug, url in PROJECTS:
            try:
                await grab(page, slug, url)
            except Exception as e:
                print(f"[WARN] {slug} failed: {e}")

        await browser.close()

if __name__ == "__main__":
    asyncio.run(main())
