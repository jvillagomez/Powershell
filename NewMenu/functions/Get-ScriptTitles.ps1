<#
.SYNOPSIS
Grab tiles from all scripts in a given directory

.DESCRIPTION
Given a directory path, will copy all titles from .ps1 file headers. Use in providing a menu for Invoke-Script function (Calling other scripts).
All scripts in given directory MUST have a title, or error will be thrown. All scripts must contain a title to avoid any indexing errors

.Parameter name
[System.Sring] $dir: string containing the path containing ps1 scripts.

.OUTPUTS
Returns an array of strings (script titles).
 
.EXAMPLE
Connect-Msol
$PathToScripts = "C:\PowerShell\module"
$titles = Get-ScriptTitles
Write-Host $titles


# Check STAFFHUB status (single)
# Report STAFFHUB users (all)
# Remove STAFFHUB user (single)
# Remove STAFFHUB users (bulk)
# Set STAFFHUB user (single)
# Set STAFFHUB users (bulk)
#>
Function Get-ScriptTitles
{
    Param
    (
        [Parameter(Mandatory=$true)]
        $dir
    )

    Process
    {
        $fileCount = (Get-ChildItem $dir).Count
        $titles = @()
        foreach ($scriptFile in get-childitem $dir)
        {
            $title = ((get-content "$($scriptFile.DirectoryName)\$($scriptFile.Name)")[0 .. 10] | select-string -pattern "Title:").ToString()
            $titles += $title.Trimstart("Title: ")
        }

        if($fileCount -ne $titles.Count)
        {
            Write-Host "One of the scripts is missing a title. Please correct and try again."
        }
        else
        {
            return $titles
        }
    }

}
