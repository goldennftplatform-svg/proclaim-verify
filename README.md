<!-- SPDX-License-Identifier: MIT AND Apache-2.0 -->

# proclaim-verify

A small, usable CLI for Logos builders who need to check RISC Zero guest
binaries before they trust a program ID. It runs **real local commands**: it
computes base58 encodings, asks `lgs` for the image ID of an actual `.bin`,
compares that ID against an expected value, and can rebuild a guest at a
canonical path so two builders get comparable IDs.

**One independent builder, sharing a tool for review and reuse.** Not a team
product, not a prize submission, not a deployment, not a claim about any
on-chain program. Nothing here submits, publishes, or verifies anything on a
chain.

Licensed **MIT AND Apache-2.0** — both licenses apply. See `LICENSE-MIT` and
`LICENSE-APACHE`.

---

## Why this exists

A clean rebuild of the same guest source can produce a **different image ID**
when built from a different absolute directory. The cause is Cargo embedding
path-derived symbol strings in the ELF; one loaded header byte (`e_shoff`)
changes, so the measured image ID changes. That means an ID recorded on one
machine is not automatically a valid comparison value on another.

Full read-only investigation:
[`docs/CI-PROGRAM-ID-INVESTIGATION.md`](https://github.com/goldennftplatform-svg/proclaim-labs/blob/main/docs/CI-PROGRAM-ID-INVESTIGATION.md).

This tool does not paper over that. It tells you what the ID is for the binary
or build you actually have, and it labels path-derived IDs as path-specific.

## Requirements

- `bash`, `python3`
- `lgs` on `PATH` for `program-id`, `check`, and `repro`
- For `repro` only: a Logos scaffold project, `cargo +risc0`, and the usual
  RISC Zero target installed. No Docker is used or required.

## Install

```sh
git clone https://github.com/goldennftplatform-svg/proclaim-verify.git
cd proclaim-verify
chmod +x bin/verify-source tests/self-test.sh run-tests.sh
./bin/verify-source self-test
```

Optional: put `bin/` on your `PATH` to call `verify-source` directly.

## Commands

```sh
# Base58-encode a 32-byte hex program ID (no lgs needed)
./bin/verify-source base58 \
  4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144
# => 6FMaVQ6CmbAVNHgwsmmeBe5kiiKkQRFtqu4GUQ2vAf2T

# Print the real image ID of a built guest binary
./bin/verify-source program-id path/to/registry.bin

# Compare a local build against an expected ID (exit 0 = match, 1 = mismatch)
./bin/verify-source check path/to/registry.bin <hex64>

# Rebuild from a canonical absolute path and print the resulting ID
./bin/verify-source repro --source /path/to/project --work /tmp/repro-work

# Run the dependency-free logic tests
./bin/verify-source self-test

# End-to-end check against your own real built guest (needs lgs + a scaffold)
./tests/real-binary-smoke.sh path/to/registry.bin <expected-hex64>
```

`program-id` and `check` locate the Logos project automatically by walking up
from the binary path for `scaffold.toml` and running `lgs` there. You do not
need to `cd` into the project first, and relative binary paths work.

`check` exits non-zero on a mismatch or a malformed ID, so it is safe to use in
a shell script or CI job. It prints `built=` and `expected=` values to make the
failure diagnosable.

## What this is NOT

- Not on-chain verification, not proof generation, not proof verification.
- Not a substitute for checking source, builds, and deployment independently.
- Not evidence of adoption, users, testimonials, or prize-criterion completion.
- Not a claim that any particular program ID is correct or deployed.

It is a local measuring and comparison tool, nothing more.

## Files

| Path | Purpose |
| --- | --- |
| `bin/verify-source` | The CLI. Bash + python3, no third-party crates or npm packages. |
| `tests/self-test.sh` | Dependency-free tests for base58, validation, and exit codes. |
| `tests/real-binary-smoke.sh` | Optional end-to-end check against a real guest `.bin` you build yourself. |
| `run-tests.sh` | One-command test runner with exit code. |
| `docs/PORTABLE-PROGRAM-IDS.md` | How to remove path-specific ID assertions from a CI workflow. |
| `RESULT.md` | Exact commands, results, and honest limitations. |
