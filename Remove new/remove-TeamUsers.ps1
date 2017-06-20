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
    # START [get users from file]-------------------------
    $inputFile = get-FileName "C:\source\STAFFHUBservice"
    $fileData = get-content $inputfile
    $users = (Get-MsolUser -All).UserPrincipalName
    # END [get users from file]-------------------------
    # START [confirm all users listed]-------------------------
    Write-Host "Confirm users below" -ForegroundColor Cyan
    foreach ($uname in $fileData)
    {
        Write-Host $uname
    }
    Write-Host "Remove TEAMS for ALL users above? (y/n)" -ForeGroundColor Cyan
    $confirm = Read-Host("->")
    # END [confirm all users listed]-------------------------
    # START [applying lic with STAFFHUB disabled]-------------------------------
    if($confirm = 'y')
    {
        # START [Iterate through users]--------------------------------
        Foreach ($name in $users)
        {
            $user = Get-MsolUser -UserPrincipalName $name
            $dname = $user.DisplayName
            $uname = $user.UserPrincipalName
            # START [User is not licensed]--------------
            if($user.Licenses.AccountSkuId -notcontains "ucxucr:STANDARDWOFFPACK_FACULTY")
            {
                # START {Ask if admin wishes to license user W/ TEAMS1 disabled}--------------
                write-host "User does not have prexisting license" -ForegroundColor Yellow
                write-host "You must apply the license first." -ForegroundColor Yellow
                Write-Host "Apply License using default settings for initial licensing [enaables: blah blah]? (y/n)" -ForegroundColor Cyan
                # END {Ask if admin wishes to license user W/ TEAMS1 disabled}--------------

                $initialize = Read-Host('->')
                # START {license user W/ TEAMS1 disabled}--------------
                if($initialize -eq 'y')
                {
                    $standardServices = New-MsolLicenseOptions -AccountSkuId ucxucr:STANDARDWOFFPACK_FACULTY -DisabledPlans TEAMS1,Deskless,FLOW_O365_P2,POWERAPPS_O365_P2,OFFICE_FORMS_PLAN_2,PROJECTWORKMANAGEMENT,SWAY,INTUNE_O365,YAMMER_EDU,SHAREPOINTWAC_EDU,SHAREPOINTSTANDARD_EDU
                    Set-MsolUserLicense -UserPrincipalName $uname -AddLicenses ucxucr:STANDARDWOFFPACK_FACULTY -LicenseOptions $standardServices
                    $user = Get-MsolUser -UserPrincipalName $uname
                    if($user.licenses.AccountSkuId -contains 'ucxucr:STANDARDWOFFPACK_FACULTY')
                    {
                        Write-host "$dname was licensed successfully!" -ForegroundColor Green
                    }
                    else
                    {
                        Write-host "$dname was not licensed. Error Occured" -ForegroundColor Red
                    }
                    continue
                }
                # END {license user W/ STAFFHUB enabled}--------------
                # START {dont license user}--------------
                else
                {
                    Write-host "Chose not to License: $dname"
                    Write-host "$dname was not licensed, therefore does not have TEAMS"
                    continue
                }
                # END {dont license user}--------------
            }
            # END [user is not licensed]-------------------------
            # START [user is licensed]-------------------------
            foreach($license in $user.Licenses)
            {
                # START [check status of TEAMS1]-----------------
                if($license.AccountSkuId -eq "ucxucr:STANDARDWOFFPACK_FACULTY")
                {
                    $services = $license.ServiceStatus
                    $sStatus = $services.ProvisioningStatus
                    $sNames = $services.ServicePlan.ServiceName
                    # START [if TEAMS1 is disabled]-----------------
                    if($sStatus[0] -ne "SUCCESS")
                    {
                        Write-Host "$dname already has TEAMS enabled" -ForegroundColor Yellow
                        continue
                    }

                    $disabled = @()
                    For ($i = 0; $i -le $services.Count; ++$i)
                    {
                        if($i -ne 0)
                        {
                            if($sStatus[$i] -ne "SUCCESS")
                            {
                                $disabled += $snames[$i]
                            }
                        }
                    }
                    $disabled += "TEAMS1"
                    $disabled = $disabled | ? {$_}
                    Set-MsolUserLicense -UserPrincipalName $uname -RemoveLicenses ucxucr:STANDARDWOFFPACK_FACULTY
                    $licOptions = New-MsolLicenseOptions -AccountSkuId ucxucr:STANDARDWOFFPACK_FACULTY -DisabledPlans $disabled
                    Set-MsolUserLicense -UserPrincipalName $uname -AddLicenses ucxucr:STANDARDWOFFPACK_FACULTY -LicenseOptions $licOptions

                    # START [confirm TEAMS1 disabling]-----------------
                    $user = Get-MsolUser -UserPrincipalName $uname
                    foreach($license in $user.Licenses)
                    {
                        if($license.AccountSkuId -eq "ucxucr:STANDARDWOFFPACK_FACULTY")
                        {
                            if($license.ServiceStatus[0].ProvisioningStatus -eq 'SUCCESS')
                            {
                                Write-Host "$dname now has TEAMS enabled" -ForegroundColor Green
                            }
                            else
                            {
                                Write-Host "$dname could not have TEAMS enabled" -ForegroundColor Red
                            }
                        }

                    }
                    # END [confirm TEAMS1 disabling]-----------------
                }
                # END [check status of TEAMS1]-----------------
            }
            # END [User is licensed]--------------
        }
        # END [Iterate through users]--------------------------------
    }
    # END [applying lic with STAFFHUB disabled]-------------------------------
}
# END [Removal of Users in file]-------------------------

# Begin ---------------------------------
remove-TeamUsers
