CREATE TABLE [AsData_PL].[Ecrm_Account]
(
	   [ID] BIGINT IDENTITY(1,1) NOT NULL
	  ,[accountid] uniqueidentifier
	  ,[name] nvarchar(50)
      ,[accountnumber] nvarchar(50)
	  ,[accountcategorycode] int
	  ,[accountcategorycodevalue] varchar(25)
      ,[createdon] datetime2
      ,[customertypecode] int
	  ,[customertypecodevalue] varchar(25)
      ,[donotbulkemail] bit
      ,[donotbulkpostalmail] bit
      ,[donotemail] bit
      ,[donotfax] bit
      ,[donotphone] bit
      ,[donotpostalmail] bit
      ,[donotsendmm] bit
      ,[emailaddress1] nvarchar(255)
      ,[emailaddress2] nvarchar(255)
      ,[emailaddress3] nvarchar(255)
	  ,[preferredcontactmethodcode] int
	  ,[preferredcontactmethodvalue] varchar(25)
      ,[primarycontactid] uniqueidentifier
      ,[primarycontactidname] nvarchar(50)
      ,[followemail] bit
      ,[importsequencenumber] int
      ,[industrycode] int
	  ,[industrycodevalue] nvarchar(50)
	  ,[sfa_employertype] int
	  ,[sfa_employertypevalue] varchar(50)
	  ,[sfa_providertype] int
	  ,[sfa_providertypevalue] varchar(25)
	  ,[sfa_intermediarytype] int
	  ,[sfa_intermediaryvalue] varchar(25)
	  ,[sfa_tleveltype] int
	  ,[sfa_tleveltypevalue] varchar(25)
      ,[isprivate] bit
      ,[lastonholdtime] datetime2
      ,[lastusedincampaign] datetime2
      ,[lsc_divisionid] uniqueidentifier
      ,[lsc_divisionidname] nvarchar(25)
      ,[lsc_learningproviderstatus] int
      ,[lsc_managingproviderid] uniqueidentifier
	  ,[lsc_managingprovideridname] nvarchar(25)
      ,[lsc_navmsregistered] bit
      ,[lsc_noofemployees] int
      ,[lsc_uniquelearnerprovidernumber] nvarchar(50)
      ,[lsc_urn] nvarchar(25)
      ,[lsc_urnstatus] int
	  ,[lsc_urnstatusvalue] nvarchar(25)
      ,[marketingonly] bit
      ,[masteraccountidname] nvarchar(25)
      ,[masterid] uniqueidentifier
      ,[merged] bit
      ,[modifiedon] datetime2
      ,[numberofemployees] int
      ,[onholdtime] int
      ,[originatingleadid] uniqueidentifier
      ,[originatingleadidname] nvarchar(25)
      ,[ownerid] uniqueidentifier
	  ,[owneridname] nvarchar(25)
      ,[parentaccountid] uniqueidentifier
	  ,[parentaccountidname] nvarchar(25)
	  ,[sfa_automatedmarketingconsent] bit
	  ,[sfa_employerrelationship] varchar(50)
	  ,[sfa_employerapprenticeshipstatus] varchar(50)
	  ,[sfa_channelsource] varchar(50)
	  ,[sfa_couldtakepartinbamediversityhubs] bit
	  ,[sfa_couldtakepartinraisingvalueofapprenticesh] bit
	  ,[sfa_commsdate] datetime2
	  ,[sfa_datadigitalengagement] bit
	  ,[sfa_disabilitypart] bit
	  ,[sfa_employersegmentation] int
	  ,[sfa_levelofengagement] int
	  ,[sfa_levelofengagementvalue] varchar(25)
	  ,[sfa_tlevelstatusname] varchar(50)
      ,[statecode] int
	  ,[statecodevalue] varchar(25)
	  ,[statuscode] int
	  ,[statuscodevalue] varchar(25)
      ,CONSTRAINT PK_ECRM_Company_Id PRIMARY KEY CLUSTERED (Id)
)
GO
CREATE NONCLUSTERED INDEX [NCI_Ecrm_Company_AccountId] ON [AsData_PL].[Ecrm_Contact]([accountid] ASC)
GO