CREATE TABLE [Comt].[CustomProviderPaymentPriority]
(
	[EmployerAccountId] BIGINT MASKED WITH (FUNCTION='RANDOM(1,5)') NOT NULL , 
    [ProviderId] BIGINT NOT NULL, 
    [PriorityOrder] INT NOT NULL, 
    PRIMARY KEY ([EmployerAccountId], [ProviderId])
)
