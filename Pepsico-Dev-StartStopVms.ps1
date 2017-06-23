################### Auto Start Stop Runbook ####################
# Author Y Lakshmoji Rao -409997 CTS
# CMS Automation Team Not touching below mentioned servers
#sne-db1, sen-db,sed-RDP,sen-ad-replica
# Date of immplementation 22-07-2016

workflow StartStopvms 
	{
	$subscriptionName = Get-AutomationVariable -Name "SubscriptionName" 
	write-output "Subscriptionname is $subscriptionName"
    $subscriptionID = Get-AutomationVariable -Name "SubscriptionID"
	write-output "SunscriptionID is $subscriptionID" 
	#$certificateName = Get-AutomationVariable -Name "PSSDEVCredentials" 
    $certificate = Get-AutomationCertificate -Name "PSSDEVCredentials" 
	#write-output "Certificate name is $certificateName" 
    Set-AzureSubscription -SubscriptionName $subscriptionName -SubscriptionId $subscriptionID -Certificate $certificate 
    Select-AzureSubscription $subscriptionName
	write-output "Connetecd to $subscriptionName"
		foreach( $vm in Get-AzureVM )
    {
     $name=$vm.Name.ToLower();
     $serviceName=$vm.ServiceName;
     $status=$vm.PowerState;
     If( ($vm.Status -ne 'StoppedDeallocated') -and ($name -ne "sen-db1") -and ($name -ne "sen-ad") -and ($name -ne "sen-rdp") -and ($name -ne "sen-ad-replica"))
		 {
                #write $name
                Stop-AzureVM -Name $name -ServiceName $servicename -Force
				$stutus=$vm.PowerState;
                #Write-Output (" Pepsico servers in  application related")
                Write-Output ( "ServerName $name and it servicename $serviceName current status is Stopped")
            }
    elseif( ($name -ne "sen-db1") -and ($name -ne "sen-ad") -and ($name -ne "sen-rdp") -and ($name -ne "sen-ad-replica" ))
   	        {
			  Start-AzureVM -Name $name -ServiceName $serviceName
   	          $stutus=$vm.PowerState;
			  #Write-Output ("Critical pepsico servers")
   	          Write-Output  ("ServerName $name and it servicename $serviceName current status is Running")
    	     }
	}	
		
	}