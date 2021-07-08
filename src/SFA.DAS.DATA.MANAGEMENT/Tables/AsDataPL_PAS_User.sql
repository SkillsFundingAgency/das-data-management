﻿CREATE TABLE [AsData_PL].[PAS_User]
(
	  Id bigint not null
     ,UserRef varchar(255) not null
     ,DisplayName varchar(255) not null
     ,Ukprn bigint not null
     ,IsDeleted bit not null
     ,UserType smallint not null
     ,LastLogin datetime2 null
     ,CONSTRAINT PK_Pas_User_Id PRIMARY KEY CLUSTERED (Id)
)
GO

