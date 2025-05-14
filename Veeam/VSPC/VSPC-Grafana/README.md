[back](../README.md)

Modified version of the script provided by [VeeamHub](https://github.com/VeeamHub/grafana/blob/master/veeam-availability-console-grafana/veeam-availability-console-script.sh). Work in progress to bring update script to work with Veeam Service Provider Console API v3 and InfluxDB 2.x. 

# InfluxDB - Changes

- New write endpoint URL: `<influxDbUrl>:8086/api/v2/write?`
- `bucket` has replaced `db` in URL query string
- `org` is now required in URL query string 
- Username and password are not required if using an API key. Update `Authorization` headers to `Token <apiKey>` instead of `Token <Username>:<password>`

# Veeam Service Provider Console - Changes

Authorization to the VSPC API does not require a username or password if using an API key. Instead you can just pass your API key as an authorization header to the VSPC API rather than authenticating first before requesting a resource. See [API Key-Based Auth](https://helpcenter.veeam.com/docs/vac/rest/api_keys.html?ver=81) for information on creating an API key and its use. 

## Docs: 

- [VSPC v2 to v3 changes](https://helpcenter.veeam.com/archive/vac/60/rest/appendix_migration_operations.html#tenantslicensesreports)
- API docs are available on each Veeam Service Provider Console installation at `https://<VspcUrl>:1280/api/swagger/index.html`.
  - You can authenticate with your VSPC instance here and run queries in the browser. 
- API docs are also available online through the [Veeam Helpcenter](https://helpcenter.veeam.com/docs/vac/rest/reference/vspc-rest.html?ver=81#tag/About). 
- [API Reference Docs](https://helpcenter.veeam.com/docs/vac/rest/about_rest.html?ver=81)
