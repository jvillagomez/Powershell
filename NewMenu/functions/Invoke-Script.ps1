<#
.SYNOPSIS
Runs an external script with no pipeline.

.DESCRIPTION
Preferably used after Select-Option has been run. Will run a script from a given directory, identified by index.
After the called script has finished running, will return to original script.

.Parameter name
[System.String ]$dir: path to directory containing external script.

.OUTPUTS
None. Runs chosen script, and returns to next line in original script.

.EXAMPLE
$dir = "$PSScriptRoot\Scripts"

$titles = Get-ScriptTitles $dir
$prompt = "Licensing Menu"
$choice = Select-Option $titles $prompt # Obtain index to call script contained inside of $dir

Invoke-Script $dir $choice

#>
Function Invoke-Script
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $dir,

        [string]
        $choice
    )
    Process
    {
        Set-Location -LiteralPath $dir
        $filenames = get-childitem
        invoke-expression (".\$($filenames[$choice].name)")
    }
}
