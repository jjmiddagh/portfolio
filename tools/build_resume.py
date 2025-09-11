#!/usr/bin/env python3
import os, subprocess

SRC = os.path.join("assets", "resume", "Joshua Middagh Resume.docx")
OUT_DIR = "includes"
OUT = os.path.join(OUT_DIR, "resume.html")
FILTER = os.path.join("tools", "promote-bold-to-h3.lua")

os.makedirs(OUT_DIR, exist_ok=True)

def run(cmd): subprocess.run(cmd, check=True)

try:
    run(["quarto", "pandoc", SRC, "-t", "html", "--lua-filter", FILTER, "-o", OUT])
except FileNotFoundError:
    run(["pandoc", SRC, "-t", "html", "--lua-filter", FILTER, "-o", OUT])

print(f"[pre-render] Wrote {OUT}")
