

$UserPrincipalName = "jvillagomez@ucx.ucr.edu"

$userObject = get-msolUser -UserPrincipalName $UserPrincipalName
$license  = $userObject.Licenses | Where {$_.AccountSkuId -eq "ucxucr:STANDARDWOFFPACK_FACULTY"}
$services = $license.ServiceStatus
$service = $services.ServicePlan
$services


create fucntion for 365 calls