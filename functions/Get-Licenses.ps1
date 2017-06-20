<#
.SYNOPSIS
    Short description

.DESCRIPTION
    Long description

.OUTPUTS
    The value returned by this cmdlet

.EXAMPLE
    Example of how to use this cmdlet

.LINK
    To other relevant cmdlets or help
#>
Function Get-Licenses
{
    Param
    (
    )

    Process
    {
        . "C:\Users\jvillagomez\OneDrive - ucx.ucr.edu\dave\functions\Connect-Msol.ps1"
        Connect-Msol

        $LicenseNames = Get-MsolAccountSku
        $LicenseNames = $LicenseNames.AccountSkuId

        return $LicenseNames
    }
}
