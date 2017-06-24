<#
.SYNOPSIS
    Creates User Objects form a text file containing names.

.DESCRIPTION
    Opens up a file explorer window, allowing the user to select the txt file. Reads the file for UserPrincipalNames (emails), and returns the user object of each respective name. Must provide array of all available users objuects for matching to occur.

.Parameter name
    [System.Objects] Mandatory; Array of all user objects available.

.OUTPUTS
    Returns an array of User Objects.

.EXAMPLE
    Connect-Msol
    $users = Get-Licensedusers
    $UsersList = Get-UsersFromList $users

    # UsersList contains all import users only!
#>

Function Get-UsersFromList
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $All_Users
    )

    Process
    {
        $All_UserPrincipalNames = $All_Users.UserPrincipalName

        $filePath = Select-File
        $UserList = Get-Content $filePath
        $UserObjects = @()
        Foreach ($user in $UserList)
        {
            $match=0
            Foreach ($UserPrincipalName in $All_UserPrincipalNames)
            {
                If ($user -eq $UserPrincipalName)
                {
                    $match +=1
                    $index = [array]::indexOf($All_UserPrincipalNames, $user)
                    $UserObjects += $All_Users[$index]
                }

            }
            If ($match -eq 0)
            {
                Write-Host "$user was not found" -ForegroundColor Yellow
            }
        }
        return $UserObjects
    }

}
