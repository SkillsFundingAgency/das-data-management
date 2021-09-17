﻿CREATE  TABLE [ASData_PL].[Acc_Paye]
(
	[Ref] [nvarchar](500) NOT NULL,	
	[Name] [varchar](500) NULL,
	[IsRetentionApplied] bit DEFAULT (0),
    [RetentionAppliedDate]  DateTime2(7),
	[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
GO