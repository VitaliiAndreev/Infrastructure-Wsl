@{
    ModuleVersion        = '0.1.0'
    GUID                 = '9f4c8d11-7a32-4b8e-9d5f-2c1e3b4a5d6f'
    Author               = 'Vitaly Andrev'
    Description          = 'WSL (Windows Subsystem for Linux) utilities for infrastructure repos.'
    PowerShellVersion    = '7.0'
    CompatiblePSEditions = @('Core')
    RootModule        = 'Infrastructure.Wsl.psm1'
    # FunctionsToExport is module discovery metadata: used by
    # Get-Module -ListAvailable, Find-Module, and PSGallery without loading
    # the module. It does NOT control what is callable at runtime - that is
    # governed by Export-ModuleMember in the psm1, which takes precedence.
    # Both lists must stay in sync. The shared Module.Tests.ps1 in the
    # run-unit-tests action enforces this.
    FunctionsToExport = @(
        'Assert-Wsl2Ready',
        'Assert-WslHasBash',
    )
    CmdletsToExport   = @()
    AliasesToExport   = @()
}
