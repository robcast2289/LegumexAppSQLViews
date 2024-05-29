-- Se utiliza para mostrar los nombres de diarios tipo Transferir en:
-- Diarios de Transferencia
CREATE VIEW [dbo].[DAXJOURNAL_TRANSFERJOURNAL] AS
SELECT JOURNALNAMEID,
       DESCRIPTION
FROM INVENTJOURNALNAME
WHERE JOURNALTRANSTYPE = 3