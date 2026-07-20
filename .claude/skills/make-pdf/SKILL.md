---
name: make-pdf
description: Render (or re-render) a lesson handout HTML to a print-ready PDF and visually verify it. Use after editing a handout, or when a PDF is missing or broken.
argument-hint: "[lesson folder or handout.html path — defaults to newest lesson]"
---

# /make-pdf — render a handout to PDF

## Step 1 — Resolve the input

- Explicit `.html` path → use it.
- Lesson folder → its `handout.html`.
- No argument → the newest `lessons/*/` folder containing a `handout.html`.

## Step 2 — Render

Run `tools/make_pdf.sh <input.html>`. Expect `OK: <path> (<bytes>, <n> pages)`.
The script already fails on missing output or suspiciously small files
(< 50 KB usually means fonts didn't embed).

## Step 3 — Visual QA (mandatory)

Open the produced PDF with the Read tool and verify (CLAUDE.md checklist):

- no tofu boxes (□)
- Thai above/below vowels and tone marks stack correctly, not clipped
- Chinese glyphs render
- Paiboon specials render: ɛ ɔ ə ʉ and à â á ǎ
- tone-legend footer present at the end
- page count ≤ 3 (target 2) — if over, tighten the handout, don't shrink fonts

## Step 4 — Failure diagnosis (in this order)

1. `assets/fonts/*.ttf` all present? (six files + OFL.txt)
2. Handout links `../../assets/handout.css` and lives two levels under repo
   root? (Font paths are relative to the CSS file.)
3. `tools/make_pdf.sh` found a Chromium binary? (It probes
   `/opt/pw-browsers/…` then PATH.)
4. Still failing → rerun with the script's stderr visible and read the error.

## Step 5 — Report

Output path + page count + "QA passed" (or what failed and what you fixed).
