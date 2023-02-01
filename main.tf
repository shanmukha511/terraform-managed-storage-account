module "network" {
  source = "./keyvault"

  keyvaultname       = var.keyvaultname
  keyvaultlocation        = var.keyvaultlocation
  resourcegroupname   = var.resourcegroupname
  softdelete = var.softdelete
  roledefname     = var.roledefname
  principal_ids       = var.principal_ids
  
  
  privateserviceconnectionname       = var.privateserviceconnectionname
  endpointname        = var.endpointname
  storageaccntname   = var.storageaccntname
  storagelocation = var.storagelocation
  managedstorageaccountname     = var.managedstorageaccountname
  keyname       = var.keyname
  
  regenratioperiod       = var.regenratioperiod
  sasdefinitionname        = var.sasdefinitionname
  validityperiod   = var.validityperiod
  subnetid = var.subnetid
}