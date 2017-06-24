#TODO => finish this. need to continue acses where:
# If EXIT is poart of options chosen
# IF exit is chosen alone

<#
.SYNOPSIS
Prompts the user with a menu. Menu is persistent, until a valid numerical option has been chosen from menu.
Alows user to select multiple numerical options seperated by spaces.

.DESCRIPTION
Long description

.OUTPUTS
The value returned by this cmdlet

.EXAMPLE
Example of how to use this cmdlet
#>
Function Select-MultiOption
{
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

        $ChoicesAreValid = $false
        while ((!$ChoicesAreValid) -and ($choices -notcontains 0))
        {
            Write-host ""
            Write-host $title -foregroundcolor Cyan
            Write-host $border

            $ValidOptions = @(0, $options.Count)
            For ($i = 0; $i -lt $options.Count; $i++)
            {
                $ValidOptions += $i
                Write-host "$($i+1). $($options[$i])"
            }

            Write-host "0. QUIT" -foregroundcolor DarkGray
            Write-host $border

            $choice = read-host "->"
            $choice = $choice.split()

            $ValidEntry = is_Numeric $choice
            if($ValidEntry)
            {
                $choices = @()
                Foreach ($number in $choice)
                {
                    $number = $number.trim()
                    $choices += [int]$number
                }
                $ChoicesAreValid = A-contains-B $ValidOptions $choices
                Write-host ""
            }
        }
        If (($choices.Count -eq 1) -and (($choices-1) -eq -1))
        {
            return "User Quit"
        }
        return ($choice-1)
    }
}
