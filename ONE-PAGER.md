<!-- SPDX-License-Identifier: MIT AND Apache-2.0 -->

# proclaim-verify — one-page brief

**The problem:** Build a Logos guest from a different directory and the image ID
changes, even though the source is identical. Cargo embeds path-derived symbols
in the ELF. So an ID recorded on one machine is not a safe comparison value on
another — and a wrong ID means you verify or call the wrong program.

**What this tool does:** a small CLI that tells you the truth about the binary
you actually have.

- `program-id <binary.bin>` — ask `lgs` for the real image ID of a built guest
- `check <binary.bin> <expected-hex>` — compare against an expected ID, exit 0/1
  so it drops straight into CI
- `base58 <hex>` — encode/decode IDs without any dependencies
- `repro` — rebuild from a canonical path so two builders get comparable IDs

**Try it in 60 seconds** (needs `bash`, `python3`; `lgs` only for the binary
commands):

```sh
git clone --branch v1.0.0 --depth 1 \
  https://github.com/goldennftplatform-svg/proclaim-verify.git
cd proclaim-verify
chmod +x bin/verify-source run-tests.sh
./bin/verify-source self-test        # 6/6 logic checks
bash run-tests.sh                    # syntax + self-tests + SPDX 10/10
./bin/verify-source base58 4df7d5396b68a16aae6d0f768ef447a0055eb43866827154f71139e486265144
# => 6FMaVQ6CmbAVNHgwsmmeBe5kiiKkQRFtqu4GUQ2vAf2T
```

I cloned the tag into a clean directory and re-ran all of the above before
tagging it.

**Evidence:** [release](https://github.com/goldennftplatform-svg/proclaim-verify/releases/tag/v1.0.0) ·
[11 recorded adversarial self-tests](https://github.com/goldennftplatform-svg/proclaim-verify/blob/main/SELF-TEST-RESULTS.md) ·
[battle-test kit — try to break it](https://github.com/goldennftplatform-svg/proclaim-verify/blob/main/BATTLE-TEST.md)

**Honest scope:** local measuring and comparison only. No chain calls, no proof
generation, no deploy, no submitted solution, no users or adoption. Dual-licensed
`MIT AND Apache-2.0` — both apply.

**Ask:** if you build RISC Zero guests, run the battle-test kit and tell me where
it breaks. Real bugs and nasty input cases are more useful than stars.
