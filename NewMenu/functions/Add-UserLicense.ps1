<#
.SYNOPSIS
Add single license to user(s).

.DESCRIPTION
Adds a license to selected user(s). If user already has a given license, it will remove it beforehand, and apply the new accordingly.
Must provide:
1. A User Object
2. Custom PS-Object w/members:
    LicenseName
    LicenseOptions

.PARAMETER name
[System.Object] $user: User object. Will fail if => ( $user.GetType() -ne System.Object )
[System.Object] $License: Custom PS-Object. Members include LicenseName and LicenseOptions. Will fail if => ( $License.GetType() -ne System.Object )

.OUTPUTS
NONE. Nothing returned.

.EXAMPLE
Single User (Single-License):
    $users = Get-LicensedUsers   #Get all user objects
    $user = Select-User $users   #Get specific User
    $License = Select-License   #Select a single license
    $services = $Select-Services $License

    $LicenseObject = New-Object psobject    #Create License Custom PS-Object
    Add-Member -InputObject $LicenseObject -MemberType NoteProperty -Name LicenseName -Value $license.AccountSkuId
    Add-Member -InputObject $LicenseObject -MemberType NoteProperty -Name LicenseOptions -Value $DisabledServices

    Add-UserLicense $user $LicenseObject
    # User is Now licensed!
------------------------------------------
In Loop (Multiple-User, Single-Sicense):
    $users = Get-LicensedUsers   # Get all user objects
    $License = Select-License
    $services = Select-Services $License

    $LicenseObject = New-Object psobject
    Add-Member -InputObject $LicenseObject -MemberType NoteProperty -Name LicenseName -Value $license.AccountSkuId
    Add-Member -InputObject $LicenseObject -MemberType NoteProperty -Name LicenseOptions -Value $services

    foreach($user in $users)
    {
        Add-UserLicense $user $LicenseObject
    }
    # Users are Now licensed!
------------------------------------------
In Loop (Multiple-User, Multiple-License):
    $users = Get-LicensedUsers   # Get all user objects
    $Licenses = Select-License

    foreach ($user in $users)
    {
        foreach($license in $Licenses)
        {
            $services = Select-Services $license

            $LicenseObject = New-Object psobject
            Add-Member -InputObject $LicenseObject -MemberType NoteProperty -Name LicenseName -Value $license.AccountSkuId
            Add-Member -InputObject $LicenseObject -MemberType NoteProperty -Name LicenseOptions -Value $services
        }
    }
    # All licenses have been applied to all users!

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
