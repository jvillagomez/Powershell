#=========================================================================
$Module = ((get-item $PSScriptRoot).parent.FullName)+"\functions\DIT.psm1"
Import-Module $Module
#=========================================================================
Connect-Msol

function License-Menu
{
    $dir = "$PSScriptRoot\Scripts"

    $titles = Get-ScriptTitles $dir
    $prompt = "Licensing Menu"

    $choice = Select-Option $titles $prompt

    Invoke-Script $dir $choice

    $prompt = "Run another script?"
    $choices = @("Yes","No")
    $choice = Select-Option $choices $prompt

    if ($choice -eq 1)
    {
        exit
    }
    License-Menu
}

License-Menu
