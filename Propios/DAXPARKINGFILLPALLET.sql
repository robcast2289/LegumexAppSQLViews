IF OBJECT_ID('dbo.DAXPARKINGFILLPALLET', 'V') IS NOT NULL
DROP VIEW dbo.DAXPARKINGFILLPALLET GO
CREATE VIEW [dbo].[DAXPARKINGFILLPALLET] AS
SELECT iif(t2.QtyConvert01ByUnitAvg > 0, (t2.INVENTQTYAVAILPHYSICAL / t2.QtyConvert01ByUnitAvg) * 100, 0) AS PERCENTFILLPALLET,
       iif(t2.QtyConvert01ByUnitAvg > 0, (t1.INVENTQTYAVAILPHYSICAL / t2.QtyConvert01ByUnitAvg) * 100, 0) AS PERCENTFILLITEMPALLET,
       t2.ITEMSINPALLET,
       t1.*
FROM daxinventonhandcontainer t1
INNER JOIN
  (SELECT tmp.shipcpycontainerrecid,
          tmp.wmslocationid,
          SUM(tmp.INVENTQTYAVAILPHYSICAL) AS INVENTQTYAVAILPHYSICAL,
          isnull(AVG(tmp.QtyConvert01ByUnit), 0) AS QtyConvert01ByUnitAvg,
          COUNT(*) AS ITEMSINPALLET
   FROM daxinventonhandcontainer tmp
   GROUP BY tmp.shipcpycontainerrecid,
            tmp.wmslocationid) AS t2 ON t1.shipcpycontainerrecid = t2.shipcpycontainerrecid
AND t1.wmslocationid = t2.wmslocationid