CREATE TABLE [ASData_PL].[Comt_ChangeOfPartyRequest]
(
	[Id] [bigint] NULL,
	[ApprenticeshipId] [bigint] NULL,
	[DeliveryModel] [tinyint] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)