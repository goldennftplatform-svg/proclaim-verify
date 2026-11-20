<!-- SPDX-License-Identifier: MIT AND Apache-2.0 -->

This is the first tagged release of `proclaim-verify`.

It is a small CLI for Logos builders who need to know what image ID a guest
binary actually has, especially when a clean rebuild produces a different ID
because of Cargo path-derived symbols.

Install and check in under a minute:

```sh
git clone --branch v1.0.0 --depth 1 https://github.com/goldennftplatform-svg/proclaim-verify.git
cd proclaim-verify
chmod +x bin/verify-source run-tests.sh
./bin/verify-source self-test
bash run-tests.sh
```

What works without `lgs`: `base58`, `self-test`. What needs `lgs` on `PATH`:
`program-id`, `check`, `repro`.

Evidence: `RESULT.md`, `SELF-TEST-RESULTS.md` (11/11 adversarial cases), and
`BATTLE-TEST.md` for anyone who wants to try to break it. All checks passed
again from a clean checkout before this tag.

**Honest scope:** this verifies local guest binaries and build provenance. It
does not deploy, submit, or verify anything on a chain. It is not a prize
submission, not adoption, and not a claim about any on-chain program.
Dual-licensed `MIT AND Apache-2.0` — both apply.
