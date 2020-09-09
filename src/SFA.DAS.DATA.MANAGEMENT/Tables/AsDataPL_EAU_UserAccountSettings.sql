CREATE TABLE [AsData_PL].[EAU_UserAccountSettings]
(    
         ID BIGINT NOT NULL
        ,UserId BIGINT NOT NULL
        ,AccountId BIGINT NOT NULL
        ,ReceiveNotifications BIT NOT NULL 
	    ,[Asdm_UpdatedDateTime] datetime2 default getdate()
 )