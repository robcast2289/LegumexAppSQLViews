CREATE PROCEDURE DAXVEHICLES 
	@SHIPCPYCONTAINERID nvarchar(30),
	@shipCpyContainerState int -- Proximo paso
AS
	DECLARE @ResultTable TABLE (
	  SHIPPINGCPYVENDTABLEVEHICLESID nvarchar(40),
	  INTRASTATTRANSPORT nvarchar(10)
	)

	declare @SHIPCPYCONTAINERIDRow nvarchar(30);
	declare @SHIPCPYCONTAINERSTATERow int;
	declare @SHIPPINGCPYVENDTABLERECIDRow bigint;
	declare @RECIDRow bigint;

	declare @PARKINGSPACETRANSTYPE int;
	declare @SHIPPINGCPYTYPE int;
	declare @SHIPPINGCPYVENDTABLERECID bigint;

	SELECT @SHIPCPYCONTAINERIDRow=SHIPCPYCONTAINERID, 
			@SHIPCPYCONTAINERSTATERow=SHIPCPYCONTAINERSTATE,
			@SHIPPINGCPYVENDTABLERECIDRow=SHIPPINGCPYVENDTABLERECID,
			@RECIDRow=RECID 
		FROM SHIPCPYCONTAINERTABLE WHERE SHIPCPYCONTAINERID = @SHIPCPYCONTAINERID;


	if @shipCpyContainerState = 2 -- Si es, Ingresado
	begin
		select top 1 @PARKINGSPACETRANSTYPE=T1.PARKINGSPACETRANSTYPE from SHIPCPYCONTAINERTRANS T1
		where T1.SHIPCPYCONTAINERTABLERECID = @RECIDRow
		order by T1.CREATEDDATETIME desc, T1.RECID desc;

		if @PARKINGSPACETRANSTYPE = 13 -- Si es, Traslado de salida externo
		begin
			select @SHIPPINGCPYTYPE=SHIPPINGCPYTYPE, @SHIPPINGCPYVENDTABLERECID=RECID FROM SHIPPINGCPYVENDTABLE WHERE RECID=@SHIPPINGCPYVENDTABLERECIDRow;
			IF @SHIPPINGCPYTYPE = 0 -- Si la naviera es comercial
			begin
				select @SHIPPINGCPYVENDTABLERECID=RECID FROM SHIPPINGCPYVENDTABLE WHERE SHIPPINGCPYTYPE=1;
			end
		end
		else
		begin
			select @SHIPPINGCPYVENDTABLERECID=RECID FROM SHIPPINGCPYVENDTABLE WHERE RECID=@SHIPPINGCPYVENDTABLERECIDRow;
		end
	end
	else if @shipCpyContainerState in (4,5) -- Si es, Cerrado o Salida Final
	begin
		select @SHIPPINGCPYVENDTABLERECID=RECID FROM SHIPPINGCPYVENDTABLE WHERE RECID=@SHIPPINGCPYVENDTABLERECIDRow;
	end
	else if @shipCpyContainerState = 6 -- Si es, Salida Externa
	begin
		select @SHIPPINGCPYTYPE=SHIPPINGCPYTYPE, @SHIPPINGCPYVENDTABLERECID=RECID FROM SHIPPINGCPYVENDTABLE WHERE RECID=@SHIPPINGCPYVENDTABLERECIDRow;
		IF @SHIPPINGCPYTYPE = 0 -- Si la naviera es comercial
		begin
			select @SHIPPINGCPYVENDTABLERECID=RECID FROM SHIPPINGCPYVENDTABLE WHERE SHIPPINGCPYTYPE=1;
		end
	end

	insert into @ResultTable (SHIPPINGCPYVENDTABLEVEHICLESID,INTRASTATTRANSPORT)
	SELECT 
		T1.SHIPPINGCPYVENDTABLEVEHICLESID,
		T2.INTRASTATTRANSPORT
	FROM SHIPPINGCPYVENDTABLEVEHICLES T1
	INNER JOIN SHIPPINGCPYVENDTABLE T2 ON T1.SHIPPINGCPYVENDTABLERECID = T2.RECID and T2.RECID= @SHIPPINGCPYVENDTABLERECID
	where T1.SHIPCPYINACTIVE = 0;

	select * from @ResultTable
GO;
