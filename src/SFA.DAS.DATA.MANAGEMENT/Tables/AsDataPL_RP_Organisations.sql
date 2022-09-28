CREATE TABLE [AsData_PL].[RP_Organisations]
(
   Id uniqueidentifier
  ,Name nvarchar(400)
  ,OrganisationType nvarchar(100)
  ,OrganisationUKPRN int
  ,Status nvarchar(20)
  ,TradingName nvarchar (400) NULL
  ,CompanyRegistrationNumber nvarchar (20) NULL
  ,CharityRegistrationNumber nvarchar (20) NULL
  ,RoATPApproved bit not null
  ,CreatedAt datetime2(7)
  ,CreatedBy nvarchar(256) NULL
  ,UpdatedAt datetime2(7)
  ,DeletedAt datetime2(7)
  ,UkprnOnRegister varchar(20)
  ,PostCode nvarchar(20)
  ,ContactNumber nvarchar(20)
  ,OrganisationReferenceType nvarchar(20)
  ,OrganisationLegalName nvarchar(256)
  ,OrganisationTradingName nvarchar(256)
  ,EndPointAssessmentOrgId nvarchar(256)
  ,VerificationAuthority nvarchar(256)
  ,VerificationId nvarchar(50)
  ,PrimaryVerificationSource nvarchar(20)
  ,AsDm_UpdatedDateTime DateTime2 default(getdate())
)