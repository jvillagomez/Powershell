<#
----------------------------------------------------
Title: Get Invalid AD Info
Author: Juan A Villagomez
----------------------------------------------------
#>
$exclusionStrings = @("Sophos","room","ebc","healthinsurance","ucr","services","admission","purchasing","DOA","SMS","IEP","Business","EX1","Super","Anon Svn","admin","linux","Destiny","Parking","exchsiteconn","captcha","internet","auth","ucrx","ucx","hermes")

$manageNull = @()
$manageDisabled = @()
$invalidReportees = @()

function get-ADuserInfo
{
    $allUsers = get-ADUser -filter *
    
    $validUsers = @()    
    $manageNull = @()
    $manageDisabled = @()
    $reportDisabled = @()

    foreach($user in $allUsers)
    {
        $DistinguishedName = ($user.DistinguishedName)
        if($user.enabled -and !$DistinguishedName.Contains("OU=E-Mail Only") -and $DistinguishedName.Contains("CN=Users"))
        {
            $exclusionMatches = 0
            $name = ($user.samaccountname).ToLower()
            $dname = ($user.Name).ToLower()
            foreach($identifier in $exclusionStrings)
            {
                $identifier=$identifier.ToLower()
                if($name.Contains($identifier) -or $dname.Contains($identifier))
                {
                    $exclusionMatches += 1 
                }
            }        
            if($exclusionMatches -gt 0)
            {
                continue
            }
            $validUsers += $user
        }
    }
    
    $counter = 0

    foreach($user in $validUsers)
    {
        $counter++
        Write-Progress -Activity 'Processing Users' -CurrentOperation $user.samaccountname -PercentComplete (($counter / $validUsers.count) * 100)

        $userObj = Get-ADUser $user.samaccountname -Properties manager, displayName
        # START {MGR CHECK}
        if ($userObj.manager -eq $null) 
        {
            $manageNull += $userObj.samaccountname
        }
        else
        {
            $manager = (Get-ADUser (Get-ADUser $user.samaccountname -Properties manager).manager)
            if (!$manager.enabled) 
            {
                $userObj = New-Object PSObject -Property @{employee=$userObj.samaccountname;mgr=$manager.samaccountname} 
                $manageDisabled += $userObj
            }
        }
        # END {MGR CHECK}
        
        # START {DR CHECK}
        $directReports = (Get-Aduser -identity $user.samaccountname -Properties directreports | Select-Object -ExpandProperty directReports | Get-ADUser -Properties mail, manager | Select-Object -Property Name, SamAccountName, Mail, @{ Name = "Manager"; Expression = { (Get-Aduser -identity $psitem.manager).Name } }).samaccountname
        if($directReports)
        {
            foreach($reportee in $directReports)
            {
                $exclusions = 0
                foreach($exclusion in $exclusionStrings)
                {
                    if($reportee.Contains($exclusion))
                    {
                        $exclusions += 1
                    }
                }

                if($exclusions -eq 0)
                {
                    $reportee = get-aduser -identity $reportee
                    if(!$reportee.enabled)
                    {
                        $userObj = New-Object PSObject -Property @{reportee=$reportee.samaccountname;mgr=$user.samaccountname} 
                        $reportDisabled += $userObj
                    }
                }
            }
        }
        # END {DR CHECK}
    }
    
     Write-Progress -Activity 'Processing Users' -Completed
    
    if($manageNull.Count -ne 0)
    {
        Write-Host ""
        write-host "Employees w/Null MGRs" -ForegroundColor Cyan
        foreach($user in $manageNull)
        {
            write-host "$user"
        }
    }
    if($manageDisabled.Count -ne 0)
    {
        Write-Host ""
        write-host "Employees w/Disabled MGRs" -ForegroundColor Cyan
        foreach($user in $manageDisabled)
        {
            $employee = $user.employee
            $mgr = $user.mgr
            write-host "Employee: $employee"
            write-host "Manager : $mgr" -ForegroundColor Gray
        }
    }
    if($reportDisabled.Count -ne 0)
    {
        Write-Host ""
        write-host "Employees w/Disabled Reportees" -ForegroundColor Cyan
        foreach($user in $reportDisabled)
        {
            $mgr = $user.mgr
            $reportee = $user.reportee
            write-host "MGR      : $mgr"
            write-host "Reportee : $reportee" -ForegroundColor Gray
        }
    }

    
    Write-Host ""
    Write-Host "Run again? (y/n)" -ForegroundColor DarkCyan
    $choice = Read-Host ("->")

    if($choice -eq 'y')
    {
        write-Host "========================================================" -ForegroundColor Yellow
        get-ADuserInfo
    }
    else
    {
        write-Host "========================================================" -ForegroundColor Yellow
    }
}

get-ADuserInfo
