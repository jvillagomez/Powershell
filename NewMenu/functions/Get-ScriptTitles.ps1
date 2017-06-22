<#
.SYNOPSIS
    Connect to office365 for license manipulations.

.DESCRIPTION
    Checks for an existing connection. If not connected, prompts user for a username and password.

.OUTPUTS
    NONE

.EXAMPLE
    Connect-Msol

    #If not connected:
    #Please Supply values below:
    #Username: jpavelski@ucx.ucr.edu
    #Password: Pass1234

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
            exit
        }
        return $titles
    }

}
