<#
.SYNOPSIS
    WSL (Windows Subsystem for Linux) utilities for infrastructure repos.

.DESCRIPTION
    Provides WSL-specific functions extracted from Common.PowerShell and
    Infrastructure-Vm-Provisioner to keep each module cohesive and
    single-purpose. WSL is a Windows-exclusive runtime; everything in
    this module assumes wsl.exe is available on PATH (or that callers
    have first run Assert-Wsl2Ready).

    Current functions:
      - Assert-Wsl2Ready - ensures WSL2 is installed and at least one
        distro is registered. Throws Wsl2NotReady on miss.
      - Assert-WslHasBash - probes the targeted distro for bash on PATH.
        Throws WslMissingBash on miss (Docker Desktop's docker-desktop
        default distro has no bash, so callers that rely on
        `#!/usr/bin/env bash` need this gate after Assert-Wsl2Ready).
      - Invoke-WslShell - thin pass-through to `wsl -d <distro> -- bash
        -c <command>`. Pester-mockable boundary so callers do not roll
        their own shell-escaping each time.

    Each function lives in its own file under Public\ and is dot-sourced
    below so diffs stay focused on a single function per commit.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. "$PSScriptRoot\Public\Assert-Wsl2Ready.ps1"
. "$PSScriptRoot\Public\Assert-WslHasBash.ps1"
. "$PSScriptRoot\Public\Invoke-WslShell.ps1"

# Export-ModuleMember controls what is actually callable after Import-Module.
# It takes precedence over FunctionsToExport in the psd1 at runtime, so both
# must be kept in sync. FunctionsToExport serves a separate purpose: it is
# read by Get-Module -ListAvailable, Find-Module, and PSGallery for fast
# discovery without loading the module. The shared Module.Tests.ps1 in the
# run-unit-tests action enforces that every Public\*.ps1 file appears in both.
Export-ModuleMember -Function @(
    'Assert-Wsl2Ready',
    'Assert-WslHasBash',
    'Invoke-WslShell'
)
