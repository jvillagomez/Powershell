# START [Connect to office]---------------------------------
$connection = Get-PSSession
if($connection.Count -ne 1)
{
    $UserCredential = Get-Credential
    Connect-MsolService -Credential $UserCredential > $null
    New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection > $null
    clear
}
# END [Connect to office]---------------------------------

# START [Removal of Users in file]-------------------------
function remove-TeamUsers
{
    $365EduForFac = "ucxucr:STANDARDWOFFPACK_FACULTY"
    $on = @("Success","PendingInput")
    
    # For testing ONLY
    #$users = (Get-MsolUser -All) | Where {$_.UserPrincipalName -eq "jpavelski@ucx.ucr.edu"}
    
    $users = (Get-MsolUser -All) | Where {$_.Licenses.AccountSkuId -contains $365EduForFac}
    
    foreach($user in $users)
    {
        write-host $user.UserPrincipalName
    }
    
    Write-Host "Remove Services for ALL users above? (y/n)" -ForeGroundColor Cyan
    $confirm = Read-Host("->")

    if($confirm = 'y')
    {
        # START [Iterate through users]--------------------------------
        Foreach ($user in $users)
        {
            $license  = $user.Licenses | Where {$_.AccountSkuId -eq $365EduForFac}
            $services = $license.ServiceStatus
            $services_Status = $services.ProvisioningStatus
            $services_Name = $services.ServicePlan.ServiceName

            $disabled = @("SCHOOL_DATA_SYNC_P1","STREAM_O365_E3")
            For ($i = 2; $i -le $services.Count; ++$i)
            {
                if($on -NotContains $services_Status[$i])
                {
                    $disabled += $services_Name[$i]
                }
            }
            $disabled = $disabled | ? {$_}
                
            Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -RemoveLicenses $365EduForFac
            $licOptions = New-MsolLicenseOptions -AccountSkuId $365EduForFac -DisabledPlans $disabled
            Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $365EduForFac -LicenseOptions $licOptions

            Write-Host $user.UserPrincipalName -ForegroundColor Cyan
        }
    }
}
# END [Removal of Users in file]-------------------------

# Begin ---------------------------------
remove-TeamUsers
