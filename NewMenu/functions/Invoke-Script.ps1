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
