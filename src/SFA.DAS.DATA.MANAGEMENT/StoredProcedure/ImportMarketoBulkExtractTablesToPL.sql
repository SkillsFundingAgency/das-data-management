CREATE PROCEDURE [dbo].[ImportMarketoBulkExtractTablesToPL]
(
   @RunId int
)
AS

-- ==================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 05/10/2020
-- Description: Import Marketo Campaign Data To Presentation Layer
-- ==================================================================

BEGIN TRY

    SET NOCOUNT ON

 DECLARE @LogID int

/* Start Logging Execution */

  INSERT INTO Mgmt.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,Execution_Status
	  )
  SELECT 
        @RunId
	   ,'Step-6'
	   ,'ImportMarketoBulkExtractTablesToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportMarketoBulkExtractTablesToPL'
     AND RunId=@RunID

IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION

/* Delta Code */
Update Target
SET  
	 Target.EmployerHashedID=Source.EmployerHashedId 
	,Target.ProviderId=Source.ProviderId 
FROM AsData_PL.MarketoLeads as Target  JOIN 
(
		Select MLData.LeadId,MLData.[FirstName],MLData.[LastName],MLData.[EmailAddress],MLData.[LeadCreatedAt],MLData.[LeadUpdatedAt],trim(STRING_AGG(EmpData.EmployerHashedId,',')) As EmployerHashedId,trim(STRING_AGG(Cast(ProviderData.Ukprn As NVarchar(20)),',')) As ProviderID
		from [ASData_PL].[MarketoLeads]  MLData   LEFT JOIN 
		(			  select ml.LeadId,au.HashedId as EmployerHashedId  from [ASData_PL].[MarketoLeads] ml
					  inner join (  select au.Email,au.id,aus.AccountId as EmployerAccountId,aa.HashedId from asdata_pl.acc_user au join ASData_PL.Acc_UserAccountSettings aus
						on au.Id=aus.UserId join ASData_PL.Acc_Account aa on aa.Id=aus.AccountId ) au on ml.EmailAddress=au.Email 
		) As EmpData ON MLData.LeadId = EmpData.LeadId
		LEFT JOIN ( select ml.LeadId,PUser.Ukprn from [ASData_PL].[MarketoLeads]  ml JOIN ASData_PL.PAS_User PUser  ON ml.EmailAddress = PUser.Email ) As ProviderData ON MLData.LeadId= ProviderData.LeadId
		Group by MLData.LeadId,MLData.[FirstName],MLData.[LastName],MLData.[EmailAddress],MLData.[LeadCreatedAt],MLData.[LeadUpdatedAt]
) as source
ON Target.LeadId=Source.LeadId
where 	   
	   ISNULL(Target.EmployerHashedID,'NA')<>ISNULL(Source.EmployerHashedID,'NA')
	OR ISNULL(Target.ProviderId,'NA')<>ISNULL(Source.ProviderId,'NA')

/* Delta Update MarketoLeads */
;with baseMarketoLeadsData as
(
        Select MLData.LeadId,MLData.[FirstName],MLData.[LastName],MLData.[EmailAddress],MLData.[CreatedAt],MLData.[UpdatedAt],trim(STRING_AGG(EmpData.EmployerHashedId,',')) As EmployerHashedId,trim(STRING_AGG(Cast(ProviderData.Ukprn As NVarchar(20)),',')) As ProviderID
		from stg.MarketoLeads  MLData   LEFT JOIN 
		(			  select ml.LeadId,au.HashedId as EmployerHashedId  from stg.MarketoLeads ml
					  inner join (  select au.Email,au.id,aus.AccountId as EmployerAccountId,aa.HashedId from asdata_pl.acc_user au join ASData_PL.Acc_UserAccountSettings aus
						on au.Id=aus.UserId join ASData_PL.Acc_Account aa on aa.Id=aus.AccountId ) au on ml.EmailAddress=au.Email 
			          where ml.LeadId is not null
		) As EmpData ON MLData.LeadId = EmpData.LeadId
		LEFT JOIN ( select ml.LeadId,PUser.Ukprn from stg.MarketoLeads  ml JOIN ASData_PL.PAS_User PUser  ON ml.EmailAddress = PUser.Email where ml.LeadId is not null ) As ProviderData ON MLData.LeadId= ProviderData.LeadId
		where MLData.LeadId is not null
		Group by MLData.LeadId,MLData.[FirstName],MLData.[LastName],MLData.[EmailAddress],MLData.[CreatedAt],MLData.[UpdatedAt]
)
MERGE AsData_PL.MarketoLeads as Target
 USING baseMarketoLeadsData as Source
    ON Target.LeadId=TRY_CONVERT(bigint,Source.LeadId)
  WHEN MATCHED AND ( ISNULL(Target.FirstName,'NA')<>ISNULL(CASE WHEN Source.FirstName='NULL' THEN NULL ELSE Source.FirstName END,'NA')
                  OR ISNULL(Target.LastName,'NA')<>ISNULL(CASE WHEN Source.LastName='NULL' THEN NULL ELSE Source.LastName END,'NA')
				  OR ISNULL(Target.EmailAddress,'NA')<>ISNULL(CASE WHEN Source.EmailAddress='NULL' THEN NULL ELSE Source.EmailAddress END,'NA')
				  )
  THEN UPDATE SET Target.FirstName=CASE WHEN Source.FirstName='NULL' THEN NULL ELSE Source.FirstName END
                 ,Target.LastName=CASE WHEN Source.LastName='NULL' THEN NULL ELSE Source.LastName END
				 ,Target.EmailAddress=CASE WHEN Source.EmailAddress='NULL' THEN NULL ELSE Source.EmailAddress END
				 ,Target.LeadCreatedAt=TRY_CONVERT(datetime2,CASE WHEN Source.CreatedAt='null' then NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.CreatedAt END,104)
				 ,Target.LeadUpdatedAt=TRY_CONVERT(datetime2,CASE WHEN Source.UpdatedAt='null' then NULL WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1) ELSE Source.UpdatedAt END,104)
				 ,Target.AsDm_UpdatedDate=getdate()
				 ,Target.EmployerHashedID=Source.EmployerHashedId 
				 ,Target.ProviderId=Source.ProviderId 
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (LeadId
              ,FirstName
			  ,LastName
			  ,EmailAddress
			  ,LeadCreatedAt
			  ,LeadUpdatedAt
			  ,EmployerHashedID
			  ,ProviderID
			  ,AsDm_CreatedDate
			  ,AsDm_UpdatedDate) 
       VALUES (TRY_CONVERT(bigint,LeadId)
	          ,CASE WHEN Source.FirstName='NULL' THEN NULL ELSE Source.FirstName END
			  ,CASE WHEN Source.LastName='NULL' THEN NULL ELSE Source.LastName END
			  ,CASE WHEN Source.EmailAddress='NULL' THEN NULL ELSE Source.EmailAddress END			 
			  ,TRY_CONVERT(datetime2,CASE WHEN Source.CreatedAt='null' then NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.CreatedAt END,104)
			  ,TRY_CONVERT(datetime2,CASE WHEN Source.UpdatedAt='null' then NULL WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1) ELSE Source.UpdatedAt END,104)
			  ,Source.EmployerHashedID
			  ,Source.ProviderID
			  ,getdate()
			  ,getdate());

/* Delta Update MarketoLeadActivities */

	   MERGE AsData_PL.MarketoLeadActivities as Target
 USING Stg.MarketoLeadActivities as Source
    ON Target.MarketoGUID=Source.MarketoGUID
  WHEN MATCHED AND ( ISNULL(Target.LeadId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.LeadId='NULL' THEN NULL ELSE Source.LeadId END,'-1'))
                  OR ISNULL(Target.ActivityTypeId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.ActivityTypeId='NULL' THEN NULL ELSE Source.ActivityTypeId END,'-1'))
				  OR ISNULL(Target.CampaignId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.CampaignId='NULL' THEN NULL ELSE Source.CampaignId END,'-1'))
				  )
  THEN UPDATE SET Target.LeadId=TRY_CONVERT(bigint,CASE WHEN Source.LeadId='NULL' THEN NULL ELSE Source.LeadId END)
                 ,Target.CampaignId=TRY_CONVERT(bigint,CASE WHEN Source.CampaignId='NULL' THEN NULL ELSE Source.CampaignId END)
				 ,Target.ActivityTypeId=TRY_CONVERT(bigint,CASE WHEN Source.ActivityTypeId='NULL' THEN NULL ELSE Source.ActivityTypeId END)
				 ,Target.AsDm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET AND SOURCE.ActivityTypeId <= 11
  THEN INSERT (MarketoGUID
              ,LeadId
			  ,ActivityDate
			  ,ActivityTypeId
			  ,CampaignId
			  ,AsDm_CreatedDate
			  ,AsDm_UpdatedDate) 
       VALUES (Source.MarketoGUID
	          ,TRY_CONVERT(bigint,CASE WHEN Source.LeadId='NULL' THEN NULL ELSE Source.LeadId END)
			  ,TRY_CONVERT(datetime2,CASE WHEN Source.ActivityDate='NULL' THEN NULL WHEN Source.ActivityDate LIKE '%+%' THEN SUBSTRING(Source.ActivityDate,1,CHARINDEX('+',Source.ActivityDate)-1) ELSE Source.ActivityDate END,104)
			  ,CONVERT(bigint,CASE WHEN Source.ActivityTypeId='NULL' THEN NULL ELSE Source.ActivityTypeId END)
			  ,CONVERT(bigint,CASE WHEN Source.CampaignId='NULL' THEN NULL ELSE Source.CampaignId END)
			  ,getdate()
			  ,getdate()
			  );



/* Delta Update MarketoLeadPrograms */

 MERGE AsData_PL.MarketoLeadPrograms as Target
 USING Stg.MarketoLeadPrograms as Source
    ON Target.LeadProgramID=TRY_CONVERT(bigint,Source.ID)
  WHEN MATCHED AND ( ISNULL(Target.FirstName,'NA')<>ISNULL(CASE WHEN Source.FirstName='null' then NULL ELSE Source.FirstName END,'NA')
                  OR ISNULL(Target.LastName,'NA')<>ISNULL(CASE WHEN Source.LastName='null' then NULL ELSE Source.LastName END,'NA')
				  OR ISNULL(Target.EmailAddress,'NA')<>ISNULL(CASE WHEN Source.Email='null' then NULL ELSE Source.Email END,'NA')
				  OR ISNULL(Target.ProgramId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.ProgramId='null' then NULL ELSE Source.ProgramId END,'-1'))
				  OR ISNULL(Target.ProgramName,'NA')<>ISNULL(CASE WHEN Source.Program='null' then NULL ELSE Source.Program END,'NA')
				  OR ISNULL(Target.Status,'NA')<>ISNULL(CASE WHEN Source.Status='null' then NULL ELSE Source.Status END,'NA')
				  OR ISNULL(Target.ProgramTypeId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.ProgramTypeId='null' then NULL ELSE Source.ProgramTypeId END,'-1'))
				  OR ISNULL(Target.LeadId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.LeadId='null' then NULL ELSE Source.LeadId END,'-1'))
				  OR ISNULL(Target.StatusId,'NA')<>ISNULL(CASE WHEN Source.StatusId='null' then NULL ELSE Source.StatusId END,'NA')
				  )
  THEN UPDATE SET Target.FirstName=CASE WHEN Source.FirstName='null' then NULL ELSE Source.FirstName END
                 ,Target.LastName=CASE WHEN Source.LastName='null' then NULL ELSE Source.LastName END
				 ,Target.EmailAddress=CASE WHEN Source.Email='null' then NULL ELSE Source.Email END
				 ,Target.ProgramId=TRY_CONVERT(bigint,CASE WHEN Source.ProgramId='null' then NULL ELSE Source.ProgramId END)
				 ,Target.ProgramName=CASE WHEN Source.Program='null' then NULL ELSE Source.Program END
				 ,Target.Status=CASE WHEN Source.Status='null' then NULL ELSE Source.Status END
				 ,Target.ProgramTypeId=TRY_CONVERT(bigint,CASE WHEN Source.ProgramTypeId='null' then NULL ELSE Source.ProgramTypeId END)
				 ,Target.LeadId=TRY_CONVERT(bigint,CASE WHEN Source.LeadId='null' then NULL ELSE Source.LeadId END)
				 ,Target.StatusId=CASE WHEN Source.StatusId='null' then NULL ELSE Source.StatusId END
				 ,Target.AsDm_UpdatedDate=getdate()
				 ,Target.LeadProgramCreatedAt=TRY_CONVERT(datetime2,CASE WHEN Source.CreatedAt='null' then NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.CreatedAt END,104)
				 ,Target.LeadProgramUpdatedAt=TRY_CONVERT(datetime2,CASE WHEN Source.UpdatedAt='null' then NULL WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1) ELSE Source.UpdatedAt END,104)
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (LeadProgramId,FirstName,LastName,EmailAddress,MemberDate,ProgramId,ProgramName,ProgramTypeId,LeadId,Status,StatusId,AsDm_CreatedDate,AsDm_UpdatedDate,LeadProgramCreatedAt,LeadProgramUpdatedAt) 
       VALUES (TRY_CONVERT(bigint,Source.ID)
	          ,CASE WHEN Source.FirstName='null' then NULL ELSE Source.FirstName END
	          ,CASE WHEN Source.LastName='null' then NULL ELSE Source.LastName END
			  ,CASE WHEN Source.Email='null' then NULL ELSE Source.Email END
			  ,TRY_CONVERT(datetime2,CASE WHEN Source.MemberDate='null' then NULL WHEN Source.MemberDate LIKE '%+%' THEN SUBSTRING(Source.MemberDate,1,CHARINDEX('+',Source.MemberDate)-1) ELSE Source.MemberDate END,104)
			  ,TRY_CONVERT(bigint,CASE WHEN Source.ProgramId='null' then NULL ELSE Source.ProgramId END)
			  ,CASE WHEN Source.Program='null' then NULL ELSE Source.Program END
			  ,TRY_CONVERT(bigint,CASE WHEN Source.ProgramTypeId='null' then NULL ELSE Source.ProgramTypeId END)
			  ,TRY_CONVERT(bigint,CASE WHEN Source.LeadId='null' then NULL ELSE Source.LeadId END)
			  ,CASE WHEN Source.Status='null' then NULL ELSE Source.Status END
			  ,CASE WHEN Source.StatusId='null' then NULL ELSE Source.StatusId END
			  ,getdate()
			  ,getdate()
			  ,TRY_CONVERT(datetime2,CASE WHEN Source.CreatedAt='null' then NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.CreatedAt END,104)
			  ,TRY_CONVERT(datetime2,CASE WHEN Source.UpdatedAt='null' then NULL WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1) ELSE Source.UpdatedAt END,104));

/* Delta Update MarketoCampaigns */

			  MERGE AsData_PL.MarketoCampaigns as Target
 USING Stg.MarketoCampaigns as Source
    ON Target.CampaignId=TRY_CONVERT(bigint,Source.Id)
  WHEN MATCHED AND ( ISNULL(Target.CampaignName,'NA')<>ISNULL(CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END,'NA')
                  OR ISNULL(Target.CampaignType,'NA')<>ISNULL(CASE WHEN Source.type='NULL' THEN NULL ELSE Source.type END,'NA')
				  OR ISNULL(Target.ProgramName,'NA')<>ISNULL(CASE WHEN Source.programName='NULL' THEN NULL ELSE Source.programName END,'NA')
				  OR ISNULL(Target.ProgramId,-1)<>TRY_CONVERT(BIGINT,ISNULL(Source.programId,-1))
				  OR ISNULL(Target.WorkspaceName,'NA')<>ISNULL(CASE WHEN Source.WorkspaceName='NULL' THEN NULL ELSE Source.WorkspaceName END,'NA')
				  OR ISNULL(Target.createdAt,'9999-12-31')<>TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.createdAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.createdAt END,'9999-12-31'),104)
				  OR ISNULL(Target.updatedAt,'9999-12-31')<>TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.updatedAt='NULL' THEN NULL WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1) ELSE Source.updatedAt END,'9999-12-31'),104)
				  OR ISNULL(Target.Active,0)<>TRY_CONVERT(BIT,ISNULL(Source.Active,0))
				  )
  THEN UPDATE SET Target.CampaignName=CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END
                 ,Target.CampaignType=CASE WHEN Source.type='NULL' THEN NULL ELSE Source.type END
				 ,Target.ProgramName=CASE WHEN Source.programName='NULL' THEN NULL ELSE Source.programName END
				 ,Target.ProgramId=TRY_CONVERT(bigint,ISNULL(Source.programId,-1))
				 ,Target.WorkspaceName=CASE WHEN Source.WorkspaceName='NULL' THEN NULL ELSE Source.WorkspaceName END
				 ,Target.createdAt=TRY_CONVERT(datetime2,CASE WHEN Source.createdAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.createdAt END,104)
				 ,Target.updatedAt=TRY_CONVERT(datetime2,CASE WHEN Source.updatedAt='NULL' THEN NULL WHEN Source.updatedAt LIKE '%+%' THEN SUBSTRING(Source.updatedAt,1,CHARINDEX('+',Source.updatedAt)-1) ELSE Source.updatedAt END,104)
				 ,Target.Active=TRY_CONVERT(BIT,Source.Active)
				 ,Target.AsDm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT ([CampaignId]
              ,[CampaignName]
              ,[CampaignType]
              ,[ProgramName]
              ,[ProgramId]
              ,[WorkspaceName]
              ,[createdAt]
              ,[updatedAt]
              ,[active]
			  ,AsDm_CreatedDate
			  ,AsDm_UpdatedDate) 
       VALUES (   TRY_CONVERT(bigint,Source.Id)
	             ,CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END
                 ,CASE WHEN Source.type='NULL' THEN NULL ELSE Source.type END
				 ,CASE WHEN Source.programName='NULL' THEN NULL ELSE Source.programName END
				 ,TRY_CONVERT(bigint,ISNULL(Source.programId,-1))
				 ,CASE WHEN Source.WorkspaceName='NULL' THEN NULL ELSE Source.WorkspaceName END
				 ,TRY_CONVERT(datetime2,CASE WHEN Source.createdAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.createdAt END,104)
				 ,TRY_CONVERT(datetime2,CASE WHEN Source.updatedAt='NULL' THEN NULL WHEN Source.updatedAt LIKE '%+%' THEN SUBSTRING(Source.updatedAt,1,CHARINDEX('+',Source.updatedAt)-1) ELSE Source.updatedAt END,104)
				 ,TRY_CONVERT(BIT,Source.Active)
				 ,getdate()
			     ,getdate()
				 );



/* Delta Update MarketoLeadActivityLinkClicked */

  MERGE AsData_PL.MarketoLeadActivityLinkClicked as Target
              USING (SELECT marketoguid,leadid,primaryattributevalueid,primaryattributevalue,JSON_VALUE(AttributesCleansed,'$.ReferrerURL') ReferrerURL
                            , JSON_VALUE(AttributesCleansed,'$.Link') Link
							, JSON_VALUE(AttributesCleansed,'$.QueryParameters') QueryParameters
							, JSON_VALUE(AttributesCleansed,'$.WebpageURL') WebpageURL
							, CASE WHEN JSON_VALUE(AttributesCleansed,'$.Link') IS not null AND charindex('?',JSON_VALUE(AttributesCleansed,'$.Link'))<>0 then replace(LEFT(JSON_VALUE(AttributesCleansed,'$.Link'),charindex('?',JSON_VALUE(AttributesCleansed,'$.Link'))-1),'https://','')
							       WHEN JSON_VALUE(AttributesCleansed,'$.Link') IS not null AND charindex('?',JSON_VALUE(AttributesCleansed,'$.Link'))=0 then replace(JSON_VALUE(AttributesCleansed,'$.Link'),'https://','')
							       WHEN JSON_VALUE(AttributesCleansed,'$.ReferrerURL') IS NOT NULL AND charindex('?',JSON_VALUE(AttributesCleansed,'$.ReferrerURL'))<>0  THEN REPLACE(REPLACE(LEFT(JSON_VALUE(AttributesCleansed,'$.ReferrerURL'),charindex('?',JSON_VALUE(AttributesCleansed,'$.ReferrerURL'))-1),'//',''),'https:','')
								   WHEN JSON_VALUE(AttributesCleansed,'$.ReferrerURL') IS NOT NULL AND replace(JSON_VALUE(AttributesCleansed,'$.ReferrerURL'),'https://','') like '%info.apprenticeships.gov.uk%' THEN 'info.apprenticeships.gov.uk'--+ISNULL(JSON_VALUE(AttributesCleansed,'$.WebpageURL'),'')
								   WHEN JSON_VALUE(AttributesCleansed,'$.ReferrerURL') IS NOT NULL AND charindex('?',JSON_VALUE(AttributesCleansed,'$.ReferrerURL'))=0 THEN REPLACE(REPLACE(JSON_VALUE(AttributesCleansed,'$.ReferrerURL'),'//',''),'https:','')
								 --  WHEN JSON_VALUE(AttributesCleansed,'$.ReferrerURL') IS NOT NULL AND replace(JSON_VALUE(AttributesCleansed,'$.ReferrerURL'),'https://','') like '%info.apprenticeships.gov.uk%' THEN 'info.apprenticeships.gov.uk'+ISNULL(JSON_VALUE(AttributesCleansed,'$.WebpageURL'),'')
								   ELSE ''
								   END as PrimaryLink
                        FROM (select *,REPLACE(REPLACE(substring(attributes,2,len(attributes)-2),'""','"'),' ','') as AttributesCleansed from Stg.MarketoLeadActivities MLA
                       WHERE ATTRIBUTES LIKE '%Referrer URL%' or Attributes like '%""Link"":%'
                          or ATTRIBUTES LIKE '%Query Parameters%' or Attributes like '%""Web Page URL"":%') mla
		               ) as Source
                 ON Target.MarketoGUID=Source.MarketoGUID
               WHEN MATCHED THEN UPDATE SET Target.primaryAtttributevalueId=TRY_CONVERT(bigint,CASE WHEN Source.PrimaryAttributeValueID='NULL' THEN NULL ELSE Source.PrimaryAttributeValueID END)
                                           ,Target.primaryattributevalue=CASE WHEN Source.primaryattributevalue='null' then NULL ELSE Source.primaryattributevalue END
				                           ,Target.ReferrerURL=CASE WHEN Source.ReferrerURL='null' then NULL ELSE Source.ReferrerURL END
										   ,Target.Link=CASE WHEN Source.Link='null' then NULL ELSE Source.Link END
										   ,Target.QueryParameters=CASE WHEN Source.QueryParameters='null' then NULL ELSE Source.QueryParameters END
										   ,Target.WebpageURL=CASE WHEN Source.WebpageURL='null' then NULL ELSE Source.WebpageURL END
										   ,Target.PrimaryLink=CASE WHEN Source.PrimaryLink='null' then NULL ELSE Source.PrimaryLink END
				                           ,Target.AsDm_UpdatedDate=getdate()
               WHEN NOT MATCHED BY TARGET 
               THEN INSERT (MarketoGUID
                           ,LeadId 
                           ,primaryAtttributevalueId 
                           ,primaryAttributeValue 
						   ,ReferrerURL 
                           ,Link 
                           ,QueryParameters
                           ,WebpageURL
                           ,PrimaryLink
                           ,AsDm_CreatedDate
			               ,AsDm_UpdatedDate) 
                    VALUES (Source.MarketoGUID
					       ,Source.LeadId
	                       ,TRY_CONVERT(bigint,CASE WHEN Source.PrimaryAttributeValueID='NULL' THEN NULL ELSE Source.PrimaryAttributeValueID END)
			               ,CASE WHEN Source.primaryattributevalue='null' then NULL ELSE Source.primaryattributevalue END
			               ,CASE WHEN Source.ReferrerURL='null' then NULL ELSE Source.ReferrerURL END
			               ,CASE WHEN Source.Link='null' then NULL ELSE Source.Link END
						   ,CASE WHEN Source.QueryParameters='null' then NULL ELSE Source.QueryParameters END
						   ,CASE WHEN Source.WebpageURL='null' then NULL ELSE Source.WebpageURL END
						   ,CASE WHEN Source.PrimaryLink='null' then NULL ELSE Source.PrimaryLink END
			               ,getdate()
			               ,getdate()
			               );


COMMIT TRANSACTION
END
 


 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 
END TRY

BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

    DECLARE @ErrorId int

  INSERT INTO Mgmt.Log_Error_Details
	  (UserName
	  ,ErrorNumber
	  ,ErrorState
	  ,ErrorSeverity
	  ,ErrorLine
	  ,ErrorProcedure
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,RunId
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'ImportMarketoBulkExtractTablesToPL',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunId

  END CATCH

GO
