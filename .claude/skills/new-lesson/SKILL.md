---
name: new-lesson
description: Create a complete 1-hour Thai lesson kit (lesson plan, teacher script, student handout PDF) for an assigned topic. Use when Mos receives a new teaching topic or asks to prepare/create/build a lesson.
argument-hint: <topic> [date] [student names]
---

# /new-lesson — generate a complete lesson kit

Produce a ready-to-teach kit for the given topic. Follow every step; the QA
steps are not optional.

## Step 1 — Resolve inputs & context

1. Topic = the argument. Date defaults to today. Students default to the ones
   in the most recent `lessons/INDEX.md` row (else ask).
2. Read `lessons/INDEX.md`. Find the most recent lesson with a takeaway and
   read its `takeaway.md` — you need its **spaced-repetition queue** (feeds
   this lesson's warm-up) and **seeds** (may shape content). Also confirm the
   topic wasn't already taught; if it was, build on it, don't repeat it.
3. Read the attendees' `students/<name>.md` profiles — their L1s decide which
   pedagogy notes apply and whether the 中文 column stays on (default: on,
   Traditional).

## Step 2 — Load the rules

Read (do not skim): `CLAUDE.md`, `reference/romanization.md`,
`reference/pedagogy-chinese-l1.md`. Check `curriculum/topic-library.md` for
the topic's row — reuse its core patterns and follow its *Recycles from* links.
If the topic is missing, add a row for it in the same change.
Only research the web if the topic needs current/authentic material (e.g.
"BTS fare talk", seasonal festivals).

## Step 3 — Author the lesson folder

Create `lessons/YYYY-MM-DD-<kebab-slug>/` with three files copied from
`templates/` and filled in:

- `lesson-plan.md` — timing skeleton, checklist, anticipated Chinese-L1
  difficulties **specific to this vocab set**, answer key, homework spec
- `teacher-script.md` — full delivery wording, tone anchors per word,
  drill sequences with expected wrong answers, culture anecdote
- `handout.html` — student-facing only; keep the
  `../../assets/handout.css` link and the tone-legend footer

Content constraints (CLAUDE.md): 8–12 vocab, 2–4 patterns, one 8–12-turn
dialogue with ครับ/ค่ะ variants, warm-up items pulled from the
spaced-repetition queue, Thai script first everywhere. Include at least one
tone minimal-pair drill built from this lesson's own vocab.

## Step 4 — Linguistic QA (mandatory)

For EVERY Thai item in vocab, patterns, and dialogue:

1. Re-derive the tone from the Thai spelling using
   `reference/romanization.md` §4 (class → live/dead → table) and confirm the
   printed diacritic matches. Fix mismatches — trust the derivation, not memory.
2. Confirm vowel length (single vs doubled letters) matches the Thai spelling.
3. Confirm every vocab row has all four columns filled (Thai/Paiboon/English/中文).

Write the derivations for the vocab table into the lesson-plan's answer-key
section as a QA appendix (one line each, like `ข้าว: high+้→falling→khâao ✓`).

## Step 5 — Render & QA the PDF (mandatory)

1. `tools/make_pdf.sh lessons/<folder>/handout.html`
2. Open the PDF with the Read tool and check the CLAUDE.md PDF QA list:
   no tofu, Thai marks stack cleanly, Chinese renders, ɛ ɔ ə ʉ à â á ǎ render,
   legend footer present, ≤3 pages (target 2).
3. On failure: check `assets/fonts/` exists → the CSS link path → rerun.
   Do not hand over a lesson whose PDF failed QA.

## Step 6 — Update the index & report

1. Add the INDEX.md row (status `prepped`).
2. Report to Mos: the file list, a 3-line summary of the lesson, and any open
   questions (e.g. "want the dialogue harder?"). Keep it short.
