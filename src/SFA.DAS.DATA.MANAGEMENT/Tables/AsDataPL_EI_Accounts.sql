CREATE TABLE AsData_Pl.EI_Accounts
(
    [Id] BIGINT NOT NULL,
	[AccountLegalEntityId] BIGINT  NOT NULL,
	[LegalEntityId] BIGINT  NOT NULL,
	[HasSignedIncentivesTerms] BIT NOT NULL,
	[UpdatedDateTime] datetime2 default getdate()
)




