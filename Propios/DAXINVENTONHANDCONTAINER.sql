IF OBJECT_ID('dbo.DAXINVENTONHANDCONTAINER', 'V') IS NOT NULL
DROP VIEW dbo.DAXINVENTONHANDCONTAINER GO
CREATE VIEW [dbo].[DAXINVENTONHANDCONTAINER] AS
SELECT IT.ITEMID,
       IT.ITEMGROUPID,
       IT.NAME,
       IT.PDSCWUNITID,
       IT.UNITID,
       IT.PDSBESTBEFORE,
       IT.PDSSHELFADVICE,
       IT.PDSSHELFLIFE,
       ISQ.INVENTBATCHID,
       ISQ.INVENTLOCATIONID,
       ISQ.INVENTSITEID,
       ISQ.WMSLOCATIONID,
       IB.PRODDATE,
       DATEDIFF(DAY, IB.PRODDATE, GETDATE()) AS PRODDATEDAYSTOTODAY,
       IB.EXPDATE,
       IB.PDSBESTBEFOREDATE,
       IB.PDSSHELFADVICEDATE,
       IB.PDSDISPOSITIONCODE,
       ISQ.AvailPhysical,
       ISQ.PdsCWAvailPhysical,
       ISQ.POSTEDVALUE,
       CASE
           WHEN ISQ.AvailPhysical > 0 THEN ISQ.POSTEDVALUE / ISQ.AvailPhysical
           WHEN ISQ.AvailPhysical = 0 THEN 0
       END AS COSTPRICE,
       CASE
           WHEN ISQ.PdsCWAvailPhysical > 0 THEN ISQ.POSTEDVALUE / ISQ.PdsCWAvailPhysical
           WHEN ISQ.PdsCWAvailPhysical = 0 THEN 0
       END AS PDSCWCOSTPRICE,
       ISQ.physicalInventCalculated AS INVENTQTYPHYSICALONHAND,
       ISQ.AvailPhysical AS INVENTQTYAVAILPHYSICAL,
       ISQ.RESERVPHYSICAL AS INVENTQTYRESERVPHYSICAL,
       ISQ.PdsCWPhysicalInvent,
       ISNULL(UOM.FACTOR, 0) AS QTYCONVERT01BYUNIT,
       CASE
           WHEN UOM.FACTOR = 0 THEN 0
           WHEN UOM.FACTOR = NULL THEN 0
           ELSE ISQ.AvailPhysical / UOM.FACTOR
       END AS QTYCONVERT01BYUNITPERCENT,
       UOM.FACTOR - ISQ.AvailPhysical AS QTYCONVERT01LEFT,
       SCCT.SHIPCPYCONTAINERID,
       PPT.PARKINGPOSITIONID,
       PST.PARKINGSECTORID,
       PST.NAME AS PARKINGSECTORNAME,
       PSPT.PARKINGSPACEID,
       SCCT.SHIPCPYEXPECTEDEXITDATE,
       SCCT.MAXWEIGHT,
       SCVT.SHIPPINGCPYTYPE,
       IT.DATAAREAID
FROM
  (SELECT INS.ITEMID,
          IND.INVENTSITEID,
          IND.INVENTLOCATIONID,
          IND.INVENTBATCHID,
          IND.WMSLOCATIONID,
          SUM(INS.POSTEDQTY) AS POSTEDQTY,
          SUM(INS.POSTEDVALUE) AS POSTEDVALUE,
          SUM(INS.PHYSICALVALUE) AS PHYSICALVALUE,
          SUM(INS.DEDUCTED) AS DEDUCTED,
          SUM(INS.REGISTERED) AS REGISTERED,
          SUM(INS.RECEIVED) AS RECEIVED,
          SUM(INS.PICKED) AS PICKED,
          SUM(INS.RESERVPHYSICAL) AS RESERVPHYSICAL,
          SUM(INS.RESERVORDERED) AS ReservOrdered,
          SUM(INS.ONORDER) AS OnOrder,
          SUM(INS.ORDERED) AS Ordered,
          SUM(INS.ARRIVED) AS Arrived,
          SUM(INS.QUOTATIONRECEIPT) AS QuotationReceipt,
          SUM(INS.QUOTATIONISSUE) AS QuotationIssue,
          SUM(INS.PHYSICALINVENT) AS PhysicalInvent,
          SUM(INS.AVAILPHYSICAL) AS AvailPhysical,
          SUM(INS.AVAILORDERED) AS AvailOrdered,
          SUM(INS.PDSCWPOSTEDQTY) AS PdsCWPostedQty,
          SUM(INS.PDSCWDEDUCTED) AS PdsCWDeducted,
          SUM(INS.PDSCWREGISTERED) AS PdsCWRegistered,
          SUM(INS.PDSCWRECEIVED) AS PdsCWReceived,
          SUM(INS.PDSCWPICKED) AS PdsCWPicked,
          SUM(INS.PDSCWRESERVPHYSICAL) AS PdsCWReservPhysical,
          SUM(INS.PDSCWRESERVORDERED) AS PdsCWReservOrdered,
          SUM(INS.PDSCWONORDER) AS PdsCWOnOrder,
          SUM(INS.PDSCWORDERED) AS PdsCWOrdered,
          SUM(INS.PDSCWARRIVED) AS PdsCWArrived,
          SUM(INS.PDSCWQUOTATIONRECEIPT) AS PdsCWQuotationReceipt,
          SUM(INS.PDSCWQUOTATIONISSUE) AS PdsCWQuotationIssue,
          SUM(INS.PDSCWPHYSICALINVENT) AS PdsCWPhysicalInvent,
          SUM(INS.PDSCWAVAILPHYSICAL) AS PdsCWAvailPhysical,
          SUM(INS.PDSCWAVAILORDERED) AS PdsCWAvailOrdered,
          SUM(INS.POSTEDQTY) + SUM(INS.RECEIVED) - SUM(INS.DEDUCTED) + SUM(INS.REGISTERED) - SUM(INS.PICKED) AS physicalInventCalculated,
          INS.DATAAREAID
   FROM dbo.INVENTSUM AS INS
   INNER JOIN dbo.INVENTDIM AS IND ON INS.INVENTDIMID = IND.INVENTDIMID
   AND INS.DATAAREAID = IND.DATAAREAID
   WHERE (INS.CLOSED = 0)
     AND (IND.INVENTSITEID IN
            (SELECT SITEID
             FROM dbo.INVENTSITE AS ivs
             WHERE (SHIPCPYISCONTAINER = 1)))
   GROUP BY INS.ITEMID,
            IND.INVENTSITEID,
            IND.INVENTLOCATIONID,
            IND.INVENTBATCHID,
            IND.WMSLOCATIONID,
            INS.DATAAREAID
   HAVING (SUM(INS.POSTEDQTY) + SUM(INS.RECEIVED) - SUM(INS.DEDUCTED) + SUM(INS.REGISTERED) - SUM(INS.PICKED) > 0)) AS ISQ
INNER JOIN
  (SELECT T1.ITEMID,
          T1.PRODUCT,
          T1.PDSBESTBEFORE,
          T1.PDSSHELFADVICE,
          T1.PDSSHELFLIFE,
          T1.DATAAREAID,
          T2.ITEMGROUPID,
          T3.NAME,
          T4.PDSCWUNITID,
          T5.UNITID
   FROM dbo.INVENTTABLE AS T1
   INNER JOIN dbo.ECORESPRODUCTTRANSLATION AS T3 ON T1.PRODUCT = T3.PRODUCT
   AND T1.PARTITION = T3.PARTITION
   LEFT OUTER JOIN dbo.INVENTITEMGROUPITEM AS T2 ON T1.ITEMID = T2.ITEMID
   AND T1.DATAAREAID = T2.ITEMDATAAREAID
   LEFT OUTER JOIN dbo.PDSCATCHWEIGHTITEM AS T4 ON T1.ITEMID = T4.ITEMID
   AND T1.DATAAREAID = T4.DATAAREAID
   LEFT OUTER JOIN dbo.INVENTTABLEMODULE AS T5 ON T1.ITEMID = T5.ITEMID
   AND T1.DATAAREAID = T5.DATAAREAID
   AND T5.MODULETYPE = 0
   WHERE (T3.LANGUAGEID = N'es-mx')) AS IT ON ISQ.ITEMID = IT.ITEMID
AND ISQ.DATAAREAID = IT.DATAAREAID
LEFT OUTER JOIN dbo.INVENTBATCH AS IB ON ISQ.ITEMID = IB.ITEMID
AND ISQ.INVENTBATCHID = IB.INVENTBATCHID
AND ISQ.DATAAREAID = IB.DATAAREAID
LEFT OUTER JOIN dbo.SHIPCPYCONTAINERTABLE AS SCCT ON ISQ.INVENTLOCATIONID = SCCT.SHIPCPYCONTAINERID
LEFT OUTER JOIN dbo.SHIPPINGCPYVENDTABLE AS SCVT ON SCCT.SHIPPINGCPYVENDTABLERECID = SCVT.RECID
LEFT OUTER JOIN
  (SELECT NAME,
          PARKINGINACTIVE,
          PARKINGPOSITIONID,
          PARKINGPOSITIONINT,
          PARKINGSECTORTABLERECID,
          PARKINGSPACETRANSTYPE,
          PARKINGSPACETRANSTYPE_LAST,
          SHIPCPYCONTAINERTABLERECID,
          MODIFIEDDATETIME,
          MODIFIEDBY,
          MODIFIEDTRANSACTIONID,
          CREATEDDATETIME,
          CREATEDBY,
          CREATEDTRANSACTIONID,
          DATAAREAID,
          RECVERSION,
          PARTITION,
          RECID
   FROM dbo.PARKINGPOSITIONTABLE
   WHERE (RECID IN
            (SELECT MIN(RECID) AS Expr1
             FROM dbo.PARKINGPOSITIONTABLE
             GROUP BY SHIPCPYCONTAINERTABLERECID))) AS PPT ON SCCT.RECID = PPT.SHIPCPYCONTAINERTABLERECID
LEFT OUTER JOIN dbo.PARKINGSECTORTABLE AS PST ON PPT.PARKINGSECTORTABLERECID = PST.RECID
LEFT OUTER JOIN dbo.PARKINGSPACETABLE AS PSPT ON PST.PARKINGSPACETABLERECID = PSPT.RECID
LEFT OUTER JOIN
  (SELECT T1.FROMUNITOFMEASURE,
          T1.TOUNITOFMEASURE,
          T1.PRODUCT,
          T1.FACTOR,
          T1.NUMERATOR,
          T1.DENOMINATOR,
          T1.INNEROFFSET,
          T1.OUTEROFFSET,
          T1.ROUNDING,
          T1.MODIFIEDDATETIME,
          T1.RECVERSION,
          T1.PARTITION,
          T1.RECID
   FROM dbo.UNITOFMEASURECONVERSION AS T1
   INNER JOIN dbo.UNITOFMEASURE AS T2 ON T1.FROMUNITOFMEASURE = T2.RECID
   AND T2.SYMBOL = 'PALL'
   INNER JOIN dbo.UNITOFMEASURE AS T3 ON T1.TOUNITOFMEASURE = T3.RECID
   AND T3.SYMBOL = 'LBS') AS UOM ON IT.PRODUCT = UOM.PRODUCT