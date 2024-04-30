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
		  shipcpycontainerrecid,
          wmslocationid
   FROM daxinventonhandcontainer
   GROUP BY shipcpycontainerid,
			shipcpycontainerrecid,
            wmslocationid) t2 ON t1.shipcpycontainerrecid = t2.shipcpycontainerrecid
AND t1.wmslocationid = t2.wmslocationid