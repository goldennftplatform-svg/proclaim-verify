<!-- SPDX-License-Identifier: MIT AND Apache-2.0 -->

# RESULT — proclaim-verify

## What shipped

A standalone, dependency-light CLI (`bin/verify-source`) that other Logos
builders can clone and run locally to:

- encode a 32-byte program ID as base58,
- read the real image ID of a built guest `.bin` via `lgs`,
- compare a build against an expected ID with a machine-readable exit code,
- rebuild a guest from a canonical absolute path for comparable IDs,
- self-test the pure logic with no external crates or packages.

## Exact commands run (WSL, 2026-11-20)

```sh
bash run-tests.sh
```

Output:

```text
=== shell syntax ===
syntax OK
=== self-test ===
PASS: base58 known vector
PASS: base58 all-zero vector
PASS: reject short hex
PASS: reject non-hex
PASS: reject missing binary
PASS: usage exit code
self-test: all checks passed
=== SPDX headers ===
SPDX: 4/4
all checks passed
```

Known vector check:

```sh
./bin/verify-source base58 4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144
# 6FMaVQ6CmbAVNHgwsmmeBe5kiiKkQRFtqu4GUQ2vAf2T
```

All-zero vector:

```sh
./bin/verify-source base58 0000000000000000000000000000000000000000000000000000000000000000
# 11111111111111111111111111111111
```

`--help` exits 2 as designed (no command given); the usage text is printed to
stderr.

### End-to-end run against a real built guest

`tests/real-binary-smoke.sh` was run against the real 463,236-byte
`registry.bin` at
`/home/xps/logos-work/registry/methods/guest/target/riscv32im-risc0-zkvm-elf/docker/registry.bin`,
from a working directory outside the project (project root detected via
`scaffold.toml`):

```text
=== real binary: .../docker/registry.bin ===
program-id: 4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144
MATCH: 4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144
expected-ID check: PASS
wrong-ID rejection: PASS (exit 1)
real-binary smoke: PASS
```

This is a real `lgs` readout of an actual guest binary, not a mock. It says
nothing about whether that program is deployed or correct.

## What was measured, and what was not

**Measured here:** real executions of the CLI's pure logic and validation
paths, plus a real end-to-end `lgs` readout and match/mismatch check on an
actual built guest binary. The base58 implementation reproduces the
independently known ID/base58 pair exactly, and rejects malformed input. The
`repro` command was **not** executed in this session: it needs a fresh guest
build (which is slow), and no result from it is claimed here.

**Not implemented / not claimed:**

- No on-chain lookup, no RPC, no proof generation or verification.
- No network calls by the tool itself.
- No claim that any program ID is deployed, correct, or prize-eligible.
- No adoption, users, testimonials, or CI results asserted by this repository.
- No Docker, no credentials, no submission, no deployment.
- The `repro` command's output is only valid for the absolute path used; the
  tool prints that caveat itself.

## License

MIT AND Apache-2.0. Both licenses apply; see `LICENSE-MIT` and `LICENSE-APACHE`.
