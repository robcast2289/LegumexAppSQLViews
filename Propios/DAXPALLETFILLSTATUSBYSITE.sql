IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXPALLETFILLSTATUSBYSITE') DROP VIEW [DAXPALLETFILLSTATUSBYSITE]
GO
CREATE VIEW [dbo].[DAXPALLETFILLSTATUSBYSITE] AS
SELECT * FROM
(
SELECT tbl1.PARKINGSPACEID, 'Pallets ocupadas en su totalidad' RANGEDESCRIPTION, COUNT(*) TOTALCONTAINERS 
FROM (
SELECT 
	t3.PARKINGSPACEID, 
	t3.SHIPCPYCONTAINERID, 
	t3.WMSLOCATIONID, 
	t1.INVENTQTYAVAILPHYSICAL, 
	t2.MAXWEIGHT, 
	t2.QTYLOCATIONS, 
	(t2.MAXWEIGHT / t2.QTYLOCATIONS) WEIGHTBYLOCATION, 
	(t1.INVENTQTYAVAILPHYSICAL / (t2.MAXWEIGHT / t2.QTYLOCATIONS))*100 AS PERCENTFILL
FROM DAXWMSLOCATIONAVAILPHYSICAL t1
INNER JOIN SHIPCPYCONTAINERTABLE t2 ON t1.inventlocationid = t2.SHIPCPYCONTAINERID 
INNER JOIN DAXWMSLOCATIONBYCONTAINER t3 ON t1.INVENTLOCATIONID = t3.SHIPCPYCONTAINERID AND t1.WMSLOCATIONID = t3.WMSLOCATIONID
) AS tbl1
WHERE tbl1.PERCENTFILL > 99.00
GROUP BY tbl1.PARKINGSPACEID
UNION
SELECT tbl1.PARKINGSPACEID, 'Pallets ocupadas parcialmente' RANGEDESCRIPTION, COUNT(*) TOTALCONTAINERS 
FROM (
SELECT 
	t3.PARKINGSPACEID, 
	t3.SHIPCPYCONTAINERID, 
	t3.WMSLOCATIONID, 
	t1.INVENTQTYAVAILPHYSICAL, 
	t2.MAXWEIGHT, 
	t2.QTYLOCATIONS, 
	(t2.MAXWEIGHT / t2.QTYLOCATIONS) WEIGHTBYLOCATION, 
	(t1.INVENTQTYAVAILPHYSICAL / (t2.MAXWEIGHT / t2.QTYLOCATIONS))*100 AS PERCENTFILL
FROM DAXWMSLOCATIONAVAILPHYSICAL t1
INNER JOIN SHIPCPYCONTAINERTABLE t2 ON t1.inventlocationid = t2.SHIPCPYCONTAINERID 
INNER JOIN DAXWMSLOCATIONBYCONTAINER t3 ON t1.INVENTLOCATIONID = t3.SHIPCPYCONTAINERID AND t1.WMSLOCATIONID = t3.WMSLOCATIONID
) AS tbl1
WHERE tbl1.PERCENTFILL BETWEEN 50.00 AND 98.99
GROUP BY tbl1.PARKINGSPACEID
UNION
SELECT tbl1.PARKINGSPACEID, 'Pallets ocupadas menos de la mitad' RANGEDESCRIPTION, COUNT(*) TOTALCONTAINERS 
FROM (
SELECT 
	t3.PARKINGSPACEID, 
	t3.SHIPCPYCONTAINERID, 
	t3.WMSLOCATIONID, 
	t1.INVENTQTYAVAILPHYSICAL, 
	t2.MAXWEIGHT, 
	t2.QTYLOCATIONS, 
	(t2.MAXWEIGHT / t2.QTYLOCATIONS) WEIGHTBYLOCATION, 
	(t1.INVENTQTYAVAILPHYSICAL / (t2.MAXWEIGHT / t2.QTYLOCATIONS))*100 AS PERCENTFILL
FROM DAXWMSLOCATIONAVAILPHYSICAL t1
INNER JOIN SHIPCPYCONTAINERTABLE t2 ON t1.inventlocationid = t2.SHIPCPYCONTAINERID 
INNER JOIN DAXWMSLOCATIONBYCONTAINER t3 ON t1.INVENTLOCATIONID = t3.SHIPCPYCONTAINERID AND t1.WMSLOCATIONID = t3.WMSLOCATIONID
) AS tbl1
WHERE tbl1.PERCENTFILL BETWEEN 1.00 AND 49.99
GROUP BY tbl1.PARKINGSPACEID
UNION
SELECT tbl1.PARKINGSPACEID, 'Pallets libres' RANGEDESCRIPTION, COUNT(*) TOTALCONTAINERS 
FROM (
SELECT 
	t3.PARKINGSPACEID, 
	t3.SHIPCPYCONTAINERID, 
	t3.WMSLOCATIONID, 
	t1.INVENTQTYAVAILPHYSICAL, 
	t2.MAXWEIGHT, 
	t2.QTYLOCATIONS, 
	(t2.MAXWEIGHT / t2.QTYLOCATIONS) WEIGHTBYLOCATION, 
	(t1.INVENTQTYAVAILPHYSICAL / (t2.MAXWEIGHT / t2.QTYLOCATIONS))*100 AS PERCENTFILL
FROM DAXWMSLOCATIONAVAILPHYSICAL t1
INNER JOIN SHIPCPYCONTAINERTABLE t2 ON t1.inventlocationid = t2.SHIPCPYCONTAINERID 
INNER JOIN DAXWMSLOCATIONBYCONTAINER t3 ON t1.INVENTLOCATIONID = t3.SHIPCPYCONTAINERID AND t1.WMSLOCATIONID = t3.WMSLOCATIONID
) AS tbl1
WHERE tbl1.PERCENTFILL = 0
GROUP BY tbl1.PARKINGSPACEID
) tbl2
GO