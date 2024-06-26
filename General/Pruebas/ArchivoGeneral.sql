IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXALLITEMIDS') DROP VIEW DAXALLITEMIDS
 GO 
CREATE VIEW [dbo].[DAXALLITEMIDS] AS 
SELECT DISTINCT DATAAREAID, ITEMID, INVENTLOCATIONID FROM DAXINVENTSUMINVENTDIMVIEW WHERE DATAAREAID = 'lx' 


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXCONSULTA') DROP VIEW DAXCONSULTA
 GO 
CREATE VIEW [dbo].[DAXCONSULTA] AS
SELECT DISTINCT INVENTLOCATIONID, DATAAREAID, INVENTSITEID, WMSLOCATIONIDDEFAULTRECEIPT
FROM            dbo.INVENTLOCATION
WHERE        (INVENTLOCATIONTYPE = 0) AND (SHIPCPYCONTAINERCLOSED = 0)

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXCONTAINERS') DROP VIEW DAXCONTAINERS
 GO 

CREATE VIEW [dbo].[DAXCONTAINERS]
AS
SELECT 
A.PARKINGSPACEID AS 'PARKINGSPACEID',
B.DATAAREAID AS 'DATAAREAID',
B.PARKINGSECTORID AS 'PARKINGSECTORID',
C.PARKINGPOSITIONID AS 'PARKINGPOSITIONID',
C.NAME AS 'NAME',
D.SHIPCPYCONTAINERID AS 'SHIPCPYCONTAINERID',
D.SHIPCPYCUSTOMMARKID AS 'SHIPCPYCUSTOMMARKID',
D.SHIPCPYCONTAINERSTATE AS 'SHIPCPYCONTAINERSTATE',
D.SHIPCPYEXPECTEDDATE AS 'SHIPCPYEXPECTEDDATE',
E.INTRASTATTRANSPORT AS 'INTRASTATTRANSPORT'
FROM Parkingspacetable A 
INNER JOIN PARKINGSECTORTABLE B ON A.DATAAREAID = B.DATAAREAID
INNER JOIN PARKINGPOSITIONTABLE C ON B.RECID = C.PARKINGSECTORTABLERECID 
INNER JOIN ShipCpyContainerTable D ON D.DATAAREAID = A.DATAAREAID
INNER JOIN SHIPPINGCPYVENDTABLE E ON E.RECID = D.SHIPPINGCPYVENDTABLERECID



IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXCONTENEDORES') DROP VIEW DAXCONTENEDORES
 GO 


CREATE VIEW [dbo].[DAXCONTENEDORES]
AS SELECT 
A.SHIPCPYCONTAINERID AS 'SHIPCPYCONTAINERID',
A.SHIPCPYCONTAINERSTATE AS 'SHIPCPYCONTAINERSTATE',
A.SHIPCPYCUSTOMMARKID AS 'SHIPCPYCUSTOMMARKID',
A.SHIPCPYEXPECTEDDATE AS 'SHIPCPYEXPECTEDDATE',
A.SHIPCPYREALDATETIME AS 'SHIPCPYREALDATETIME',
A.DATAAREAID AS 'DATAAREAID',
B.NAME AS 'NAME',
B.PARKINGPOSITIONID AS 'PARKINGPOSITIONID',
B.PARKINGSPACETRANSTYPE AS 'PARKINGSPACETRANSTYPE',
C.PARKINGSECTORID AS 'PARKINGSECTORID',
D.PARKINGSPACEID AS 'PARKINGSPACEID',
D.NAME AS 'SITIO',
E.INTRASTATTRANSPORT AS 'INTRASTATTRANSPORT'
FROM SHIPCPYCONTAINERTABLE A
JOIN ParkingPositionTable B ON A.RECID = B.SHIPCPYCONTAINERTABLERECID 
JOIN Parkingsectortable C ON B.PARKINGSECTORTABLERECID = C.RECID
JOIN Parkingspacetable D  ON D.RECID = C.PARKINGSPACETABLERECID
JOIN SHIPPINGCPYVENDTABLE E ON E.RECID = A.SHIPPINGCPYVENDTABLERECID



IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXDATAAREAID') DROP VIEW DAXDATAAREAID
 GO 

CREATE VIEW [dbo].[DAXDATAAREAID]
AS SELECT DISTINCT DATAAREAID 
FROM DAXINVENTSUMINVENTDIMVIEW 


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXEMPTYWAREHOUSE') DROP VIEW DAXEMPTYWAREHOUSE
 GO 
CREATE VIEW DAXEMPTYWAREHOUSE
AS SELECT DISTINCT 
T1. USERID,
T1.INVENTLOCATIONID,
T1.DATAAREAID
FROM DAXWAREHOUSEUSER T1
INNER JOIN  DAXINVENTSUMINVENTDIMVIEW T2 ON T1.INVENTLOCATIONID = T2.INVENTLOCATIONID

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXFISICARESERVADAVIEW') DROP VIEW DAXFISICARESERVADAVIEW
 GO 

CREATE VIEW [dbo].[DAXFISICARESERVADAVIEW] AS SELECT SL.SALESID, SL.LINENUM, SL.ITEMID, SL.DATAAREAID, SL.SALESQTY, SL.SALESPRICE, IT.QTY, IT.STATUSISSUE 
FROM SALESLINE SL
INNER JOIN INVENTTRANSORIGIN ITO ON ITO.PARTITION = SL.PARTITION AND ITO.DATAAREAID = SL.DATAAREAID AND ITO.INVENTTRANSID = SL.INVENTTRANSID
INNER JOIN INVENTTRANS IT ON IT.PARTITION = ITO.PARTITION AND IT.DATAAREAID = ITO.DATAAREAID AND IT.INVENTTRANSORIGIN = ITO.RECID
WHERE SL.PARTITION = 5637144576 AND SL.DATAAREAID = 'LX' 
AND STATUSISSUE = 4


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXINVENT_TRANSFERJOURNAL') DROP VIEW DAXINVENT_TRANSFERJOURNAL
 GO 
CREATE VIEW [dbo].[DAXINVENT_TRANSFERJOURNAL] AS
SELECT        T1.ITEMID, T1.NAMEALIAS, T1.DATAAREAID, T1.PARTITION, T1.RECID, T2.DATAAREAID AS DATAAREAID#2, T2.PARTITION AS PARTITION#2, T2.AVAILPHYSICAL, T2.RESERVPHYSICAL, T2.PHYSICALINVENT, 
                         T2.AVAILORDERED, T2.PDSCWAVAILORDERED, T2.PDSCWPHYSICALINVENT, T2.PDSCWAVAILPHYSICAL, T3.DATAAREAID AS DATAAREAID#3, T3.PARTITION AS PARTITION#3, T3.INVENTSITEID, 
                         T3.INVENTLOCATIONID, T3.WMSLOCATIONID, T3.INVENTBATCHID, T3.INVENTSERIALID, T3.CONFIGID, T3.INVENTCOLORID, T3.INVENTSIZEID, T3.INVENTSTYLEID, T3.INVENTSTATUSID, T3.LICENSEPLATEID, 
                         T4.PARTITION AS PARTITION#4, T4.NAME
FROM            dbo.INVENTTABLE AS T1 INNER JOIN
                         dbo.INVENTSUM AS T2 ON T1.ITEMID = T2.ITEMID AND T1.DATAAREAID = T2.DATAAREAID AND T1.PARTITION = T2.PARTITION INNER JOIN
                         dbo.INVENTDIM AS T3 ON T2.INVENTDIMID = T3.INVENTDIMID AND T2.DATAAREAID = T3.DATAAREAID AND T2.PARTITION = T3.PARTITION INNER JOIN
                         dbo.ECORESPRODUCTTRANSLATION AS T4 ON T1.PRODUCT = T4.PRODUCT AND T1.PARTITION = T4.PARTITION
WHERE        (T4.LANGUAGEID = N'es-mx')

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXINVENTONHANDCONTAINER') DROP VIEW DAXINVENTONHANDCONTAINER
 GO 
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
	   SCCT.RECID AS SHIPCPYCONTAINERRECID,
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

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXINVENTSUMINVENTDIMVIEW') DROP VIEW DAXINVENTSUMINVENTDIMVIEW
 GO 
CREATE VIEW "DBO".DAXINVENTSUMINVENTDIMVIEW AS SELECT T1.ITEMID AS ITEMID,T1.NAMEALIAS AS NAMEALIAS,T1.DATAAREAID AS DATAAREAID,T1.PARTITION AS PARTITION,T1.RECID AS RECID,T2.DATAAREAID AS DATAAREAID#2,T2.PARTITION AS PARTITION#2,T2.AVAILPHYSICAL AS AVAILPHYSICAL,T2.RESERVPHYSICAL AS RESERVPHYSICAL,T2.PHYSICALINVENT AS PHYSICALINVENT,T2.AVAILORDERED AS AVAILORDERED,T2.PDSCWAVAILORDERED AS PDSCWAVAILORDERED,T2.PDSCWPHYSICALINVENT AS PDSCWPHYSICALINVENT,T2.PDSCWAVAILPHYSICAL AS PDSCWAVAILPHYSICAL,T3.DATAAREAID AS DATAAREAID#3,T3.PARTITION AS PARTITION#3,T3.INVENTSITEID AS INVENTSITEID,T3.INVENTLOCATIONID AS INVENTLOCATIONID,T3.WMSLOCATIONID AS WMSLOCATIONID,T3.INVENTBATCHID AS INVENTBATCHID,T3.INVENTSERIALID AS INVENTSERIALID,T3.CONFIGID AS CONFIGID,T3.INVENTCOLORID AS INVENTCOLORID,T3.INVENTSIZEID AS INVENTSIZEID,T3.INVENTSTYLEID AS INVENTSTYLEID,T3.INVENTSTATUSID AS INVENTSTATUSID,T3.LICENSEPLATEID AS LICENSEPLATEID,T4.PARTITION AS PARTITION#4,T4.NAME AS NAME FROM INVENTTABLE T1 CROSS JOIN INVENTSUM T2 CROSS JOIN INVENTDIM T3 CROSS JOIN ECORESPRODUCTTRANSLATION T4 WHERE (T1.ITEMID=T2.ITEMID AND (T1.DATAAREAID = T2.DATAAREAID) AND (T1.PARTITION = T2.PARTITION)) AND (T2.INVENTDIMID=T3.INVENTDIMID AND (T2.DATAAREAID = T3.DATAAREAID) AND (T2.PARTITION = T3.PARTITION)) AND ((T4.LANGUAGEID=N'es-mx') AND (T1.PRODUCT=T4.PRODUCT AND (T1.PARTITION = T4.PARTITION)))

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXINVENTSUMINVENTDIMVIEW2') DROP VIEW DAXINVENTSUMINVENTDIMVIEW2
 GO 

CREATE VIEW [dbo].[DAXINVENTSUMINVENTDIMVIEW2] AS 
	SELECT T1.ITEMID AS ITEMID,
	T1.NAMEALIAS AS NAMEALIAS,
	T1.DATAAREAID AS DATAAREAID,
	T1.PARTITION AS PARTITION,
	T1.RECID AS RECID,
	T2.DATAAREAID AS DATAAREAID#2,
	T2.PARTITION AS PARTITION#2,
	T2.AVAILPHYSICAL AS AVAILPHYSICAL,
	T2.RESERVPHYSICAL AS RESERVPHYSICAL,
	T2.PHYSICALINVENT AS PHYSICALINVENT,
	T2.AVAILORDERED AS AVAILORDERED,
	T2.PDSCWAVAILPHYSICAL AS PDSCWAVAILPHYSICAL ,
	T2.PDSCWAVAILORDERED AS PDSCWAVAILORDERED,
	T2.PDSCWPHYSICALINVENT AS PDSCWPHYSICALINVENT,
	T3.DATAAREAID AS DATAAREAID#3,
	T3.PARTITION AS PARTITION#3,
	T3.INVENTSITEID AS INVENTSITEID,
	T3.INVENTLOCATIONID AS INVENTLOCATIONID,
	T3.WMSLOCATIONID AS WMSLOCATIONID,
	T3.INVENTBATCHID AS INVENTBATCHID,
	T3.INVENTSERIALID AS INVENTSERIALID,
	T3.CONFIGID AS CONFIGID,
	T3.INVENTCOLORID AS INVENTCOLORID,
	T3.INVENTSIZEID AS INVENTSIZEID,
	T3.INVENTSTYLEID AS INVENTSTYLEID,
	T3.INVENTSTATUSID AS INVENTSTATUSID,
	T3.LICENSEPLATEID AS LICENSEPLATEID,
	T5.STOPPED AS STOPPED,
	T4.PARTITION AS PARTITION#4,
	T4.NAME AS NAME FROM INVENTTABLE T1 
	CROSS JOIN INVENTSUM T2 
	CROSS JOIN InventItemInventSetup T5
	CROSS JOIN INVENTDIM T3 
	CROSS JOIN ECORESPRODUCTTRANSLATION T4 
	WHERE (T1.ITEMID=T2.ITEMID AND (T1.DATAAREAID = T2.DATAAREAID) AND (T1.PARTITION = T2.PARTITION)) AND (T1.ITEMID = T5.ITEMID) 
	AND (T2.INVENTDIMID=T3.INVENTDIMID AND (T2.DATAAREAID = T3.DATAAREAID) AND (T2.PARTITION = T3.PARTITION)) 
	AND ((T4.LANGUAGEID=N'es-mx') AND (T1.PRODUCT=T4.PRODUCT AND (T1.PARTITION = T4.PARTITION))) AND PDSCWPHYSICALINVENT = 0 
	AND AVAILPHYSICAL >= 1 OR 
	(T1.ITEMID=T2.ITEMID AND (T1.DATAAREAID = T2.DATAAREAID) AND (T1.PARTITION = T2.PARTITION)) 
	AND (T1.ITEMID = T5.ITEMID) AND (T2.INVENTDIMID=T3.INVENTDIMID AND (T2.DATAAREAID = T3.DATAAREAID) AND (T2.PARTITION = T3.PARTITION)) 
	AND ((T4.LANGUAGEID=N'es-mx') AND (T1.PRODUCT=T4.PRODUCT AND (T1.PARTITION = T4.PARTITION))) AND PDSCWPHYSICALINVENT > 0 AND AVAILPHYSICAL >= 1



IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXINVENTTRANSFERTABLE') DROP VIEW DAXINVENTTRANSFERTABLE
 GO 

CREATE VIEW [dbo].[DAXINVENTTRANSFERTABLE]
AS SELECT DISTINCT INVENTLOCATIONIDFROM, INVENTLOCATIONIDTO, TRANSFERSTATUS,FROMADDRESSNAME, TOADDRESSNAME, DATAAREAID
FROM INVENTTRANSFERTABLE


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXINVENTTRANSFERTABLELINE') DROP VIEW DAXINVENTTRANSFERTABLELINE
 GO 
CREATE VIEW [dbo].[DAXINVENTTRANSFERTABLELINE]
AS

SELECT DISTINCT 
                         E.TRANSFERID, E.INVENTLOCATIONIDFROM, E.INVENTLOCATIONIDTO, E.FROMADDRESSNAME, E.TOADDRESSNAME, E.TRANSFERSTATUS, E.DATAAREAID, E.SHIPDATE, E.DateAsInt, D.ITEMID, E.RECVERSION, 
                         D.QTYTRANSFER, D.PDSCWQTYTRANSFER, F.INVENTSITEID AS SITE_FROM, T.INVENTSITEID AS SITE_TO, D.LINENUM, O.INVENTBATCHID, ID_TO.WMSLOCATIONID AS WMSLOCATIONID_TO, 
                         ID_FROM.WMSLOCATIONID AS WMSLOCATIONID_FROM
						 ,(select top 1 DIOT.CREATEDUSERID from dbo.DAXINVENTORDERTRANSFER DIOT
						 	where DIOT.TRANSFERID = E.TRANSFERID and DIOT.ITEMID = D.ITEMID and DIOT.LINENUMBER = D.LINENUM) AS CREATEDUSERID
FROM            dbo.INVENTTRANSFERTABLE AS E INNER JOIN
                         dbo.INVENTTRANSFERLINE AS D ON E.TRANSFERID = D.TRANSFERID AND E.DATAAREAID = D.DATAAREAID INNER JOIN
                         dbo.INVENTLOCATION AS F ON E.INVENTLOCATIONIDFROM = F.INVENTLOCATIONID INNER JOIN
                         dbo.INVENTLOCATION AS T ON E.INVENTLOCATIONIDTO = T.INVENTLOCATIONID INNER JOIN
                         dbo.INVENTDIM AS O ON D.INVENTDIMID = O.INVENTDIMID INNER JOIN
                         dbo.INVENTTRANSORIGIN AS ITO_TO ON D.INVENTTRANSIDRECEIVE = ITO_TO.INVENTTRANSID INNER JOIN
                         dbo.INVENTTRANS AS IT_TO ON ITO_TO.RECID = IT_TO.INVENTTRANSORIGIN INNER JOIN
                         dbo.INVENTDIM AS ID_TO ON IT_TO.INVENTDIMID = ID_TO.INVENTDIMID INNER JOIN
                         dbo.INVENTTRANSORIGIN AS ITO_FROM ON D.INVENTTRANSID = ITO_FROM.INVENTTRANSID INNER JOIN
                         dbo.INVENTTRANS AS IT_FROM ON ITO_FROM.RECID = IT_FROM.INVENTTRANSORIGIN INNER JOIN
                         dbo.INVENTDIM AS ID_FROM ON IT_FROM.INVENTDIMID = ID_FROM.INVENTDIMID



IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXINVSUMSITELOCATIONVIEW') DROP VIEW DAXINVSUMSITELOCATIONVIEW
 GO 
CREATE VIEW "DBO".DAXINVSUMSITELOCATIONVIEW AS SELECT T1.ITEMID AS ITEMID,T1.NAMEALIAS AS NAMEALIAS,T1.DATAAREAID AS DATAAREAID1,T1.DATAAREAID AS DATAAREAID,T1.PARTITION AS PARTITION,1010 AS RECID,SUM(T2.AVAILPHYSICAL) AS AVAILPHYSICAL,SUM(T2.AVAILORDERED) AS AVAILORDERED,SUM(T2.PHYSICALINVENT) AS PHYSICALINVENT,SUM(T2.RESERVPHYSICAL) AS RESERVPHYSICAL,SUM(T2.PDSCWAVAILORDERED) AS PDSCWAVAILORDERED,T2.DATAAREAID AS DATAAREAID#2,T2.PARTITION AS PARTITION#2,T2.PDSCWPHYSICALINVENT AS PDSCWPHYSICALINVENT,T3.DATAAREAID AS DATAAREAID#3,T3.PARTITION AS PARTITION#3,T3.INVENTSITEID AS INVENTSITEID,T3.INVENTLOCATIONID AS INVENTLOCATIONID,T3.WMSLOCATIONID AS WMSLOCATIONID,T4.PARTITION AS PARTITION#4,T4.NAME AS NAME FROM INVENTTABLE T1 CROSS JOIN INVENTSUM T2 CROSS JOIN INVENTDIM T3 CROSS JOIN ECORESPRODUCTTRANSLATION T4 WHERE (T1.ITEMID=T2.ITEMID AND (T1.DATAAREAID = T2.DATAAREAID) AND (T1.PARTITION = T2.PARTITION)) AND (T2.INVENTDIMID=T3.INVENTDIMID AND (T2.DATAAREAID = T3.DATAAREAID) AND (T2.PARTITION = T3.PARTITION)) AND ((T4.LANGUAGEID=N'es-mx') AND (T1.PRODUCT=T4.PRODUCT AND (T1.PARTITION = T4.PARTITION))) GROUP BY T1.ITEMID,T1.NAMEALIAS,T1.DATAAREAID,T1.DATAAREAID,T1.PARTITION,T2.DATAAREAID,T2.PARTITION,T2.PDSCWPHYSICALINVENT,T3.DATAAREAID,T3.PARTITION,T3.INVENTSITEID,T3.INVENTLOCATIONID,T3.WMSLOCATIONID,T4.PARTITION,T4.NAME

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXITEMIDAD') DROP VIEW DAXITEMIDAD
 GO 

CREATE VIEW [dbo].[DAXITEMIDAD]
AS SELECT DISTINCT ITEMID 
FROM DAXINVENTSUMINVENTDIMVIEW 
WHERE  AVAILPHYSICAL > 0 AND DATAAREAID = 'ad' OR PDSCWAVAILORDERED >0 AND DATAAREAID = 'ad' 


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXITEMIDEX') DROP VIEW DAXITEMIDEX
 GO 

CREATE VIEW [dbo].[DAXITEMIDEX]
AS SELECT DISTINCT ITEMID 
FROM DAXINVENTSUMINVENTDIMVIEW 
WHERE  AVAILPHYSICAL > 0 AND DATAAREAID = 'ex' OR PDSCWAVAILORDERED >0 AND DATAAREAID = 'ex' 


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXITEMIDEXL') DROP VIEW DAXITEMIDEXL
 GO 

CREATE VIEW [dbo].[DAXITEMIDEXL]
AS SELECT DISTINCT ITEMID 
FROM DAXINVENTSUMINVENTDIMVIEW 
WHERE  AVAILPHYSICAL > 0 AND DATAAREAID = 'exl' OR PDSCWAVAILORDERED >0 AND DATAAREAID = 'exl' 


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXITEMIDLX') DROP VIEW DAXITEMIDLX
 GO 

CREATE VIEW [dbo].[DAXITEMIDLX]
AS SELECT 
DISTINCT ITEMID FROM DAXINVENTSUMINVENTDIMVIEW where DATAAREAID = 'lx'  AND AVAILPHYSICAL > 0 


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXITEMIDS') DROP VIEW DAXITEMIDS
 GO 

CREATE VIEW [dbo].[DAXITEMIDS]
AS SELECT DISTINCT ITEMID, DATAAREAID
FROM DAXINVENTSUMINVENTDIMVIEW 
WHERE  AVAILPHYSICAL > 0 OR PDSCWAVAILORDERED >0 


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXITEMNAMES') DROP VIEW DAXITEMNAMES
 GO 
CREATE VIEW DAXITEMNAMES 
AS SELECT 
T1.ITEMID,
T2.NAME
FROM INVENTTABLE T1
INNER JOIN ECORESPRODUCTTRANSLATION T2 ON T1.PRODUCT = T2.PRODUCT

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXITEMSJOURNAL') DROP VIEW DAXITEMSJOURNAL
 GO 
CREATE VIEW DAXITEMSJOURNAL AS 
SELECT DISTINCT 
ITEMID, NAME, DATAAREAID, INVENTLOCATIONID
FROM DAXINVENTSUMINVENTDIMVIEW
WHERE AVAILPHYSICAL > 0


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXITEMSNOTBLOCK') DROP VIEW DAXITEMSNOTBLOCK
 GO 
CREATE VIEW [dbo].[DAXITEMSNOTBLOCK]
AS
/* 
	Modificacion:	RCASTRO - 05/01/2024
					 - Se agrego filtro InventDimId, para que tome la configuracion predeterminada del inventario
					 - También se elimino la tabla InventSum de la consulta ya que no importa si ha tenido o no disponible
*/
SELECT DISTINCT 
	T3.ITEMID, 
	T2.NAME,
	T1.DATAAREAID, 
	T1.STOPPED
FROM            
	dbo.INVENTITEMINVENTSETUP AS T1 
	INNER JOIN dbo.INVENTTABLE AS T3 ON T1.ITEMID = T3.ITEMID 
	INNER JOIN dbo.ECORESPRODUCTTRANSLATION AS T2 ON T2.PRODUCT = T3.PRODUCT 
	INNER JOIN dbo.INVENTDIM AS T4 ON T1.INVENTDIMID = T4.INVENTDIMID
WHERE        
	(T1.STOPPED = 0) 
	AND (T1.INVENTDIMID = 'AllBlank')
	AND (T2.LANGUAGEID = N'es-mx')


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXJOURNAL_TRANSFERJOURNAL') DROP VIEW DAXJOURNAL_TRANSFERJOURNAL
 GO 
CREATE VIEW [dbo].[DAXJOURNAL_TRANSFERJOURNAL] AS
SELECT JOURNALNAMEID,DESCRIPTION,DATAAREAID
FROM INVENTJOURNALNAME
WHERE JOURNALTRANSTYPE = 3
AND JOURNALTYPE = 2

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXNAMEAD') DROP VIEW DAXNAMEAD
 GO 

CREATE VIEW [dbo].[DAXNAMEAD]
AS SELECT DISTINCT NAME
FROM DAXINVENTSUMINVENTDIMVIEW WHERE AVAILPHYSICAL > 0 AND DATAAREAID ='ad'



IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXNAMEEX') DROP VIEW DAXNAMEEX
 GO 

CREATE VIEW [dbo].[DAXNAMEEX]
AS SELECT DISTINCT NAME
FROM DAXINVENTSUMINVENTDIMVIEW WHERE AVAILPHYSICAL > 0 AND DATAAREAID ='ex'



IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXNAMEEXL') DROP VIEW DAXNAMEEXL
 GO 

CREATE VIEW [dbo].[DAXNAMEEXL]
AS SELECT DISTINCT NAME
FROM DAXINVENTSUMINVENTDIMVIEW WHERE AVAILPHYSICAL > 0 AND DATAAREAID ='exl'



IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXNAMELX') DROP VIEW DAXNAMELX
 GO 

CREATE VIEW [dbo].[DAXNAMELX]
AS SELECT DISTINCT NAME
FROM DAXINVENTSUMINVENTDIMVIEW WHERE AVAILPHYSICAL > 0 AND DATAAREAID ='lx'



IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXPCCANTIDADFACTOR') DROP VIEW DAXPCCANTIDADFACTOR
 GO 

CREATE VIEW [dbo].[DAXPCCANTIDADFACTOR]
AS    SELECT DISTINCT ISNULL(FRU.SYMBOL,'') AS FROM_UNIT, ISNULL(TOU.SYMBOL,'') AS TO_UNIT, ISNULL(UOM.FACTOR,0) AS FACTOR, IT.ITEMID AS 'ITEMID' , ISNULL(UOM.DENOMINATOR,0) AS DENOMINATOR, P.DATAAREAID AS 'DATAAREAID', INV.UNITID AS 'INV_UNITID'
	FROM UNITOFMEASURECONVERSION UOM 
	INNER JOIN UNITOFMEASURE FRU ON FRU.PARTITION = UOM.PARTITION AND FRU.RECID = UOM.FROMUNITOFMEASURE
	INNER JOIN UNITOFMEASURE TOU ON TOU.PARTITION = UOM.PARTITION AND TOU.RECID = UOM.TOUNITOFMEASURE
	INNER JOIN PdsCatchWeightItem P ON P.PDSCWUNITID = FRU.SYMBOL
	INNER JOIN INVENTTABLE IT ON P.ITEMID = IT.ITEMID
	INNER JOIN INVENTTABLEMODULE INV ON INV.PARTITION = IT.PARTITION AND INV.DATAAREAID = IT.DATAAREAID AND INV.ITEMID = IT.ITEMID
	


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXSALESORDERVIEW') DROP VIEW DAXSALESORDERVIEW
 GO 


CREATE view [dbo].[DAXSALESORDERVIEW] as SELECT ST.SALESNAME ,SL.SALESID, SL.LINENUM, SL.ITEMID, SL.DATAAREAID, SL.SALESQTY, SL.SALESPRICE,SL.QTYORDERED, SL.PDSCWQTY as 'PDSCWQTYSALE', SL.SALESUNIT , IT.QTY,IT.PDSCWQTY as 'PDSCWQTYRES' , AL.INVENTLOCATIONID,AL.INVENTBATCHID ,AL.WMSLOCATIONID, SL.NAME, SL.LINEAMOUNT
FROM SALESLINE SL
INNER JOIN INVENTTRANSORIGIN ITO ON ITO.PARTITION = SL.PARTITION AND ITO.DATAAREAID = SL.DATAAREAID AND ITO.INVENTTRANSID = SL.INVENTTRANSID
INNER JOIN INVENTTRANS IT ON IT.PARTITION = ITO.PARTITION AND IT.DATAAREAID = ITO.DATAAREAID AND IT.INVENTTRANSORIGIN = ITO.RECID
INNER JOIN INVENTDIM AL ON IT.INVENTDIMID = AL.INVENTDIMID
INNER JOIN SALESTABLE ST ON SL.SALESID = ST.SALESID
/*INNER JOIN INVENTSUM T3 ON AL.INVENTDIMID = T3.INVENTDIMID*/
WHERE SL.PARTITION = 5637144576  
AND IT.STATUSISSUE = 4 



IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXTRASLADOINTERNOPARKINGPOSITIONID') DROP VIEW DAXTRASLADOINTERNOPARKINGPOSITIONID
 GO 

CREATE view [dbo].[DAXTRASLADOINTERNOPARKINGPOSITIONID]
as select 
DAXCONTENEDORES.SHIPCPYCONTAINERID AS 'SHIPCPYCONTAINERID', 
PARKINGSPACETABLE.PARKINGSPACEID AS 'PARKINGSPACEID',
PARKINGSECTORTABLE.PARKINGSECTORID AS 'PARKINGSECTORID',
ParkingPositionTable.PARKINGPOSITIONID AS 'PARKINGPOSITIONID', 
PARKINGSECTORTABLE.NAME AS 'NAME', 
CONCAT(PARKINGSECTORTABLE.PARKINGSECTORID ,  '-',PARKINGSECTORTABLE.NAME) AS 'SECTNAME',
ParkingPositionTable.NAME AS 'NAMEPOSITION'
FROM PARKINGPOSITIONTABLE
LEFT JOIN DAXCONTENEDORES
ON ParkingPositionTable.PARKINGPOSITIONID = DAXCONTENEDORES.PARKINGPOSITIONID
LEFT JOIN PARKINGSECTORTABLE
ON PARKINGPOSITIONTABLE.PARKINGSECTORTABLERECID = PARKINGSECTORTABLE.RECID
LEFT JOIN PARKINGSPACETABLE
ON PARKINGSECTORTABLE.PARKINGSPACETABLERECID = PARKINGSPACETABLE.RECID



IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'DAXWAREHOUSEUSER') DROP VIEW DAXWAREHOUSEUSER
 GO 
CREATE VIEW DAXWAREHOUSEUSER
AS SELECT 
T1. USERID,
T1.INVENTLOCATIONID,
T1.DATAAREAID,
T2.SHIPCPYCONTAINERCLOSED
FROM WHSWORKUSERWAREHOUSE T1
INNER JOIN INVENTLOCATION T2 ON T1.INVENTLOCATIONID = T2.INVENTLOCATIONID
WHERE T2.SHIPCPYCONTAINERCLOSED = 0 

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'FISCALYEAR') DROP VIEW FISCALYEAR
 GO 
CREATE VIEW [dbo].[FISCALYEAR]
AS
SELECT DISTINCT
T1.RECID, 
T1.NAME, 
T1.STARTDATE, 
T1.ENDDATE, 
T1.STARTD, 
T1.ENDD, 
T2.STATUS,
T3.NAME AS DATAAREAID
FROM            
	dbo.FISCALCALENDARPERIOD AS T1 
	INNER JOIN dbo.LEDGERFISCALCALENDARPERIOD AS T2 ON T1.RECID = T2.FISCALCALENDARPERIOD
	INNER JOIN dbo.LEDGER AS T3 ON T2.LEDGER = T3.RECID
WHERE        
	(T1.NAME <> 'Período 0')


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = 'OCFILTROPORLINEA') DROP VIEW OCFILTROPORLINEA
 GO 
CREATE VIEW OCFILTROPORLINEA
AS SELECT 
T1. DATAAREAID,
T1.PURCHSTATUS,
T1.PURCHID,
T1.DOCUMENTSTATE,
T1.PURCHNAME,
T3.INVENTLOCATIONID
FROM PURCHTABLE T1
INNER JOIN PURCHLINE T2 ON T1.PURCHID = T2.PURCHID
INNER JOIN INVENTDIM T3 ON T2.INVENTDIMID = T3.INVENTDIMID
WHERE T1.PURCHSTATUS = 1 and T3.INVENTLOCATIONID <> '' AND T1.DOCUMENTSTATE = 40 AND T1.PURCHSTATUS = 1
