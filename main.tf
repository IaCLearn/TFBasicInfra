module "vnet_cscabilis" {
  source                      = "./modules/vnet"
  name                        = var.vnet_name
  location                    = var.location
  network_address_space       = var.network_address_space
  app_subnet_address_prefix   = var.app_subnet_address_prefix
  app_subnet_address_name     = var.app_subnet_address_name
  db_subnet_address_prefix   = var.db_subnet_address_prefix
  db_subnet_address_name     = var.db_subnet_address_name
  appgw_subnet_address_prefix = var.appgw_subnet_address_prefix
  appgw_subnet_address_name   = var.appgw_subnet_address_name
  environment                 = var.environment
  sql_nsg_name=               var.sql_nsg_name
  app_nsg_name= var.app_nsg_name
  dnsservers=var.dnsservers
}



module "sqlvm_cscabilis" {
source = "./modules/VM"
omsapprg_name=var.omsapprg_name
sql_vmname=var.sql_vmname
publisher_sql=var.publisher_sql
offer_sql=var.offer_sql
sku_sql=var.sku_sql
image_version_sql=var.image_version_sql
sql_vmusername= var.sql_vmusername
sqladminpwd=var.sqladminpwd
sqladmin=var.sqladmin
sqllogfilepath=var.sqllogfilepath
sqldatafilepath=var.sqldatafilepath
vm_size_sql=var.vm_size_sql
environment = var.environment
existingsnetid=module.vnet_cscabilis.db_subnet_id

}

