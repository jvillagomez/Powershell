#Import-Module MSOnline

#$UserCredential = Get-Credential

#Connect-MsolService -Credential $UserCredential

#New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#$user = Get-MsolUser -UserPrincipalName jpavelski@ucx.ucr.edu

$allUsers = Get-MsolUser

$pname = "@ucx.ucr.edu"
$uname = Read-Host -Prompt "Enter Username "
$user = $uname + $pname

if ($allUsers.UserPrincipalName -contains $user)
{
    $index = $allUsers.UserPrincipalName.IndexOf($user)
    $employee = $allUsers.DisplayName[$index]
    $confirm = Read-Host -Prompt "Modify $employee : $user ? "

    if($confirm -eq 'y')
    {
        $userAccount = Get-MsolUser -UserPrincipalName $user
        
        Write-Host ("Current Licenses: ")
        Write-Output -InputObject $userAccount.Licenses
        
        $licOptions = New-MsolLicenseOptions -AccountSkuId ucxucr:STANDARDWOFFPACK_FACULTY -DisabledPlans FLOW_O365_P2,POWERAPPS_O365_P2,OFFICE_FORMS_PLAN_2,PROJECTWORKMANAGEMENT,SWAY,INTUNE_O365,YAMMER_EDU

        Set-MsolUserLicense -UserPrincipalName $user -AddLicenses ucxucr:STANDARDWOFFPACK_FACULTY -LicenseOptions $licOptions
        Set-MsolUserLicense -UserPrincipalName $user -AddLicenses ucxucr:RIGHTSMANAGEMENT_STANDARD_FACULTY 

        Write-Host ("Updated Licenses: ")
        Write-Output -InputObject $userAccount.Licenses

        #ensure services are correct (with what dave wants)
        #make the listed licensec prettir by filetring only the ID
    }
    else
    {
        #split into fucntions for recursion
        #account for answers 'y', 'n', and anything invalid
    }
}
else
{
    Write-Host('INVALID USERNAME PROVIDED')
}


# write if loop to validate if user even exists
#   loop through all names in get-msoluser to valuidate existence
#   if name exists in array, print NAME
#   start over if not correct
# write if loop to confirm chosen user is correct user
#   start over if not correct


#Write-Output -InputObject $user.Licenses


#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#Import-PSSession $Session  

# this is what is needed to make a connection to )365
# this does not need to be in the finished product
# of the two scripts
  #Get-MsolUser -All | where {$_.UsageLocation -eq $null}

 #Set-MsolUser -UserPrincipalName (Read-Host "User UPN to set Usage location") -UsageLocation US  

 # Get-MsolAccountSku | Select -ExpandProperty ServiceStatus
 # (Get-MsolAccountSku | where {$_.AccountSkuId -eq 'litwareinc:ENTERPRISEPACK'}).ServiceStatus
