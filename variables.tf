variable "keyvaultname" {
  type = string
  description = "Name of key vault account"
}

variable "keyvaultlocation" {
  type = string
  description = "Azure location where keyvault should be deployed"
}

variable "resourcegroupname" {
  type = string
  description = "Name of resource group to deploy resources in"
}

variable "softdelete" {
  type = string
  description = "The number of days that items should be retained for once soft-deleted. The valid value can be between 7 and 90 days"
}


variable "roledefname" {
  type = string
  description = "Role Definition name to be assigned"
}

variable "principal_ids" {
  type = list(string)
  description = "The Prinicpal ID of Active Directory groups"
}

variable "privateserviceconnectionname" {
  type = string
  description = "Private service connection name"
}

variable "subnetid" {
  type = string
  description="The resource id of existing subnet"
}


variable "endpointname" {
  type = string
  description = "Private endpoint name"
 
}

variable "storageaccntname" {
  type = string
  description = "Storage Account name"
}

variable "storagelocation" {
  type = string
  description = "Azure location where keyvault should be deployed"
}

variable "managedstorageaccountname" {
  type = string
  description = "Managed Storage Account name"
}

variable "keyname" {
  type = string
  description = "storage account key name"
}


variable "regenratioperiod" {
  type = string
  description="The timeperiod for storage key to be generated"
}

variable "sasdefinitionname" {
  type = string
  description = "The SAS definition name"
}

variable "validityperiod" {
  type = string
  description = "The validityperiod for SAS Token"
}
