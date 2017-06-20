function isAlpha
{
    <#
    .SYNOPSIS 
    Checks if string ONLY contains alphabetical characters.
 
    .DESCRIPTION
    Checks characters inside of the input string. If anything other than alphabetical characters are found, returns FALSE.
 
    .PARAMETER
    System.String
 
    .OUTPUTS
    System.Bool
 
    .EXAMPLES
    is_Numeric "ABCD"    #Returns TRUE
    is_Numeric " ABC"    #Returns TRUE
    is_Numeric "AB D"    #Returns FALSE
    is_Numeric "ABDC"    #Returns FALSE
    is_Numeric "A2D3"    #Returns FALSE
    
    #>

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

