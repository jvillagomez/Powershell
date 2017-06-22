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

Function Get-LicensedUsers
{
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false)]
        [string]
        $LicenseName
    )

    Process
    {
        #Import-Module "C:\functions\powershell\functions\DIT.psm1"
        $Valid_Licenses = Get-Licenses
        if ($LicenseName)
        {
            if($Valid_Licenses.Contains($LicenseName))
            {
                $users = (Get-MsolUser -All) | Where {$_.Licenses.AccountSkuId -contains $LicenseName}
                return $users
            }
            else
            {
                return "Invalid license provided!"
            }
        }
        else
        {
            # return all licensed users, if no specific license was provided
            $users = get-msolUser -All | Where {$_.isLicensed -eq "True"}
            return $users
        }
    }
}

Function Get-Licenses
{
    Param
    (
    )

    Process
    {
        #Import-Module "C:\functions\powershell\functions\DIT.psm1"
        Connect-Msol

        $LicenseNames = Get-MsolAccountSku
        $LicenseNames = $LicenseNames.AccountSkuId

        return $LicenseNames
    }
}

function is_Numeric
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $value
    )

    Process
    {
        $value = $value.trim()
        $onlyNumeric = $value -match "^[0-9]+$"

        if (!$onlyNumeric)
        {
            return $false
        }

        return $true
    }
}

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

Function Select-Folder
{
    Param
    (
        [string] $Description = "Select Folder",
        [string] $RootFolder="Desktop"
    )
    Process
    {
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
}

Function Select-Option
{
    [CmdletBinding()]
    [OutputType([Nullable])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]] $options,
        [string] $prompt
    )
    Process
    {
        $title = "     " + $prompt + "     "
        $border = "-" * $title.Length

        $choice = "placeholder"
        while (!(is_Numeric $choice) -or $choice -lt 0 -or $choice -gt $options.Count ){
            Write-host ""
            Write-host $title -foregroundcolor Cyan
            #Write-host "      Choose an option below:     " -foregroundcolor Cyan
            Write-host $border

            For ($i = 0; $i -lt $options.Count; $i++)
            {
                Write-host "$($i+1). $($options[$i])"
            }
            Write-host "0. QUIT" -foregroundcolor DarkGray
            Write-host $border
            $choice = read-host "->"
            $choice = $choice.trim()
            if(!(is_Numeric $choice)){
                continue
            }
            $choice = [int]$choice
            Write-host ""
        }
        If (($choice-1) -eq -1)
        {
            exit
        }
        return ($choice-1)
    }
}

Function Select-User
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object[]] $All_Users
    )

    Process
    {
        #Import-Module "C:\functions\powershell\functions\DIT.psm1"

        Write-Host "Please enter a name:" -ForegroundColor Cyan
        $SearchCriteria = Read-Host "->"
        $SearchCriteria = $SearchCriteria.ToLower()
        $usersAlike = @()
        foreach($user in $All_Users)
        {
            $DisplayName = ($user.DisplayName).ToLower()
            $UserPrincipalName = ($user.UserPrincipalName).ToLower()

            if($DisplayName.Contains($SearchCriteria) -or $UserPrincipalName.Contains($SearchCriteria))
            {
                $usersAlike += $user
            }
        }

        if($usersAlike.Count -eq 0)
        {
            $options = @("Yes","No")
            $prompt = "No matches. Try different search?"
            $choice = Select-Option $options $prompt

            if ($choice -eq 0)
            {
                clear-Host
                Select-User $All_Users
            }
            else
            {
                exit
            }
        }

        else
        {
            $options = $usersAlike.DisplayName
            $prompt = "Your search matched the following users:"
            $choice = Select-Option $options $prompt

            if($choice -eq (-1))
            {
                $options = @("Yes","No")
                $prompt = "Try different search?"
                $choice = Select-Option $options $prompt

                if ($choice -eq 0)
                {
                    clear-Host
                    Select-User $All_Users
                }
                else
                {
                    exit
                }
            }
            else
            {
                return $usersAlike[$choice]
            }
        }
    }
}

Function Get-ScriptTitles
{
    Param
    (
        [Parameter(Mandatory=$true)]
        $dir
    )

    Process
    {
        $fileCount = (Get-ChildItem $dir).Count
        $titles = @()
        foreach ($scriptFile in get-childitem $dir)
        {
            $title = ((get-content "$($scriptFile.DirectoryName)\$($scriptFile.Name)")[0 .. 10] | select-string -pattern "Title:").ToString()
            $titles += $title.Trimstart("Title: ")
        }

        if($fileCount -ne $titles.Count)
        {
            Write-Host "One of the scripts is missing a title. Please correct and try again."
            exit
        }
        return $titles
    }

}

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

        $all += "ALL"
        $done += "Finished Selecting"
        $services += $all
        $services += $done

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

Function Add-UserLicense
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Object]
        $user,

        [System.Object]
        $License
    )

    Process
    {
        $LicenseName = $License.LicenseName
        $disabledServices = $License.LicenseOptions

        $UserLicenses = $user.Licenses.AccountSkuId
        If ($UserLicenses -contains $LicenseName)
        {
            Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -RemoveLicenses $LicenseName
        }

        $options = New-MsolLicenseOptions -AccountSkuId $LicenseName -DisabledPlans $disabledServices
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $LicenseName -LicenseOptions $options
    }

}
