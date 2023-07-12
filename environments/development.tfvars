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
appbkend_subnet_address_name = "corissnet"
appbrst_subnet_address_prefix = "192.168.4.0/24"
appbrst_subnet_address_name = "appbrstsnet"
pe_subnet_address_name="pesnet"
pe_subnet_address_prefix="192.168.5.0/24"
dbbi_subnet_address_name="dbbisnet"
dbbi_subnet_address_prefix="192.168.8.0/24"
location="canadacentral"
sql_nsg_name="sql_nsg"
app_nsg_name="app_nsg"
environment = "Development"
asgwebservernames="asgWebservers"
asgsqlservernames="asgsqlservers"
dnsservers=["10.0.0.4"]

#Web app vm creation generic windows vm
publisher_windows = "MicrosoftWindowsServer"
offer_windows ="WindowsServer"
sku_windows = "2019-Datacenter"
version_windows = "latest"

 
#common variables
vm_dompassword="Longstrokes13$$"
existingrgname="sqlvmsrg"
domainname="phebsix.com"
oupath="OU=AzureVM,DC=phebsix,DC=com"
domainusername="localadmin"

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
rediscachelist=["errovam002"]

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
      name = "perg"
      location="canadacentral"

    }
]


# SQL VM General creation
apprg_name="sqlvmsrg"
publisher_sql="MicrosoftSQLServer"
offer_sql="sql2019-ws2019"
sku_sql="SQLDEV-gen2"
image_version_sql="latest"
vmusername="localadmin"
sqladmin="localadmin"
vmpassword="Longstrokes13$$"
sqladminpwd="Longstrokes13$$"
sqllogfilepath="F:\\Logs"
sqldatafilepath="G:\\Data"

#SQL VM List 
sqlvmlist={
  sqlvm01={
    size="Standard_D8ds_v4",
    datadisksize="512",
    logdisksize="128",
   subnetname="dbsnet"
  
  }
  # sqlvm02={
  #   size="Standard_D8ds_v4",
  #   datadisksize="512",
  #   logdisksize="128",
  #   subnetname="dbbisnet"
    
  # }
}

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
win_source_image_id="/subscriptions/10c1c1c4-c34c-4a6f-b4bd-8560ab234169/resourceGroups/ADDomain/providers/Microsoft.Compute/galleries/cstvmgallery/images/newindef1/versions/0.0.1"
wincstvmlist={
wincstvm01={
    size="Standard_D8ds_v4",
    datadisksize="512",
    subnetname="appbrstsnet"
  }
  wincstvm02={
    size="Standard_D8ds_v4",
    datadisksize="512",
    subnetname="appsnet"
   
  }
    
}

#Windows generic list add more list if required
wingenlist={

wingem01={
    size="Standard_D8ds_v4",
    datadisksize="512"
  }
  
wingem02={
    size="Standard_D8ds_v4",
    datadisksize="512"
  }
 
 
}


#Azure private dns zones
privatednszonenames=[
{
      id = 1
      name = "privatelink.blob.core.windows.net" 
     
    },
    {
      id = 2
      name = "privatelink.vaultcore.azure.net" 

    },
    {
      id = 3
      name = "privatelink.redis.cache.windows.net"
    }
]

