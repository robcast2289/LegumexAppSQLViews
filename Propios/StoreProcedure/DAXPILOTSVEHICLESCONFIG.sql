CCREATE PROCEDURE [dbo].[DAXPILOTSVEHICLESCONFIG] 
    @SHIPCPYCONTAINERID NVARCHAR(30),
    @parkingSpaceTransTypeActual INT,
	@external_movement INT = 0
AS
BEGIN
    DECLARE @SHIPPINGCPYVENDTABLERECID BIGINT;
	DECLARE @RECID BIGINT;
	DECLARE @PILOTRECID_ENTRYEXT BIGINT;
	DECLARE @PILOTRECID_ENTRY BIGINT;
	DECLARE @PILOTRECID_EXIT BIGINT;
	DECLARE @PILOTRECID_EXITEXT BIGINT;
	DECLARE @PILOTRECID BIGINT;
	DECLARE @PILOTRECID2 BIGINT;
	DECLARE @LOCALPORTRECID BIGINT;
    DECLARE @PARKINGSPACETRANSTYPE INT;
    DECLARE @SHIPPINGCPYTYPE INT;
	DECLARE @LOCALPORTID VARCHAR(10);
	DECLARE @CANAUTOMATICBATCH INT;
	DECLARE @CUSTOMMARKIDTMP VARCHAR(20);
	DECLARE @CUSTOMMARKID VARCHAR(20) = '';
	DECLARE @PARKINGSPACEID_TO VARCHAR(10) = '';
	DECLARE @PARKINGSPACEID_TO_NAME VARCHAR(25) = '';

    -- Obtener los valores necesarios de SHIPCPYCONTAINERTABLE
    SELECT @SHIPPINGCPYVENDTABLERECID = T1.SHIPPINGCPYVENDTABLERECID,
           @SHIPCPYCONTAINERID = T1.SHIPCPYCONTAINERID,
		   @RECID = T1.RECID,
		   @PILOTRECID_ENTRYEXT = T1.SHIPCPYCONTAINERPILOTRECID_ENTRYEXT,
		   @PILOTRECID_ENTRY = T1.SHIPCPYCONTAINERPILOTRECID_ENTRY,
		   @PILOTRECID_EXIT = T1.SHIPCPYCONTAINERPILOTRECID_EXIT,
		   @PILOTRECID_EXITEXT = T1.SHIPCPYCONTAINERPILOTRECID_EXITEXT,
		   @LOCALPORTRECID = T1.SHIPCPYCONTAINERLOCALPORTRECID
    FROM SHIPCPYCONTAINERTABLE T1
    WHERE T1.SHIPCPYCONTAINERID = @SHIPCPYCONTAINERID
	AND T1.SHIPCPYCONTAINERSTATE NOT IN (5);

	-- Obtiene el puerto local configurado
	SELECT @LOCALPORTID = T1.SHIPCPYCONTAINERLOCALPORTID
	FROM SHIPCPYCONTAINERLOCALPORT T1
	WHERE T1.RECID = @LOCALPORTRECID

	-- Verifica si se puede realizar Automatico
	SELECT @CANAUTOMATICBATCH = 
	CASE 
		WHEN T1.ISEXTERNAL = 0 THEN 1
		WHEN T1.ISEXTERNAL = 1 THEN 0
	END
	FROM PARKINGSPACETABLE T1
	INNER JOIN PARKINGSECTORTABLE T2 ON T1.RECID = T2.PARKINGSPACETABLERECID
	INNER JOIN PARKINGPOSITIONTABLE T3 ON T2.RECID = T3.PARKINGSECTORTABLERECID
	WHERE T3.SHIPCPYCONTAINERTABLERECID = @RECID;

	-- buscar la ultima transaccion de contenedor
	SELECT TOP 1 @PARKINGSPACETRANSTYPE = T1.PARKINGSPACETRANSTYPE,
	@CUSTOMMARKIDTMP = T1.SHIPCPYCUSTOMMARKID1
    FROM SHIPCPYCONTAINERTRANS T1
    WHERE T1.SHIPCPYCONTAINERTABLERECID = @RECID
    ORDER BY T1.CREATEDDATETIME DESC, T1.RECID DESC;

    -- Determinar el RECID de SHIPPINGCPYVENDTABLE basado en shipCpyContainerState
    IF @parkingSpaceTransTypeActual IN (2, 9) -- Si la posicion es, [Reservado -> Ingresado] [Traslado preparado entrada externa -> Ingresado]
    BEGIN

		SELECT @PILOTRECID = @PILOTRECID_ENTRY;

        IF @PARKINGSPACETRANSTYPE = 13 -- Si es, Traslado de salida externo
        BEGIN
			SELECT @CUSTOMMARKID = @CUSTOMMARKIDTMP;

            SELECT @SHIPPINGCPYTYPE = SHIPPINGCPYTYPE
            FROM SHIPPINGCPYVENDTABLE
            WHERE RECID = @SHIPPINGCPYVENDTABLERECID;

            IF @SHIPPINGCPYTYPE = 0 -- Si la naviera es comercial
            BEGIN
                SELECT @PILOTRECID = @PILOTRECID_ENTRYEXT;
            END
        END
    END
    ELSE IF @parkingSpaceTransTypeActual IN (4, 7, 10) -- Si la posicion es, [abierto -> Cerrado] [abierto -> Traslado Preparado externo] [Cerrado -> Salida Final] [Traslado preparado salida externa -> Salida Externa]
    BEGIN
        SELECT @PILOTRECID = @PILOTRECID_EXIT;

		SELECT @SHIPPINGCPYTYPE = SHIPPINGCPYTYPE
            FROM SHIPPINGCPYVENDTABLE
            WHERE RECID = @SHIPPINGCPYVENDTABLERECID;
        IF @parkingSpaceTransTypeActual = 10 -- Si es Salida Externa
        BEGIN
			SELECT @CUSTOMMARKID = @CUSTOMMARKIDTMP;

			IF @SHIPPINGCPYTYPE = 0 -- Si la naviera es comercial
			BEGIN
				SELECT @PILOTRECID = @PILOTRECID_EXITEXT;
			END

			SELECT @PARKINGSPACEID_TO = T1.PARKINGSPACEID,
			@PARKINGSPACEID_TO_NAME = T1.NAME
			FROM PARKINGSPACETABLE T1
			INNER JOIN PARKINGSECTORTABLE T2 ON T1.RECID = T2.PARKINGSPACETABLERECID
			INNER JOIN PARKINGPOSITIONTABLE T3 ON T2.RECID = T3.PARKINGSECTORTABLERECID
			WHERE T3.SHIPCPYCONTAINERTABLERECID = @RECID
			AND T3.PARKINGSPACETRANSTYPE <> 10
        END
		IF @parkingSpaceTransTypeActual = 4 AND @external_movement = 1 -- Si es Traslado preparado interno
		BEGIN
			IF @SHIPPINGCPYTYPE = 0  -- Si la naviera es comercial, no devuelve nada
			BEGIN
				SELECT @PILOTRECID = 0, @PILOTRECID2 = 0
			END
			ELSE
			BEGIN
				SELECT @PILOTRECID = @PILOTRECID_EXIT, @PILOTRECID2 = @PILOTRECID_ENTRY;
			END
		END
    END

    -- Devolver los resultados
	IF @external_movement = 1
	BEGIN
		SELECT 
			t1.SHIPCPYCONTAINERPILOTTYPE,
			T3.SHIPPINGCPYVENDTABLEPILOTID,
			T3.NAME,
			T4.DOCUMENTTYPEIDENTIFICATIONID,
			T4.SHIPCPYPILOTDOCUMENTNUM,
			T5.SHIPPINGCPYVENDTABLEVEHICLESID,
			T6.INTRASTATTRANSPORT,
			@CUSTOMMARKID SHIPCPYCUSTOMMARKID,
			ISNULL(@LOCALPORTID,'') SHIPCPYCONTAINERLOCALPORTID,
			0 CANAUTOMATICBATCH,
			@PARKINGSPACEID_TO PARKINGSPACEID_TO,
			@PARKINGSPACEID_TO_NAME PARKINGSPACEID_TO_NAME
		FROM SHIPCPYCONTAINERPILOT T1
		INNER JOIN SHIPPINGCPYVENDTABLEPILOT T3 ON T1.SHIPPINGCPYVENDTABLEPILOTRECID = T3.RECID
		INNER JOIN SHIPPINGCPYVENDTABLEPILOTDOCUMENT T4 ON T1.SHIPPINGCPYVENDTABLEPILOTDOCUMENTRECID = T4.RECID
		INNER JOIN SHIPPINGCPYVENDTABLEVEHICLES T5 ON T1.SHIPPINGCPYVENDTABLEVEHICLESRECID = T5.RECID
		INNER JOIN SHIPPINGCPYVENDTABLE T6 ON T3.SHIPPINGCPYVENDTABLERECID = T6.RECID
		WHERE T1.RECID IN (@PILOTRECID,@PILOTRECID2)
		UNION
		SELECT 0,'','','','','','','',@LOCALPORTID,@CANAUTOMATICBATCH,@PARKINGSPACEID_TO,@PARKINGSPACEID_TO_NAME
	END
	ELSE
	BEGIN
		SELECT 
			t1.SHIPCPYCONTAINERPILOTTYPE,
			T3.SHIPPINGCPYVENDTABLEPILOTID,
			T3.NAME,
			T4.DOCUMENTTYPEIDENTIFICATIONID,
			T4.SHIPCPYPILOTDOCUMENTNUM,
			T5.SHIPPINGCPYVENDTABLEVEHICLESID,
			T6.INTRASTATTRANSPORT,
			@CUSTOMMARKID SHIPCPYCUSTOMMARKID,
			ISNULL(@LOCALPORTID,'') SHIPCPYCONTAINERLOCALPORTID,
			0 CANAUTOMATICBATCH,
			@PARKINGSPACEID_TO PARKINGSPACEID_TO,
			@PARKINGSPACEID_TO_NAME PARKINGSPACEID_TO_NAME
		FROM SHIPCPYCONTAINERPILOT T1
		INNER JOIN SHIPPINGCPYVENDTABLEPILOT T3 ON T1.SHIPPINGCPYVENDTABLEPILOTRECID = T3.RECID
		INNER JOIN SHIPPINGCPYVENDTABLEPILOTDOCUMENT T4 ON T1.SHIPPINGCPYVENDTABLEPILOTDOCUMENTRECID = T4.RECID
		INNER JOIN SHIPPINGCPYVENDTABLEVEHICLES T5 ON T1.SHIPPINGCPYVENDTABLEVEHICLESRECID = T5.RECID
		INNER JOIN SHIPPINGCPYVENDTABLE T6 ON T3.SHIPPINGCPYVENDTABLERECID = T6.RECID
		WHERE T1.RECID IN (@PILOTRECID,@PILOTRECID2)
	END
END