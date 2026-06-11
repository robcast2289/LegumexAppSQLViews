-- View: DAXINVENTBATCHVALID
-- Esta vista selecciona los lotes de inventario que son válidos, es decir, aquellos cuya fecha de expiración (EXPDATE) es mayor o igual a la fecha actual (GETDATE()).
-- Se utiliza para los diarios de transferir entrada
CREATE VIEW [dbo].[DAXINVENTBATCHVALID] AS
SELECT 
	INVENTBATCHID, 
	EXPDATE, 
	ITEMID, 
	DESCRIPTION, 
	PRODDATE, 
	DATAAREAID, 
	PARTITION, 
	RECID 
FROM 
	INVENTBATCH
WHERE 
	EXPDATE >= GETDATE()
GO