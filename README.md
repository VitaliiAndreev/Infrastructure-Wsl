# Infrastructure.Wsl

WSL (Windows Subsystem for Linux) utilities for infrastructure repos.

## Contents

- [Functions](#functions)
- [Installation](#installation)
- [Local tests](#local-tests)

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
