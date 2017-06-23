workflow StopVms-PrimaryRegion
{
    $subscriptionName = Get-AutomationVariable -Name "SubscriptionName" 
    $subscriptionID = Get-AutomationVariable -Name "SubscriptionID" 
    $certificateName = Get-AutomationVariable -Name "CertificateName" 
    $certificate = Get-AutomationCertificate -Name $certificateName  
    Set-AzureSubscription -SubscriptionName $subscriptionName -SubscriptionId $subscriptionID -Certificate $certificate 
    Select-AzureSubscription $subscriptionName
    foreach ($vm in Get-AzureVM)
    {
        $name = $vm.Name
        $servicename = $vm.ServiceName
        $VMService = Get-AzureService -ServiceName $servicename
        if($VMService.Location -eq 'East Us 2')
        {
            If($vm.Status -ne 'StoppedDeallocated')
            {
                # Add the VM's which should not be shutdown
                Stop-AzureVM -Name $name -ServiceName $servicename -Force
            }
        }
    }
}