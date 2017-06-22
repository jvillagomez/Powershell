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
        #Import-Module "C:\functions\powershell\functions\DIT.psm1"

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
