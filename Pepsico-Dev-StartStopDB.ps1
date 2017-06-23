################### Auto Start Stop Runbook ####################
# Author Y Lakshmoji Rao -409997 CTS
# CMS Automation 
# With this Runbook we are stopping DB after App server brought down
# DB will be started before App servers up
# Date of immplementation 22-07-2016



workflow StartStopDB-Dev
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
     If( ($vm.Status -ne 'StoppedDeallocated') -and (($name -eq "sen-db1") -or ($name -eq "sen-ad-replica") ) )
		 {
               #write $name
                Stop-AzureVM -Name $name -ServiceName $servicename -Force
				#$stutus=$vm.PowerState;
                #Write-Output (" Critical Pepsico server stopping block")
               Write-Output ( "ServerName $name and it servicename $serviceName current status is Stopped")
            }
    elseif( ($name -eq "sen-db1") -or ($name -eq "sen-ad-replica" ) )
   	  
		 {
			 Start-AzureVM -Name $name -ServiceName $serviceName
   	         #$stutus=$vm.PowerState;
			 #Write-Output ("Critical pepsico servers Starting Block")
   	         Write-Output  ("ServerName $name and it servicename $serviceName current status is Started")
          }
		  else 
		  {
			  write-output ( "Server Name is $name and it is $status" )
		  }
		
	  }	
		
	
}