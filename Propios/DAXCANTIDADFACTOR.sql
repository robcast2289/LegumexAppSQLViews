IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXCANTIDADFACTOR') DROP VIEW DAXCANTIDADFACTOR
GO
CREATE VIEW [dbo].[DAXCANTIDADFACTOR] AS
SELECT DISTINCT ISNULL(FRU.SYMBOL, N'') AS FROM_UNIT,
                ISNULL(TOU.SYMBOL, N'') AS TO_UNIT,
                ISNULL(UOM.FACTOR, 0) AS FACTOR,
                IT.ITEMID,
                ISNULL(UOM.DENOMINATOR, 0) AS DENOMINATOR,
                --P.DATAAREAID,
				IT.DATAAREAID,
                INV.UNITID AS INV_UNITID
FROM dbo.UNITOFMEASURECONVERSION AS UOM
INNER JOIN dbo.UNITOFMEASURE AS FRU ON FRU.PARTITION = UOM.PARTITION
    AND FRU.RECID = UOM.FROMUNITOFMEASURE
INNER JOIN dbo.UNITOFMEASURE AS TOU ON TOU.PARTITION = UOM.PARTITION
    AND TOU.RECID = UOM.TOUNITOFMEASURE
INNER JOIN dbo.INVENTTABLE AS IT ON UOM.PRODUCT = IT.PRODUCT
INNER JOIN dbo.INVENTTABLEMODULE AS INV ON INV.PARTITION = IT.PARTITION
    AND INV.DATAAREAID = IT.DATAAREAID
    AND INV.ITEMID = IT.ITEMID
GO