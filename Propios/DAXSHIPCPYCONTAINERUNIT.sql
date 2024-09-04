-- Se utiliza para mostrar las unidades de medida en:
-- Control de parqueos y contenedores -> Traslado preparado externo
CREATE VIEW [dbo].[DAXSHIPCPYCONTAINERUNIT] AS
SELECT T1.SHIPCPYCONTAINERUNITID, T1.DESCRIPTION
FROM SHIPCPYCONTAINERUNIT T1
