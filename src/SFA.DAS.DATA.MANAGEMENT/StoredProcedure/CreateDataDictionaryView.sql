﻿CREATE PROCEDURE [dbo].[CreateDataDictionaryView]
(
   @RunId int
)
AS

-- =========================================================================
-- Author:      Sarma Evani
-- Create Date: 24/09/2020
-- Description: Create Data Dictionary View
-- =====================================================================================================

BEGIN TRY


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
	   ,'Step-4'
	   ,'CreateDataDictionaryView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateDataDictionaryView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)


SET @VSQL1='

IF  EXISTS (SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DataDictionary'' AND TABLE_SCHEMA = ''dbo'' )
BEGIN
     DROP VIEW dbo.DataDictionary
END
'

set @VSQL2  = 'Create View dbo.DataDictionary As
with filterdata as 
(
		SELECT  ''ASData_PL'' As SchemaName,''SaltKeyLog'' As TableName,''BASE TABLE''  As TableType UNION		
		SELECT  ''ASData_PL'' As SchemaName,''Va_County'' As TableName,''BASE TABLE''  As TableType UNION		
		SELECT  ''ASData_PL'' As SchemaName,''Va_LocalAuthority'' As TableName,''BASE TABLE''  As TableType UNION		
		SELECT  ''dbo'' As SchemaName,''Apprentice'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''Apprenticeship'' As TableName,''BASE TABLE''  As TableType UNION 
		SELECT  ''dbo'' As SchemaName,''AssessmentOrganisation'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''CandidateEthLookUp'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''Commitment'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''DataLockStatus'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''Employer'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''EmployerAccount'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''Ext_EPAO_Options'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''EmployerAccountLegalEntity'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''Provider'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''ReferenceData'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''SourceDbChanges'' As TableName,''BASE TABLE''  As TableType UNION 
		SELECT  ''dbo'' As SchemaName,''Stg_FIC_Feedback'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''TrainingCourse'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''dbo'' As SchemaName,''Transfers'' As TableName,''BASE TABLE''  As TableType UNION 
		SELECT  ''Mtd'' As SchemaName,''SourceConfigForImport'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''Mgmt'' As SchemaName,''Log_Error_Details'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''Mgmt'' As SchemaName,''Log_Execution_Results'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''Mgmt'' As SchemaName,''Log_Record_Counts'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''Mgmt'' As SchemaName,''Log_RunId'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_Application'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ApplicationHistory'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ApplicationHistoryEvent'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ApplicationStatusType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ApprenticeshipFramework'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ApprenticeshipFrameworkStatusType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ApprenticeshipOccupation'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ApprenticeshipOccupationStatusType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ApprenticeshipType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_Candidate'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_CandidateDetails'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_County'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_EducationLevel'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_Employer'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_EmployerTrainingProviderStatus'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_LocalAuthority'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_LocalAuthorityGroup'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_LocalAuthorityGroupMembership'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_LocalAuthorityGroupType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_Provider'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ProviderSite'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ProviderSiteRelationship'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_ProviderSiteRelationshipType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_Standard'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_StandardSector'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_TrainingType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_Vacancy'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_VacancyHistory'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_VacancyHistoryEventType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_VacancyLocationType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_VacancyOwnerRelationship'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_VacancySource'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_VacancyStatusType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_WageType'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''Avms_WageUnit'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''CandidateConfig'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''CopyActivity'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''FAA_CandidateDetails'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''RAA_ApplicationReviews'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''RAA_ReferenceDataApprenticeshipProgrammes'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''RAA_ReferenceDataBankHolidays'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''RAA_ReferenceDataBannedPhrases'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''RAA_ReferenceDataCandidateSkills'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''RAA_ReferenceDataProfanities'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''RAA_ReferenceDataQualificationTypes'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''RAA_Users'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''RAA_Vacancies'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''Stg'' As SchemaName,''SQLCode'' As TableName,''BASE TABLE'' As TableType UNION
		SELECT  ''StgPmts'' As SchemaName,''DataMatchReport'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''StgPmts'' As SchemaName,''Job'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''StgPmts'' As SchemaName,''JobEvent'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''StgPmts'' As SchemaName,''JobEventStatus'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''StgPmts'' As SchemaName,''JobProviderEarnings'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''StgPmts'' As SchemaName,''JobStatus'' As TableName,''BASE TABLE''  As TableType UNION
		SELECT  ''StgPmts'' As SchemaName,''JobType'' As TableName,''BASE TABLE''  As TableType UNION		
		SELECT  ''Mgmt'' As SchemaName,''LoadStatus'' As TableName,''VIEW'' As TableType UNION
		SELECT  ''ASData_PL'' As SchemaName,''DAS_Dashboard_Registration'' As TableName,''VIEW'' As TableType UNION
		SELECT  ''ASData_PL'' As SchemaName,''DAS_Dashboard_Reservation'' As TableName,''VIEW'' As TableType UNION
		SELECT  ''ASData_PL'' As SchemaName,''DAS_Dashboard_ReservationAndCommitment'' As TableName,''VIEW'' As TableType UNION
		SELECT  ''ASData_PL'' As SchemaName,''DAS_Dashboard_ReservationAndTraining'' As TableName,''VIEW'' As TableType UNION
		SELECT  ''ASData_PL'' As SchemaName,''DAS_Dashboard_StdsAndFrameworks'' As TableName,''VIEW'' As TableType  
)
Select distinct DatamartEnvironment,Layer,SchemaRoleLink,DataElementCategory,DataElementId,DataElementDescription,DataElementType,DataElementMaxLength_InBytes,DataElementIsNullable,DataAvailableSince,DataOwner
FROM
(
	SELECT ''Production'' AS DatamartEnvironment,''Presentation'' AS Layer,SCHEMA_NAME(b.schema_id) AS SchemaRoleLink,b.name as DataElementCategory, cast(CONCAT(b.object_id,a.column_id) as bigint) AS DataElementId, a.name as DataElementDescription, UPPER(c.name) AS DataElementType, a.max_length AS DataElementMaxLength_InBytes, a.is_Nullable As DataElementIsNullable, Cast(b.create_date As Date) AS DataAvailableSince, ''AS Information Asset Owner'' AS DataOwner
	FROM sys.columns a
	JOIN sys.views b
	ON a.object_id = b.object_id
	LEFT JOIN sys.types as c
	ON a.user_type_id = c.user_type_id
) As ViewMetadata
WHERE lower(ltrim(rtrim(ViewMetadata.SchemaRoleLink)) + ''.'' + ltrim(trim(ViewMetadata.DataElementCategory))) NOT IN (Select lower(SchemaName + ''.'' + TableName)  from filterdata where TableType=''VIEW'')

UNION

Select distinct DatamartEnvironment,Layer,SchemaRoleLink,DataElementCategory,DataElementId,DataElementDescription,DataElementType,DataElementMaxLength_InBytes,DataElementIsNullable,DataAvailableSince,DataOwner
FROM
(
	SELECT ''Production'' AS DatamartEnvironment,''Presentation'' AS Layer,  SCHEMA_NAME(b.schema_id) AS SchemaRoleLink, b.name as DataElementCategory, cast(CONCAT(b.object_id,a.column_id) as bigint) AS DataElementId, a.name as DataElementDescription, UPPER(c.name) AS DataElementType, a.max_length AS DataElementMaxLength_InBytes, a.is_Nullable As DataElementIsNullable, Cast(b.create_date As Date) AS DataAvailableSince, ''AS Information Asset Owner'' AS DataOwner
	FROM sys.columns a
	JOIN sys.tables b
	ON a.object_id = b.object_id
	LEFT JOIN sys.types as c
	ON a.user_type_id = c.user_type_id
	Where b.is_external = 0
) As TableMetadata 
WHERE lower(ltrim(rtrim(TableMetadata.SchemaRoleLink)) + ''.'' + ltrim(trim(TableMetadata.DataElementCategory))) NOT IN (Select lower(SchemaName + ''.'' + TableName)  from filterdata where TableType=''BASE TABLE'')'


EXEC SP_EXECUTESQL @VSQL1
EXEC (@VSQL2)

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
	    'CreateDataDictionaryView',
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


