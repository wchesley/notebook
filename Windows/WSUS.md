<sub>[Back](./README.md)</sub>

# Windows Server Update Services (WSUS)

Connect to WID database via SQL Server Management Studio (SSMS), use the named pipe `\\.\pipe\MICROSOFT##WID\tsql\query` to connect to the local WID database. The database file is located in `C:\Windows\WID\Data`. You will most likely have to run SSMS as administrator in order to connect to the WSUS WID. 

To shrink the database file: 

```sql
USE SUSDB;
GO
DBCC SHRINKFILE (SUSDB, 0);
GO
```

To shrink the database: 

```sql
USE SUSDB;
GO
DBCC SHRINKDATABASE (SUSDB, 0);
GO
```

[WSUS Maintenance Guide](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/update-management/wsus-maintenance-guide)
[WSUS DB Maintenance](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/update-management/wsus-automatic-maintenance?source=recommendations)