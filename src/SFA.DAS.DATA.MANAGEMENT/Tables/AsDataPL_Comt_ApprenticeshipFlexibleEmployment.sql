CREATE TABLE [ASData_PL].[Comt_ApprenticeshipFlexibleEmployment](
    [ApprenticeshipId] [bigint] NOT NULL,
    [EmploymentPrice] [int] NULL,
    [EmploymentEndDate] [datetime2](7) NULL,
    [AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate()),
    CONSTRAINT [PK_Comt_ApprenticeshipFlexibleEmployment_Id] PRIMARY KEY CLUSTERED (ApprenticeshipId)
) ON [PRIMARY]


