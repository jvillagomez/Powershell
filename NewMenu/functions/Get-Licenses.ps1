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
        $LicenseNames = Get-MsolAccountSku
        $LicenseNames = $LicenseNames.AccountSkuId

        return $LicenseNames
    }
}
