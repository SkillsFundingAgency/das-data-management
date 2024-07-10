CREATE TABLE [AsData_PL].[Va_ContactMessages]
(
  ContactMessagesId BIGINT IDENTITY(1,1) NOT NULL
 ,CreatedDateTime DateTime2
 ,UpdatedDateTime DateTime2
 ,UserId varchar(256) 
 ,Enquiry varchar(max)
 ,SourceContactMessagesId varchar(256)
 ,CandidateID BIGINT NOT NULL
 ,Status TINYINT
 ,ContactMethod varchar(50)
 ,PreferenceID BIGINT NOT NULL
 ,SourceDb varchar(100)
 ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
 )
