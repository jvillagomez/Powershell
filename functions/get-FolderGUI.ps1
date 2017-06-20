<#
.SYNOPSIS
    Prompts the user with a menu.

.DESCRIPTION
    This will output a menu to the console, displaying array elements as numerical options. Pormpt isd persistent. If an invalid option is chosen, prompt will re-run until a proper option has been chosen.

.PARAMETER Name
    [string[]] $options
    Array with options to prompt user with.

.OUTPUTS
    System.Int
    The respective index of the numerical key chosen. Not the numerical key itself, but the index of the element corresponding to numerical key chosen.

.EXAMPLE

#>

Function Select-Folder
{
    Param
    (
        [string] $Description = "Select Folder",
        [string]$RootFolder="Desktop"
    )

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $objForm = New-Object System.Windows.Forms.FolderBrowserDialog
    $objForm.Rootfolder = $RootFolder
    $objForm.Description = $Description
    $Show = $objForm.ShowDialog()
    If ($Show -eq "OK")
    {
        Return $objForm.SelectedPath
    }
    Else
    {
        Write-Error "Operation cancelled by user."
    }
}


Select-Folder
