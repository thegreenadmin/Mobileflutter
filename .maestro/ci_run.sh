#!/usr/bin/env bash
# CI runner for .github/workflows/maestro.yml: installs the APK on the running
# emulator and runs every top-level flow in .maestro/flows one at a time, so a
# failing or crashing flow doesn't stop the rest. Writes
# maestro-results/results.tsv (flow, PASS/FAIL, seconds) plus per-flow logs
# and screenshots (Maestro's takeScreenshot output, command log and logcat go
# to maestro-results/<flow>/ via --test-output-dir). Exits non-zero if any flow failed.
set -uo pipefail

APK="${1:?Usage: ci_run.sh <apk> [flow-name-regex]}"
FILTER="${2:-.}"
MAESTRO_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="${MAESTRO_OUT:-maestro-results}"
mkdir -p "$OUT"
: > "$OUT/results.tsv"

adb install -r "$APK"

failed=0
for flow in "$MAESTRO_DIR"/flows/*.yaml; do
  name="$(basename "$flow" .yaml)"
  [[ "$name" =~ $FILTER ]] || continue
  echo "::group::$name"
  start=$(date +%s)
  if maestro test "$flow" \
      --format junit --output "$OUT/$name.xml" \
      --test-output-dir "$OUT/$name" \
      --debug-output "$OUT/$name" > "$OUT/$name.log" 2>&1; then
    status=PASS
  else
    status=FAIL
    failed=$((failed + 1))
    # Where the flow got stuck: screen + view hierarchy.
    adb exec-out screencap -p > "$OUT/$name-fail.png" || true
    adb exec-out uiautomator dump /dev/tty > "$OUT/$name-fail.xml" 2>/dev/null || true
  fi
  secs=$(( $(date +%s) - start ))
  tail -40 "$OUT/$name.log"
  echo "::endgroup::"
  echo "$name: $status (${secs}s)"
  printf '%s\t%s\t%s\n' "$name" "$status" "$secs" >> "$OUT/results.tsv"
done

total=$(wc -l < "$OUT/results.tsv")
echo "Maestro: $((total - failed))/$total flows passed"
[ "$failed" -eq 0 ]
