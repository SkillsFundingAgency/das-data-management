CREATE TABLE [dbo].[Stg_FIU_Feedback]
(
	Feedback_Id int identity(1,1) ,
	Campaign_Category varchar(255) null,
	Campaign_SubCategory varchar(255) null,
	Campaign_Metrics varchar(255) null,
	CampaignStartDate datetime null,
	CampaignEndDate datetime null,
	Count int null
)
