-- Se utiliza para listar los almacenes en: 
-- Ordenes de Transferencia
-- Diario de Transferir
ALTER VIEW [dbo].[DAXCONSULTA] AS
SELECT DISTINCT INVENTLOCATIONID,
                DATAAREAID,
                INVENTSITEID,
                WMSLOCATIONIDDEFAULTRECEIPT
FROM dbo.INVENTLOCATION
WHERE (INVENTLOCATIONTYPE = 0)
  AND (SHIPCPYCONTAINERCLOSED = 0)