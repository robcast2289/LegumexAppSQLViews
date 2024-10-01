-- Se utiliza para mostrar los documentos de pilotos en:
-- Control de parqueos y contenedores
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXSHIPPINGCPYVENDTABLEPILOTDOCUMENT') DROP VIEW DAXALLITEMIDS
GO
CREATE VIEW [dbo].[DAXSHIPPINGCPYVENDTABLEPILOTDOCUMENT] AS 
SELECT DISTINCT
	T1.SHIPPINGCPYVENDTABLEPILOTID,
	T2.DOCUMENTTYPEIDENTIFICATIONID,
	T2.SHIPCPYPILOTDOCUMENTNUM 
FROM SHIPPINGCPYVENDTABLEPILOT T1
INNER JOIN SHIPPINGCPYVENDTABLEPILOTDOCUMENT T2 ON T1.RECID = T2.SHIPPINGCPYVENDTABLEPILOTRECID
WHERE T2.SHIPCPYINACTIVE = 0
GO