CREATE TABLE [ASData_PL].[CRSDel_StandardLocation]
(
	[LocationId]			int						NOT NULL,
	[Name]					varchar(250)			NULL,
	[Email]					varchar(260)			NULL,
	[Website]				varchar(260)			NULL,	
	[Postcode]				varchar(25)				NULL,	
	[Lat]					float					NULL,
	[Long]					float					NULL,
	[AsDm_UpdatedDateTime] [datetime2](7)	DEFAULT (getdate())
)

