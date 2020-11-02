CREATE TABLE [AsData_PL].[AR_Employer]
(
	   [RedundancyEmployerId]  bigint not null
	  --,[AccountLegalEntityId] bigint not null
	  ,[OrganisationName] nvarchar(100) not null
      ,[Email] nvarchar(100) not null
	  ,[PhoneNumber] nvarchar(50) not null
      ,[ContactableForFeedback] bit not null
	  ,[Locations] int not null
      ,[Sectors] int not null
	  ,[ApprenticeshipMoreDetails] nvarchar(max) null
      ,[CreatedOn] datetime2(7) not null
	  ,[ContactFirstName] nvarchar(100) not null
      ,[ContactLastName] nvarchar(100) not null
	  ,[Asdm_UpdatedDateTime] datetime2 default getdate()
)
GO
CREATE NONCLUSTERED INDEX [NCI_AR_Emp_RedundancyEmployerId] ON [AsData_PL].[AR_Employer]([RedundancyEmployerId] ASC)
GO
