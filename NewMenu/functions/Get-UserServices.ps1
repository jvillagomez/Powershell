<#
.SYNOPSIS
Extracts user license/services information.

.DESCRIPTION
Provided a user (User Object), will grab their licenses and respective license options (services). not hard-coded, so it will not break when new services are added.

.Parameter name
[System.Object] $user: User Object to extract information from.

.OUTPUTS
Returns an array containing a custom PS-Object for each licnese the user contains. License objects contain an AccountSkuId and its respective disabled services.

.EXAMPLE
Connect-Msol
$users = get-LicensedUsers
$user = Select-User $users
$LicSerInfo = Get-UserServices $user
Write-Host $LicSerInfo

# LicenseName                              LicenseOptions
# -----------                              --------------
# ucxucr:STANDARDWOFFPACK_FACULTY          {SCHOOL_DATA_SYNC_P1, STREAM_O365_E3, INTUNE_O365}
# ucxucr:RIGHTSMANAGEMENT_STANDARD_FACULTY {}
# ucxucr:AAD_PREMIUM                       {EXCHANGE_S_FOUNDATION}
#>
Function Get-UserServices
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object]
        $user
    )

    Process
    {
        $AllLicenses = Get-Licenses
        $UserLicenses = $user.Licenses

        $UserServices = @()

        Foreach ($license in $UserLicenses)
        {
            $LicenseObj = New-Object psobject

            $DisabledServices = @()
            $LicenseServices = $license.ServiceStatus
            $i=0
            Foreach ($service in $LicenseServices)
            {
                $i++
                $isDisabled = ($service.ProvisioningStatus) -ne "Success" -and ($service.ProvisioningStatus) -ne "PendingInput"
                If ($isDisabled)
                {
                    $DisabledServices += ($service.ServicePlan.ServiceName)
                }
            }
            Add-Member -InputObject $LicenseObj -MemberType NoteProperty -Name LicenseName -Value $license.AccountSkuId
            Add-Member -InputObject $LicenseObj -MemberType NoteProperty -Name LicenseOptions -Value $DisabledServices

            $UserServices += $LicenseObj
        }
        return $UserServices
    }
}
