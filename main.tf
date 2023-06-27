module "vnet_md" {
  source                      = "./modules/vnet"
  vnetrgname = var.vnetrgname
  vnet_name                      = var.vnet_name
  location                    = var.location
  network_address_space       = var.network_address_space
  app_subnet_address_prefix   = var.app_subnet_address_prefix
  app_subnet_address_name     = var.app_subnet_address_name
  db_subnet_address_prefix   = var.db_subnet_address_prefix
  db_subnet_address_name     = var.db_subnet_address_name
  appgw_subnet_address_prefix = var.appgw_subnet_address_prefix
  appgw_subnet_address_name   = var.appgw_subnet_address_name
  appbkend_subnet_address_prefix = var.appbkend_subnet_address_prefix
  appbkend_subnet_address_name = var.appbkend_subnet_address_name
  appbrst_subnet_address_prefix = var.appbrst_subnet_address_prefix
  appbrst_subnet_address_name = var.appbrst_subnet_address_name
  environment                 = var.environment
  sql_nsg_name=               var.sql_nsg_name
  app_nsg_name= var.app_nsg_name
  dnsservers=var.dnsservers
}

# module "stgaccount_md" {
#   source = "./modules/storageaccounts"
#   storage_list = var.storage_list
#   containers_list = var.containers_list
#   existingrgname = var.existingrgname
# depends_on = [ module.vm_md ]
  
# }


module "vm_md" {
source = "./modules/vm/genericvm"
apprg_name=var.apprg_name
# sql_vmname=var.sql_vmname
# publisher_sql=var.publisher_sql
# offer_sql=var.offer_sql
# sku_sql=var.sku_sql
# image_version_sql=var.image_version_sql
vmusername= var.vmusername
vmpassword = var.vmpassword
# sqladminpwd=var.sqladminpwd
# sqladmin=var.sqladmin
# sqllogfilepath=var.sqllogfilepath
# sqldatafilepath=var.sqldatafilepath
# vm_size_sql=var.vm_size_sql
environment = var.environment
# existingdbsnetid=module.vnet_md.db_subnet_id
vm_dompassword=var.vm_dompassword
existingappsnetid = module.vnet_md.app_subnet_id
publisher_windows = var.publisher_windows
offer_windows =var.offer_windows
sku_windows = var.sku_windows
version_windows = var.version_windows
appvmcount = var.appvmcount
appvm_names = var.appvm_names

}

module "cstlinuxvm_md" {
  source ="./modules/vm/customimagelinuxvm"
  brstvmrg_name=var.brstvmrg_name
  existingappbrstsnetid=module.vnet_md.appbrst_subnet_id
  environment=var.environment
  webbfecount=var.webbfecount
  webbfe_names=var.webbfe_names
  cstlinuxvmsize=var.cstlinuxvmsize
  source_image_id=var.source_image_id
  vmpassword = var.vmpassword
  vmusername = var.vmusername
  }

# module "keyvault_md" {
#   source = "./modules/keyvault"
#   existingrgname=var.existingrgname
#   kvname = var.kvname
#   kvsku_name = var.kvsku_name
#   depends_on = [ module.vm_md ]
# }

# module "appgw_md"{
# source="./modules/applicationgateway"
# backend_address_pool_name=var.backend_address_pool_name
# frontend_port_name=var.frontend_port_name
# http_setting_name=var.http_setting_name
# listener_name=var.listener_name
# request_routing_rule_name=var.request_routing_rule_name
# appgwipconfigname=var.appgwpip
# frontend_ip_configuration_name=var.frontend_ip_configuration_name
# private_frontend_ip_configuration_name = var.private_frontend_ip_configuration_name
# appgwname=var.appgwname
# appgwpip=var.appgwpip
#   existingrgname=var.existingrgname
# existingappgwsubnetid =  module.vnet_md.appgw_subnet_id
# backendaddresspoolfqdns = var.backendaddresspoolfqdns
#   depends_on = [ module.vm_md ]
# }

# module "redishcache_md" {
#   source = "./modules/rediscache"
#   capacity= var.capacity
#   redisfamily=var.redisfamily
#   sku_name=var.sku_name
#   existingrgname=var.existingrgname
#   depends_on = [ module.vm_md ]
# }