BeforeAll {
    # wsl stub - the function is invoked via `& wsl` from the source.
    # Pester Mock binds to this stub at dot-source time, so per-test
    # Mock calls take effect against the same target.
    function wsl { $global:LASTEXITCODE = 0 }

    . "$PSScriptRoot\..\Infrastructure.Wsl\Public\Invoke-WslShell.ps1"
}

Describe 'Invoke-WslShell' {

    Context 'argument shape' {

        It 'invokes wsl with the requested distro and bash command' {
            # ParameterFilter captures every invocation's $args
            # collection; we assert on the joined argv string so
            # PS does not strip the literal '--' token.
            $script:capturedArgs = @()
            Mock wsl {
                $script:capturedArgs = @($args)
                $global:LASTEXITCODE = 0
            }

            Invoke-WslShell -Distro 'Ubuntu-24.04' -Command 'ping -c 3 1.1.1.1'

            $joined = $script:capturedArgs -join ' '
            $joined | Should -Match '-d\s+Ubuntu-24\.04'
            $joined | Should -Match 'bash\s+-c\s+ping -c 3 1\.1\.1\.1'
        }
    }

    Context 'exit code propagation' {

        It 'returns the wsl-side LASTEXITCODE to the caller' {
            Mock wsl { $global:LASTEXITCODE = 42 }

            Invoke-WslShell -Distro 'Ubuntu-24.04' -Command 'false' | Out-Null

            $LASTEXITCODE | Should -Be 42
        }
    }

    Context 'parameter validation' {

        It 'rejects an empty Distro' {
            { Invoke-WslShell -Distro '' -Command 'true' } |
                Should -Throw -ExpectedMessage '*Distro*'
        }

        It 'rejects an empty Command' {
            { Invoke-WslShell -Distro 'Ubuntu-24.04' -Command '' } |
                Should -Throw -ExpectedMessage '*Command*'
        }
    }
}
