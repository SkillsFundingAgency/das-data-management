﻿CREATE  TABLE [ASData_PL].[Acc_Paye]
(
	[Ref] [nvarchar](16) NOT NULL,	
	[Name] [varchar](500) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
GO