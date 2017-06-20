<#
.SYNOPSIS
    Prompts the user with a menu.

.DESCRIPTION
    This will output a menu to the console, displaying array elements as numerical options. Pormpt isd persistent. If an invalid option is chosen, prompt will re-run until a proper option has been chosen.

.PARAMETER Name
    [string[]] $options
    Array with options to prompt user with.

.OUTPUTS
    System.Int 
    The respective index of the numerical key chosen. Not the numerical key itself, but the index of the element corresponding to numerical key chosen.

.EXAMPLE
    $array = @("option1","option2","option3")

    get-Menu $array
    (Console)

          Choose an option below:     
    ----------------------------------
    1. option1
    2. option2
    3. option3
    0. Quit

    If user inputs "2", function returns "1" (index of chosen element in $array for further computation).


#>
Function get-Menu
{
    [CmdletBinding()]
    [OutputType([Nullable])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]] $options
    )
    Process
    {
        . "C:\Users\jvillagomez\OneDrive - ucx.ucr.edu\dave\functions\is_Numeric.ps1"

        $arraySize = $options.Count
        $choice = "placeholder"
        while (!(is_Numeric $choice) -or $choice -lt 0 -or $choice -gt $options.Count ){
            clear-Host
            Write-host "      Choose an option below:     " -foregroundcolor Cyan
            Write-host "----------------------------------"
            
            For ($i = 0; $i -lt $options.Count; $i++)
            {
                Write-host "$($i+1). $($options[$i])"
            }
            Write-host "0. QUIT" -foregroundcolor DarkGray
            Write-host "----------------------------------"
            $choice = read-host "->"
            $choice = $choice.trim()
            if(!(is_Numeric $choice)){
                continue
            }
            $choice = [int]$choice

        }
        return ($choice-1)
    }
}


#FOR TESTING ONLY
$array = @("egeg","adadad","egsegergs","ghkwefgkuwr","w;ekfhekfhkjwehf","fgjwrgfjwfj")
get-Menu $array
