Import-Module MSOnline

$UserCredential = Get-Credential

Connect-MsolService -Credential $UserCredential

New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

$user = Get-MsolUser -UserPrincipalName jpavelski@ucx.ucr.edu

Write-Output -InputObject $user.Licenses

#$license = $user.Licenses[0].AccountSkuId

Set-MsolUserLicense -UserPrincipalName jpavelski@ucx.ucr.edu -RemoveLicenses ucxucr:STANDARDWOFFPACK_FACULTY

Write-Output -InputObject $user.Licenses

$licOptions = New-MsolLicenseOptions -AccountSkuId ucxucr:STANDARDWOFFPACK_FACULTY -DisabledPlans vergergeg

Set-MsolUserLicense -UserPrincipalName jpavelski@ucx.ucr.edu -AddLicenses ucxucr:STANDARDWOFFPACK_FACULTY

Write-Output -InputObject $user.Licenses