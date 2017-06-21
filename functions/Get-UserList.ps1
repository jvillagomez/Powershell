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
