IF OBJECT_ID('dbo.DAXPARKINGSUMMARYBYSECTOR', 'V') IS NOT NULL
DROP VIEW dbo.DAXPARKINGSUMMARYBYSECTOR GO
CREATE VIEW [dbo].[DAXPARKINGSUMMARYBYSECTOR] AS
SELECT PARKINGSPACEID,
       PARKINGSPACENAME,
       PARKINGSECTORID,
       PARKINGSECTORNAME,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (T1.PARKINGSECTORID = PARKINGSECTORID)
     AND (PARKINGSPACETRANSTYPE = 0)) AS AVAILPOSITION,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (T1.PARKINGSECTORID = PARKINGSECTORID)
     AND (PARKINGSPACETRANSTYPE <> 0)) AS TAKENPOSITION,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (T1.PARKINGSECTORID = PARKINGSECTORID)
     ) AS TOTALPOSITION,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (T1.PARKINGSECTORID = PARKINGSECTORID)
     AND (SHIPPINGCPYTYPE = 0)) AS COMMERCIALCONTAINERS,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (T1.PARKINGSECTORID = PARKINGSECTORID)
     AND (SHIPPINGCPYTYPE = 1)) AS OWNCONTAINERS

FROM dbo.DAXPARKINGPOSITIONTABLE AS T1
GROUP BY PARKINGSPACEID,
         PARKINGSPACENAME,
         PARKINGSECTORID,
         PARKINGSECTORNAME