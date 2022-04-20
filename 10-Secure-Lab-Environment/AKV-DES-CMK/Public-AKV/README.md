# Create Secure Lab of Azure Confidential Compute VMs

## Overview
  Encryption for deployed VMs will use Azure Key Vault with a Customer Managed Key (CMK) and Disk Encryption Set (DES)


## Prerequisites

### Create Confidential VM Orchestrator Service Principal

Connect-AzureAD -Tenant "your tenant ID" 
New-AzureADServicePrincipal -AppId bf7b6499-ff71-4aa2-97a4-f372087be7f0 -DisplayName "Confidential VM Orchestrator" 

### Get Confidential VM Orchestrator Object Id for Deployment

(az ad sp show --id "bf7b6499-ff71-4aa2-97a4-f372087be7f0" | Out-String | ConvertFrom-Json).objectId

</br>

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcocallaw%2FAzConfidentialCompute-Lab%2Fmain%2F10-Secure-Lab-Environment%2FAKV-DES-CMK%2FPublic-AKV%2Fazuredeploy.json)  [![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fcocallaw%2FAzConfidentialCompute-Lab%2Fmain%2F10-Secure-Lab-Environment%2FAKV-DES-CMK%2FPublic-AKV%2Fazuredeploy.json)
