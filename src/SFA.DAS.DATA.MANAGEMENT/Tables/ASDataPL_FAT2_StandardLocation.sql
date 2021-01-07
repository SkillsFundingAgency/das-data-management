CREATE TABLE [ASData_PL].[FAT2_StandardLocation]
(
	[LocationId]			int						NOT NULL,
	[Name]					varchar(250)			NULL,
	[Email]					varchar(260)			NULL,
	[Website]				varchar(260)			NULL,	
	[Postcode]				varchar(25)				NULL,	
	[AsDm_UpdatedDateTime] [datetime2](7)	DEFAULT (getdate())
)

