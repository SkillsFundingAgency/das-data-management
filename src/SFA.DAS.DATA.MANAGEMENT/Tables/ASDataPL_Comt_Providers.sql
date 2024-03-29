﻿CREATE TABLE [ASData_PL].[Comt_Providers]
(	
	UKPRN		[bigint] NOT NULL,
	Name		[nvarchar](100) NULL,
	Created		[datetime2](7) NOT NULL,
	Updated		[datetime2](7) NULL,
	AsDm_UpdatedDateTime datetime2 default getdate(),
	[IsRetentionApplied] bit DEFAULT (0),
	[RetentionAppliedDate]  DateTime2(7),
	CONSTRAINT PK_Comt_Providers_UKPRN PRIMARY KEY CLUSTERED (UKPRN)
)ON [PRIMARY]
