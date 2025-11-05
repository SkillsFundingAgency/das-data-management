CREATE TABLE [AsData_PL].[PAS_UserSettings]
(
	 Id bigint not null
     ,UserId bigint not null 
     ,UserRef varchar(255) not null
     ,ReceiveNotifications bit not null
     ,AsDm_UpdatedDateTime	datetime2 default getdate()	NULL
     ,CONSTRAINT PK_Pas_UserSettings_Id PRIMARY KEY CLUSTERED (Id)

)
GO

