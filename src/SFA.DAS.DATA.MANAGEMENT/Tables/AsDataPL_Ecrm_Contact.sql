CREATE TABLE [AsData_PL].[Ecrm_Contact]
( 
       [ID] BIGINT IDENTITY(1,1) NOT NULL
      ,[contactid] uniqueidentifier
      ,[parentaccountid] uniqueidentifier
      ,[parentaccountidname] nvarchar(255)
      ,[parentaccountidtype] nvarchar(25)
	  ,[accountid] uniqueidentifier
      ,[accountidname] nvarchar(255)
      ,[salutation] nvarchar(255)
	  ,[firstname] nvarchar(255)
	  ,[middlename] nvarchar(255)
	  ,[lastname] nvarchar(255)
	  ,[fullname] nvarchar(255)
	  ,[nickname] nvarchar(255)
	  ,[jobtitle] nvarchar(255)
	  ,[createdon] datetime2
	  ,[emailaddress1] nvarchar(25)
      ,[emailaddress2] nvarchar(25)
      ,[emailaddress3] nvarchar(25)
	  ,[donotbulkemail] bit
      ,[donotbulkpostalmail] bit
      ,[donotemail] bit
      ,[donotfax] bit
      ,[donotphone] bit
      ,[donotpostalmail] bit
      ,[donotsendmm] bit
      ,[msdyn_gdproptout] int
      ,[msdyn_orgchangestatus] int
      ,[preferredcontactmethodcode] int
      ,[PreferredContactMethodValue] nvarchar(25)
      ,[accountrolecode] nvarchar(25)
      ,[company] nvarchar(50)
      ,[customertypecode] nvarchar(50)
      ,[department] nvarchar(50)
	  ,[employeeid] nvarchar(50)
      ,[followemail] nvarchar(25)
      ,[isautocreate] bit
      ,[isbackofficecustomer] bit
      ,[isprivate] bit
      ,[lastonholdtime] datetime2
      ,[lastusedincampaign] datetime2
      ,[lsc_navmsregistered] bit
      ,[lsc_uniquelearnernumber] nvarchar(50)
      ,[marketingonly] bit
      ,[mastercontactidname] nvarchar(25)
      ,[masterid] uniqueidentifier
      ,[merged] bit
      ,[modifiedon] datetime2
      ,[onholdtime] bit
      ,[originatingleadid] uniqueidentifier
      ,[originatingleadidname] nvarchar(25)
      ,[overriddencreatedon] datetime2
      ,[ownerid] uniqueidentifier
      ,[owneridname] nvarchar(50)
      ,[owneridtype] nvarchar(50)
      ,[parentcontactid] uniqueidentifier
      ,[parentcontactidname] nvarchar(50)
      ,[participatesinworkflow] bit
      ,[preferredserviceid] uniqueidentifier
      ,[preferredserviceidname]  nvarchar(25)
      ,[processid] uniqueidentifier
      ,[sfa_unknowemail] bit
      ,[stageid] uniqueidentifier
      ,[statecode] int
      ,[statecodevalue] varchar(25)
      ,[statuscode]  int
      ,[statuscodevalue] varchar(25)
      ,CONSTRAINT PK_ECRM_Contact_Id PRIMARY KEY CLUSTERED (Id)
)
GO
CREATE NONCLUSTERED INDEX [NCI_Ecrm_Contact_AccountId] ON [AsData_PL].[Ecrm_Contact]([parentaccountid] ASC)
GO