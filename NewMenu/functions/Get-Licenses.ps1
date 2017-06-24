<#
.SYNOPSIS
    Returns all available license names.

.DESCRIPTION
    returns the AccountSkuId for all available licenszes. To be used for validation or menu options.

.OUTPUTS
    Returns array of strings (AccountSkuIds).

.EXAMPLE
    Connect-Msol

    $licensesAvail = Get-Licenses
    Write-Host $licensesAvail

    # ucxucr:AAD_PREMIUM
    # ucxucr:OFFICESUBSCRIPTION_FACULTY
    # ucxucr:STANDARDWOFFPACK_FACULTY
    # ucxucr:RIGHTSMANAGEMENT_STANDARD_FACULTY
    # ucxucr:STANDARDWOFFPACK_STUDENT
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
