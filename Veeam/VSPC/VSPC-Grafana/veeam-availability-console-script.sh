#!/bin/bash
##      .SYNOPSIS
##      Grafana Dashboard for Veeam Backup for Veeam Availability Console - Using RestAPI to InfluxDB Script
## 
##      .DESCRIPTION
##      This Script will query the Veeam Availability Console RestAPI and send the data directly to InfluxDB, which can be used to present it to Grafana. 
##      The Script and the Grafana Dashboard it is provided as it is, and bear in mind you can not open support Tickets regarding this project. It is a Community Project
##	
##      .Notes
##      NAME:  veeam-availability-console-script.sh
##      ORIGINAL NAME: veeam_availability-console-grafana.sh
##      LASTEDIT: 2024-09-26
##      VERSION: 1.0.0
##      KEYWORDS: Veeam, InfluxDB, Grafana
##      AUTHORS: Jorge de la Cruz, Walker Chesley
   
##      .Link
##      https://jorgedelacruz.es/
##      https://jorgedelacruz.uk/
##      https://mpowell.tech/
##      https://github.com/wchesley - Author of update for VSPC api v3 and InfluxDB2 compatibility

##
# Configurations
##
# Endpoint URL for InfluxDB
InfluxDBURL="172.16.0.62"
InfluxDBPort="8086/api/v2" #Default Port
InfluxDbApiKey="hAECQwGJSBvaFJ588EiqoxK-ORgCprGSe2K_r3Md2_V_wvMbIaluozN-XnMr32DNn1LO2_HP_Fmps2PIT_11CA=="
InfluxDB="WGDC-Veeam" #Default Database (used as bucket in influxdb 2.0)
InfluxDbOrg="WGDC" #Default Organization (new in influxdb 2.0)
# Endpoint URL for login action
Bearer="2df4e6ca10e520f71Rjxa6kBKhG1lEPMDOSsakkZYR8TBFer2vWmyKGLXCOiozaAjzoFIhVlhCI0EYdO7uSE3SjRnJ3R25SYXafN4i2fi2CXZ7uehN1XgoglY8T7apmK"
RestServer="https://172.16.0.56"
RestPort="1280/api/v3" #Default Port

# V3 Default Site UID: 
# we only use one site to manage all tenants, you will need to change this to your site UID or update the logic to derrive each site UID from the VSPC API
SiteUid="6cde3d8d-6e3c-49ef-9602-d9ca65fef5a5"

# Unix Epoc Time - Jan 1, 2030
# Used for those cases where there is no expirey, but things giving null causes problems
NoExpiration="1893456000"

##
# Veeam Availability Console - Company Information - This section will retrieve the company information for each tenant
##

echo =================================
echo Retrieving company info per tenant...
echo 
VACUrl="$RestServer:$RestPort/organizations/companies"
TenantUrl=$(curl -X GET --header "Accept:application/json" --header "Authorization:Bearer $Bearer" "$VACUrl" -k 2>&1 -k --silent)

declare -i arraylicense=0
echo "$TenantUrl" | jq -c '.data[]' | while read id; do
    TenantId=$(echo "$id" | jq --raw-output ".instanceUid")
    TenantName=$(echo "$id" | jq --raw-output ".name" | awk '{gsub(/ /,"\\ ");print}')
    TenantStatus=$(echo "$id" | jq --raw-output '.status')
    TenantBackupServerManagementEnabled=$(echo "$id" | jq --raw-output '.companyServices.isBackupServerManagementEnabled')
    TenantBackupAgentManagementEnabled=$(echo "$id" | jq --raw-output '.companyServices.isBackupAgentManagementEnabled')
    TenantFileRestoreEnabled=$(echo "$id" | jq --raw-output '.companyServices.isFileLevelRestoreEnabled')
    TenantVBPublicCloudManagementEnabled=$(echo "$id" | jq --raw-output '.companyServices.isVBPublicCloudManagementEnabled')

    curl -i -XPOST "http://$InfluxDBURL:$InfluxDBPort/write?bucket=$InfluxDB&org=$InfluxDbOrg" --header "Authorization: Token $InfluxDbApiKey" --data-binary "veeam_vac_tenant,companyName=$TenantName status=\"$TenantStatus\",canManageBackupServer=$TenantBackupServerManagementEnabled,canManageBackupAgent=$TenantBackupAgentManagementEnabled,canRestoreFiles=$TenantFileRestoreEnabled,canManageVBPublicCloud=$TenantVBPublicCloudManagementEnabled"

    echo =====================================
    echo Backup resources......
    echo

    VACUrl="$RestServer:$RestPort/v3/organizations/companies/$TenantId/sites/$SiteUid/backupResources"
    BackupResourcesUrl=$(curl -X GET --header "Accept:application/json" --header "Authorization:Bearer $Bearer" "$VACUrl" -k 2>&1 -k --silent)
    declare -i arrayresources=0
    echo "$BackupResourcesUrl" | jq -c '.data[]' | while read id; do
    # echo TODO This is run.... but inside the loop is not
    # for id in $(echo "$BackupResourcesUrl" | jq -r ".[].instanceUid"); do
	#     echo TODO: THIS IS NEVER RUN!!!!!!
        cloudRepositoryName=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].cloudRepositoryName"| awk '{gsub(/ /,"\\ ");print}')
    storageQuota=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].storageQuota")
    storageQuotaUnits=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].storageQuotaUnits")
    case $storageQuotaUnits in
        B)
            storageQuota=$(echo "scale=4; $storageQuota / 1048576" | bc -l)
        ;;
        KB)
            storageQuota=$(echo "scale=4; $storageQuota / 1024" | bc -l)
        ;;
        MB)
        ;;
        GB)
            storageQuota=$(echo "scale=4; $storageQuota * 1024" | bc -l)
        ;;
        TB)
            storageQuota=$(echo "scale=4; $storageQuota * 1048576" | bc -l)
        ;;
        esac
    vMsQuota=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].vMsQuota")
    trafficQuota=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].trafficQuota")
    trafficQuotaUnits=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].trafficQuotaUnits")
    case $trafficQuotaUnits in
        B)
            trafficQuota=$(echo "scale=4; $trafficQuota / 1048576" | bc -l)
        ;;
        KB)
            trafficQuota=$(echo "scale=4; $trafficQuota / 1024" | bc -l)
        ;;
        MB)
        ;;
        GB)
            trafficQuota=$(echo "scale=4; $trafficQuota * 1024" | bc -l)
        ;;
        TB)
            trafficQuota=$(echo "scale=4; $trafficQuota * 1048576" | bc -l)
        ;;
        esac
    wanAccelerationEnabled=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].wanAccelerationEnabled")
    usedStorageQuota=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].usedStorageQuota")
    usedStorageQuotaUnits=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].usedStorageQuotaUnits")
    case $usedStorageQuotaUnits in
        B)
            usedStorageQuota=$(echo "scale=4; $usedStorageQuota / 1048576" | bc -l)
        ;;
        KB)
            usedStorageQuota=$(echo "scale=4; $usedStorageQuota / 1024" | bc -l)
        ;;
        MB)
        ;;
        GB)
            usedStorageQuota=$(echo "scale=4; $usedStorageQuota * 1024" | bc -l)
        ;;
        TB)
            usedStorageQuota=$(echo "scale=4; $usedStorageQuota * 1048576" | bc -l)
        ;;
        esac
    usedTrafficQuota=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].usedTrafficQuota")
    usedTrafficQuotaUnits=$(echo "$BackupResourcesUrl" | jq --raw-output ".[$arrayresources].usedTrafficQuotaUnits")
    case $usedTrafficQuotaUnits in
        B)
            usedTrafficQuota=$(echo "scale=4; $usedTrafficQuota / 1048576" | bc -l)
        ;;
        KB)
            usedTrafficQuota=$(echo "scale=4; $usedTrafficQuota / 1024" | bc -l)
        ;;
        MB)
        ;;
        GB)
            usedTrafficQuota=$(echo "scale=4; $usedTrafficQuota * 1024" | bc -l)
        ;;
        TB)
            usedTrafficQuota=$(echo "scale=4; $usedTrafficQuota * 1048576" | bc -l)
        ;;
        esac
    #echo "veeam_vac_backupresources,companyName=$TenantName,cloudRepositoryName=$cloudRepositoryName,wanAccelerationEnabled=$wanAccelerationEnabled storageQuota=$storageQuota,vMsQuota=$vMsQuota,trafficQuota=$trafficQuota,usedStorageQuota=$usedStorageQuota,usedTrafficQuota=$usedTrafficQuota"
    curl -i -XPOST "http://$InfluxDBURL:$InfluxDBPort/write?precision=s&bucket=$InfluxDB" --header "Authorization: Token $InfluxDbUser:$InfluxDbApiKey" --data-raw "veeam_vac_backupresources,companyName=$TenantName,cloudRepositoryName=$cloudRepositoryName,wanAccelerationEnabled=$wanAccelerationEnabled storageQuota=$storageQuota,vMsQuota=$vMsQuota,trafficQuota=$trafficQuota,usedStorageQuota=$usedStorageQuota,usedTrafficQuota=$usedTrafficQuota"
    arrayresources=$arrayresources+1
    done
    arraylicense=$arraylicense+1
done

# ##
# # Veeam Availability Console, Cloud Connect and Veeam Backup & Replication Licensing - This section will retrieve the licensing of the Veeam Availability Console, Veeam Cloud Connect and every managed Veeam Backup & Replication Server
# ##
# echo =========================================
# echo Retreiving other licenses....
# echo

# # Cloud Connect Licensing
# VACUrl="$RestServer:$RestPort/v3/licensing/sites"
# CloudConnectLicenseUrl=$(curl -X GET --header "Accept:application/json" --header "Authorization:Bearer $Bearer" "$VACUrl" 2>&1 -k --silent)

# CloudConnectLicensecontactPerson=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].contactPerson" | awk '{gsub(/ /,"\\ ");print}')
# CloudConnectLicenseEdition=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].edition" | awk '{gsub(/ /,"\\ ");print}')
# CloudConnectLicenselicensedTo=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].licensedTo" | awk '{gsub(/ /,"\\ ");print}')
# CloudConnectLicenselicenseType=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].licenseType")
# CloudConnectLicenselicensestatus=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].status")
# CloudConnectLicenselicenseExpirationDate=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].licenseExpirationDate")
# CloudConnectLicenselicenseExpirationDateUnix=$(date -d "$CloudConnectLicenselicenseExpirationDate" +"%s")
# CloudConnectLicensesupportExpirationDate=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].supportExpirationDate")
# if [[ $CloudConnectLicensesupportExpirationDate = "null" ]] ; then
#         CloudConnectLicensesupportExpirationDate=$CloudConnectLicenselicenseExpirationDate
# fi
# CloudConnectLicensesupportExpirationDateUnix=$(date -d "$CloudConnectLicensesupportExpirationDate" +"%s")
# CloudConnectLicenselicensedVMs=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].licensedVMs")
# CloudConnectLicenseusedVMs=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].usedVMs")
# CloudConnectLicensebackupServerName=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].backupServerName" | awk '{gsub(/ /,"\\ ");print}')
# CloudConnectLicensecompanyName=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].companyName" | awk '{gsub(/ /,"\\ ");print}')
# if [[ $CloudConnectLicenselicensedTo = "null" ]] ; then
#         CloudConnectLicenselicensedTo="$CloudConnectLicensecompanyName"
# fi
# if [[ $CloudConnectLicensecontactPerson = "null" ]] ; then
#         CloudConnectLicensecontactPerson="$CloudConnectLicenselicensedTo"
# fi
# CloudConnectLicenselicensedCloudconnectBackups=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].licensedCloudconnectBackups")
# CloudConnectLicenseusedCloudconnectBackups=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].usedCloudconnectBackups")
# CloudConnectLicenselicensedCloudconnectReplicas=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].licensedCloudconnectReplicas")
# CloudConnectLicenseusedCloudconnectReplicas=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].usedCloudconnectReplicas")
# CloudConnectLicenselicensedCloudconnectServers=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].licensedCloudconnectServers")
# CloudConnectLicenseusedCloudconnectServers=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].usedCloudconnectServers")
# CloudConnectLicenselicensedCloudconnectWorkstations=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].licensedCloudconnectWorkstations")
# CloudConnectLicenseusedCloudconnectWorkstations=$(echo "$CloudConnectLicenseUrl" | jq --raw-output ".[].usedCloudconnectWorkstations")

# #echo "veeam_vac_vcclicense,edition=$CloudConnectLicenseEdition,status=$CloudConnectLicenselicensestatus,type=$CloudConnectLicenselicenseType,contactPerson=$CloudConnectLicensecontactPerson,licenseExpirationDate=$CloudConnectLicenselicenseExpirationDate,supportExpirationDate=$CloudConnectLicensesupportExpirationDate,backupServerName=$CloudConnectLicensebackupServerName,companyName=$CloudConnectLicensecompanyName licensedCloudConnectBackups=$CloudConnectLicenselicensedCloudconnectBackups,usedCloudConnectBackups=$CloudConnectLicenseusedCloudconnectBackups,licensedCloudConnectReplicas=$CloudConnectLicenselicensedCloudconnectReplicas,usedCloudConnectReplicas=$CloudConnectLicenseusedCloudconnectReplicas,licensedCloudConnectServers=$CloudConnectLicenselicensedCloudconnectServers,usedCloudConnectServers=$CloudConnectLicenseusedCloudconnectServers,licensedCloudConnectWorkstations=$CloudConnectLicenselicensedCloudconnectWorkstations,usedCloudConnectWorkstations=$CloudConnectLicenseusedCloudconnectWorkstations"
# curl -i -XPOST "http://$InfluxDBURL:$InfluxDBPort/write?precision=s&bucket=$InfluxDB" --header "Authorization: Token $InfluxDbUser:$InfluxDbApiKey" --data-raw "veeam_vac_vcclicense,edition=$CloudConnectLicenseEdition,status=$CloudConnectLicenselicensestatus,type=$CloudConnectLicenselicenseType,contactPerson=$CloudConnectLicensecontactPerson,backupServerName=$CloudConnectLicensebackupServerName,companyName=$CloudConnectLicensecompanyName licenseExpirationDate=$CloudConnectLicenselicenseExpirationDateUnix,supportExpirationDate=$CloudConnectLicensesupportExpirationDateUnix,licensedCloudConnectBackups=$CloudConnectLicenselicensedCloudconnectBackups,usedCloudConnectBackups=$CloudConnectLicenseusedCloudconnectBackups,licensedCloudConnectReplicas=$CloudConnectLicenselicensedCloudconnectReplicas,usedCloudConnectReplicas=$CloudConnectLicenseusedCloudconnectReplicas,licensedCloudConnectServers=$CloudConnectLicenselicensedCloudconnectServers,usedCloudConnectServers=$CloudConnectLicenseusedCloudconnectServers,licensedCloudConnectWorkstations=$CloudConnectLicenselicensedCloudconnectWorkstations,usedCloudConnectWorkstations=$CloudConnectLicenseusedCloudconnectWorkstations"

# # Veeam Availability Console Licensing
# echo =================================
# echo Retrieving VAC Licenses....
# echo

# VACUrl="$RestServer:$RestPort/v3/licensing/console"
# VACLicenseUrl=$(curl -X GET --header "Accept:application/json" --header "Authorization:Bearer $Bearer" "$VACUrl" 2>&1 -k --silent)

# VACLicenseproductName=$(echo "$VACLicenseUrl" | jq --raw-output ".productName" | awk '{gsub(/ /,"\\ ");print}')
# VACLicenselicensedTo=$(echo "$VACLicenseUrl" | jq --raw-output ".licensedTo" | awk '{gsub(/ /,"\\ ");print}')
# VACLicenselicenseType=$(echo "$VACLicenseUrl" | jq --raw-output ".type")
# VACLicenselicensesCount=$(echo "$VACLicenseUrl" | jq --raw-output ".licensesCount")
# VACLicenselicensesUsedCount=$(echo "$VACLicenseUrl" | jq --raw-output ".licensesUsedCount")
# VACLicenselicenseExpirationDate=$(echo "$VACLicenseUrl" | jq --raw-output ".expirationDate")
# VACLicenselicenseExpirationDateUnix=$(date -d "$VACLicenselicenseExpirationDate" +"%s")
# VACLicensesupportExpirationDate=$(echo "$VACLicenseUrl" | jq --raw-output ".supportExpirationDate")
# if [[ $VACLicensesupportExpirationDate = "null" ]] ; then
#         VACLicensesupportExpirationDate=$VACLicenselicenseExpirationDate
# fi
# VACLicensesupportExpirationDateUnix=$(date -d "$VACLicensesupportExpirationDate" +"%s")
# VACLicensesupportId=$(echo "$VACLicenseUrl" | jq --raw-output ".supportId")
# VACLicensevmCount=$(echo "$VACLicenseUrl" | jq --raw-output ".vmCount")
# VACLicenseworkstationCount=$(echo "$VACLicenseUrl" | jq --raw-output ".workstationCount")
# VACLicenseserverCount=$(echo "$VACLicenseUrl" | jq --raw-output ".serverCount")
# VACLicensecloudWorkstationCount=$(echo "$VACLicenseUrl" | jq --raw-output ".cloudWorkstationCount")
# VACLicensecloudServerCount=$(echo "$VACLicenseUrl" | jq --raw-output ".cloudServerCount")
# VACLicensecloudconnectBackupVmCount=$(echo "$VACLicenseUrl" | jq --raw-output ".cloudconnectBackupVmCount")
# VACLicensecloudconnectBackupWorkstationCount=$(echo "$VACLicenseUrl" | jq --raw-output ".cloudconnectBackupWorkstationCount")
# VACLicensecloudconnectBackupServerCount=$(echo "$VACLicenseUrl" | jq --raw-output ".cloudconnectBackupServerCount")
# VACLicensecloudconnectReplicationVmCount=$(echo "$VACLicenseUrl" | jq --raw-output ".cloudconnectReplicationVmCount")
# #echo "veeam_vac_vaclicense,productName=$VACLicenseproductName,licensedTo=$VACLicenselicensedTo,licenseType=$VACLicenselicenseType,licensesCount=$VACLicenselicensesCount,licensesUsedCount=$VACLicenselicensesUsedCount,supportID=$VACLicensesupportId,licenseExpirationDate=$VACLicenselicenseExpirationDate,supportExpirationDate=$VACLicensesupportExpirationDate licensevmCount=$VACLicensevmCount,licenseworkstationCount=$VACLicenseworkstationCount,licenseserverCount=$VACLicenseserverCount,licensecloudWorkstationCount=$VACLicensecloudWorkstationCount,licensecloudServerCount=$VACLicensecloudServerCount,licensecloudconnectBackupVmCount=$VACLicensecloudconnectBackupVmCount,cloudconnectBackupWorkstationCount=$VACLicensecloudconnectBackupWorkstationCount,cloudconnectBackupServerCount=$VACLicensecloudconnectBackupServerCount,cloudconnectReplicationVmCount=$VACLicensecloudconnectReplicationVmCount"
# curl -i -XPOST "http://$InfluxDBURL:$InfluxDBPort/write?precision=s&bucket=$InfluxDB" --header "Authorization: Token $InfluxDbUser:$InfluxDbApiKey" --data-raw "veeam_vac_vaclicense,productName=$VACLicenseproductName,licensedTo=$VACLicenselicensedTo,licenseType=$VACLicenselicenseType,licensesCount=$VACLicenselicensesCount,licensesUsedCount=$VACLicenselicensesUsedCount,supportID=$VACLicensesupportId licenseExpirationDate=$VACLicenselicenseExpirationDateUnix,supportExpirationDate=$VACLicensesupportExpirationDateUnix,licensevmCount=$VACLicensevmCount,licenseworkstationCount=$VACLicenseworkstationCount,licenseserverCount=$VACLicenseserverCount,licensecloudWorkstationCount=$VACLicensecloudWorkstationCount,licensecloudServerCount=$VACLicensecloudServerCount,licensecloudconnectBackupVmCount=$VACLicensecloudconnectBackupVmCount,cloudconnectBackupWorkstationCount=$VACLicensecloudconnectBackupWorkstationCount,cloudconnectBackupServerCount=$VACLicensecloudconnectBackupServerCount,cloudconnectReplicationVmCount=$VACLicensecloudconnectReplicationVmCount"

# # Veeam Backup & Replication Licensing
# echo ====================================
# echo Retrieving B\&R Licensing
# echo

# VACUrl="$RestServer:$RestPort/v3/licensing/backupServers"
# TenantLicenseUrl=$(curl -X GET --header "Accept:application/json" --header "Authorization:Bearer $Bearer" "$VACUrl" 2>&1 -k --silent)

# declare -i arrayVBRLicense=0
# for id in $(echo "$TenantLicenseUrl" | jq -r ".[].instanceUid"); do
#     TenantLicenseEdition=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].edition" | awk '{gsub(/ /,"\\ ");print}')
#     TenantLicenseStatus=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].status")
#     TenantLicenseSupportID=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].supportID")
#     if [ "$TenantLicenseSupportID" == "" ];then
#         declare -i TenantLicenseSupportID=0
#     fi
#     TenantLicenselicenseExpirationDate=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].licenseExpirationDate")
#     if [[ $TenantLicenselicenseExpirationDate = "null" ]] ; then
#         TenantLicenselicenseExpirationDate=""
#         TenantLicenselicenseExpirationDateUnix=$NoExpiration
#     else
#         TenantLicenselicenseExpirationDateUnix=$(date -d "$TenantLicenselicenseExpirationDate" +"%s")
#     fi
#     TenantLicensesupportExpirationDate=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].supportExpirationDate")
#     if [[ $TenantLicensesupportExpirationDate = "null" ]] ; then
#         TenantLicensesupportExpirationDate=$TenantLicenselicenseExpirationDate
#     fi
#     TenantLicenselicenseExpirationDate=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].licenseExpirationDate")
#     TenantLicenselicenseExpirationDateUnix=$(date -d "$TenantLicenselicenseExpirationDate" +"%s")
#     TenantLicensesupportExpirationDate=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].supportExpirationDate")
#     TenantLicensesupportExpirationDateUnix=$(date -d "$TenantLicensesupportExpirationDate" +"%s")
#     TenantLicenselicensedSockets=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].licensedSockets")
#     TenantLicenseusedSockets=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].usedSockets")
#     TenantLicenselicensedVMs=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].licensedVMs")
#     TenantLicenseusedVMs=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].usedVMs")
#     TenantLicensebackupServerName=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].backupServerName")
#     TenantLicensecompanyName=$(echo "$TenantLicenseUrl" | jq --raw-output ".[$arrayVBRLicense].companyName" | awk '{gsub(/ /,"\\ ");print}')
#     #echo "veeam_vac_vbrlicense,companyName=$TenantLicensecompanyName,edition=$TenantLicenseEdition,status=$TenantLicenseStatus,SupportID=$TenantLicenseSupportID,LicenseExpirationDate=$TenantLicenselicenseExpirationDate,SupportExpirationDate=$TenantLicensesupportExpirationDate,backupServerName=$TenantLicensebackupServerName licensedSockets=$TenantLicenselicensedSockets,usedSockets=$TenantLicenseusedSockets,licensedVMs=$TenantLicenselicensedVMs,usedVMs=$TenantLicenseusedVMs"
#     #FIX NULL!
#     TenantLicensesupportExpirationDateUnix=0

#     curl -i -XPOST "http://$InfluxDBURL:$InfluxDBPort/write?precision=s&bucket=$InfluxDB" --header "Authorization: Token $InfluxDbUser:$InfluxDbApiKey" --data-raw "veeam_vac_vbrlicense,companyName=$TenantLicensecompanyName,edition=$TenantLicenseEdition,status=$TenantLicenseStatus,SupportID=$TenantLicenseSupportID,backupServerName=$TenantLicensebackupServerName licenseExpirationDate=$TenantLicenselicenseExpirationDateUnix,supportExpirationDate=$TenantLicensesupportExpirationDateUnix,licensedSockets=$TenantLicenselicensedSockets,usedSockets=$TenantLicenseusedSockets,licensedVMs=$TenantLicenselicensedVMs,usedVMs=$TenantLicenseusedVMs"
#     arrayVBRLicense=$arrayVBRLicense+1
# done

# ##
# # Veeam Availability Backup Repositories per every Veeam Backup & Replication Server. This part will check the capacity and used space of the Backup Repositories
# ##
# echo ==================================================
# echo Checking capacity and used space of repositories
# echo

# VACUrl="$RestServer:$RestPort/v3/infrastructure/backupServers/repositories"
# BackupRepoLicenseUrl=$(curl -X GET --header "Accept:application/json" --header "Authorization:Bearer $Bearer" "$VACUrl" 2>&1 -k --silent)

# declare -i arrayVACRepo=0
# for id in $(echo "$BackupRepoLicenseUrl" | jq -r ".[].instanceUid"); do
#     BackupReponame=$(echo "$BackupRepoLicenseUrl" | jq --raw-output ".[$arrayVACRepo].name" | awk '{gsub(/ /,"\\ ");print}')
#     BackupReposerverName=$(echo "$BackupRepoLicenseUrl" | jq --raw-output ".[$arrayVACRepo].serverName" | awk '{gsub(/ /,"\\ ");print}')
#     BackupRepocompanyName=$(echo "$BackupRepoLicenseUrl" | jq --raw-output ".[$arrayVACRepo].companyName" | awk '{gsub(/ /,"\\ ");print}')
#     BackupRepocapacity=$(echo "$BackupRepoLicenseUrl" | jq --raw-output ".[$arrayVACRepo].capacity")
#     BackupRepocapacityUnits=$(echo "$BackupRepoLicenseUrl" | jq --raw-output ".[$arrayVACRepo].capacityUnits")
#     case $BackupRepocapacityUnits in
#         B)
#             BackupRepocapacity=$(echo "scale=4; $BackupRepocapacity / 1048576" | bc -l)
#         ;;
#         KB)
#             BackupRepocapacity=$(echo "scale=4; $BackupRepocapacity / 1024" | bc -l)
#         ;;
#         MB)
#         ;;
#         GB)
#             BackupRepocapacity=$(echo "scale=4; $BackupRepocapacity * 1024" | bc -l)
#         ;;
#         TB)
#             BackupRepocapacity=$(echo "scale=4; $BackupRepocapacity * 1048576" | bc -l)
#         ;;
#         esac
#     BackupRepofreeSpace=$(echo "$BackupRepoLicenseUrl" | jq --raw-output ".[$arrayVACRepo].freeSpace")
#     BackupRepofreeSpaceUnits=$(echo "$BackupRepoLicenseUrl" | jq --raw-output ".[$arrayVACRepo].freeSpaceUnits")
#     case $BackupRepofreeSpaceUnits in
#         B)
#             BackupRepofreeSpace=$(echo "scale=4; $BackupRepofreeSpace / 1048576" | bc -l)
#         ;;
#         KB)
#             BackupRepofreeSpace=$(echo "scale=4; $BackupRepofreeSpace / 1024" | bc -l)
#         ;;
#         MB)
#         ;;
#         GB)
#             BackupRepofreeSpace=$(echo "scale=4; $BackupRepofreeSpace * 1024" | bc -l)
#         ;;
#         TB)
#             BackupRepofreeSpace=$(echo "scale=4; $BackupRepofreeSpace * 1048576" | bc -l)
#         ;;
#         esac
#     BackupRepobackupSize=$(echo "$BackupRepoLicenseUrl" | jq --raw-output ".[$arrayVACRepo].backupSize")
#     BackupRepobackupSizeUnits=$(echo "$BackupRepoLicenseUrl" | jq --raw-output ".[$arrayVACRepo].backupSizeUnits")
#     case $BackupRepobackupSizeUnits in
#         B)
#             BackupRepobackupSize=$(echo "scale=4; $BackupRepobackupSize / 1048576" | bc -l)
#         ;;
#         KB)
#             BackupRepobackupSize=$(echo "scale=4; $BackupRepobackupSize / 1024" | bc -l)
#         ;;
#         MB)
#         ;;
#         GB)
#             BackupRepobackupSize=$(echo "scale=4; $BackupRepobackupSize * 1024" | bc -l)
#         ;;
#         TB)
#             BackupRepobackupSize=$(echo "scale=4; $BackupRepobackupSize * 1048576" | bc -l)
#         ;;
#         esac
#     BackupRepobackuphealthstate=$(echo "$BackupRepoLicenseUrl" | jq --raw-output ".[$arrayVACRepo].healthState")
#     #echo "veeam_vac_repositories,repoName=$BackupReponame,backupServerName=$BackupReposerverName capacity=$BackupRepocapacity,freeSpace=$BackupRepofreeSpace,backupsize=$BackupRepobackupSize"
#     curl -i -XPOST "http://$InfluxDBURL:$InfluxDBPort/write?precision=s&bucket=$InfluxDB" --header "Authorization: Token $InfluxDbUser:$InfluxDbApiKey" --data-raw "veeam_vac_repositories,companyName=$BackupRepocompanyName,repoName=$BackupReponame,backupServerName=$BackupReposerverName capacity=$BackupRepocapacity,freeSpace=$BackupRepofreeSpace,backupsize=$BackupRepobackupSize"
#     arrayVACRepo=$arrayVACRepo+1
# done

# ##
# # Veeam Availability Jobs per every Veeam Backup & Replication Server. This part will check the different Jobs, and the Job Sessions per every Job
# ##
# echo ======================
# echo Checking jobs....
# echo

# VACUrl="$RestServer:$RestPort/v3/infrastructure/backupServers/jobs"
# veeamJobsUrl=$(curl -X GET --header "Accept:application/json" --header "Authorization:Bearer $Bearer" "$VACUrl" 2>&1 -k --silent)

# declare -i arrayJobs=0
# for id in $(echo "$veeamJobsUrl" | jq -r '.[].instanceUid'); do
#     nameJob=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].name" | awk '{gsub(/ /,"\\ ");print}' | awk '{gsub(",","\\,");print}')
#     idJob=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].instanceUid")
#     typeJob=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].type" | awk '{gsub(/ /,"\\ ");print}')    
#     lastRunJob=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].lastRun")
#     lastRunTimeUnix=$(date -d "$lastRunJob" +"%s")
#     if [[ $lastRunTimeUnix < "0" ]]; then
#             lastRunTimeUnix="1"
#     fi
#     totalDuration=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].duration")
#     status=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].status")
#     case $status in
#         Success)
#             jobStatus="1"
#         ;;
#         Warning)
#             jobStatus="2"
#         ;;
#         Failed)
#             jobStatus="3"
#         ;;
#         -)
#             jobStatus="0"
#         ;;
#         esac
#     processingRate=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].processingRate")
#     processingRateUnits=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].processingRateUnits")
#     case $processingRate in
#         B/s)
#             processingRate=$(echo "scale=4; $processingRate / 1048576" | bc -l)
#         ;;
#         KB/s)
#             processingRate=$(echo "scale=4; $processingRate / 1024" | bc -l)
#         ;;
#         MB/s)
#         ;;
#         GB/s)
#             processingRate=$(echo "scale=4; $processingRate * 1024" | bc -l)
#         ;;
#         TB/s)
#             processingRate=$(echo "scale=4; $processingRate * 1048576" | bc -l)
#         ;;
#         esac    
#     transferredData=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].transferredData")
#     transferredDataUnits=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].transferredDataUnits")
#     case $transferredData in
#         B)
#             transferredData=$(echo "scale=4; $transferredData / 1048576" | bc -l)
#         ;;
#         KB)
#             transferredData=$(echo "scale=4; $transferredData / 1024" | bc -l)
#         ;;
#         MB)
#         ;;
#         GB)
#             transferredData=$(echo "scale=4; $transferredData * 1024" | bc -l)
#         ;;
#         TB)
#             transferredData=$(echo "scale=4; $transferredData * 1048576" | bc -l)
#         ;;
#         esac
#     BackupReposerverName=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].serverName")
#     bottleneck=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].bottleneck" | awk '{gsub(/ /,"\\ ");print}')
#     isEnabled=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].isEnabled")
#     protectedVMs=$(echo "$veeamJobsUrl" | jq --raw-output ".[$arrayJobs].protectedVMs")
#     #echo "veeam_vac_jobs,veeamjobname=$nameJob,backupServerName=$BackupReposerverName,bottleneck=$bottleneck,typeJob=$typeJob,isEnabled=$isEnabled totalDuration=$totalDuration,status=$jobStatus,processingRate=$processingRate,transferredData=$transferredData,protectedVMs=$protectedVMs $lastRunTimeUnix"
#     curl -i -XPOST "http://$InfluxDBURL:$InfluxDBPort/write?precision=s&bucket=$InfluxDB" --header "Authorization: Token $InfluxDbUser:$InfluxDbApiKey" --data-raw "veeam_vac_jobs,veeamjobname=$nameJob,backupServerName=$BackupReposerverName,bottleneck=$bottleneck,typeJob=$typeJob,isEnabled=$isEnabled totalDuration=$totalDuration,status=\"$jobStatus\",processingRate=$processingRate,transferredData=$transferredData,protectedVMs=$protectedVMs,lastRunTime=$lastRunTimeUnix"
#     arrayJobs=$arrayJobs+1
# done

# ##
# # Logging off
# ##
# #VACUrl="$RestServer:$RestPort/v3/accounts/logout"
# #curl -X POST --header "Accept: application/json" --header "Authorization:Bearer $Bearer" "$VACUrl" -k --silent
