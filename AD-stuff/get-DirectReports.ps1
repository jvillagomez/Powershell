<#
----------------------------------------------------
Title: Direct Reports (w/ Indirect)
Author: Juan A Villagomez
----------------------------------------------------
#>

#independent so it only runs once
$allUsers = get-ADUser -filter *
$i=0
#RETURNS single user OBJECT
function get-User($inputString)
{
    Write-Host "Enter Uname || Name" -ForegroundColor DarkCyan
    $name = Read-Host ("->")
    $name = $name.ToLower()
    #possibleUsers array will be populate with users in AD that match input name-string
    $possibleUsers = @()
    #iterate through each userObject to find a match with input name-string
    Foreach ($user in $allUsers)
    {
            if((($user.SamAccountName).ToLower()).Contains($name) -or (($user.Name).ToLower()).Contains($name))
            {
                $possibleUsers += $user
            }
    }

    # START [no matches were found]
    if($possibleUsers.Count -eq 0)
    {
        Write-Host "Input did not match any users" -ForegroundColor Yellow
        Write-Host ("Try different search? (y/n)") -ForegroundColor DarkCyan
        $rerun = Read-Host("->")
        if($rerun -eq 'y')
        {
            get-User
        }
        exit
    }
    # END [no matches were found]


    $i=1
    Write-Host ("Possible Matches:") -ForegroundColor DarkCyan
    foreach($option in $possibleUsers)
    {
       Write-Host ("$i : $($option.Name)  ($($option.SamAccountName))")
       $i++
    }
    Write-Host ("0 : Exit")
    Write-Host ("Choose User Above") -ForegroundColor DarkCyan
    $choice = Read-Host("->")
    if($choice -eq 0)
    {
        Write-Host ("Try different search? (y/n)") -ForegroundColor DarkCyan
        $rerun = Read-Host("->")
        if($rerun -eq 'y')
        {
            get-User
        }
        exit
    }
    else
    {
        Write-Host ""
        write-host ("MGR: " + $possibleUsers[$choice-1].Name) -ForegroundColor Cyan
        return $possibleUsers[$choice-1].SamAccountName
    }
}

function get-DirectReport
{
    $user = get-User
    #Write-Host "Enter Uname || Name" -ForegroundColor Cyan
    #$user = Read-Host ("->")

    #$directReports = (Get-Aduser -identity $user -Properties directreports | Select-Object -ExpandProperty directReports | Get-ADUser -Properties mail, manager | Select-Object -Property Name, Mail, @{ Name = "Manager"; Expression = { (Get-Aduser -identity $psitem.manager).Name } })
    #$directReports | Format-Table -AutoSize -Wrap
    get-AllReports $user

    Write-Host "Another Report? (y/n)" -ForegroundColor DarkCyan
    $choice = Read-Host ("->")

    if($choice -eq 'y')
    {
        write-Host "==============================================" -ForegroundColor Yellow
        get-DirectReport
    }
    else
    {
        write-Host "==============================================" -ForegroundColor Yellow
    }
}

function get-AllReports($user)
{
    $directReports = (Get-Aduser -identity $user -Properties directreports | Select-Object -ExpandProperty directReports | Get-ADUser -Properties mail, manager | Select-Object -Property Name, SamAccountName, Mail, @{ Name = "Manager"; Expression = { (Get-Aduser -identity $psitem.manager).Name } })

    if(!$directReports -and $i -eq 0)
    {
        write-host('User has no Direct Reports!') -ForegroundColor Red
    }
    else
    {
        $i+=1
        $directReports | Format-Table Name,Mail,Manager # -AutoSize -Wrap
        foreach($reportee in $directReports)
        {
            get-AllReports $reportee.SamAccountName
        }        
    }
}


get-DirectReport