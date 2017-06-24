<#
.SYNOPSIS
Menu for selecting License(s).

.DESCRIPTION
Prompts user with a menu to select license(s). Grabs available licenses using 'Get-MsolAccountSku', so it wont break with newly added license types.

.Parameter name
NONE

.OUTPUTS
Array of License Custom PS-Objects.

.EXAMPLE
Connect-Msol
$licenses = Select-License
$licenses # writes objects to console

#>
Function Select-License
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
        $prompt = "Select License(s) to ENABLE"
        $choice = 0 #placeholder
        while(($choice -ne -1) -and ($LicensesAvailable[$choice] -ne $all) -and ($LicensesAvailable[$choice] -ne $done))
        {
            Write-Host "To Enable:" -foregroundcolor Green
            Write-Output $enabled
            write-host $LicensesAvailable.AccountSkuId
            $choice = Select-Option $LicensesAvailable.AccountSkuId $prompt
            if($choice -eq (-1))
            {
                return
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

Select-License