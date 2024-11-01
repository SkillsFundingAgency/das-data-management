CREATE TABLE [ASData_PL].[FAT_ROATP_OrganisationStatus]
(
	[Id] INT ,
	[Status] NVARCHAR(50), 
	[CreatedAt] [datetime2](7) ,
	[UpdatedAt] [datetime2](7),
	[EventDescription] NVARCHAR(20),
	[AsDm_UpdatedDateTime]  [datetime2](7)	DEFAULT (getdate())
)
