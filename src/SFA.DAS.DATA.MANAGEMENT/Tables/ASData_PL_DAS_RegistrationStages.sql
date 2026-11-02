CREATE TABLE ASData_PL.DAS_RegistrationStages
(
    [UserEmail] NVARCHAR(255) NULL,
    [AccountCount] INT NULL,
    [EmployerAccountId] BIGINT NULL,
    [EmployerName] NVARCHAR(100) NULL,
    [Stage1a] VARCHAR(5) NULL,
    [Stage1b] VARCHAR(5) NULL,
    [Stage2] VARCHAR(5) NULL,
    [Stage3] VARCHAR(5) NULL,
    [Stage4a] VARCHAR(5) NULL,
    [Stage4b] VARCHAR(5) NULL,
    [Stage5] VARCHAR(5) NULL,
    [AsDm_UpdatedDateTime] datetime2 default getdate()	
);