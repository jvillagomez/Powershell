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
Function Get-LicensedUsers
{
    Param
    (
        # Param1 help description
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
