CREATE PROCEDURE [dbo].[DAXSHIPCPYCONTAINERTABLEDATES] 
    @SHIPCPYCONTAINERID NVARCHAR(30)
AS
BEGIN
    SELECT 
		T1.SHIPCPYEXPECTEDEXITDATE,
		T1.SHIPCPYALERTDATE,
		T1.SHIPCPYEXPECTEDDATECLOSED
	FROM SHIPCPYCONTAINERTABLE T1
	WHERE T1.SHIPCPYCONTAINERID = @SHIPCPYCONTAINERID
END