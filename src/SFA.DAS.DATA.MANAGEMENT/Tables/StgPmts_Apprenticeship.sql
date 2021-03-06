
CREATE TABLE [StgPmts].[Apprenticeship](
	[Id] [bigint] NOT NULL,
	[AccountId] [bigint] NOT NULL,
	[AgreementId] [char](6) NULL,
	[AgreedOnDate] [date] NOT NULL,
	[Uln] [bigint] NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[EstimatedStartDate] [date] NOT NULL,
	[EstimatedEndDate] [date] NOT NULL,
	[Priority] [int] NOT NULL,
	[StandardCode] [bigint] NULL,
	[ProgrammeType] [int] NULL,
	[FrameworkCode] [int] NULL,
	[PathwayCode] [int] NULL,
	[LegalEntityName] [nvarchar](100) NULL,
	[TransferSendingEmployerAccountId] [bigint] NULL,
	[StopDate] [date] NULL,
	[Status] [tinyint] NOT NULL,
	[IsLevyPayer] [bit] NOT NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[ApprenticeshipEmployerType] [tinyint] NOT NULL
	
) 

