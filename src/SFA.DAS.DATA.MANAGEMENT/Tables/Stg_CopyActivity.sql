﻿CREATE TABLE [dbo].[Stg_CopyActivity]
(
	Id BIGINT NOT NULL PRIMARY KEY
   ,NID BIGINT default ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT))
   ,RunId BIGINT
   ,SourceDb varchar(255)
)
