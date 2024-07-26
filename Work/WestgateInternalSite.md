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
- Initial thought is to filter based on number of items in Items_on_Quotes view...yet there can be orders that are not builds with more than 4 items (initail guess at minimum amount of items)
- Might be best to filter based on `Department` types, only filter for ones related to a PC build. 
- If we can set some unique ID on the `ORD_SNUM` field, then we can easily filter by that and get only orders that are to be builds. 


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