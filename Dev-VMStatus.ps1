Workflow VM-Status
{
    $subscriptionName = Get-AutomationVariable -Name "SubscriptionName" 
    $subscriptionID = Get-AutomationVariable -Name "SubscriptionID" 
    $certificateName = Get-AutomationVariable -Name "CertificateName" 
    $certificate = Get-AutomationCertificate -Name $certificateName  
    Set-AzureSubscription -SubscriptionName $subscriptionName -SubscriptionId $subscriptionID -Certificate $certificate 
    Select-AzureSubscription $subscriptionName
    foreach($vm in Get-AzureVM)
    {


    $name=$vm.Name.ToLower();
    $serviceName=$vm.ServiceName;
    $status=$vm.PowerState;
    If( ($name -eq "pepsicovm1") -or ($name -eq "pepsicotest1") -or ($name -eq "testvm1"))
            {
                #write $name
                #Stop-AzureVM -Name $name -ServiceName $servicename -Force
                Write-out " Pepsico servers"
                Write-out  "ServerName $name and it servicename $serviceName current status is $status"
            }
    else
    {
    Write-out "Non pepsico"
    Write-out  "ServerName $name and it servicename $serviceName current status is $status"
    }

}