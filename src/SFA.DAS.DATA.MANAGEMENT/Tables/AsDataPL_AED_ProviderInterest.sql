CREATE TABLE [AsData_PL].[AED_ProviderInterest]
(
		Id						uniqueidentifier, 
		EmployerDemandId		uniqueidentifier,
		Ukprn					int, 
		Email					varchar(256),
		Phone					varchar(50),
		Website					varchar(500),
		DateCreated				datetime,
		Asdm_UpdatedDateTime	datetime2 default getdate()
)
