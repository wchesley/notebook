# Veeam Availability Console Script

Modified version of the script provided by [VeeamHub](https://github.com/VeeamHub/grafana/blob/master/veeam-availability-console-grafana/veeam-availability-console-script.sh). Work in progress to bring update script to work with Veeam Service Provider Console API v3 and InfluxDB 2.x. 

- [VSPC v2 to v3 changes](https://helpcenter.veeam.com/archive/vac/60/rest/appendix_migration_operations.html#tenantslicensesreports)

### InfluxDB changes

- New write endpoint URL: `<influxDbUrl>:8086/api/v2/write?`
- `bucket` has replaced `db` in URL query string
- `org` is now required in URL query string 
- Username and password are not required if using an API key. Update `Authorization` headers to `Token <apiKey>` instead of `Token <Username>:<password>`