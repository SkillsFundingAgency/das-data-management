CREATE TABLE [dbo].[AsDataPL_Va_LegalEntity]
(
	LegalEntityId INT PRIMARY KEY
   ,LegalEntityName Varchar(256)
   ,SourceLegalEntityId INT
   ,SourceDb varchar(100)
)
