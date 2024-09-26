# InfluxDB

InfluxDB is an open-source time series database (TSDB) developed by the company InfluxData. It is used for storage and retrieval of time series data in fields such as operations monitoring, application metrics, Internet of Things sensor data, and real-time analytics.

# Contents

- [InfluxDB](#influxdb)
- [Contents](#contents)
- [Related Docs](#related-docs)
- [General Notes](#general-notes)
  - [Difference between `fields` and `tags`](#difference-between-fields-and-tags)
    - [Question: Understanding how to choose between fields and tags in InfluxDB](#question-understanding-how-to-choose-between-fields-and-tags-in-influxdb)
    - [Answer:](#answer)
    - [Alt Answer:](#alt-answer)


# Related Docs

- [Influx 1.x download & install](./Influx-debian-repo.md)
- [Influx 2.x download & install](./InfluxDb-2.0-install.md)
  - [Verify Influx repository](./Verify-InfluxDb.md)
- [Influx CLI installation](./Influx-Client-Install.md)

# General Notes

## Difference between `fields` and `tags`

ref: [dba stackexchange](https://dba.stackexchange.com/questions/163292/understanding-how-to-choose-between-fields-and-tags-in-influxdb)

### Question: Understanding how to choose between fields and tags in InfluxDB

What are some good rules and examples of how to choose between storing data in fields vs. tags when designing [InfluxDB schemas](https://docs.influxdata.com/influxdb/v1.2/concepts/schema_and_data_layout/)?

What I've [found so far](https://docs.influxdata.com/influxdb/v1.7/concepts/schema_and_data_layout/#encouraged-schema-design) is:

> a measurement that changes over time should be a field, and metadata about the measurement should be in tags
> 
> 
> tags and fields are effectively columns in the table. tags are indexed, fields are not
> 
> the values that are highly variant and not usually part of a WHERE clause are put into fields
> 
> Store data in fields if you plan to use them with an InfluxQL function
> 
> Tags containing highly variable information like UUIDs, hashes, and 
> random strings will lead to a large number of series in the database, 
> known colloquially as high series cardinality. High series cardinality 
> is a primary driver of high memory usage for many database workloads.
> 

But let's say you store filled orders in an e-commerce application: order id, sale price, currency.

- Should the order id be a tag, or a field?
- Should the currency be a tag, or a field?

### Answer: 



I just read a tutorial that said fields are data and tags are metadata. That is a very intuitive definition.

The example had pressure and temperature fields and a weather station tag. Again, crystal clear and perfectly matches the description.

Unfortunately, they then said that if you are querying on pressure or temperature and not weather station, you should flip the field and tag designations around. In other words the definitions provided for field and tag are meaningless.

The simple solution is to stipulate that fields can either be indexed or not indexed. Fields that are indexed are called tags. Use tag when you need to index a field (to dramatically improve query speed for example).

--- 
### Alt Answer: 



Tags are indexed string values meant for discrete sets of values. Tags can be queried in a WHERE clause, and can be used for grouping values with GROUP BY. Tags are ideal for metadata and a poor choice for data. Use a tag if you need such functionality and you have a bounded set of tag values.

Fields are typed values (can be string, but can be int, long, bool, or any other valid field type) and are meant for data. Fields are not indexed, and can be selected as columns in the result. Use fields for your data.

To select between a tag and a field, use the following questions:

1. **Does this data have a small, bounded, discrete set of values?**
    - If so, likely use a tag.
2. **Do I need to group or query this data in a WHERE clause?**
    - If so, refer to #1: Does this data have a small, bounded, discrete set of values?
    - If the value is unbounded (like an order ID in your example) then find some way to tag metadata about the value and store the value as a tag. Example for an order would be the month the order was placed (12 discrete values) although that's clearly not as useful for finding a given order.
3. If you answered "no" to 1 and 2, **use a field**.

In your example, currency should be a tag (has a discrete set of values, is metadata) and order ID should be a field (not a bounded set of values, is data not metadata)

Note that while Order ID would seem to need to be a tag to be able to find the data for a particular order, this will cause extremely high series cardinality within InfluxDB and will lead to very high (unsustainably high) memory usage. InfluxDB is meant for visualizing data by time, not by IDs like an order ID, and so it may need to be used in addition to a second database (such as MySQL, Postgresql or a NoSQL alternative) which can query by primary keys / IDs.

---