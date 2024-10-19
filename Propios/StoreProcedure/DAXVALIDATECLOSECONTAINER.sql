CREATE PROCEDURE [dbo].[DAXVALIDATECLOSECONTAINER] 
    @ShipCpyContainerId NVARCHAR(30)
AS
BEGIN
	-- WHSZONE
	DECLARE @DontValidateSalesTable INT;
    DECLARE @AdvanceLoading INT;
	DECLARE @ZoneId	VARCHAR(20);
	DECLARE @ShipCpyContainerTableRecId BIGINT;
	DECLARE @ShipCpyContainterSalesState INT;
	-- SALESTABLE
	DECLARE @SalesTablesRecId BIGINT;
	DECLARE @SalesStatus INT;
	DECLARE @SalesId VARCHAR(50);

	 -- Obtener los valores necesarios de SHIPCPYCONTAINERTABLE
    SELECT @ShipCpyContainerTableRecId = T1.RECID,
			@ZoneId = T1.ZONEID
    FROM SHIPCPYCONTAINERTABLE T1
    WHERE T1.SHIPCPYCONTAINERID = @ShipCpyContainerId
	AND T1.SHIPCPYCONTAINERSTATE NOT IN (5);

    -- Obtiene los valores necesarios de WHSZONE
    SELECT @DontValidateSalesTable = T1.DONTVALIDATESALESTABLE,
            @AdvanceLoading = T1.ADVANCELOADING,
			@ShipCpyContainterSalesState = T1.SHIPCPYCONTAINTERSALESSTATE
	FROM WHSZONE T1
	WHERE T1.ZONEID = @ZoneId;


    -- Valida existencias en almacén
	DECLARE @InventLocationRecId BIGINT;
	SELECT TOP 1 @InventLocationRecId = T1.RECID
	FROM INVENTLOCATION T1
	WHERE T1.INVENTLOCATIONID = @ShipCpyContainerId;

	IF @InventLocationRecId IS NULL
	BEGIN
		SELECT 'Revise proceso error crítico no existe almacén ' + @ShipCpyContainerId AS ErrorMessage;
		RETURN;
	END
	ELSE
	BEGIN
		DECLARE @physicalInventCalculated NUMERIC(32,16);
		DECLARE @ItemId VARCHAR(20);
		SELECT @physicalInventCalculated = SUM(T1.POSTEDQTY) + SUM(T1.RECEIVED) - SUM(T1.DEDUCTED) + SUM(T1.REGISTERED) - SUM(T1.PICKED),
				@ItemId = T1.ITEMID
		FROM INVENTSUM T1
		INNER JOIN INVENTDIM T2 ON T1.INVENTDIMID = T2.INVENTDIMID
		AND T2.INVENTLOCATIONID = @ShipCpyContainerId
		WHERE T1.CLOSED = 0
		GROUP BY T1.ITEMID, T2.INVENTSITEID, T2.INVENTLOCATIONID;

		IF @physicalInventCalculated != 0.00
		BEGIN
			SELECT 'El contenedor ' + @ShipCpyContainerId + ', en el código ' + @ItemId + ' tiene disponible ' + STR(@physicalInventCalculated,8,2) AS ErrorMessage;
			RETURN;
		END
	END

	-- Valida Carga anticipada
    IF @AdvanceLoading = 1
    BEGIN
        SELECT @SalesTablesRecId = T1.RECID
		FROM SALESTABLE T1
		WHERE T1.SHIPCPYCONTAINERTABLERECID = @ShipCpyContainerTableRecId;

		IF @SalesTablesRecId IS NULL
		BEGIN
			SELECT 'Antes de continuar debe asociar el contenedor ' + @ShipCpyContainerId + ' a una orden de venta, es tipo ' + @ZoneId AS ErrorMessage;
            RETURN;
		END
    END

    -- Valida Orden de Venta
	IF @DontValidateSalesTable = 1
	BEGIN
		
		SELECT @SalesTablesRecId = T1.RECID
		FROM SALESTABLE T1
		WHERE T1.SHIPCPYCONTAINERTABLERECID = @ShipCpyContainerTableRecId
		AND T1.SALESSTATUS != 4; -- Deferente de cancelado

		IF @SalesTablesRecId IS NULL
		BEGIN
			SELECT 'Revise proceso error no existe orden de venta relacionada para ' + @ShipCpyContainerId AS ErrorMessage;
            RETURN;
		END

		DECLARE SalesTableCursor CURSOR FOR
		SELECT T1.SALESID, T1.SALESSTATUS FROM SALESTABLE T1
		WHERE T1.SHIPCPYCONTAINERTABLERECID = @ShipCpyContainerTableRecId
		AND T1.SALESSTATUS != 4; -- Diferente de Cancelado

		OPEN SalesTableCursor;

		FETCH NEXT FROM SalesTableCursor INTO @SalesId, @SalesStatus;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @ShipCpyContainterSalesState = 1 -- Confirmada
			BEGIN
				IF @SalesStatus != 3 -- Facturado
				BEGIN
					DECLARE @CustConfirmJourRecId BIGINT;
                    SELECT TOP 1 @CustConfirmJourRecId = T1.RecId
                    FROM CustConfirmJour T1
                    WHERE T1.SalesId = @SalesId;

                    IF @CustConfirmJourRecId IS NULL
                    BEGIN
                        SELECT 'Revise proceso orden de venta ' + @SalesId + ' para ' + @ShipCpyContainerId + ', estado ' + CASE WHEN @SalesStatus = 0 THEN '' WHEN @SalesStatus = 1 THEN 'Orden abierta' END + ', no tiene confirmación' AS ErrorMessage;
                        CLOSE SalesTableCursor;
                        DEALLOCATE SalesTableCursor;
                        RETURN;
                    END
				END
			END
			ELSE IF @ShipCpyContainterSalesState = 2 -- Remisionada
            BEGIN
                IF @SalesStatus != 2 AND @SalesStatus != 3  -- Entregado y Facturado
                BEGIN
                    SELECT 'Revise proceso orden de venta ' + @SalesId + ' para ' + @ShipCpyContainerId + ', estado ' + CASE WHEN @SalesStatus = 0 THEN '' WHEN @SalesStatus = 1 THEN 'Orden abierta' END AS ErrorMessage;
                    CLOSE SalesTableCursor;
                    DEALLOCATE SalesTableCursor;
                    RETURN;
                END
            END
            ELSE
            BEGIN
                SELECT 'Revise configuración en ' + @ZoneId + ', debe configurar estado de orden de venta' AS ErrorMessage;
                CLOSE SalesTableCursor;
                DEALLOCATE SalesTableCursor;
                RETURN;
            END

            FETCH NEXT FROM SalesTableCursor INTO @SalesId, @SalesStatus;
		END

		CLOSE SalesTableCursor;
        DEALLOCATE SalesTableCursor;
	END

	SELECT NULL AS ErrorMessage;
	RETURN;
END