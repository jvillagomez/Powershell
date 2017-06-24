<#
----------------------------------------------------
Title: Add License to User(s)
Author: Juan A Villagomez
----------------------------------------------------
#>
$Module = ((get-item $PSScriptRoot).parent.parent.FullName)+"\functions\DIT.psm1" #Dont remove
Import-Module $Module #Dont remove
Connect-Msol

function Choose-License
{
    $LicensesAvailable = Get-MsolAccountSku

    $prompt = "Choose a License"
    $choice = Select-Option $LicensesAvailable.AccountSkuId $prompt
    $LicenseChosen = $LicensesAvailable[$choice]
    return $LicenseChosen
}

function Choose-Assignees
{
    $AssigneeChoices = @("Single user","Users from list","All Users")
    $prompt = "Choose Assignee(s)"
    $choice = Select-Option $AssigneeChoices $prompt

    If ($choice -eq 0)
    {
        $user = Select-User $All_Users
        return $user
    }
    ElseIf($choice -eq 1)
    {
        $users = Get-UserList $All_Users
        return $users
    }
    Else
    {
        return $All_Users
    }
}

function Add-License
{
    $License = Choose-License
    $DisabledServices = Select-Services $License
    $LicenseObj = New-Object psobject
    Add-Member -InputObject $LicenseObj -MemberType NoteProperty -Name LicenseName -Value $license.AccountSkuId
    Add-Member -InputObject $LicenseObj -MemberType NoteProperty -Name LicenseOptions -Value $DisabledServices

    $Assignees = Choose-Assignees

    Write-Host "Apply:" -foregroundcolor Cyan
    Write-Host "$($License.AccountSkuId)"
    Write-Host "With:" -foregroundcolor Cyan
    Write-Host "$services"
    Write-Host "To:" -foregroundcolor Cyan
    Write-Host "$($Assignees.UserPrincipalName)"

    $prompt = "Proceed?"
    $choices = @("Yes","No")
    $choice = Select-Option $choices $prompt

    if($choice -eq 0)
    {
        Foreach ($assignee in $Assignees)
        {
            Add-UserLicense $assignee $LicenseObj
        }
    }
}

$All_Users = Get-LicensedUsers
Add-License
