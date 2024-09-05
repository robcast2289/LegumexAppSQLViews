-- Se utiliza para mostrar las unidades de medida en:
-- Control de parqueos y contenedores -> Cerrar contenedor
CREATE VIEW [dbo].[DAXSHIPCPYCONTAINERLOCALPORT] AS
SELECT T1.SHIPCPYCONTAINERLOCALPORTID, T1.NAME 
FROM SHIPCPYCONTAINERLOCALPORT T1