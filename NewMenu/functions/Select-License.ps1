<#
.SYNOPSIS
    Menu for selecting License(s).

.DESCRIPTION
    Prompts user with a menu to select license(s). Grabs available licenses using 'Get-MsolAccountSku', so it wont break with newly added license types.

.OUTPUTS
    Array of License Custom PS-Objects.


.EXAMPLE
    Connect-Msol

    #If not connected:
    #Please Supply values below:
    #Username: jpavelski@ucx.ucr.edu
    #Password: Pass1234

#>
Function Select-Services
{
    Param
    (
    )

    Process
    {
        $LicensesAvailable = Get-MsolAccountSku

        $all, $done = "All", "Finished Selecting"
        $LicensesAvailable = $LicensesAvailable += $all,$done

        $LicensesToApply = @()
        $prompt = "Select Licence(s) to ENABLE"
        $choice = 0 #placeholder
        while(($choice -ne -1) -and ($LicensesAvailable[$choice] -ne $all) -and ($LicensesAvailable[$choice] -ne $done))
        {
            Write-Host "To Enable:" -foregroundcolor Green
            Write-Output $enabled
            $choice = Select-Option $LicensesAvailable $prompt
            if($choice -eq (-1))
            {
                exit
            }
            ElseIf($LicensesAvailable[$choice] -eq $all)
            {
                return $LicensesAvailable
            }
            Else
            {
                if($LicensesAvailable[$choice] -eq $done)
                {
                    continue
                }
                $LicensesToApply += $LicensesAvailable[$choice]
            }
        }
        return $LicensesToApply
    }
}
