<#
----------------------------------------------------
Title: Add License to User(s)
Author: Juan A Villagomez
----------------------------------------------------
#>
#=========================================================================
$Module = ((get-item $PSScriptRoot).parent.FullName)+"\functions\DIT.psm1"
Import-Module $Module
#=========================================================================
Connect-Msol

function Choose-License
{
    $LicensesAvailable = Get-MsolAccountSku

    $prompt = "Choose a License"
    $choice = Select-Option $LicensesAvailable.AccountSkuId $prompt
    $LicenseChosen = $LicensesAvailable[$choice]
    return $LicenseChosen
}

function Choose-Services
{
    # Apply parameter here for specific license chosen
    $disabled = @()
    $services = $license.ServiceStatus.ServicePlan.ServiceName

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
    $Assignees = Choose-Assignees

    $confirm

}

$All_Users = Get-LicensedUsers
Add-License
