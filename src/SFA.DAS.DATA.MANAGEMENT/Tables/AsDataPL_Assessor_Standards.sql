CREATE TABLE [AsData_PL].[Assessor_Standards]
(
	[StandardUId]					[varchar](20)		PRIMARY KEY NOT NULL,
	[IFateReferenceNumber]			[varchar](10)		NOT NULL,
	[LarsCode]						[int]				NULL,
	[Title]							[varchar](1000)		NULL,
	[Version]						[decimal](18,1)		NULL,
	[Level]							[int]				NULL,
	[Status]						[varchar](100)		NULL,
	[TypicalDuration]				[int]				NULL,
	[MaxFunding]					[int]				NULL,
	[IsActive]						[bit]				NULL,
	[LastDateStarts]				[datetime]			NULL,
	[EffectiveFrom]					[datetime]			NULL,
	[EffectiveTo]					[datetime]			NULL,
	[VersionEarliestStartDate]		[datetime]			NULL,
	[VersionLatestStartDate]		[datetime]			NULL,
	[VersionLatestEndDate]			[datetime]			NULL,
	[VersionApprovedForDelivery]	[datetime]			NULL,
	[ProposedTypicalDuration]		[int]				NULL,
	[ProposedMaxFunding]			[int]				NULL
)
