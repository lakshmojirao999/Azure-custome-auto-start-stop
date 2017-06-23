################### Auto Start Stop Runbook ####################
# Author Y Lakshmoji Rao -409997 CTS
# CMS Automation 
# With this Runbook we are  stopping/starting  below  VM's' 
# senfit-db-1, senfit-db-2 
# Date of immplementation 29-07-2016


workflow StartStopDB-Fit
{
	$subscriptionName = Get-AutomationVariable -Name "SubscriptionName" 
	write-output "Subscriptionname is $subscriptionName"
    $subscriptionID = Get-AutomationVariable -Name "SubscriptionID" 
	write-output "SunscriptionID is $subscriptionID" 
    $certificateName = Get-AutomationVariable -Name "CertificateName" 
    $certificate = Get-AutomationCertificate -Name $certificateName  
    Set-AzureSubscription -SubscriptionName $subscriptionName -SubscriptionId $subscriptionID -Certificate $certificate 
    Select-AzureSubscription $subscriptionName
	write-output "Connetecd to $subscriptionName"
    foreach ($vm in Get-AzureVM)
    {
        $name=$vm.Name.ToLower();
        $servicename = $vm.ServiceName
		$status=$vm.PowerState;
        $VMService = Get-AzureService -ServiceName $servicename
        if($VMService.Location -eq 'East Us 2')
        {
            If(($vm.Status -ne 'StoppedDeallocated') -and (($name -eq "senfit-db-1") -or ($name -eq "senfit-db-2" )) )
            {
                # Add the VM's which should not be shutdown
				#Write-output("Server name $name ")
				Stop-AzureVM -Name $name -ServiceName $servicename -Force
				Write-Output ( "ServerName $name and it servicename $serviceName current status is Stopped")
            }
	elseif(($name -eq "senfit-db-1") -or ($name -eq "senfit-db-2" ) )
			{
			Start-AzureVM -Name $name -ServiceName $serviceName
			Write-Output ( "ServerName $name and it servicename $serviceName current status is Running")
			}
			else 
		  {
			  write-output ( "Server Name is $name and it is $status" )
		  }
        }
    }
	
	
}