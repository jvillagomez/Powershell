Function Select-User
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $All_Users
    )

    Process
    {
        #Import-Module "C:\functions\powershell\functions\DIT.psm1"

        Write-Host "Please enter a name:" -ForegroundColor Cyan
        $SearchCriteria = Read-Host "->"
        $SearchCriteria = $SearchCriteria.ToLower()
        $usersAlike = @()
        foreach($user in $All_Users)
        {
            $DisplayName = ($user.DisplayName).ToLower()
            $UserPrincipalName = ($user.UserPrincipalName).ToLower()

            if($DisplayName.Contains($SearchCriteria) -or $UserPrincipalName.Contains($SearchCriteria))
            {
                $usersAlike += $user
            }
        }

        if($usersAlike.Count -eq 0)
        {
            $options = @("Yes","No")
            $prompt = "No matches. Try different search?"
            $choice = Select-Option $options $prompt

            if ($choice -eq 0)
            {
                clear-Host
                Select-User $All_Users
            }
            else
            {
                exit
            }
        }

        else
        {
            $options = $usersAlike.DisplayName
            $prompt = "Your search matched the following users:"
            $choice = Select-Option $options $prompt

            if($choice -eq (-1))
            {
                $options = @("Yes","No")
                $prompt = "Try different search?"
                $choice = Select-Option $options $prompt

                if ($choice -eq 0)
                {
                    clear-Host
                    Select-User $All_Users
                }
                else
                {
                    exit
                }
            }
            else
            {
                return $usersAlike[$choice]
            }
        }
    }
}
