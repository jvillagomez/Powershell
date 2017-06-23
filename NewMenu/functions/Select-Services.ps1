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
Function Select-Services
{
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true)]
        [System.Object]
        $license
    )

    Process
    {
        $services = $license.ServiceStatus.ServicePlan.ServiceName

        $all, $done = "ALL","Finished Selecting"
        $services += $all,$done

        $enabled = @()
        $disabled = @()
        $prompt = "Select Services to ENABLE"
        $choice = 0 #placeholder
        while(($choice -ne -1) -and ($services[$choice] -ne $all) -and ($services[$choice] -ne $done))
        {
            foreach($service in $services)
            {
                if($enabled -contains $service)
                {
                    $services = $services -ne $service
                }
            }

            Write-Host "To Enable: $enabled" -foregroundcolor Green
            $choice = Select-Option $services $prompt
            if($choice -eq (-1))
            {
                exit
            }
            ElseIf($services[$choice] -eq $all)
            {
                write-host "Chose ALL"
                return $disabled
            }
            Else
            {
                if($services[$choice] -eq $done)
                {
                    continue
                }
                $enabled += $services[$choice]
            }
        }
        Foreach ($service in $services)
        {
            if($service -eq $all -or $service -eq $done)
            {
                continue
            }
            if($enabled -notcontains $service)
            {
                $disabled += $service
            }
        }
        return $disabled
    }
}
