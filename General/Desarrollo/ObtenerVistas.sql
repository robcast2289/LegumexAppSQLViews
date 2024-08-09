 -- Listar las vistas creadas fuera de Dynamics
 SELECT name,
 (
	 SELECT definition
	FROM sys.sql_modules  
	WHERE object_id = OBJECT_ID(name)
 ) as query
 FROM sysobjects 
 WHERE xtype = 'V'
 and name not in (
 SELECT NAME FROM SQLDICTIONARY
 WHERE FIELDID = 0
 AND FLAGS = 1
  AND NAME NOT IN ('DAXINVENTSUMINVENTDIMVIEW','DAXINVSUMSITELOCATIONVIEW')
 )
 order by name




 -- Listar con comando de Eliminar y crear de las vistas creadas cuera de Dynamics
 SELECT name,
 CONCAT('IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = ''',name,''') DROP VIEW ',name,CHAR(10),'GO',char(10),
 (
	 SELECT definition
	FROM sys.sql_modules  
	WHERE object_id = OBJECT_ID(name)
 ),
 CHAR(10)  --Quitar
 ,'GO') as query
 FROM sysobjects 
 WHERE xtype = 'V'
 AND name NOT IN (
 SELECT NAME FROM SQLDICTIONARY
 WHERE FIELDID = 0
 AND FLAGS = 1
  AND NAME NOT IN ('DAXINVENTSUMINVENTDIMVIEW','DAXINVSUMSITELOCATIONVIEW')
 )
 AND name NOT IN ('ReportingVirtualDataAreaView','ReportingVirtualDataAreaView1','ReportingVirtualDataAreaView2')
 order by name




-- Ver la definicion de una vista en especifico
SELECT name,
 CONCAT('IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS  WHERE TABLE_NAME = ''',name,''') DROP VIEW ',name,CHAR(10),' GO ',char(10),
 (
	 SELECT definition
	FROM sys.sql_modules  
	WHERE object_id = OBJECT_ID(name)
 ),CHAR(10)) as query
 FROM sysobjects 
 WHERE xtype = 'V'
 AND name = 'DAXINVENT_TRANSFERJOURNAL'