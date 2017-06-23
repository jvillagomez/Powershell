<#
.SYNOPSIS
    Returns collection of User Objects (Licensed users only).

.DESCRIPTION
    By default (no paramters), returns an array of user objects. Obejcts correspond to any users who hare currently licensed. When $LicenseName parameter is provided, returns all user objects that contain the respective license.

.Parameter name
    [string] $LicenseName: Optional; Should contain AccountSkuId of respective license.

.OUTPUTS
    Returns [System.Object] $users; an array of User Objects.

.EXAMPLE
    No Parameter:
        Connect-Msol
        $users = Get-LicensedUsers
        # Returns array of users!

    Single AccountSkuId:
        Connect-Msol
        $AccountSkuId
        $users = Get-LicensedUsers
        # Returns array of users!

    Multiple AccountSkuId:
        Connect-Msol
        $users = Get-LicensedUsers
        # Returns array of users!
#>
Function Get-LicensedUsers
{
    Param
    (
        [Parameter(Mandatory=$false)]
        [string]
        $LicenseName
    )

    Process
    {
        #Import-Module "C:\functions\powershell\functions\DIT.psm1"

        $Valid_Licenses = Get-Licenses
        if ($LicenseName)
        {
            if($Valid_Licenses.Contains($LicenseName))
            {
                $users = (Get-MsolUser -All) | Where {$_.Licenses.AccountSkuId -contains $LicenseName}
                return $users
            }
            else
            {
                return "Invalid license provided!"
            }
        }
        else
        {
            # return all licensed users, if no specific license was provided
            $users = get-msolUser -All | Where {$_.isLicensed -eq "True"}
            return $users
        }
    }
}

Get-LicensedUsers
