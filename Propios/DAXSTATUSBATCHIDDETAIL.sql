IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXSTATUSBATCHIDDETAIL') DROP VIEW DAXSTATUSBATCHIDDETAIL
GO
CREATE VIEW [dbo].[DAXSTATUSBATCHIDDETAIL] AS
SELECT 
	T1.PARKINGSPACEID,
	T1.PARKINGSPACENAME,
	T1.INTRASTATTRANSPORT,
	T1.SHIPPINGCPYTYPE,
	T1.INVENTLOCATIONID,
	T1.WMSLOCATIONID,
	T1.ITEMID,
	T1.NAME,
	T1.PDSCWUNITID,
	T1.UNITID,
	T1.INVENTBATCHID,
	T1.INVENTQTYPHYSICALONHAND,
	T1.PdsCWAvailPhysical,
	T1.EXPDATE, 
	DATEDIFF(DAY, GETDATE(), T1.EXPDATE) EXPDAYS,
	CASE
		WHEN DATEDIFF(DAY, GETDATE(), T1.EXPDATE) < 0 THEN 'Lotes Vencidos'
		WHEN DATEDIFF(DAY, GETDATE(), T1.EXPDATE) = 0 THEN 'Lotes Por Vencer Hoy'
		WHEN DATEDIFF(DAY, GETDATE(), T1.EXPDATE) > 0 THEN 'Lotes No Vencidos'
	END STATUSBATCHID
FROM DAXINVENTONHANDCONTAINER T1
INNER JOIN DAXPARKINGPOSITIONTABLE TBL2 ON T1.PARKINGPOSITIONID = TBL2.PARKINGPOSITIONID
INNER JOIN INVENTLOCATION TBL3 ON T1.SHIPCPYCONTAINERID = TBL3.INVENTLOCATIONID
WHERE T1.PARKINGSPACEID IS NOT NULL
AND T1.EXPDATE IS NOT NULL
AND T1.INVENTQTYAVAILPHYSICAL > 0
AND TBL2.PARKINGSPACETRANSTYPE IN (3,4,7,9,10)
AND TBL3.SHIPCPYCONTAINERCLOSED = 0
GO