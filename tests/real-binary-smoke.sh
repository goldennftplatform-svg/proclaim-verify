#!/usr/bin/env bash
# SPDX-License-Identifier: MIT AND Apache-2.0
# End-to-end check against a REAL built guest binary. Requires lgs on PATH.
# Usage: real-binary-smoke.sh <registry.bin> [expected-hex64]
set -euo pipefail
[ $# -ge 1 ] || { echo "Usage: $0 <registry.bin> [expected-hex64]" >&2; exit 2; }
BIN="$1"
EXPECT="${2:-}"
TOOL="$(cd "$(dirname "$0")/.." && pwd)/bin/verify-source"

echo "=== real binary: $BIN ==="
ID="$("$TOOL" program-id "$BIN")"
printf '%s' "$ID" | grep -Eq '^[0-9a-f]{64}$' \
  || { echo "FAIL: lgs returned a malformed ID: $ID" >&2; exit 1; }
echo "program-id: $ID"

if [ -n "$EXPECT" ]; then
  "$TOOL" check "$BIN" "$EXPECT"
  echo "expected-ID check: PASS"
fi

ZERO=0000000000000000000000000000000000000000000000000000000000000000
if "$TOOL" check "$BIN" "$ZERO" >/dev/null 2>&1; then
  echo 'FAIL: wrong ID was accepted' >&2
  exit 1
fi
echo "wrong-ID rejection: PASS (exit 1)"
echo "real-binary smoke: PASS"
