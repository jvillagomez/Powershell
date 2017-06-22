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

        $options = New-MsolLicenseOptions -AccountSkuId $LicenseName -DisabledPlans $disabled
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $LicenseName -LicenseOptions $options
    }

}
