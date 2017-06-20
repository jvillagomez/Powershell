$dir = "C:\Users\jvillagomez\OneDrive - ucx.ucr.edu\dave\AD-Reports\Scripts"
$titles = @()
$filenames = get-childitem -literalPath $dir

function Select-TextItem
{
PARAM
(
    [Parameter(Mandatory=$true)]
    $options,
    $displayProperty
)
    Write-Host "Choose an option below:"
    [int]$optionPrefix = 1
    foreach ($option in $options)
    {
        if ($displayProperty -eq $null)
        {
            Write-Host ("{0,3}: {1}" -f $optionPrefix,$option)
        }
        else
        {
            Write-Host ("{0,3}: {1}" -f $optionPrefix,$option)
        }
        $optionPrefix++
    }
    Write-Host ("{0,3}: {1}" -f 0,"Exit")
    [int]$response = Read-Host "Enter Selection"
    $val = $null
    if ($response -eq 0)
    {
        exit
    }
    if ($response -gt 0 -and $response -le $options.Count)
    {
        #$val = $options[$response-1]
    }
    #return $val
    clear
    write-host $options[$response-1]
    return $response-1
}


function Get-Menu
{
    foreach ($scriptFile in (get-childitem -LiteralPath $dir))
    {
        write-host ($scriptFile)
        $title = ((get-content "$($scriptFile.DirectoryName)\$($scriptFile.Name)")[0 .. 10] | select-string -pattern "Title:").ToString()
        write-host $title
        $titles = $titles + $title.Trimstart("Title: ")
    }
    Write-Host $filenames.Count
    foreach($file in $filenames){
    Write-Host $file
    }
    Write-Host $titles.Count

    if($filenames.Count -ne $titles.Count)
    {
        #clear
        Write-Host "One of the scripts is missing a title. Please correct and try again."
        exit
    }

    do
    {
        clear
        $option = Select-TextItem $titles
        Set-Location -LiteralPath $dir
        $kiss = "cripcut"
        invoke-expression (".\$($filenames[$option].name) $kiss")
        $again = read-host "Launch another script (Y/N)"
        if ($again -eq "n"){exit}
        elseif (($again -ne "y") -and ($again -ne "n")){$again = read-host "Launch another script (Y/N)"}
    } while ($again -eq "y")

}

Get-Menu