#!/usr/bin/env bash
# make_pdf.sh — render a handout HTML file to PDF with headless Chromium.
#
# Usage:
#   tools/make_pdf.sh <input.html> [output.pdf]
#
# Output defaults to the input path with .html replaced by .pdf.
# Fonts come from @font-face rules in assets/handout.css (bundled TTFs);
# no system fonts are required.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <input.html> [output.pdf]" >&2
  exit 2
fi

IN="$1"
if [[ ! -f "$IN" ]]; then
  echo "error: input file not found: $IN" >&2
  exit 1
fi
IN_ABS="$(realpath "$IN")"
OUT="${2:-${IN_ABS%.html}.pdf}"

# Resolve a Chromium binary (Playwright's bundled build, then PATH fallbacks).
CHROMIUM=""
for candidate in \
  /opt/pw-browsers/chromium \
  /opt/pw-browsers/chromium-*/chrome-linux/chrome \
  "$(command -v chromium || true)" \
  "$(command -v chromium-browser || true)" \
  "$(command -v google-chrome || true)"; do
  if [[ -n "$candidate" && -x "$candidate" ]]; then
    CHROMIUM="$candidate"
    break
  fi
done
if [[ -z "$CHROMIUM" ]]; then
  echo "error: no Chromium binary found" >&2
  exit 1
fi

"$CHROMIUM" \
  --headless \
  --no-sandbox \
  --disable-gpu \
  --no-pdf-header-footer \
  --virtual-time-budget=10000 \
  --print-to-pdf="$OUT" \
  "file://$IN_ABS" 2>/dev/null

if [[ ! -f "$OUT" ]]; then
  echo "error: Chromium produced no output" >&2
  exit 1
fi

SIZE=$(stat -c%s "$OUT")
# A real handout with embedded Thai/CJK fonts is well over 50 KB;
# a tiny file means the fonts did not embed (check @font-face paths).
if [[ "$SIZE" -lt 50000 ]]; then
  echo "error: output suspiciously small (${SIZE} bytes) — fonts likely missing; check @font-face paths in assets/handout.css" >&2
  exit 1
fi

PAGES=$(strings "$OUT" | awk 'match($0,/\/Count [0-9]+/){n=substr($0,RSTART+7,RLENGTH-7)} END{print (n?n:"?")}')
echo "OK: $OUT (${SIZE} bytes, ${PAGES} pages)"
