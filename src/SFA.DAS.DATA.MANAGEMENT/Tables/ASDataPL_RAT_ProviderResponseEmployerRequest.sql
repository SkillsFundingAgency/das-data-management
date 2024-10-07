CREATE TABLE [Asdata_pl].[ProviderResponseEmployerRequest](
	[EmployerRequestId] [uniqueidentifier] NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[ProviderResponseId] [uniqueidentifier] NULL,
	[AcknowledgedAt] [datetime2](7) NULL,
	[AcknowledgedBy] [uniqueidentifier] NULL,
	[ValidFrom] [datetime2](0) ,
	[ValidTo] [datetime2](0) ,
    AsDm_UpdatedDateTime datetime2 default getdate()	NULL
 PRIMARY KEY  (	[EmployerRequestId] ,[Ukprn]),


 CONSTRAINT FK_ProviderResponseEmployerRequest FOREIGN KEY (EmployerRequestId) REFERENCES [Asdata_pl].[RAT_EmployerRequest] (Id),
 
)