#!/usr/bin/env bash
# SPDX-License-Identifier: MIT AND Apache-2.0
# Dependency-free tests for the pure logic in verify-source.
set -euo pipefail
TOOL="$(cd "$(dirname "$0")/.." && pwd)/bin/verify-source"
KNOWN_HEX=4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144
KNOWN_B58=6FMaVQ6CmbAVNHgwsmmeBe5kiiKkQRFtqu4GUQ2vAf2T

pass() { printf 'PASS: %s\n' "$1"; }
fail() { printf 'FAIL: %s\n' "$1" >&2; exit 1; }

[ "$("$TOOL" base58 "$KNOWN_HEX")" = "$KNOWN_B58" ] && pass 'base58 known vector' || fail 'base58 known vector'
ZERO=$(printf '0%.0s' $(seq 1 64))
[ "$("$TOOL" base58 "$ZERO")" = "11111111111111111111111111111111" ] && pass 'base58 all-zero vector' || fail 'base58 all-zero vector'
if "$TOOL" base58 deadbeef >/dev/null 2>&1; then fail 'reject short hex'; else pass 'reject short hex'; fi
if "$TOOL" base58 "$(printf 'g%.0s' $(seq 1 64))" >/dev/null 2>&1; then fail 'reject non-hex'; else pass 'reject non-hex'; fi
if "$TOOL" check /definitely/not/a/file "$KNOWN_HEX" >/dev/null 2>&1; then fail 'reject missing binary'; else pass 'reject missing binary'; fi
"$TOOL" --help >/dev/null 2>&1 && fail 'usage exit code' || pass 'usage exit code'
printf 'self-test: all checks passed\n'
