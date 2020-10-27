<#
.SYNOPSIS
    Connects to Azure and shuts down all VMs in the specified Azure subscription and deallocates their cloud services.

.DESCRIPTION
   This runbook sample demonstrates how to connect to Azure using organization id credential
   based authentication. Before using this runbook, you must create an Azure Active Directory
   user and allow that user to manage the Azure subscription you want to work against. You must
   also place this user's username / password in an Azure Automation credential asset.
   
   You can find more information on configuring Azure so that Azure Automation can manage your
   Azure subscription(s) here: http://aka.ms/Sspv1l

   After configuring Azure and creating the Azure Automation credential asset, make sure to
   update this runbook to contain your Azure subscription name and credential asset name.

   This runbook can be scheduled to stop all VMs at a certain time of day.

.NOTES
	Original Author: System Center Automation Team
    Last Updated: 10/02/2014  -   Microsoft Services - Adapted to stop all VMs.
                  03/10/2015  -   Microsoft Services - removed unecessary inlinescript and started in parallel  
                  03/30/2015  -   Microsoft Services - added 1 min retry interval for 5 minutes.  
#>

workflow Stop-AllAzureVM
{   
	# Add the credential used to authenticate to Azure. 
	# TODO: Fill in the -Name parameter with the Name of the Automation PSCredential asset
	# that has access to your Azure subscription.  "myPScredName" is your asset name that reflects an OrgID user
    # like "someuser@somewhere.onmicrosoft.com" that has Co-Admin rights to your subscription.
	$Cred = Get-AutomationPSCredential -Name "myPScredName"

	# Connect to Azure
	Add-AzureAccount -Credential $Cred

	# Select the Azure subscription you want to work against
	# TODO: Fill in the -SubscriptionName parameter with the name of your Azure subscription
	Select-AzureSubscription -SubscriptionName "Some Subscription Name"


	# Get all Azure VMs in the subscription that are not stopped and deallocated, and shut them down
    # all at once.
    $VMs = Get-AzureVM | where-object -FilterScript {$_.status -ne 'StoppedDeallocated'} 
    
    foreach -parallel ($vm in $VMs)
      {       
        $stopRtn = Stop-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -force -ea SilentlyContinue
        $count=1
        if(($stopRtn.OperationStatus) -ne 'Succeeded')
          {
           do{
              Write-Output "Failed to stop $($VM.Name). Retrying in 60 seconds..."
              sleep 60
              $stopRtn = Stop-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -force -ea SilentlyContinue
              $count++
              }
            while(($stopRtn.OperationStatus) -ne 'Succeeded' -and $count -lt 5)
         
           }
           
       if($stopRtn){Write-Output "Stop-AzureVM cmdlet for $($VM.Name) $($stopRtn.OperationStatus) on attempt number $count of 5."}
      }
}
