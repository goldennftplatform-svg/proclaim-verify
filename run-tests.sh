#!/usr/bin/env bash
# SPDX-License-Identifier: MIT AND Apache-2.0
# Single entry point for the proclaim-verify checks. No network, no credentials.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"

echo "=== shell syntax ==="
bash -n "$HERE/bin/verify-source"
bash -n "$HERE/tests/self-test.sh"
echo "syntax OK"

echo "=== self-test ==="
bash "$HERE/tests/self-test.sh"

echo "=== SPDX headers ==="
TOTAL=$(find "$HERE" -path "$HERE/.git" -prune -o -type f \
  \( -name '*.sh' -o -name '*.md' \) -print | wc -l)
OK=$(find "$HERE" -path "$HERE/.git" -prune -o -type f \
  \( -name '*.sh' -o -name '*.md' \) -print0 \
  | xargs -0 grep -l 'SPDX-License-Identifier: MIT AND Apache-2.0' | wc -l)
echo "SPDX: $OK/$TOTAL"
[ "$OK" = "$TOTAL" ] || exit 1

echo "all checks passed"
