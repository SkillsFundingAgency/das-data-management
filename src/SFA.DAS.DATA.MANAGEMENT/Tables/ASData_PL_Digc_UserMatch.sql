CREATE TABLE [ASData_PL].[Digc_UserIdentity]
(
	[Id] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier] NULL,
	[Uln] [bigint] NULL,
	[FamilyName] [varchar](255) NULL,
	[DateOfBirth] [date] NULL,
	[EventTime] [datetime2](7) NULL,
	[CertificateType] [varchar](20) NULL,
	[CourseCode] [varchar](255) NULL,
	[CourseName] [varchar](1000) NULL,
	[CourseLevel] [varchar](20) NULL,
	[YearAwarded] [int] NULL,
	[ProviderName] [varchar](255) NULL,
	[Ukprn] [int] NULL,
	[IsMatched] [bit] NULL,
	[IsFailed] [bit] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()

)