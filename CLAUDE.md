# Thai Teaching Workspace — AI Session Conventions

This repo is a daily teaching-prep system for Mos, a Thai teacher who teaches
foreigners **in English** (students are mostly Chinese speakers from Taiwan,
mainland China, and Hong Kong). Every AI session working here follows these rules.

## What this workspace does

Daily loop, driven by three skills (slash commands):

1. `/new-lesson <topic> [date] [students]` — research + generate a complete
   1-hour lesson kit (plan, teacher script, student handout PDF)
2. `/make-pdf [path]` — (re)render a handout HTML to PDF
3. `/takeaway [lesson] <notes>` — after class: teacher log + student recap,
   update student profiles and the lesson index

## Directory map

```
curriculum/topic-library.md   topic bank with levels, patterns, recycling links
templates/                    canonical templates — copy, never edit in place
lessons/INDEX.md              running log of all lessons (single source of truth)
lessons/YYYY-MM-DD-<slug>/    one folder per lesson
students/<name>.md            per-student profile + error log + homework log
reference/romanization.md     Paiboon system + tone-derivation cheat sheet (MUST follow)
reference/pedagogy-chinese-l1.md  Chinese-L1 contrasts to weave into lessons
assets/handout.css            shared handout stylesheet (+ bundled fonts in assets/fonts/)
tools/make_pdf.sh             HTML → PDF renderer (bundled Chromium, bundled fonts)
```

## Non-negotiable content rules

1. **Romanization = Paiboon-style exactly as defined in `reference/romanization.md`.**
   Re-derive every syllable's tone from Thai spelling (cheat sheet §4) before
   it ships. Beware the pinyin trap: Paiboon á = HIGH, à = LOW.
2. **Thai script first**, always visually dominant; romanization is scaffolding.
3. **Chinese gloss column (中文, Traditional by default) is ON** for vocab
   tables and key phrases — students are Chinese speakers. Omit it only if the
   lesson is explicitly for a non-Chinese group. Never translate full dialogues
   into Chinese (it becomes a crutch).
4. **Lesson size:** 8–12 core vocab items, 2–4 patterns, one 8–12-turn
   dialogue. More = the 1-hour plan fails.
5. **Handout ≤ 3 A4 pages** (target 2). Zero teaching methodology in handouts.
6. **Anti-duplication rule:** every piece of content lives in exactly ONE file —
   lesson-plan.md = structure/timing only; teacher-script.md = delivery
   wording; handout = student content. The other files reference by section
   ("drill the vocab in Handout §2"), never copy.
7. **Politeness particles**: dialogues always show ครับ/ค่ะ variants.
8. **Illustrations = inline SVG doodles only.** Simple hand-drawn-style
   line art (stroke-based, `stroke-linecap="round"`, theme colors #14636b /
   #b3541e), drawn directly in the handout HTML. Never link external images,
   never use raster files — SVG renders perfectly in the PDF pipeline, costs
   nothing, and is editable by prompt. Use the `.doodle` (floated) and
   `.doodle-icon` (inline) classes from assets/handout.css. 1–3 doodles per
   handout, always decorative-supportive, never load-bearing for meaning.
8. Naming: lesson folders `YYYY-MM-DD-<kebab-slug>`; status in INDEX.md flows
   `prepped → taught → recapped`.

## Always update lessons/INDEX.md

Any skill or manual edit that creates a lesson, marks it taught, or writes a
takeaway MUST update the corresponding INDEX.md row in the same change.

## PDF pipeline

- Render: `tools/make_pdf.sh <lesson>/handout.html` (output lands next to input).
- Handout HTML links the shared stylesheet: `<link rel="stylesheet" href="../../assets/handout.css">`.
  Font paths inside the CSS are relative to the CSS file — do not inline or
  duplicate `@font-face` in lesson files, and never rely on system fonts
  (the container has no Thai/CJK fonts).
- Chromium quirk: `position: fixed` does NOT repeat per printed page — the tone
  legend is a normal footer at the end of the document.
- Commit generated `handout.pdf` files — the repo doubles as a browsable
  portfolio.

## QA checklists (mandatory before declaring a lesson done)

**Linguistic QA** — for every Thai item in vocab/dialogue:
- [ ] Thai spelling correct
- [ ] tone re-derived from spelling matches the printed diacritic (cheat sheet §4)
- [ ] vowel length correct (single vs doubled letters)
- [ ] vocab rows have all columns (Thai / Paiboon / English / 中文)

**PDF QA** — open the generated PDF with the Read tool and check visually:
- [ ] no tofu boxes (□) anywhere
- [ ] Thai above/below vowels + tone marks stack correctly, not clipped
- [ ] Chinese glyphs render
- [ ] Paiboon specials render: ɛ ɔ ə ʉ and à â á ǎ
- [ ] tone-legend footer present at the end
- [ ] page count ≤ 3 (target 2)

If tofu appears: check `assets/fonts/` files exist → check the CSS link path
from the lesson folder → check `make_pdf.sh` output size (< 50 KB means fonts
didn't embed).

## Misc

- `index.thml.rtf` at the repo root is unrelated legacy content from before
  this workspace existed. Leave it alone.
- Work happens on branch `claude/thai-teaching-support-system-aduubf` unless
  the user says otherwise.
