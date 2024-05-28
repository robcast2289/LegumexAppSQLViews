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
 )