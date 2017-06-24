<#
.SYNOPSIS
Checks if string ONLY contains numerical characters. Also accepts arrays.

.DESCRIPTION
Checks characters inside of the input string. If anything other than numerical characters are found, returns FALSE.
For arrays passed as arguments, function will perform a check on each element. If a single element contains non-numerical characters, it will return $false.

.PARAMETER name
[System.String] Input string to check for numerical characters.

.OUTPUTS
[System.Bool] Returns $true, if every character is numeric.

.EXAMPLE
is_Numeric "1234"    #Returns TRUE
is_Numeric " 123"    #Returns TRUE
is_Numeric "12 4"    #Returns FALSE
is_Numeric "ABDC"    #Returns FALSE
is_Numeric "A2D3"    #Returns FALSE

$array = @("1")             #true
is_Numeric $array
$array = @("1", "2", "3")   #true
is_Numeric $array
$array = @("1", "2", " 3")  #true
is_Numeric $array
$array = @("1", "2", " A")  #false
is_Numeric $array
$array = @("1", "2", " ")   #false
is_Numeric $array
$array = @("a")             #false
is_Numeric $array
#>

function is_Numeric
{
    Param(
        [Parameter(Mandatory=$true)]
        [string[]] $array
    )

    Process
    {
        If ($array.Count -gt 1)
        {
            Foreach ($member in $array)
            {
                $member = $member.trim()
                $onlyNumeric = $member -match "^[0-9]+$"

                If (!$onlyNumeric)
                {
                    return $false
                }
            }
            return $true
        }

        $array = $array.trim()
        $onlyNumeric = $array -match "^[0-9]+$"

        if (!$onlyNumeric)
        {
            return $false
        }

        return $true
    }
}

#$array = @("1")             #true
#is_Numeric $array
#$array = @("1", "2", "3")   #true
#is_Numeric $array
#$array = @("1", "2", " 3")  #true
#is_Numeric $array
#$array = @("1", "2", " A")  #false
#is_Numeric $array
#$array = @("1", "2", " ")   #false
#is_Numeric $array
#$array = @("a")             #false
#is_Numeric $array
