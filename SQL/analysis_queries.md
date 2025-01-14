[back](./README.md)

# SQL Server Database Analysis Queries

Adapted from: https://blog.nimblepros.com/blogs/sql-server-database-analysis-queries/

As a software developer or database administrator, understanding the structure and size of your SQL Server database is crucial. Whether you’re optimizing performance, preparing for maintenance, or simply auditing your database, having the right queries at your disposal can make all the difference. In this article, we’ll explore a set of SQL queries that provide valuable insights into your SQL Server database, covering aspects such as stored procedures, tables, and views.

## Analyzing Stored Procedures

### Count and Size Metrics

SQL Server has tables that hold all of the information you need about the database’s main components: tables, stored procedures, views, etc. We can query these tables to help us quickly assess the size and complexity of the database schema. Note that this is completely separate from the actual size of the data! What we mostly care about is the structure, regardless of whether there are hundreds of rows or billions.

Note that some features like diagramming do not have the `is_ms_shipped` bit set to `1` so the best solution I’ve found currently is to exclude them by name.

### Total Number of Stored Procedures
To get the total count of user-defined stored procedures, excluding system stored procedures:

```sql
SELECT COUNT(*) AS TotalUserStoredProcedures
FROM sys.procedures
WHERE is_ms_shipped = 0
AND name NOT IN ('sp_upgraddiagrams', 'sp_helpdiagrams', 'sp_helpdiagramdefinition', 'sp_creatediagram', 'sp_renamediagram' 'sp_alterdiagram', 'sp_dropdiagram');
```

### Total and Average Length of Stored Procedures

This query calculates the total and average length (in characters) of stored procedures:

```sql
SELECT 
    COUNT(*) AS TotalStoredProcedures,
    SUM(LEN(sm.definition)) AS TotalLengthOfStoredProcedures,
    AVG(LEN(sm.definition)) AS AverageLengthOfStoredProcedures
FROM 
    sys.procedures AS sp
JOIN 
    sys.sql_modules AS sm ON sp.object_id = sm.object_id
WHERE 
    sp.is_ms_shipped = 0
	AND name NOT IN ('sp_upgraddiagrams', 'sp_helpdiagrams', 'sp_helpdiagramdefinition', 'sp_creatediagram', 'sp_renamediagram', 'sp_alterdiagram', 'sp_dropdiagram');
```

In addition to a rough count, it’s also useful to know the overall size of the stored procedures. This provides a rough indicator of the complexity, as a whole.

### Top 10 Longest Stored Procedures

To identify the top 10 longest stored procedures in terms of character length:

```sql
SELECT TOP 10
    OBJECT_NAME(sm.object_id) AS StoredProcedureName,
    LEN(sm.definition) AS LengthInCharacters
FROM 
    sys.sql_modules AS sm
JOIN 
    sys.procedures AS sp ON sm.object_id = sp.object_id
WHERE 
    sp.is_ms_shipped = 0
	AND name NOT IN ('sp_upgraddiagrams', 'sp_helpdiagrams', 'sp_helpdiagramdefinition',
                 'sp_creatediagram', 'sp_renamediagram', 'sp_alterdiagram', 'sp_dropdiagram')
ORDER BY 
    LEN(sm.definition) DESC;
```

Averages can hide a lot of details, so it’s worth seeing which stored procedures are the biggest, and investigating them individually to see just how gnarly (that’s a technical term) they are.

### Parameters Analysis

#### Counting Parameters in Stored Procedures
For more detailed analysis, you can also count the number of parameters in each stored procedure:

```sql
SELECT 
    OBJECT_NAME(sm.object_id) AS StoredProcedureName,
    COUNT(p.parameter_id) AS NumberOfParameters
FROM 
    sys.sql_modules AS sm
JOIN 
    sys.procedures AS sp ON sm.object_id = sp.object_id
LEFT JOIN 
    sys.parameters AS p ON sm.object_id = p.object_id
WHERE 
    sp.is_ms_shipped = 0
	AND sp.name NOT IN ('sp_upgraddiagrams', 'sp_helpdiagrams', 'sp_helpdiagramdefinition',
                 'sp_creatediagram', 'sp_renamediagram', 'sp_alterdiagram', 'sp_dropdiagram')

GROUP BY 
    sm.object_id
ORDER BY 
    COUNT(p.parameter_id) DESC;
```

Finally, another rough indicator of complexity is number or parameters. This information can be combined with the above queries if needed. Some complicated stored procs will have many parameters, as will some insertion or update sprocs that reference tables with large numbers of columns. Either way, larger sets of parameters are generally more difficult to migrate than shorter ones, so knowing the biggest ones can help with an assessment of the database’s complexity.

## Tables and Views

While stored procedures often make up a large component of the migration effort for legacy systems, tables and (to a much lesser extent) views are a part of pretty much every application and can demonstrate technical debt as well. For instance, it’s not unusual in Big Ball of Mud systems with tons of tight coupling for certain common tables to grow over time, adding more and more optional columns to the end. The reason for this is a lack of bounded contexts and the inability to change the existing schema for fear of breaking the world. When you see a table with 50+ columns on it, you’ve usually stumbled into such a system…

### Tables Analysis

#### Top 10 Tables by Number of Columns
Identify tables with the most columns, which can be indicative of complex structures:

```sql
SELECT TOP 10
    t.name AS TableName,
    COUNT(c.column_id) AS NumberOfColumns
FROM 
    sys.tables AS t
JOIN 
    sys.columns AS c ON t.object_id = c.object_id
GROUP BY 
    t.name
ORDER BY 
    COUNT(c.column_id) DESC;
```

Again, we’re not so much concerned with the number of rows as the organization of the data into tables. And really wide tables are often a [design smell](https://deviq.com/antipatterns/code-smells).

**Foreign Key Analysis** Count total foreign keys and ratio of keys to tables.

```sql
WITH FKCounts AS (
    SELECT 
        COUNT(f.object_id) AS ForeignKeyCount
    FROM 
        sys.foreign_keys AS f
),
TableCounts AS (
    SELECT 
        COUNT(t.object_id) AS TableCount
    FROM 
        sys.tables AS t
)
SELECT 
    (SELECT ForeignKeyCount FROM FKCounts) AS TotalForeignKeys,
    (SELECT TableCount FROM TableCounts) AS TotalTables,
    CAST((SELECT ForeignKeyCount FROM FKCounts) AS FLOAT) / 
    CAST((SELECT TableCount FROM TableCounts) AS FLOAT) AS ForeignKeyToTableRatio
```

Having a rough number of foreign keys in relation to the number of tables can be helpful, though it usually requires additional analysis. If there are zero foreign keys, that’s obviously good information and for a large database usually means you’re going to find some referential integrity issues. But having a ton of foreign keys can also mean that the data schema is very rigid and tightly coupled, so identifying aggregates and bounded contexts and pulling them apart from their dependencies may be challenging.

### Views Analysis

#### Counting User-Defined Views

To count the number of user-created views, excluding system views:

```sql
SELECT COUNT(*) AS TotalUserViews
FROM sys.views
WHERE is_ms_shipped = 0;
```

### Index Analysis

#### Counting Indexes 

To count the number of indexes:

```sql
SELECT COUNT(*) AS TotalIndexes
FROM sys.indexes
WHERE is_primary_key = 0 AND is_unique_constraint = 0;
```

### Triggers

To count the number of user-created triggers: 

```sql
SELECT COUNT(*) AS TotalTriggers
FROM sys.triggers
WHERE is_ms_shipped = 0;
```

Most modern .NET apps do not use triggers heavily, but they are also frequently overlooked and forgotten, so getting a count of them and then investigating further if there are any is always prudent.

### Security Elements (Users and Roles)

To count the number of database users and roles associated with the database:

```sql
SELECT 
    'Database Users' AS SecurityElement, COUNT(*) AS Total
FROM sys.database_principals
WHERE type_desc IN ('SQL_USER', 'WINDOWS_USER', 'EXTERNAL_USER')
UNION ALL
SELECT 
    'Database Roles' AS SecurityElement, COUNT(*) AS Total
FROM sys.database_principals
WHERE type_desc = 'DATABASE_ROLE';
```

Most simple applications should only have one or two users associated with their database. Having many users and roles is an indication the database is probably accessed by many different applications and ad hoc queries and thus is likely to be more difficult to migrate.

### Functions, Types, Schemas

To Count other database metrics: 

```sql
SELECT 'Scalar-valued Functions' AS ItemType, COUNT(*) AS TotalCount
FROM sys.objects
WHERE type = 'FN'
UNION ALL
SELECT 'Table-valued Functions' AS ItemType, COUNT(*) AS TotalCount
FROM sys.objects
WHERE type IN ('TF', 'IF', 'TVF')
UNION ALL
SELECT 'Schemas' AS ItemType, COUNT(*) AS TotalCount
FROM sys.schemas
UNION ALL
SELECT 'Partition Functions' AS ItemType, COUNT(*) AS TotalCount
FROM sys.partition_functions
UNION ALL
SELECT 'User-defined Types' AS ItemType, COUNT(*) AS TotalCount
FROM sys.types
WHERE is_user_defined = 1
```
Just for completeness’ sake, this query grabs counts of functions, schemas, partitions, and user-defined types. Most simple database will have zeros for most of these and just the default `dbo`, `sys`, and other default schemas (typically about 12-13).

Having many of these things indicates a more complex data model that requires more analysis.

## Conclusion

Using these SQL queries, you can gain a comprehensive understanding of your SQL Server database’s structure and complexity. From assessing stored procedures to analyzing table structures, these insights are invaluable for database optimization, migration, or simply for maintaining an organized and efficient database system.