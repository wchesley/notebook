# SQL 

Structured Query Language (SQL) ("sequel") is a domain-specific language used to manage data, especially in a relational database management system (RDBMS). It is particularly useful in handling structured data, i.e., data incorporating relations among entities and variables.

Introduced in the 1970s, SQL offered two main advantages over older read–write APIs such as ISAM or VSAM. Firstly, it introduced the concept of accessing many records with one single command. Secondly, it eliminates the need to specify how to reach a record, i.e., with or without an index.

Originally based upon relational algebra and tuple relational calculus, SQL consists of many types of statements, which may be informally classed as sublanguages, commonly: a data query language (DQL), a data definition language (DDL), a data control language (DCL), and a data manipulation language (DML). The scope of SQL includes data query, data manipulation (insert, update, and delete), data definition (schema creation and modification), and data access control. Although SQL is essentially a declarative language (4GL), it also includes procedural elements.

SQL was one of the first commercial languages to use Edgar F. Codd's relational model. The model was described in his influential 1970 paper, "A Relational Model of Data for Large Shared Data Banks". Despite not entirely adhering to the relational model as described by Codd, SQL became the most widely used database language.

SQL became a standard of the American National Standards Institute (ANSI) in 1986 and of the International Organization for Standardization (ISO) in 1987. Since then, the standard has been revised multiple times to include a larger set of features and incorporate common extensions. Despite the existence of standards, virtually no implementations in existence adhere to it fully, and most SQL code requires at least some changes before being ported to different database systems.

## SQL Padding Whitespace to fields

SQL Server returning values with extra whitespace added to the end of the object is a result of the columns datatype. ie. if set to `char(18)` and only 8 characters are entered into the field, the remaining 10 characters are set to whitespace. This is by design. To avoid this, change the column type to `varchar(18)` and SQL will only write the given 8 characters to disk. 

## Updating Table Column

Updating a column data type: 

```sql
ALTER TABLE WestgateWeb.dbo.SV_BUILDSHEETS ALTER COLUMN NumberOrdered nvarchar(MAX) NULL;
```

## Adding Column to Existing Table

```sql
ALTER TABLE WESTGATEDEV.dbo.SV_ORDERS ADD QuoteId int NULL;
```