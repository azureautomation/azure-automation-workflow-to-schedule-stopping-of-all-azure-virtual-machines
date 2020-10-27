Azure Automation Workflow to Schedule stopping of all Azure Virtual Machines
============================================================================

            

 

3/30/2015 Updated to add 1 minute retry interval for 5 minutes.
3/10/2015 Updated to use foreach -parallel and remove uncessary inlinescript blocks 

Use this workflow in Azure Automation to schedule your Azure Virtual Machines to stop and deallocate at a specific time of day.  Good for managing test
environments created under MSDN Subscriptions.   Use in conjunction with Start-AllAzureVM.ps1     Follow the instructions in the link in the synopis
 to configure an Organizational ID to authenticate and execute this runbook in Azure Automation.  Complete the TODO sections of the script sample to customize to your newly created Organizational ID and your own Azure Subscription.


 


 


        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
