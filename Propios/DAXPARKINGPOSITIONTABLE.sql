IF OBJECT_ID('dbo.DAXPARKINGPOSITIONTABLE', 'V') IS NOT NULL
DROP VIEW dbo.DAXPARKINGPOSITIONTABLE GO
CREATE VIEW [dbo].[DAXPARKINGPOSITIONTABLE] AS
SELECT pst.PARKINGSPACEID,
       pst.NAME AS PARKINGSPACENAME,
       pset.PARKINGSECTORID,
       pset.NAME AS PARKINGSECTORNAME,
       ppt.PARKINGPOSITIONID,
       ppt.NAME AS PARKINGPOSITIONNAME,
	   ppt.PARKINGINACTIVE,
       scvt.INTRASTATTRANSPORT,
       scct.SHIPCPYCONTAINERID,
	   scct.RECID AS SHIPCPYCONTAINERRECID,
       scct.SHIPCPYEXPECTEDEXITDATE,
       ppt.PARKINGSPACETRANSTYPE,
       CASE
           WHEN ppt.PARKINGSPACETRANSTYPE = 0 THEN 'Libre'
           WHEN ppt.PARKINGSPACETRANSTYPE = 1 THEN 'Creación'
           WHEN ppt.PARKINGSPACETRANSTYPE = 2 THEN 'Reservado'
           WHEN ppt.PARKINGSPACETRANSTYPE = 3 THEN 'Ingresado'
           WHEN ppt.PARKINGSPACETRANSTYPE = 4 THEN 'Abierto'
           WHEN ppt.PARKINGSPACETRANSTYPE = 5 THEN 'Traslado de entrada interno'
           WHEN ppt.PARKINGSPACETRANSTYPE = 6 THEN 'Traslado de salida interno'
           WHEN ppt.PARKINGSPACETRANSTYPE = 7 THEN 'Cerrado'
           WHEN ppt.PARKINGSPACETRANSTYPE = 8 THEN 'Salida final'
           WHEN ppt.PARKINGSPACETRANSTYPE = 9 THEN 'Traslado preparado entrada externa'
           WHEN ppt.PARKINGSPACETRANSTYPE = 10 THEN 'Traslado preparado salida externa'
           WHEN ppt.PARKINGSPACETRANSTYPE = 11 THEN 'Salida externa'
           WHEN ppt.PARKINGSPACETRANSTYPE = 12 THEN 'Traslado de entrada externa'
           WHEN ppt.PARKINGSPACETRANSTYPE = 13 THEN 'Traslado de salida externa'
           WHEN ppt.PARKINGSPACETRANSTYPE = 14 THEN 'Reservado cancelado'
       END AS PARKINGSPACETRANSTYPE_DESC,
       scvt.SHIPPINGCPYTYPE,
       CASE
           WHEN scvt.SHIPPINGCPYTYPE = 0 THEN 'Comercial'
           WHEN scvt.SHIPPINGCPYTYPE = 1 THEN 'Propia'
       END AS SHIPPINGCPYTYPE_DESC,
       scct.MAXWEIGHT
FROM dbo.PARKINGPOSITIONTABLE AS ppt
INNER JOIN dbo.PARKINGSECTORTABLE AS pset ON ppt.PARKINGSECTORTABLERECID = pset.RECID
AND pset.PARKINGINACTIVE = 0
INNER JOIN dbo.PARKINGSPACETABLE AS pst ON pset.PARKINGSPACETABLERECID = pst.RECID
LEFT OUTER JOIN dbo.SHIPCPYCONTAINERTABLE AS scct ON ppt.SHIPCPYCONTAINERTABLERECID = scct.RECID
LEFT OUTER JOIN dbo.SHIPPINGCPYVENDTABLE AS scvt ON scct.SHIPPINGCPYVENDTABLERECID = scvt.RECID