CREATE TABLE [ASData_PL].[LTM_ApplicationCostProjection]
(	
   ID int
  ,ApplicationId int
  ,FinancialYear varchar(10)
  ,Amount int
  ,[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
