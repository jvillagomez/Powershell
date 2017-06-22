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
Function Repeat-Function
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [scriptblock]
        $func,

        [string]
        $prompt
    )

    Process
    {
        $choices = @("Yes","No")
        $choice = Select-Option $choices $prompt

        If ($choice -eq 0)
        {
            exit
        }
        else
        {
            $func
        }
    }

}
