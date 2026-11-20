<!-- SPDX-License-Identifier: MIT AND Apache-2.0 -->

# Self-test results — `proclaim-verify`

**These are our own tests of our own tool. This is not adoption, not prize
credit, and not a third-party review.** It is legitimate self-testing: the
λPrize rules ban manufactured *adoption* (fake users, registrations,
testimonials), not running and publishing your own test results. We publish
them so others can reproduce or disprove them.

Date: 2026-11-20. Environment: WSL2 Ubuntu, `source ~/.cargo/env`,
`lgs` available on `PATH`, real 463,236-byte guest binary at the canonical
build path. Tool: `bin/verify-source` from `proclaim-verify`.

## Method

Each case runs as a separate shell command; `EXIT` is the real process exit
code. Expected behaviour comes from `BATTLE-TEST.md`. No case was excluded
after seeing its result.

| # | Case | Expected | Actual | Result |
| --- | --- | --- | --- | --- |
| 1 | `base58 deadbeef` | reject, exit 1 | `ERROR: expected 64 lowercase hex characters`, exit 1 | PASS |
| 2 | `base58` 64 uppercase A's | reject, exit 1 | `ERROR: expected 64 lowercase hex characters`, exit 1 | PASS |
| 3 | `base58` 64 g's (non-hex) | reject, exit 1 | `ERROR: expected 64 lowercase hex characters`, exit 1 | PASS |
| 4 | `base58` known vector | correct base58, exit 0 | `6FMaVQ6CmbAVNHgwsmmeBe5kiiKkQRFtqu4GUQ2vAf2T`, exit 0 | PASS |
| 5 | `program-id` binary outside scaffold | clear error, exit 1 | `ERROR: no scaffold.toml found above ...`, exit 1 | PASS |
| 6 | `program-id` non-guest file inside scaffold | reject, exit 1 | `ERROR: lgs did not return a 32-byte hex program ID`, exit 1 | PASS |
| 7 | `program-id` real guest | real ID, exit 0 | `4df7d539…65144`, exit 0 | PASS |
| 8 | `check` correct ID | `MATCH`, exit 0 | `MATCH: 4df7d539…65144`, exit 0 | PASS |
| 9 | `check` wrong ID | `MISMATCH`, exit 1 | `MISMATCH: built=4df7d539…65144 expected=0000…0000`, exit 1 | PASS |
| 10 | `self-test` from `/tmp` | 6 checks pass, exit 0 | 6 `PASS` lines, exit 0 | PASS |
| 11 | `run-tests` from `/tmp` | syntax + self-test + SPDX pass, exit 0 | `syntax OK`, 6 `PASS`, `SPDX: 7/7`, exit 0 | PASS |

**11 of 11 cases passed.** The first attempt of this harness gave a false
failure on cases 7–9 because `lgs` was not on `PATH`; the harness was fixed by
adding `source ~/.cargo/env`, and all cases were rerun. That is recorded here
rather than hidden.

## Verbatim key outputs

```
$ verify-source base58 4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144
6FMaVQ6CmbAVNHgwsmmeBe5kiiKkQRFtqu4GUQ2vAf2T
EXIT=0

$ verify-source program-id .../registry.bin
4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144
EXIT=0

$ verify-source check .../registry.bin <correct ID>
MATCH: 4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144
EXIT=0

$ verify-source check .../registry.bin <wrong ID>
MISMATCH: built=4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144 expected=0000000000000000000000000000000000000000000000000000000000000000
EXIT=1
```

## What this does NOT prove

- Not a third-party or independent review; same author, same machine.
- No on-chain program lookup, no RPC, no deployment, no testnet.
- No zero-knowledge proof generation or verification.
- No bytecode-to-source equivalence proof; the tool compares image IDs.
- No adoption, users, testimonials, registrations, or prize-criterion credit.
- `repro` (canonical-path rebuild) was not executed here; no result claimed.
- One machine, one OS. "Works on my box" is all this establishes.

Independent testers are invited to repeat every case from `BATTLE-TEST.md` and
report disagreements. A failing result is useful and welcome.
