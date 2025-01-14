[back](../README.md)

# The TIG Stack (Telegraf, Influxdb, Grafana)

The TIG stack is an open-source alternative to legacy data historians. [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) solves data collection challenges, [InfluxDB](https://www.influxdata.com/products/influxdb-cloud/) stores and manages time series data, and [Grafana](https://www.influxdata.com/grafana/) enables visualization of that data. Let’s dive deeper into each part of the stack.

# Contents

- [The TIG Stack (Telegraf, Influxdb, Grafana)](#the-tig-stack-telegraf-influxdb-grafana)
- [Contents](#contents)
- [Docs:](#docs)
    - [Telegraf: Data collection](#telegraf-data-collection)
    - [InfluxDB: Data storage and querying at scale](#influxdb-data-storage-and-querying-at-scale)
    - [Grafana: Real-time data visualization and alerting](#grafana-real-time-data-visualization-and-alerting)


# Docs: 

- [InfluxDB](./InfluxDb.md)
- [Telegraf](./Telegraf-1-19-docs.md)
- Grafana

### Telegraf: Data collection

Telegraf is lightweight, written in Go, has no external dependencies,
 and requires a minimal memory footprint. You can install it on the 
smallest devices and it can handle the scale and volume of industrial 
data.

Telegraf’s architecture is plugin-based. There are over 300 [plugins](https://www.influxdata.com/products/integrations/)
 available for just about every service and protocol. Mix and match the 
plugins needed for your application and IIoT specifications. Because 
Telegraf is open-source, if a plugin doesn’t exist, you can always 
create one for an even further customized experience.

There are four types of Telegraf plugins:

- **Input:** Data starts at the input plugins where Telegraf connects to virtually any data source, including [MQTT](https://www.influxdata.com/mqtt/), Kafka, ModBus, OPC-UA, SNMP, GNMI, and more.
- **Processor:** Processors transform, decorate, or filter the raw metrics. Processors can function as data cleaners.
- **Aggregator:** Aggregators apply a desired operation to data (i.e. mean, min, or max).
- **Output:** These plugins push data from Telegraf to a destination source.

### InfluxDB: Data storage and querying at scale

If you don’t clean your data in transit, InfluxDB can clean and 
aggregate data, and more. The benefits of InfluxDB over a data historian
 don’t end with storage and querying. InfluxDB offers advanced, 
real-time analytics, can leverage large datasets for AI/ML integrations,
 and aids with the deployment of predictive maintenance procedures.

InfluxDB Cloud, powered by IOx, is a purpose-built database for time series data. Built in Rust on top of [Apache Arrow](https://www.influxdata.com/glossary/apache-arrow/), this columnar database separates compute and storage for greater flexibility. It uses [Apache Arrow Flight SQL](https://www.influxdata.com/glossary/apache-arrow-flight-sql/)
 to transfer data between clients, servers, and other systems and tools.
 Many data scientists, data warehousing, and big data engineers are 
adopting the Arrow ecosystem, simplifying integrations with InfluxDB.

InfluxDB Cloud supports native [SQL](https://www.influxdata.com/products/sql/)
 queries and includes a SQL query, parser, and execution engine. 
InfluxDB can handle data with unlimited cardinality and users can slice 
and dice their data across any dimension.

### Grafana: Real-time data visualization and alerting

The last piece of the TIG stack brings us back to the factory floor. [Grafana](https://www.influxdata.com/grafana/)
 dashboards enable you to query and visualize data to provide value in 
real time. When combined with historical data and predictive maintenance
 processes, Grafana can show the current state of things versus their 
expected state. Real-time alerts help bring focus to where it’s needed. 
Best of all, Grafana seamlessly integrates with InfluxDB.

There are a few ways of setting up dashboards to suit the needs of a 
specific use case: ready-made dashboards, custom UI Grafana dashboards, 
and custom-coded dashboards. There’s also a Flight SQL Plugin that 
enables users to build reports and dashboards common in BI tools. 
Grafana can display dashboards on a multi-page or single pane of glass 
setup. You can configure custom dashboards for all stakeholders, whether
 that’s machine info for shop floor operators at the edge, a single pane
 of glass view for business analysts at headquarters, or anyone else.