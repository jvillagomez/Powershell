<#
.SYNOPSIS
Checks if string ONLY contains numerical characters.

.DESCRIPTION
Checks characters inside of the input string. If anything other than numerical characters are found, returns FALSE.

.PARAMETER
System.String

.OUTPUTS
System.Bool

.EXAMPLES
is_Numeric "1234"    #Returns TRUE
is_Numeric " 123"    #Returns TRUE
is_Numeric "12 4"    #Returns FALSE
is_Numeric "ABDC"    #Returns FALSE
is_Numeric "A2D3"    #Returns FALSE

#>

﻿function is_Numeric
{
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
