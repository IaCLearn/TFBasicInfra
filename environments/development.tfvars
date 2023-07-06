# Virtual Network
vnet_name                   = "dev-vnet"
network_address_space       = "192.168.0.0/16"
db_subnet_address_prefix   = "192.168.0.0/24"
db_subnet_address_name     = "dbsnet"
appgw_subnet_address_prefix = "192.168.1.0/24"
appgw_subnet_address_name   = "appgwsnet"
app_subnet_address_prefix = "192.168.2.0/24"
app_subnet_address_name   = "appsnet"
appbkend_subnet_address_prefix = "192.168.3.0/24"
appbkend_subnet_address_name = "appbkendsnet"
appbrst_subnet_address_prefix = "192.168.4.0/24"
appbrst_subnet_address_name = "appbrstsnet"
pe_subnet_address_name="pesnet"
pe_subnet_address_prefix="192.168.5.0/24"
location="canadacentral"
sql_nsg_name="sql_nsg"
app_nsg_name="app_nsg"
environment = "Development"
dnsservers=["10.0.0.4"]

#Web app vm creation generic windows vm
appvmcount=2
publisher_windows = "MicrosoftWindowsServer"
offer_windows ="WindowsServer"
sku_windows = "2019-Datacenter"
version_windows = "latest"
appvm_names = "csDcOms1ASvc0"
 
#common variables
vm_dompassword="Password12$$"
existingrgname="sqlvmsrg"

#keyvault variables
keyvaultlist=["devkeyvaultz001","devkeyvaultz002"]
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
private_frontend_ip_configuration_name="myAGPrivateIPAddress"
backendaddresspoolfqdns=["linuxvm01.phebsix.com","linuxvm02.phebsix.com"]
appgwprivateip="192.168.1.10"

#Azure Redis Cache configuration variable
capacity=2
redisfamily="C"
sku_name="Standard"
rediscachelist=["errovam002","errovam003"]

#Azure Storage Account Configuration variables
storage_list=["shols001","shols002","shols003"]
containers_list=[{ name = "sa1container1", access_type = "private" }]

#Azure Resource Groups
resource_groups=[
{
      id = 1
      name = "devvnetrg" 
      location="canadacentral"
    },
    {
      id = 2
      name = "sqlvmsrg" 
      location="canadacentral"

    },
    {
      id = 3
      name = "drvmrg"
      location="canadaeast"

    }
]

#SQL VM List 
sqlvmlist={
  sqlvm01={
    size="Standard_D8ds_v4",
    datadisksize="512",
    logdisksize="128"
  }
  sqlvm02={
    size="Standard_D8ds_v4",
    datadisksize="512",
    logdisksize="128"
  }
    sqlvm03={
    size="Standard_D8ds_v4",
    datadisksize="512",
    logdisksize="128"
  }
}

# SQL VM General creation
apprg_name="sqlvmsrg"
publisher_sql="MicrosoftSQLServer"
offer_sql="sql2019-ws2019"
sku_sql="SQLDEV-gen2"
image_version_sql="latest"
vmusername="localadmin"
sqladmin="localadmin"
vmpassword="Password12$$"
sqladminpwd="Password12$$"
sqllogfilepath="F:\\Logs"
sqldatafilepath="G:\\Data"
vm_size_sql="Standard_DS3_v2"
vm_size_sqlmedium="Standard_D8ds_v4"

#General variables for custom linux image
source_image_id="/subscriptions/10c1c1c4-c34c-4a6f-b4bd-8560ab234169/resourceGroups/ADDomain/providers/Microsoft.Compute/galleries/cstvmgallery/images/cstlinuxvm/versions/0.0.1"
brstvmrg_name="sqlvmsrg"

#customlinux vm list
lincstvmlist={
linuxvm01={
    size="Standard_D8ds_v4",
    datadisksize="512"
  }
  linuxvm02={
    size="Standard_D8ds_v4",
    datadisksize="512"
   
  }
    linuxvm03={
    size="Standard_D8ds_v4",
    datadisksize="512"
  
  }
}

#Azure Custom Windows 
appbkendvmrg_name="sqlvmsrg"
win_source_image_id="/subscriptions/10c1c1c4-c34c-4a6f-b4bd-8560ab234169/resourceGroups/ADDomain/providers/Microsoft.Compute/galleries/cstvmgallery/images/wincstimg/versions/0.0.1"
wincstvmlist={
wincstvm01={
    size="Standard_D8ds_v4",
    datadisksize="512"
  }
  wincstvm02={
    size="Standard_D8ds_v4",
    datadisksize="512"
   
  }
    wincstvm03={
    size="Standard_D8ds_v4",
    datadisksize="512"
  
  }
}


