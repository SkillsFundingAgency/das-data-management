CREATE TABLE [Asdata_pl].[RAT_ProviderResponseEmployerRequestHistory](
	[EmployerRequestId] [uniqueidentifier] NOT NULL,
	[Ukprn] Varchar(256) NOT NULL,
	[ProviderResponseId] [uniqueidentifier] NULL,
	[AcknowledgedAt] [datetime2](7) NULL,
	[AcknowledgedBy] [uniqueidentifier] NULL,
	[ValidFrom] [datetime2](0) ,
	[ValidTo] [datetime2](0) ,
    AsDm_UpdatedDateTime datetime2 default getdate()	NULL
 PRIMARY KEY  (	[EmployerRequestId] ,[Ukprn])
)