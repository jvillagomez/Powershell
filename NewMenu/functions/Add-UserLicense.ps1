<#
.SYNOPSIS
    Connect to office365 for license manipulations.

.DESCRIPTION
    Checks for an existing connection. If not connected, prompts user for a username and password.

.OUTPUTS
    NONE

.EXAMPLE
    Connect-Msol

    #If not connected:
    #Please Supply values below:
    #Username: jpavelski@ucx.ucr.edu
    #Password: Pass1234

#>
Function Add-UserLicense
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object]
        $user,

        [System.Object]
        $License
    )

    Process
    {
        $LicenseName = $License.LicenseName
        $disabledServices = $License.LicenseOptions

        $UserLicenses = $user.Licenses.AccountSkuId
        If ($UserLicenses -contains $LicenseName)
        {
            Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -RemoveLicenses $LicenseName
        }

        $options = New-MsolLicenseOptions -AccountSkuId $LicenseName -DisabledPlans $disabledServices
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $LicenseName -LicenseOptions $options
    }

}
