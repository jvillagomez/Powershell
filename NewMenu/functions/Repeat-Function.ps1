#TO BE CONTINUED
#HAS USE BUT FIGURE OUT HWO TO PASS FUNC AS PARAMETER

Function Repeat-Function
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [scriptblock]
        $func,

        [string]
        $prompt
    )

    Process
    {
        $choices = @("Yes","No")
        $choice = Select-Option $choices $prompt

        If ($choice -eq 0)
        {
            exit
        }
        else
        {
            $func
        }
    }

}
