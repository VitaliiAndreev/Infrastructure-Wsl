# Infrastructure.Wsl

WSL (Windows Subsystem for Linux) utilities for infrastructure repos.

## Contents

- [Functions](#functions)
- [Installation](#installation)
- [Local tests](#local-tests)
- [CI and linting](#ci-and-linting)

## Functions

| Function | What it does |
|---|---|
| `Assert-Wsl2Ready` | Ensures WSL2 is installed and at least one distro is registered. Throws `Wsl2NotReady` on miss. Runs `wsl --install` first as a remediation attempt. |
| `Assert-WslHasBash` | Probes the targeted distro for `bash` on PATH. Throws `WslMissingBash` on miss. Defends against the Docker-Desktop default distro (`docker-desktop`) which ships busybox without bash. |
| `Invoke-WslShell` | Pass-through wrapper around `wsl -d <distro> -- bash -c <command>`. Pester-mockable so callers don't roll their own shell-escaping per call site. |

All three live under `Infrastructure.Wsl\Public\` and ship via PowerShell Gallery.

## Installation

```powershell
Install-Module Infrastructure.Wsl -MinimumVersion 0.1.0
Import-Module Infrastructure.Wsl
```

## Local tests

Requires the shared CI scaffolding from `Common-PowerShell`:

```powershell
git clone https://github.com/VitaliiAndreev/Common-PowerShell .ci-common
.\scripts\Run-Tests.ps1
```

## CI and linting

The PowerShell module is tested with Pester via `scripts\Run-Tests.ps1`. The
YAML and Bash surfaces (workflows, the `*.sh` runners) are linted by a
separate suite that delegates to **Common-Automation**, so every repo lints
against one shared engine with no per-repo config to drift.

| Workflow | Runs |
|---|---|
| `.github/workflows/ci-yaml.yml` | actionlint, action-validator, yamllint, ansible-lint |
| `.github/workflows/ci-bash.yml` | shellcheck, check-sh-executable, bats |

Each linter auto-skips when its surface is absent. To reproduce the same checks
locally (Git Bash + Docker), three sibling shim commands map to the CI surface:

```bash
# MAIN entry: the full local equivalent of ci-yaml.yml + ci-bash.yml -
# runs the whole lint suite AND the bats tests in one go.
scripts/run-ci-yaml-and-bash.sh              # or double-click scripts\run-ci-yaml-and-bash.bat

# Run a single half - lint only (shellcheck, actionlint, action-validator,
# yamllint, ansible-lint). No PowerShell tests; distinct from Run-Tests.ps1.
scripts/run-lint-yaml-and-bash.sh            # or double-click scripts\run-lint-yaml-and-bash.bat

# Run a single half - the bats tests only.
scripts/run-tests-bash.sh                    # or double-click scripts\run-tests-bash.bat

# Re-stage the +x bit on tracked *.sh files (Windows checkouts drop it,
# tripping the check-sh-executable gate).
scripts/fix-permissions.sh     # or scripts\fix-permissions.bat
```

All three are thin shims over Common-Automation's engine, pointed at this repo
via `COMMON_AUTOMATION_TARGET_REPO`, so a sibling checkout at
`..\Common-Automation` is required. `.gitattributes` pins `*.sh` to LF and
`*.bat` to CRLF - Linux CI runners reject CRLF shebangs.
