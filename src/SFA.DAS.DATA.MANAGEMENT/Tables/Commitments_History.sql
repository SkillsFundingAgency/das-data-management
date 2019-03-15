CREATE TABLE [Comt].[History]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY,
	[EntityType] NVARCHAR(50) NULL, -- deprecated
	[EntityId] BIGINT NULL, -- deprecated
	[CommitmentId] BIGINT NULL,
	[ApprenticeshipId] BIGINT NULL,
    [UserId] NVARCHAR(50) NOT NULL, 
    [UpdatedByRole] NVARCHAR(50) NOT NULL, 
    [ChangeType] NVARCHAR(50) NOT NULL,
    [CreatedOn] DATETIME NOT NULL, 
	[ProviderId] BIGINT NULL,
	[EmployerAccountId] BIGINT MASKED WITH (FUNCTION='RANDOM(1,5)') NOT NULL,
    [UpdatedByName] NVARCHAR(255) NULL, 
    [OriginalState] NVARCHAR(MAX) NULL, 
    [UpdatedState] NVARCHAR(MAX) NULL,
	[AsDm_Created_Date] datetime default(getdate()),
	[AsDm_Updated_Date] datetime default(getdate()),
	[Load_Id] int
)
