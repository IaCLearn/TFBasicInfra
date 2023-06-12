# Virtual Network
vnet_name                   = "productiontamops-vnet"
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
environment = "production"
dnsservers="10.0.0.4"

# SQL VM creation
omsapprg_name="sqlvmsrg"
sql_vmname="sqlvm01"
publisher_sql="MicrosoftSQLServer"
offer_sql="sql2019-ws2019"
sku_sql="standard"
image_version_sql="latest"
sql_vmusername="sqladmin"
sqladmin="sqladmin"
sqladminpwd="P@$$w0rd1234!"
sqllogfilepath="F:\\Logs"
sqldatafilepath="G:\\Data"
vm_size_sql="Standard_DS3_v2"

 
 #common variables
 vm_dompassword="Password12$$"