CREATE TABLE [ASData_PL].[Comt_ChangeOfPartyRequest]
(
	[Id] [bigint] NULL,
	[ApprenticeshipId] [bigint] NULL,
	[ChangeOfPartyType] [tinyint] NULL,
	[OriginatingParty] [smallint] NULL,
	[AccountLegalEntityId] [bigint] NULL,
	[ProviderId] [bigint] NULL,
	[Price] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreatedOn] [datetime] NULL,
	[Status] [tinyint] NULL,
	[RowVersion] datetime NULL,
	[LastUpdatedOn] [datetime2](7) NULL,
	[CohortId] [bigint] NULL,
	[ActionedOn] [datetime2](7) NULL,
	[NewApprenticeshipId] [bigint] NULL,
	[EmploymentPrice] [int] NULL,
	[EmploymentEndDate] [datetime2](7) NULL,
	[DeliveryModel] [tinyint] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)