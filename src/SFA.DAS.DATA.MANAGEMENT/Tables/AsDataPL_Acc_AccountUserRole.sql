CREATE TABLE [AsData_PL].[Acc_AccountUserRole]
(
	[AccountId] BIGINT NOT NULL
   ,[UserId] BIGINT NOT NULL
   ,[Role] INT NOT NULL
   ,[CreatedDate] DateTime NOT NULL
   ,[ShowWizard] bit NOT NULL
   ,[AsDm_UpdatedDateTime] datetime2 default(getdate())
)
