[back](./README.md)

# Managing Data in Influx CLI

Column: https://docs.influxdata.com/influxdb/v1.8/query_language/manage-database/#drop-series-from-the-index-with-drop-series

Had some issues dropping forecast data from influxdb, specifically the PVE database, ran the following to resolve it: 
`DROP SERIES FROM "measurement" WHERE "tag" = 'value'`

So specific to the PVE database:
`$ influx #launch influxCLI`
`> use pve 
DROP SERIES FROM "weather" WHERE "city" = 'Amarillo'`

pulled from: [here](https://community.influxdata.com/t/commad-to-delete-a-particular-series-from-influxdb/5600/3)