IF OBJECT_ID('dbo.DAXWMSLOCATIONBYCONTAINER', 'V') IS NOT NULL
DROP VIEW dbo.DAXWMSLOCATIONBYCONTAINER GO
CREATE VIEW [dbo].[DAXWMSLOCATIONBYCONTAINER] AS
SELECT T1.PARKINGSPACEID,
       T1.PARKINGSECTORID,
       T1.PARKINGPOSITIONID,
       T1.SHIPCPYCONTAINERID,
       T4.WMSLOCATIONID
FROM dbo.DAXPARKINGPOSITIONTABLE AS T1
INNER JOIN dbo.SHIPCPYCONTAINERTABLE AS T2 ON T1.SHIPCPYCONTAINERRECID = T2.RECID
INNER JOIN dbo.INVENTLOCATION AS T3 ON T2.SHIPCPYCONTAINERID = T3.INVENTLOCATIONID
INNER JOIN dbo.WMSLOCATION AS T4 ON T3.INVENTLOCATIONID = T4.INVENTLOCATIONID
AND T2.LOCPROFILEID = T4.LOCPROFILEID
  AND T1.PARKINGSPACETRANSTYPE <> 10
WHERE (T1.SHIPCPYCONTAINERRECID IS NOT NULL)
GROUP BY T1.PARKINGSPACEID,
         T1.PARKINGSPACENAME,
         T1.PARKINGSECTORID,
         T1.PARKINGSECTORNAME,
         T1.PARKINGPOSITIONID,
         T1.PARKINGPOSITIONNAME,
         T1.SHIPCPYCONTAINERID,
         T1.SHIPCPYCONTAINERRECID,
         T3.NAME,
         T4.WMSLOCATIONID