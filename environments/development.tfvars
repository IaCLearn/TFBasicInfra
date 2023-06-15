# Virtual Network
vnetrgname="devvnetrg"
vnet_name                   = "dev-vnet"
network_address_space       = "192.168.0.0/16"
db_subnet_address_prefix   = "192.168.0.0/24"
db_subnet_address_name     = "db"
appgw_subnet_address_prefix = "192.168.1.0/24"
appgw_subnet_address_name   = "appgw"
app_subnet_address_prefix = "192.168.2.0/24"
app_subnet_address_name   = "app"
location="canadacentral"
sql_nsg_name="sql_nsg"
app_nsg_name="app_nsg"
environment = "Development"
dnsservers="10.0.0.4"

# SQL VM creation
apprg_name="sqlvmsrg"
sql_vmname="sqlvm01"
publisher_sql="MicrosoftSQLServer"
offer_sql="sql2019-ws2019"
sku_sql="SQLDEV-gen2"
image_version_sql="latest"
sql_vmusername="sqladmin"
sqladmin="sqladmin"
sqladminpwd="P@$$w0rd1234!"
sqllogfilepath="F:\\Logs"
sqldatafilepath="G:\\Data"
vm_size_sql="Standard_DS3_v2"
appvmcount=2
publisher_windows = "MicrosoftWindowsServer"
offer_windows ="WindowsServer"
sku_windows = "2019-Datacenter"
version_windows = "latest"
appvm_names = "WebApp"
 
#common variables
vm_dompassword="Password12$$"
existingrgname="sqlvmsrg"

#keyvault variables
kvname = "devkeyvault001"
kvsku_name="standard"

#application gateway variables
backend_address_pool_name="myBackendPool"
frontend_port_name="myFrontendPort"
http_setting_name="myHTTPsetting"
listener_name="myListener"
request_routing_rule_name="myRoutingRule"
appgwipconfigname="my-gateway-ip-configuration"
frontend_ip_configuration_name="myAGIPConfig"
appgwname="myAppGateway"
appgwpip="myAGPublicIPAddress"

#Azure Redis Cache configuration variable
capacity=2
redisfamily="C"
sku_name="Standard"
