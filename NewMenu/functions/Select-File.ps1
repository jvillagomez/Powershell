<#
.SYNOPSIS
    Opens a file explorer window to allow user to select a file.

.DESCRIPTION
    A file explorer window opens, when function is instantiated. Function returns complete path to file chosen.

.PARAMETER Name
    NONE
    A parameter can be implemented to determine where file explorer window opens (root dir). Default is set to "Desktop".

.OUTPUTS
    System.String
    The string conatins the path to file chosen.

.EXAMPLE
    $filePath = Select-Folder

    #Dialog window opens
    #User navigates and chooses DIR of interest

    Write-Host $filePath  #Output = > "C:\some\path\that\you\choose"
#>

Function Select-File
{
    [CmdletBinding()]
    [OutputType([Nullable])]
    Param
    (
        [string] $Description = "Select Folder",
        [string] $RootFolder="Desktop"
    )

    Process
    {
        [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
        $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $OpenFileDialog.initialDirectory = $initialDirectory

        #implement line below to add filtering w/parameters
        #$OpenFileDialog.filter = "TXT (*.txt)| *.txt"

        $OpenFileDialog.ShowDialog() | Out-Null
        return $OpenFileDialog.filename
    }

}
