<#
.SYNOPSIS
Connect to office365 for license manipulations.

.DESCRIPTION
Checks for an existing connection. If not connected, prompts user for a username and password. Faster than default Get-MsolConnect cmdlet.

.Parameter name
NONE

.OUTPUTS
NONE

.EXAMPLE
Connect-Msol

#If not connected:
#Please Supply values below:
#Username: jpavelski@ucx.ucr.edu
#Password: Pass1234
#>
Function Connect-Msol
{
    Param
    (
    )
    Process
    {
        $connection = Get-PSSession
        if($connection.Count -ne 1)
        {
            $UserCredential = Get-Credential
            Connect-MsolService -Credential $UserCredential > $null
            New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection > $null
            clear
            #write-host "New Msol Connection Established" -ForegroundColor Green
            return
        }
        #write-host "Previous Msol Connection Detected" -ForegroundColor Green
        return
    }
}
