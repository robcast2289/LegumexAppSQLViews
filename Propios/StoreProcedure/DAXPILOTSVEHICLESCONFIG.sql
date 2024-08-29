CREATE PROCEDURE DAXPILOTSVEHICLESCONFIG 
    @SHIPCPYCONTAINERID NVARCHAR(30),
    @shipCpyContainerState INT
AS
BEGIN
    DECLARE @SHIPPINGCPYVENDTABLERECID BIGINT;
	DECLARE @RECID BIGINT;
	DECLARE @PILOTRECID_ENTRYEXT BIGINT;
	DECLARE @PILOTRECID_ENTRY BIGINT;
	DECLARE @PILOTRECID_EXIT BIGINT;
	DECLARE @PILOTRECID_EXITEXT BIGINT;
	DECLARE @PILOTRECID BIGINT;
    DECLARE @PARKINGSPACETRANSTYPE INT;
    DECLARE @SHIPPINGCPYTYPE INT;

    -- Obtener los valores necesarios de SHIPCPYCONTAINERTABLE
    SELECT @SHIPPINGCPYVENDTABLERECID = T1.SHIPPINGCPYVENDTABLERECID,
           @SHIPCPYCONTAINERID = T1.SHIPCPYCONTAINERID,
		   @RECID = T1.RECID,
		   @PILOTRECID_ENTRYEXT = T1.SHIPCPYCONTAINERPILOTRECID_ENTRYEXT,
		   @PILOTRECID_ENTRY = T1.SHIPCPYCONTAINERPILOTRECID_ENTRY,
		   @PILOTRECID_EXIT = T1.SHIPCPYCONTAINERPILOTRECID_EXIT,
		   @PILOTRECID_EXITEXT = T1.SHIPCPYCONTAINERPILOTRECID_EXITEXT
    FROM SHIPCPYCONTAINERTABLE T1
    WHERE T1.SHIPCPYCONTAINERID = @SHIPCPYCONTAINERID;

    -- Determinar el RECID de SHIPPINGCPYVENDTABLE basado en shipCpyContainerState
    IF @shipCpyContainerState = 2 -- Si es, Ingresado
    BEGIN
        SELECT TOP 1 @PARKINGSPACETRANSTYPE = T1.PARKINGSPACETRANSTYPE
        FROM SHIPCPYCONTAINERTRANS T1
        WHERE T1.SHIPCPYCONTAINERTABLERECID = @RECID
        ORDER BY T1.CREATEDDATETIME DESC, T1.RECID DESC;

        IF @PARKINGSPACETRANSTYPE = 13 -- Si es, Traslado de salida externo
        BEGIN
            SELECT @SHIPPINGCPYTYPE = SHIPPINGCPYTYPE
            FROM SHIPPINGCPYVENDTABLE
            WHERE RECID = @SHIPPINGCPYVENDTABLERECID;

            IF @SHIPPINGCPYTYPE = 0 -- Si la naviera es comercial
            BEGIN
                SELECT @PILOTRECID = @PILOTRECID_ENTRYEXT;
            END
			ELSE
			BEGIN
				SELECT @PILOTRECID = @PILOTRECID_ENTRY;
			END
        END
		ELSE
		BEGIN
			SELECT @PILOTRECID = @PILOTRECID_ENTRY;
		END
    END
    ELSE IF @shipCpyContainerState IN (4, 5, 6) -- Si es, Cerrado, Salida Final o Salida Externa
    BEGIN
        SELECT @PILOTRECID = @PILOTRECID_EXIT;

        IF @shipCpyContainerState = 6 AND @SHIPPINGCPYTYPE = 0 -- Si es Salida Externa y la naviera es comercial
        BEGIN
            SELECT @PILOTRECID = @PILOTRECID_EXITEXT;
        END
    END

    -- Devolver los resultados
    SELECT 
		T3.SHIPPINGCPYVENDTABLEPILOTID,
		T3.NAME,
		T4.DOCUMENTTYPEIDENTIFICATIONID,
		T4.SHIPCPYPILOTDOCUMENTNUM,
		T5.SHIPPINGCPYVENDTABLEVEHICLESID
	FROM SHIPCPYCONTAINERPILOT T1
	INNER JOIN SHIPPINGCPYVENDTABLEPILOT T3 ON T1.SHIPPINGCPYVENDTABLEPILOTRECID = T3.RECID
	INNER JOIN SHIPPINGCPYVENDTABLEPILOTDOCUMENT T4 ON T1.SHIPPINGCPYVENDTABLEPILOTDOCUMENTRECID = T4.RECID
	INNER JOIN SHIPPINGCPYVENDTABLEVEHICLES T5 ON T1.SHIPPINGCPYVENDTABLEVEHICLESRECID = T5.RECID
	WHERE T1.RECID = @PILOTRECID
END