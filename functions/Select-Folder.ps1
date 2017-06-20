<#
.SYNOPSIS
    Opens a file explorer window to allow user to select a directory.

.DESCRIPTION
    A file explorer window opens, whne function is instantiated. Function returns path to directory chosen.

.PARAMETER Name
    NONE
    A parameter can be implemented to determine where file explorer window opens (root dir). Default is set to "Desktop".

.OUTPUTS
    System.String
    The string conatins the path to directory chosen.

.EXAMPLE
    $path = Select-Folder

    #Dialog window opens
    #User navigates and chooses DIR of interest

    Write-Host $path  #Output = > "C:\some\path\that\you\choose"

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
