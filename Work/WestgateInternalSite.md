# Westgate Internal Site 
## Dev Diary

### Auto populate build list based on Order

Database View `Items_on_Quotes` seems to contain most, if not all the information I'm after for this feature. 

Example `QuoteNo` - `84418`
- Customer: WBTV - `CUS_CUSTID` - `32540`

View definition: 

```sql
CREATE VIEW [dbo].[Items_on_Quotes]      
AS
  SELECT dbo.DEPTMENT.DPT_Description  AS Department,
         dbo.CATEGORY.CAT_CATEGORYDESC AS Category,
         dbo.INVDET.IND_BARCODE        AS SKU,
         dbo.ITEMS.ITE_DESCRIPTION     AS Description,
         dbo.INVDET.IND_QUANTITY       AS Qty,
         CASE
           WHEN ORDERS.ORD_S_ID = 'SERVICE' THEN 'SERVICE QUOTE'
           ELSE 'SALES QUOTE'
         END                           AS QuoteType,
         dbo.ORDERS.ORD_INVOICENO      AS QuoteNo,
         dbo.CUSMER.CUS_NAME           AS Customer
  FROM   dbo.INVDET
         INNER JOIN dbo.CATEGORY
                 ON dbo.INVDET.IND_CatID = dbo.CATEGORY.CAT_ID
         INNER JOIN dbo.DEPTMENT
                 ON dbo.INVDET.IND_Department = dbo.DEPTMENT.DPT_ID
         INNER JOIN dbo.ORDERS
                 ON dbo.INVDET.IND_INVOICENO = dbo.ORDERS.ORD_INVOICENO
                    AND dbo.INVDET.IND_Site = dbo.ORDERS.ORD_Site
         INNER JOIN dbo.CUSMER
                 ON dbo.ORDERS.ORD_CUSTID = dbo.CUSMER.CUS_CustID
         LEFT OUTER JOIN dbo.ITEMS
                      ON dbo.INVDET.IND_INVNO = dbo.ITEMS.ITE_INVNO
  WHERE  ( dbo.ORDERS.ORD_STATUS = 'Q' )
         AND ( dbo.INVDET.IND_BARCODE NOT IN ( 'SUBTOTAL', 'PACKAGE', 'NOTE:', '*SECTION/*',
                                               'FREIGHT', 'GIFTCERT', 'REDEEM', 'DISCOUNT', 'COUPON' ) )
         AND ( NOT ( dbo.INVDET.IND_SHOWPRICE = 3 ) )
         AND ( NOT ( dbo.INVDET.IND_BARCODE = '' ) )
          OR ( dbo.ORDERS.ORD_STATUS = 'Q' )
             AND ( dbo.INVDET.IND_BARCODE NOT IN ( 'SUBTOTAL', 'PACKAGE', 'NOTE:', '*SECTION/*',
                                                   'FREIGHT', 'GIFTCERT', 'REDEEM', 'DISCOUNT', 'COUPON' ) )
             AND ( NOT ( dbo.INVDET.IND_SHOWPRICE = 3 ) )
             AND ( NOT ( dbo.INVDET.IND_DESCRIPTION = '' ) )
          OR ( dbo.ORDERS.ORD_STATUS = 'Q' )
             AND ( dbo.INVDET.IND_BARCODE NOT IN ( 'SUBTOTAL', 'PACKAGE', 'NOTE:', '*SECTION/*',
                                                   'FREIGHT', 'GIFTCERT', 'REDEEM', 'DISCOUNT', 'COUPON' ) )
             AND ( NOT ( dbo.INVDET.IND_SHOWPRICE = 3 ) )
             AND ( NOT ( dbo.INVDET.IND_QUANTITY = 0 ) )

go
```

Where querying with `QuoteNo` from view, to `INVDET` table's `IND_INVOICENO` column, that pulls the parts, their quantity, price per part is listed here, however, the total is also on the `ORDERS` table. 

Once and Order is converted to an invoice (table `PINVOICE`), the `ORDERS.ORD_INVOICENO` becomes a negative value. Might be the method to determine if it's a build or not? This was found while exploring another db view called `vCustomerPurchases` 

Determining if an order is a PC build or not: 
- Initial thought is to filter based on number of items in Items_on_Quotes view...yet there can be orders that are not builds with more than ~~4~~ 5 items (~~initail guess at minimum amount of items~~ 5 seems to be a better fit for a build or not).
  - Filtering on this exponentially increases page load times. Could be because I'm on the same server as the DB? Or could be my own filtering logic I've applied...Trying new logic based on counts? we'll see by I have little hope for it. 
  - Initial filtering logic: 
    ```csharp
    //Filter down list to only include items with a department that matches a build keyword: 
        var itemsOnOrderIndex = await itemsOnOrder.FilterByItems(Departments.AllDepartments,
            (item, keywd) => item.Department.Contains(keywd), true).ToListAsync(cancellationToken: cancellationToken);
        
        //Filter down list to only include items that are a potential build
        var itemsOnOrderFiltered = new List<WestgateDomain.Models.ItemsOnQuote>();
        foreach (var item in itemsOnOrderIndex)
        {
            var potentialBuild = itemsOnOrderIndex.SelectMany(i => itemsOnOrderIndex).Where(i => i.QuoteNo == item.QuoteNo).ToList();
            //Generally speaking, any order with more than 5 items is a build: 
            if (potentialBuild.Count >= 5)
            {
                itemsOnOrderFiltered.AddRange(potentialBuild);
            }
        }
        
        //filter down list again, removing duplicates and changing type to IQueryable:
        var indexItems = itemsOnOrderFiltered.Select(i => new ItemsOnQuoteIndexDto()
            {
                Customer = i.Customer,
                QuoteNo = i.QuoteNo,
            }).Distinct()
            .AsQueryable();
            
        //Finally return the results: 
        return indexItems;```

  - Modified to the following which resolves the issue, mostly, it's still slow, but not as slow as previous implementation: 
  ```csharp
   //Filter down list to only include items with a department that matches a build keyword: 
        var itemsOnOrderIndex = itemsOnOrder.FilterByItems(Departments.AllDepartments,
            (item, keywd) => item.Department.Contains(keywd), true);
        
        //Filter down list to only include items that are a potential build
        var itemsOnOrderFiltered = new List<WestgateDomain.Models.ItemsOnQuote?>();
        Dictionary<int, int> potentialBuild = new Dictionary<int, int>();
        foreach (var item in itemsOnOrderIndex)
        {
            if (!potentialBuild.TryAdd(item.QuoteNo.Value, 1))
            {
                potentialBuild[item.QuoteNo.Value] += 1;
            }

            //Generally speaking, any order with more than 5 items is a build: 
            if (potentialBuild[item.QuoteNo.Value] >= 5)
            {
                itemsOnOrderFiltered.Add(itemsOnOrderIndex.Where(i => i.QuoteNo == item.QuoteNo).FirstOrDefault());
            }
        }
        
        //filter down list again, removing duplicates and changing type to IEnumerable:
        var indexItems = itemsOnOrderFiltered.Select(i => new ItemsOnQuoteIndexDto()
        {
            Customer = i.Customer,
            QuoteNo = i.QuoteNo,
        }).DistinctBy(q => q.QuoteNo);
            
        //Finally return the results: 
        return indexItems;```




- Might be best to filter based on `Department` types, only filter for ones related to a PC build. This is best for creating the BuildSheet, not filtering the index list
- Filtering the index list has been simplified to just counting the number of instances any `OrderId` occurs, if we have more than 5, assume it's a build and add that to the list. 
- ~~If we can set some unique ID on the `ORD_SNUM` field, then we can easily filter by that and get only orders that are to be builds.~~ No option is presented by POS for us to set this value. 


## InService Page

Windows Service Bench - Currently in service page notes:  
This page isn't really a priority just making notes for later as there's pretty good odds that I will be creating this page. 

ref: legacy site - `InWork.aspx.cs`

```csharp
string strSQL = "SELECT " +
        "ORDERS.ORD_CUSTID AS CustAcct, " +
        "dtbl_1.CUS_NAME AS Name, " +
        "CONVERT(varchar, dbo.prm_ConvertPRMDateTime(ORDERS.ORD_SALESDATE, 0), 101) AS DateIn, " +
        "ORDERS.ORD_INVOICENO AS RefID, " +
        "ORDERS.ORD_CALLED AS Days, " +
        "CONVERT(varchar,dbo.prm_ConvertPRMDateTime(ORDERS.ORD_DATEDUE, 0), 101) AS DateOut, " + 
        "dtbl_2.SAL_SALESNAME AS CheckedInBy, " +
        "ORDERS.ORD_SNUM AS Description, " +
        "ORDERS.ORD_SOSTAT AS Status " +
        "FROM ORDERS INNER JOIN " +
        "(SELECT CUS_CustID, CUS_NAME " +
                "FROM CUSMER) AS dtbl_1 ON ORDERS.ORD_CUSTID = dtbl_1.CUS_CustID INNER JOIN " +
        "(SELECT SAL_SALESNAME, SAL_SALESID " +
                "FROM SALESID) AS dtbl_2 ON ORDERS.ORD_SALESID = dtbl_2.SAL_SALESID " +
        "WHERE (ORDERS.ORD_SOSTAT LIKE '@%') " +
        "AND (ORDERS.ORD_SNUM NOT LIKE 'Apple%') " +
        "AND (ORDERS.ORD_SNUM NOT LIKE 'RMA%') " +
        "ORDER BY RefID";
```