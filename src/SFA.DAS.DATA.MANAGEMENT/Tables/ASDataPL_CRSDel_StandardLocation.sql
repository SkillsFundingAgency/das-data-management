CREATE TABLE [ASData_PL].[CRSDel_StandardLocation]
(
	[LocationId]			int				NOT NULL,
	[Name]					varchar			NULL,
	[Email]					varchar			NULL,
	[Website]				varchar			NULL,	
	[Postcode]				varchar			NULL,	
	[Lat]					float			NULL,
	[Long]					float			NULL,
	[AsDm_UpdatedDateTime] [datetime2](7)	DEFAULT (getdate())
)

