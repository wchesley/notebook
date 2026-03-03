<sub>[Back](./README.md)</sub>

# Windows Server Update Services (WSUS)

Connect to WID database via SQL Server Management Studio (SSMS), use the named pipe `\\.\pipe\MICROSOFT##WID\tsql\query` to connect to the local WID database. If using dedicated SQL database, the file is located in `C:\Windows\WID\Data`. You will most likely have to run SSMS as administrator in order to connect to the WSUS WID. 

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

Perform cleanup of synchronization history: 
```sql
USE SUSDB 
GO 
DELETE FROM tbEventInstance WHERE EventNamespaceID = '2' AND EVENTID IN ('381', '382', '384', '386', '387', '389')
```

Reindex SUSDB: 

```sql
EXEC sp_MSforeachtable @command1="SET QUOTED_IDENTIFIER ON;ALTER INDEX ALL ON ? REBUILD;"
```

Update Statistics: 

```sql
Exec sp_msforeachtable "UPDATE STATISTICS ? WITH FULLSCAN, COLUMNS"
```

Cleanup of obsolete updates: 

```sql
DECLARE @var1 INT
DECLARE @msg nvarchar(100)
CREATE TABLE #results (Col1 INT)
        INSERT INTO #results(Col1) EXEC spGetObsoleteUpdatesToCleanup
DECLARE WC Cursor
        FOR
        SELECT Col1 FROM #results
OPEN WC
        FETCH NEXT FROM WC
        INTO @var1
        WHILE (@@FETCH_STATUS > -1)
        BEGIN SET @msg = 'Deleting' + CONVERT(varchar(10), @var1)
        RAISERROR(@msg,0,1) WITH NOWAIT EXEC spDeleteUpdate @localUpdateID=@var1
        FETCH NEXT FROM WC INTO @var1 END        
CLOSE WC
        DEALLOCATE WC

        DROP TABLE #results
```

Clean superseded updates older than 30 days or according to your specific configuration: 

```sql
DECLARE @thresholdDays INT = 30   -- Specify the number of days between today and the release date during which superseded updates should not be marked as declined. If Configuration Manager is being used with WSUS, this value should match the configuration of supersedence rules in the software update point (SUP) component properties.
DECLARE @testRun BIT = 0          -- Set this value to 1 to test without declining anything. 
-- There shouldn't be any need to modify anything after this line.
DECLARE @uid UNIQUEIDENTIFIER
DECLARE @title NVARCHAR(500)
DECLARE @date DATETIME
DECLARE @userName NVARCHAR(100) = SYSTEM_USER 
DECLARE @count INT = 0 
DECLARE DU CURSOR FOR
       SELECT MU.UpdateID, U.DefaultTitle, U.CreationDate FROM vwMinimalUpdate MU 
       JOIN PUBLIC_VIEWS.vUpdate U ON MU.UpdateID = U.UpdateId
       WHERE MU.IsSuperseded = 1 AND MU.Declined = 0 AND MU.IsLatestRevision = 1
       AND MU.CreationDate < DATEADD(dd,-@thresholdDays,GETDATE())
       ORDER BY MU.CreationDate 
PRINT 'Declining superseded updates older than ' + CONVERT(NVARCHAR(5), @thresholdDays) + ' days.' + CHAR(10) 
OPEN DU
FETCH NEXT FROM DU INTO @uid, @title, @date
WHILE (@@FETCH_STATUS > - 1)
BEGIN  
       SET @count = @count + 1
       PRINT 'Declining update ' + CONVERT(NVARCHAR(50), @uid) + ' (Creation Date ' + CONVERT(NVARCHAR(50), @date) + ') - ' + @title + ' ...'
       IF @testRun = 0
              EXEC spDeclineUpdate @updateID = @uid, @adminName = @userName, @failIfReplica = 1 
       FETCH NEXT FROM DU INTO @uid, @title, @date
END 
CLOSE DU
DEALLOCATE DU 
PRINT CHAR(10) + 'Attempted to decline ' + CONVERT(NVARCHAR(10), @count) + ' updates.'
```

[WSUS Maintenance Guide](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/update-management/wsus-maintenance-guide)
[WSUS DB Maintenance](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/update-management/wsus-automatic-maintenance?source=recommendations)