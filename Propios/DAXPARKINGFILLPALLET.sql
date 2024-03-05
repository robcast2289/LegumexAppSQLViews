IF OBJECT_ID('dbo.DAXPARKINGFILLPALLET', 'V') IS NOT NULL
DROP VIEW dbo.DAXPARKINGFILLPALLET GO
CREATE VIEW [dbo].[DAXPARKINGFILLPALLET] AS
SELECT CASE
           WHEN t2.QtyConvert01ByUnit != 0 THEN ROUND((T1.INVENTQTYAVAILPHYSICAL/t2.QtyConvert01ByUnit)*100, 2)
           ELSE 0
       END AS PERCENTFILLPALLET,
       t1.*
FROM daxinventonhandcontainer t1
INNER JOIN
  (SELECT AVG(QtyConvert01ByUnit) QtyConvert01ByUnit,
          shipcpycontainerid,
          wmslocationid
   FROM daxinventonhandcontainer
   GROUP BY shipcpycontainerid,
            wmslocationid) t2 ON t1.shipcpycontainerid = t2.shipcpycontainerid
AND t1.wmslocationid = t2.wmslocationid