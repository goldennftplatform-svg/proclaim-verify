<!-- SPDX-License-Identifier: MIT AND Apache-2.0 -->

# Portable program IDs in CI

Problem: a clean runner rebuilds the same guest source from a different
absolute checkout path and gets a different image ID. Asserting a constant
captured on a developer machine therefore fails on Actions even though the
source, locks, toolchain and flags are identical. Evidence is in
[`docs/CI-PROGRAM-ID-INVESTIGATION.md`](https://github.com/goldennftplatform-svg/proclaim-labs/blob/main/docs/CI-PROGRAM-ID-INVESTIGATION.md).

Do **not** "fix" this by pasting the failing ID into the expected constant.
That makes the assertion pass while destroying what it was checking, and any
downstream base58/PDA constants derived from the old ID will still be wrong.

Instead, derive everything from the build CI actually produced.

## 1. Derive the ID from the built binary

Replace the equality assertion with a format check and an env export:

```sh
lgs spel -- program-id path/to/registry.bin --format hex \
  | tee e2e-artifacts/program-id.txt
BUILT_ID="$(tr -d '\r' < e2e-artifacts/program-id.txt | tail -n 1)"
printf '%s' "$BUILT_ID" | grep -Eq '^[0-9a-f]{64}$' \
  || { echo 'ERROR: not a 32-byte hex ID' >&2; exit 1; }
echo "E2E_PROGRAM_ID=$BUILT_ID" >> "$GITHUB_ENV"
```

This still fails loudly if `lgs` returns garbage, but no longer rejects a
binary purely because it was built at a different path.

## 2. Derive base58 from that ID

`verify-source base58 "$BUILT_ID"` does this, or inline:

```sh
BASE58_PID="$(python3 - "$PID" <<'PY'
import sys
a = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
h = sys.argv[1].rjust(64, "0")
n = int(h, 16)
out = ""
while n:
    n, r = divmod(n, 58)
    out = a[r] + out
zeros = (len(h) - len(h.lstrip("0"))) // 2
print("1" * zeros + out)
PY
)"
```

Check with the known vector: the ID
`4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144` encodes to
`6FMaVQ6CmbAVNHgwsmmeBe5kiiKkQRFtqu4GUQ2vAf2T`.

## 3. Derive PDAs, do not assert stale constants

```sh
PDA_ENTRY="$(lgs spel -- pda entry --key "$PID" | tr -d '\r' | tail -n 1)"
PDA_INDEX="$(lgs spel -- pda index | tr -d '\r' | tail -n 1)"
test -n "$PDA_ENTRY" && test -n "$PDA_INDEX"
test "$PDA_ENTRY" != "$PDA_INDEX"
```

If your workflow requires stable published IDs, the correct answer is a
canonical build path plus a recorded ID from that path — not a universal
constant. Treat an image ID as valid for the exact build that produced it.
