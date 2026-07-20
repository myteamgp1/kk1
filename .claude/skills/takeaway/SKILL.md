---
name: takeaway
description: After teaching, write the Key Takeaway (teacher log + paste-ready student recap), update student profiles and the lesson index. Use when Mos finishes a class or says "done teaching / write the takeaway".
argument-hint: "[lesson folder — defaults to latest prepped/taught] <what happened in class>"
---

# /takeaway — post-class wrap-up

## Step 1 — Resolve the lesson

Use the argument if given; otherwise the newest `lessons/INDEX.md` row with
status `prepped` or `taught`.

## Step 2 — Get the session notes

If Mos didn't describe the class, ask exactly these four questions (one short
message, all four at once):

1. Who attended?
2. What got covered / skipped vs the plan?
3. Notable errors — who struggled with what (words, tones, patterns)?
4. Did students ask for anything / what should next lesson pick up?

Don't block on perfection — short answers are enough.

## Step 3 — Write `takeaway.md`

Copy `templates/key-takeaway.md` into the lesson folder and fill both parts:

- **Part A (teacher log):** attendees, covered-vs-planned, per-student notes
  with SPECIFIC errors (which tone confused with which, which final dropped),
  class-wide errors, the **spaced-repetition queue** (next lesson / +3 lessons /
  +1 week — pick the items that were weakest), seeds for next lessons, homework.
- **Part B (student recap):** 5–8 key phrases actually covered (Thai + Paiboon
  + English), one pronunciation tip, homework reminder. Keep it inside the
  code fence so Mos can copy it in one tap.

Romanization in Part B follows `reference/romanization.md` — re-derive tones,
same as lesson authoring.

## Step 4 — Propagate

1. Append error rows and homework rows (newest first) to each attendee's
   `students/<name>.md`; update Standing notes if a pattern emerged.
2. Flip the lesson's `lessons/INDEX.md` status to `recapped` and add a short
   note.

## Step 5 — Report

Print Part B in the chat (ready to paste into LINE/WeChat) and list what was
updated. If a seed suggests tomorrow's topic, mention it in one line.
