<#
.SYNOPSIS
Quick function to check if ListA contains the entirety of ListB.

.DESCRIPTION
Verifies if ListA contains all of the members in ListB. If a single member from ListB is not found in ListA, $false is returned.

.Parameter name
[System.Strings] $ListA: list used for reference.
[System.Strings] $ListB: list that user wants to verify against ListA.

.OUTPUTS
Returns $true if the entirety of ListB can be found in ListA. Returns $false otherwise.

.EXAMPLE
$ListA = @("A","B","C","D")
$ListB = @("A","B")
A-contains-B $ListA $ListB #returns $true

$ListA = @("A","B","C","D")
$ListB = @("E","F")
A-contains-B $ListA $ListB #returns $false

$ListA = @("A","B","C","D")
$ListB = @("A","B","E")
A-contains-B $ListA $ListB #returns $false
#>
Function A-contains-B
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [String[]] $listA,

        [Parameter(Mandatory=$true)]
        [String[]] $listB
    )

    Process
    {
        Foreach ($item in $listB)
        {
            If ($listA -notcontains $item)
            {
                return $false
            }
        }
        return $true
    }
}
