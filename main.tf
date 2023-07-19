#resource group module
module "resourcegroup_md" {
  source="./modules/resourcegroups"
  resource_groups = var.resource_groups
  location = var.location
}

#virtual network and subnet module
module "vnet_md" {
  source = "./modules/vnet"
  vnetrgname = module.resourcegroup_md.vnetrgname
  vnet_name                      = var.vnet_name
  location                    = var.location
  network_address_space       = var.network_address_space
  app_subnet_address_prefix   = var.app_subnet_address_prefix
  app_subnet_address_name     = var.app_subnet_address_name
  db_subnet_address_prefix   = var.db_subnet_address_prefix
  db_subnet_address_name     = var.db_subnet_address_name
  dbbi_subnet_address_name = var.dbbi_subnet_address_name
  dbbi_subnet_address_prefix = var.dbbi_subnet_address_prefix
  appgw_subnet_address_prefix = var.appgw_subnet_address_prefix
  appgw_subnet_address_name   = var.appgw_subnet_address_name
  appbkend_subnet_address_prefix = var.appbkend_subnet_address_prefix
  appbkend_subnet_address_name = var.appbkend_subnet_address_name
  appbrst_subnet_address_prefix = var.appbrst_subnet_address_prefix
  appbrst_subnet_address_name = var.appbrst_subnet_address_name
  pe_subnet_address_name = var.pe_subnet_address_name
  pe_subnet_address_prefix = var.pe_subnet_address_prefix
  mrz_subnet_address_name = var.mrz_subnet_address_name
  mrz_subnet_address_prefix = var.mrz_subnet_address_prefix
  inrule_subnet_address_name = var.inrule_subnet_address_name
  inrule_subnet_address_prefix = var.inrule_subnet_address_prefix
  environment= var.environment
  sql_nsg_name=var.sql_nsg_name
  app_nsg_name= var.app_nsg_name
  jmpbox_nsg_name=var.jmpbox_nsg_name
  appbrst_nsg_name = var.appbrst_nsg_name
  corris_nsg_name = var.corris_nsg_name
  inrule_nsg_name = var.inrule_nsg_name
  dnsservers=var.dnsservers
  asgwebservernames = var.asgwebservernames
  asgsqlservernames=var.asgsqlservernames
  asgjmpservernames=var.asgjmpservernames
asgbrstservernames=var.asgbrstservernames
asgcorisservernames = var.asgcorisservernames
asginruleservernames = var.asginruleservernames

}

//module to create private dns zones depends on vnet module
module "privatednszones_md" {
  source="./modules/privatednszones"
privatednszonenames = var.privatednszonenames
existingrgname = module.resourcegroup_md.pergname
existingvnetid = module.vnet_md.vnet_id
depends_on = [ module.vnet_md ]
}

#module to create storage account depends on private dns zones module
module "stgaccount_md" {
  source = "./modules/storageaccounts"
  storage_list = var.storage_list
  containers_list = var.containers_list
  existingrgname = module.resourcegroup_md.apprgname
   endpoints_subnet_id = module.vnet_md.pe_subnet_id
stg_private_dns_zone_ids = module.privatednszones_md.privatednszoneidstorageid
 
 depends_on = [module.privatednszones_md]
  
}

#generic windows vm module, uncomment out if needed
# module "vm_md" {
# source = "./modules/vm/genericvm"
# apprg_name=module.resourcegroup_md.apprgname
# vmusername= var.vmusername
# vmpassword = var.vmpassword
#  environment = var.environment
#  vm_dompassword=var.vm_dompassword
# existingappsnetid = module.vnet_md.app_subnet_id
#  publisher_windows = var.publisher_windows
# offer_windows =var.offer_windows
# sku_windows = var.sku_windows
# version_windows = var.version_windows
# wingenlist = var.wingenlist
# asgwebserverid = module.vnet_md.asgwebserversid
#   depends_on = [module.resourcegroup_md]
#  domainname = var.domainname
#  oupath = var.oupath
#  domainusername = var.domainusername
# vm_dompassword=var.vm_dompassword
#  domainusername = var.domainusername
#  asgsqlserverid = module.vnet_md.asgsqlserversid
#  }

#module to create vms from Azure SQL Server Market Place Image uncomment if required, can deploy to separate subnet the dbsnet and dbbisnet
# module "sql_md" {
# source = "./modules/vm/sqlvm"
# apprg_name=module.resourcegroup_md.apprgname
# sqlvmlist = var.sqlvmlist
# publisher_sql=var.publisher_sql
# offer_sql=var.offer_sql
# sku_sql=var.sku_sql
# image_version_sql=var.image_version_sql
# vmusername= var.vmusername
# vmpassword = var.vmpassword
# sqladminpwd=var.sqladminpwd
# sqladmin=var.sqladmin
# sqllogfilepath=var.sqllogfilepath
# sqldatafilepath=var.sqldatafilepath
#  environment = var.environment
# existingdbsnetid=module.vnet_md.db_subnet_id
# existingbisnetid=module.vnet_md.dbbi_subnet_id
#  vm_dompassword=var.vm_dompassword
#   domainname = var.domainname
#  oupath = var.oupath
#  domainusername = var.domainusername
#  asgsqlserverid = module.vnet_md.asgsqlserversid
# db_subnet_address_name=var.db_subnet_address_name

# dbbi_subnet_address_name=var.dbbi_subnet_address_name

#  }

# root module for custom linux image

 module "cstlinuxvm_md" {
  source ="./modules/vm/customimagelinuxvm"
  brstvmrg_name=module.resourcegroup_md.apprgname
  existingappsnetid = module.vnet_md.app_subnet_id
  asgwebserversid=module.vnet_md.asgwebserversid
  environment=var.environment
  vmpassword = var.vmpassword
  vmusername = var.vmusername
  lincstvmlist = var.lincstvmlist
app_subnet_address_name = var.app_subnet_address_name
depends_on = [module.cstwinvm_md,module.privatednszones_md]
  }

#custom windows vm module can deploy vm to different subnet
    module "cstwinvm_md"{
    source ="./modules/vm/customimagewinvm"
    appbkendvmrg_name = module.resourcegroup_md.apprgname
    existingappbkendsnetid=module.vnet_md.appbrst_subnet_id
    existingappsnetid=module.vnet_md.app_subnet_id
    existingdbsnetid=module.vnet_md.db_subnet_id
    existingdbbisnetid = module.vnet_md.dbbi_subnet_id
    existingmrzsnetid= module.vnet_md.mrz_subnet_id
    existingappbrstsnetid=module.vnet_md.appbrst_subnet_id
    vmpassword = var.vmpassword
    vmusername = var.vmusername
     environment=var.environment
     wincstvmlist = var.wincstvmlist
  vm_dompassword=var.vm_dompassword
  domainname = var.domainname
 oupath = var.oupath
 domainusername = var.domainusername
 appbrst_subnet_address_name=var.appbrst_subnet_address_name
 app_subnet_address_name = var.app_subnet_address_name
db_subnet_address_name=var.db_subnet_address_name
dbbi_subnet_address_name=var.dbbi_subnet_address_name
mrz_subnet_address_name=var.mrz_subnet_address_name
appbkend_subnet_address_name = var.appbkend_subnet_address_name
asgsqlserverid = module.vnet_md.asgsqlserversid
asgjmpserversid = module.vnet_md.asgjmpserversid
asgwebserversid = module.vnet_md.asgwebserversid
asgbrstserversid = module.vnet_md.asgbrstserversid
asgcorrisserversid = module.vnet_md.asgcorrisserversid
depends_on = [ module.privatednszones_md ]
  }


  

# module to create keyvault depnes on private dnszones module
module "keyvault_md" {
  source = "./modules/keyvault"
  existingrgname=module.resourcegroup_md.apprgname

  kvsku_name = var.kvsku_name
  keyvaultlist = var.keyvaultlist
  endpoints_subnet_id = module.vnet_md.pe_subnet_id
  kv_private_dns_zone_ids = module.privatednszones_md.privatednszoneidkeyvaultid
  kv_private_dns_zone_name = module.privatednszones_md.privatednszoneidkeyvault
  depends_on = [module.privatednszones_md]
}

//module to create application gateway depends on custom windows and linux modules
module "appgw_md"{
source="./modules/applicationgateway"
backend_address_pool_name=var.backend_address_pool_name
frontend_port_name=var.frontend_port_name
http_setting_name=var.http_setting_name
listener_name=var.listener_name
request_routing_rule_name=var.request_routing_rule_name
appgwipconfigname=var.appgwpip
frontend_ip_configuration_name=var.frontend_ip_configuration_name
private_frontend_ip_configuration_name = var.private_frontend_ip_configuration_name
appgwname=module.resourcegroup_md.apprgname
appgwpip=var.appgwpip
existingrgname=var.existingrgname
existingappgwsubnetid =  module.vnet_md.appgw_subnet_id
backendaddresspoolfqdns = var.backendaddresspoolfqdns
backend_address_pool_name1 = var.backend_address_pool_name1
backendaddresspoolfqdns1 = var.backendaddresspoolfqdns1
appgwprivateip=var.appgwprivateip
  depends_on = [module.cstlinuxvm_md,module.cstwinvm_md]
}


#module to deploy to redish cache depends on private dns zone modules
module "redishcache_md" {
  source = "./modules/rediscache"
  capacity= var.capacity
  redisfamily=var.redisfamily
  sku_name=var.sku_name
  existingrgname=module.resourcegroup_md.apprgname
  rediscachelist = var.rediscachelist
  rdc_private_dns_zone_ids=module.privatednszones_md.privatednszoneidrediscacheid
  endpoints_subnet_id = module.vnet_md.pe_subnet_id
 depends_on = [module.privatednszones_md]
}

