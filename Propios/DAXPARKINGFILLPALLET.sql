IF OBJECT_ID('dbo.DAXPARKINGFILLPALLET', 'V') IS NOT NULL
DROP VIEW dbo.DAXPARKINGFILLPALLET GO
CREATE VIEW [dbo].[DAXPARKINGFILLPALLET] AS
SELECT isnull(
                (SELECT (T1.INVENTQTYAVAILPHYSICAL/AVG(tmp.QtyConvert01ByUnit))*100 AS QtyConvert01ByUnit
                 FROM daxinventonhandcontainer tmp
                 WHERE tmp.shipcpycontainerrecid = t1.shipcpycontainerrecid
                   AND tmp.wmslocationid = t1.wmslocationid
                 GROUP BY tmp.shipcpycontainerrecid, tmp.wmslocationid
                 HAVING AVG(tmp.QtyConvert01ByUnit) > 0),0) AS PERCENTFILLPALLET,
       t1.*
FROM daxinventonhandcontainer t1