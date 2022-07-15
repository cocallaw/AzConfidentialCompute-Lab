# ACC VMs with mHSM Lab Environment

When provisioning the mHSM you will need to provide the following information:

Object ID of Azure AD user to be set as the initial Administrator.
`az ad user show --id <your-email-address> --query "objectId"`

The tenant ID of the Azure AD that the mHSM will be provisioned in.
`az account show --query "tenantId"`


