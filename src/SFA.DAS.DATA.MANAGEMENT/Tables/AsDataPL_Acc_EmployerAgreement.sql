CREATE TABLE [AsData_PL].[Acc_EmployerAgreement]
(
	[ID] BIGINT NOT NULL
   ,[TemplateId] Int NOT NULL
   ,[StatusId] TinyInt NOT NULL
   ,[SignedDate] DateTime NULL
   ,[AccountLegalEntityId] BIGINT NOT NULL
   ,[ExpiredDate] DateTime NULL
   ,[SignedById] BIGINT NULL
   ,[AsDm_UpdatedDateTime] DateTime2 Default(GetDate())
)
