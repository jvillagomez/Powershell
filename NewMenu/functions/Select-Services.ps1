#TODO

<#
.SYNOPSIS
Obtains user desired License Options (services) using a menu.

.DESCRIPTION
Given a license as an argument, will prompt user with a menu for selecting services to be ENABLED.
User may enter as many options as desired, each separated by a space. If a single option is invalid, user will be prompted to enter selections again.

.Parameter name
[System.Object] $license: License object must be provided to provide context for available services.

.OUTPUTS
Returns an aray containg services to be disabled (inverse from services chosen by suer in menu). This is due to the way powershell must go about enabling/disbaling licenses/services.

.EXAMPLE

#>
Function Select-Services
{
    Param
    (
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
                return
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
