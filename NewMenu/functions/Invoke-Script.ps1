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
