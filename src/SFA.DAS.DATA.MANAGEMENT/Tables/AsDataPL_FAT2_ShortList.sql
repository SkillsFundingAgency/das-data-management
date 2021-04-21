CREATE TABLE [AsData_PL].[FAT2_ShortList]
(
	[Id]					[uniqueidentifier]	PRIMARY KEY NOT NULL,
	[ShortlistUserId]		[uniqueidentifier]	NULL,
	[UkPrn]					[int]				NULL,
	[StandardId]			[int]				NULL,
	[CourseSector]			[varchar](1000)		NULL,
	[LocationDescription]	[varchar](1000)		NULL,
	[CreatedDate]			[datetime]			NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7)		DEFAULT (getdate())
)