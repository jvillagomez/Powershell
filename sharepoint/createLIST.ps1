# Please dont worry about the credentials right now, I'll have it automatically check like the rest of the 365 scripts.
# FOR USE: ready to be run now.
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

Function Select-FolderDialog
{
    param([string]$Description="Select Folder",[string]$RootFolder="Desktop")

 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
     Out-Null     

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


$User = "jvillagomez@ucx.ucr.edu"
#$User = "dwossum@ucx.ucr.edu"
$SiteURL = "https://ucxucr.sharepoint.com/sites/dit-og"
Write-Host ("Enter Name of List") -ForegroundColor Cyan
$ListTitle = read-host "->"

$Password = Read-Host -Prompt "Please enter your password" -AsSecureString
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)

$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)
$Context.Credentials = $Creds
#=======================================================================

$folder = Select-FolderDialog # the variable contains user folder selection
$childItems = (get-childItem($folder) | ? {$_.Mode -eq "d-----"}).Name

#=======================================================================

#Create list with "custom" list template
$ListInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
$ListInfo.Title = $ListTitle
$ListInfo.TemplateType = "100" #this code is for custom list
$List = $Context.Web.Lists.Add($ListInfo)
$List.Description = $ListTitle
$List.Update()
$Context.ExecuteQuery()

#Add items to the list
$ListItemInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation

foreach($folder in $childItems)
{
    $Item = $List.AddItem($ListItemInfo)
    $Item["Title"] = $folder
    $Item.Update()
    $Context.ExecuteQuery()
}
