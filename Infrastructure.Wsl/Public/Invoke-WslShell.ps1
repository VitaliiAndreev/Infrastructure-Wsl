function Invoke-WslShell {
<#
.SYNOPSIS
    Thin pass-through to `wsl -d <distro> -- bash -c <command>`.

.DESCRIPTION
    Exists so callers that shell into WSL share a single Pester-mockable
    boundary instead of each rolling their own `& wsl -d ...` block and
    tripping the same shell-escaping pitfalls. The wrapper itself does
    nothing clever - it just hands the command to bash inside the named
    distro and returns stdout/stderr verbatim. `$LASTEXITCODE` is set by
    the native wsl process and propagates to the caller as-is.

    Assumes Assert-Wsl2Ready and (where bash is required) Assert-WslHasBash
    have already run; this function does not re-verify them.

.PARAMETER Distro
    Name of the WSL distro to run inside. Required - the wrapper does
    not fall back to the system default because Docker Desktop silently
    moves the default to its no-bash 'docker-desktop' engine distro and
    that silent fallback masks the root cause.

.PARAMETER Command
    The bash command to execute. Passed verbatim as a single string
    argument to `bash -c`, so multi-line scripts and pipes are supported
    without per-call-site quoting ceremony.

.EXAMPLE
    Invoke-WslShell -Distro 'Ubuntu-24.04' -Command 'ping -c 3 192.168.1.1'

.EXAMPLE
    # The native wsl exit code propagates - check $LASTEXITCODE.
    $output = Invoke-WslShell -Distro $distro -Command 'systemctl is-active sshd'
    if ($LASTEXITCODE -ne 0) { ... }
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Distro,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Command
    )
    & wsl -d $Distro -- bash -c $Command
}
