CREATE TABLE [AsData_PL].[AED_ProviderInterest]
(
		Id						uniqueidentifier, 
		EmployerDemandId		uniqueidentifier,
		Ukprn					int, 	
		Website					varchar(500),
		DateCreated				datetime,
		Asdm_UpdatedDateTime	datetime2 default getdate()
)
