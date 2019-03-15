CREATE TABLE [fdb].[Stg_FIU_GA_Feedback]
(
	Feedback_Id int identity(1,1) not null ,
	Campaign_Category varchar(255) null,
	Campaign_Action varchar(255) null,
	CampaignStartDate datetime null,
	CampaignEndDate datetime null,
	All_Users_Count int null,
	FIU_Referred_Users_Count int null,
	AsDm_Created_Date datetime default(getdate()),
	AsDm_Updated_Date datetime default(getdate()),
	Load_Id int
)
