CREATE TABLE [AsData_PL].[Va_County]
( 
  CountyId int PRIMARY KEY
 ,CodeName nvarchar(3)
 ,ShortName nvarchar(50)
 ,FullName nvarchar(150)
 ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
