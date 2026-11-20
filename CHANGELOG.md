<!-- SPDX-License-Identifier: MIT AND Apache-2.0 -->

# Changelog

## v1.0.0 — 2026-11-20

First tagged release. No functional change from `f0b6224`.

- `bin/verify-source`: base58 encoding, real guest image-ID lookup via `lgs`,
  expected-ID comparison with machine-readable exit codes, and canonical-path
  rebuild.
- `BATTLE-TEST.md`: public kit for third parties to try to break the tool.
- `SELF-TEST-RESULTS.md`: 11/11 adversarial cases with exact commands and
  outputs, including the first harness failure that was fixed and retained.
- `RESULT.md`: exactly what was run and what was not.

Scope: local verification only. Nothing here deploys, submits, or verifies
anything on a chain. Dual-licensed `MIT AND Apache-2.0`.
