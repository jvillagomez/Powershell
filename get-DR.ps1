# START [User query]---------------------------------
function select-user($allusers, $inputx)
{
    $usersAlike = @()
    # START [check ValidUsers for inputUser]---------------------------------
    foreach($user in $allusers)
    {
        if(($($user).DisplayName).Contains($inputx) -or ($($user).UserPrincipalName).Contains($inputx))
        {
            $usersAlike += $user
        }
    }
    # END [check ValidUsers for inputUser]---------------------------------

    # START [If no users match inputUser]---------------------------------
    if($usersAlike.Count -eq 0)
    {
        Write-Host "Input did not match any users" -ForegroundColor Yellow
        Write-Host ("Try different search? (y/n)") -ForegroundColor Cyan
        $rerun = Read-Host("->")
        if($rerun -eq 'y')
        {
            get-AADuser
        }
        exit
    }
    # END [If no users match inputUser]---------------------------------

    # START [Choose user from matches]---------------------------------
    $i=1
    Write-Host ("Did you mean:") -ForegroundColor Cyan
    foreach($option in $usersAlike)
    {
       Write-Host ("$i : $($option.DisplayName)  ($($option.UserPrincipalName))")
       $i++
    }
    Write-Host ("0 : Exit")
    Write-Host ("Choose User Above") -ForegroundColor Cyan
    $choice = Read-Host("->")
    if($choice -eq 0)
    {
        Write-Host ("Try different search? (y/n)") -ForegroundColor Cyan
        $rerun = Read-Host("->")
        if($rerun -eq 'y')
        {
            get-AADuser
        }
        exit
    }
    else
    {
        return $usersAlike[$choice-1]
    }
    # END [Choose user from matches]---------------------------------
}
# END [User query]---------------------------------

#function get-DRdirect()
Write-Host "Enter Uname || Name" -ForegroundColor Cyan
$user = Read-Host ("->")
Get-Aduser -identity $user -Properties directreports | Select-Object -ExpandProperty directReports | Get-ADUser -Properties mail, manager | Select-Object -Property Name, Mail, @{ Name = "Manager"; Expression = { (Get-Aduser -identity $psitem.manager).samaccountname } }


