CREATE TABLE [dbo].[ReferenceData]
(
	Id INT IDENTITY(1,1) NOT NULL
   ,Category varchar(100)
   ,FieldName varchar(100)
   ,FieldValue varchar(20)
   ,FieldDesc Varchar(255)
   ,CONSTRAINT PK_ReferenceData_ID PRIMARY KEY (ID)
)
