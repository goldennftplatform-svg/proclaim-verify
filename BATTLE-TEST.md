<!-- SPDX-License-Identifier: MIT AND Apache-2.0 -->

# Battle-test kit

This is a public test target. It is **not** a prize submission, not a
deployment, and not a claim about any on-chain program. We want other builders
to clone it, run it, and tell us what breaks.

## Quick start (about 1 minute)

```sh
git clone https://github.com/goldennftplatform-svg/proclaim-verify.git
cd proclaim-verify
bash run-tests.sh
```

Expected: syntax checks pass, six self-test checks pass, SPDX count matches,
and the script exits 0. If you get anything else, that is a bug report.

## Real guest test (needs a Logos scaffold and `lgs`)

Build your own guest, then:

```sh
./bin/verify-source program-id path/to/registry.bin
./tests/real-binary-smoke.sh path/to/registry.bin <expected-hex64>
```

Expected: a 64-character lowercase hex ID, `MATCH` for the expected value,
`wrong-ID rejection: PASS (exit 1)`, and exit 0 overall. The tool finds your
project by walking up from the binary for `scaffold.toml`, so you do not need to
`cd` into the project first.

## What to try to break

- Pass a malformed program ID (short, uppercase, non-hex). It must be rejected.
- Run `program-id` on a binary outside any Logos project. It must fail with a
  clear message, not a stack trace or a fake ID.
- Run `check` with a wrong expected ID in a shell script. It must exit 1.
- Run `self-test` from a different working directory. It must still pass.
- Compare IDs from builds at two different absolute paths. They are expected to
  differ; that is documented behaviour, not a bug. Tell us if the tool hides it.

## How to report a bug

Include:

1. OS and shell (e.g. Ubuntu 24.04 bash, WSL2 Ubuntu, macOS zsh).
2. `python3 --version`, `lgs --version` if relevant, and Rust toolchain.
3. The exact command you ran.
4. The complete output and the exit code (`echo $?`).
5. Whether you used a real built guest or only the self-test.

Open an issue on
`goldennftplatform-svg/proclaim-verify`, or post in Logos Discord
**#builder-hub**. Be specific; "it didn't work" is not actionable.

## Boundaries — what this tool does NOT do

- No on-chain lookup, no RPC, no network calls by the tool itself.
- No proof generation or proof verification.
- No submission, deployment, analytics, telemetry, or credential use.
- No claim that any program ID is deployed, correct, or prize-eligible.
- No adoption, users, testimonials, or prize-criterion credit.

`repro` builds a guest locally from a canonical path and was **not** executed
by us in this repository's verification run; any result you get from it is
yours, at your build path.

## Related public targets

- `goldennftplatform-svg/proclaim-labs` — 8 published local Rust workspaces,
  323 tests, each with README/RESULT and exact commands. A real-ZK workspace is
  being verified locally but is not published yet.
- `goldennftplatform-svg/proclaim-module-starter` — third-party module template.
- `https://goldennftplatform-svg.github.io/proclaim-site/build.html` — honest
  status page, including the self-assessment and all zero adoption counters.

Licensed MIT AND Apache-2.0. Both licenses apply.
