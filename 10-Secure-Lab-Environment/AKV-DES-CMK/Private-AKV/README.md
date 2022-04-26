# Azure Confidential Compute Secure Lab Environment

## Overview
  These templates deploy a user defined amount of Azure Confidential Compute SKU VMs, and configures an Azure Key Vault (AKV) and Disk Encryption Set (DES) to support Confidential VM with CMK encryption. The AKV is connected to the Azure Virtual Network using a Private Endpoint, and the network settings configured to allow no public access to the AKV wiht only an exception for trusted Azure services. This provides a secure closed environment for the resources. 

## Prerequisites

### Create Confidential VM Orchestrator Service Principal
The Azure Confidential Compute SKU VMs require a Azure AD Service Principal to be created for the Confidential VM Orchestrator service. This service principal is granted permissions with the encryption key in the Azure Key Vault to encrypt and decrypt the VM.

`Connect-AzureAD -Tenant "Your-Tenant-ID"`

`New-AzureADServicePrincipal -AppId bf7b6499-ff71-4aa2-97a4-f372087be7f0 -DisplayName "Confidential VM Orchestrator"`

### Get Confidential VM Orchestrator Object ID for Deployment
Once the service principal is created, the unique per tenent Object ID of the Service Principal will need to be identified and provided as part of the template deployment to assign permissions with the Azure Key Vault.

`(az ad sp show --id "bf7b6499-ff71-4aa2-97a4-f372087be7f0" | Out-String | ConvertFrom-Json).objectId`

## Deploy 
[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcocallaw%2FAzConfidentialCompute-Lab%2Fmain%2F10-Secure-Lab-Environment%2FAKV-DES-CMK%2FPrivate-AKV%2Fazuredeploy.json)  [![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fcocallaw%2FAzConfidentialCompute-Lab%2Fmain%2F10-Secure-Lab-Environment%2FAKV-DES-CMK%2FPrivate-AKV%2Fazuredeploy.json)
