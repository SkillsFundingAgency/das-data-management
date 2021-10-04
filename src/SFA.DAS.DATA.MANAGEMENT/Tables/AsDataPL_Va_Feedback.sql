CREATE TABLE [AsData_PL].[Va_FaaFeedback]
(
  FeedbackId BIGINT IDENTITY(1,1) NOT NULL
 ,CreatedDateTime DateTime2
 ,UserId varchar(256) 
 ,TypeCode varchar(10)
 ,Enquiry varchar(max)
 ,Feedback nvarchar(max)
 ,SourceFeedbackId varchar(256)
 ,SourceDb varchar(100)
 ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
 )
