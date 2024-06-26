IF OBJECT_ID('dbo.DAXPARKINGSUMMARYBYSITE', 'V') IS NOT NULL
DROP VIEW dbo.DAXPARKINGSUMMARYBYSITE GO
CREATE VIEW [dbo].[DAXPARKINGSUMMARYBYSITE] AS
SELECT PARKINGSPACEID,
       PARKINGSPACENAME,

  (SELECT COUNT(*) AS Expr1
   FROM
     (SELECT PARKINGSECTORID
      FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
      WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
      GROUP BY PARKINGSECTORID) AS t1) AS SECTORS,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (PARKINGSPACETRANSTYPE = 0)) AS AVAILPOSITION,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (PARKINGSPACETRANSTYPE = 2)) AS RESERVEDPOSITION,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (PARKINGSPACETRANSTYPE <> 0)) AS TAKENPOSITION,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (PARKINGINACTIVE = 1)) AS INACTIVEPOSITION,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     ) AS TOTALPOSITION,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (SHIPPINGCPYTYPE = 0)) AS COMMERCIALCONTAINERS,

  (SELECT COUNT(*) AS Expr1
   FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
   WHERE (T1.PARKINGSPACEID = PARKINGSPACEID)
     AND (SHIPPINGCPYTYPE = 1)) AS OWNCONTAINERS,

  (SELECT COUNT(*) AS Expr1
   FROM
     (SELECT SHIPCPYCONTAINERID
      FROM dbo.DAXPARKINGPOSITIONTABLE AS dppt
      WHERE (T1.PARKINGSPACEID = PARKINGSPACEID) AND (SHIPCPYCONTAINERID IS NOT NULL)
      GROUP BY SHIPCPYCONTAINERID) AS t1) AS TOTALCONTAINERS

FROM dbo.DAXPARKINGPOSITIONTABLE AS T1
GROUP BY PARKINGSPACEID,
         PARKINGSPACENAME