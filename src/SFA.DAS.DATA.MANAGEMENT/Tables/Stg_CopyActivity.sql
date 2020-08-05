CREATE TABLE [Stg].[CopyActivity]
(
	CAId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY
   ,NID BIGINT default ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT))
   ,RunId BIGINT
   ,Category Varchar(256)
   ,SourceDb varchar(255)
)
