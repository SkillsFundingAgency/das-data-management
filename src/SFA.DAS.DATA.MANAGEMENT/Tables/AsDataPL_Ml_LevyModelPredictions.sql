CREATE TABLE AsData_Pl.ML_LevyModelPredictions
(
    [Id] BIGINT identity(1,1) NOT NULL,
	[AccountId] BIGINT,
	[LevyModelPredictions] nvarchar(max),
	[AsDm_UpdatedDateTime] datetime2(7) default(getdate())
	,CONSTRAINT PK_ML_LevyPredictions PRIMARY KEY CLUSTERED (Id)
)
GO

CREATE NONCLUSTERED INDEX [NCI_ML_LevyPredictions_AccountId] ON AsData_Pl.ML_LevyModelPredictions(AccountId)
GO
