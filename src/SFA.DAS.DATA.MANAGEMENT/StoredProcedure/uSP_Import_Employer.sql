
CREATE PROCEDURE uSP_Import_Employer
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Import Employer Related Data 
-- ==================================================

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
	   ,'uSP_Import_Employer'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

  /* Get Provider Data into Temp Table */

IF OBJECT_ID ('tempdb..#tEmployer') IS NOT NULL
DROP TABLE #tEmployer

SELECT ETA.HashedId as EmpHashedId
      ,ETA.PublicHashedId as EmpPublicHashedId
	  ,ETA.Name as EmpName
	  ,ETAL.LegalEntityId as LegalEntityId
	  ,ETAL.PublicHashedId as LegalEntityPublicHashedId
	  ,ETAL.Name as LegalEntityName
	  ,ETAL.OrganisationType as OrganisationType
	  ,ETAL.Address as LegalEntityAddress
	  ,ETAL.Created as LegalEntityCreatedDate
	  ,ETAL.Updated as LegalEntityUpdatedDate
	  ,ETAL.Deleted as LegalEntityDeletedDate
	  ,ETA.Id as Source_AccountId
INTO #tEmployer
FROM dbo.Ext_Tbl_Accounts ETA
LEFT
JOIN dbo.Ext_Tbl_AccountLegalEntities ETAL
  ON ETA.Id=ETAL.AccountId

 MERGE dbo.Employer as Target
 USING #tEmployer as Source
    ON Target.EmpHashedID=Source.EmpHashedID
   AND Target.LegalEntityId=Source.LegalEntityId
  WHEN MATCHED AND (Target.EmpPublicHashedId<>Source.EmpPublicHashedId
                  OR Target.EmpName<>Source.EmpName
				  OR Target.LegalEntityId<>Source.LegalEntityId
				  OR Target.LegalEntityPublicHashedId<>Source.LegalEntityPublicHashedId
				  OR Target.LegalEntityName<>Source.LegalEntityName
				  OR Target.OrganisationType<>Source.OrganisationType
				  OR Target.LegalEntityAddress<>Source.LegalEntityAddress
				  OR Target.LegalEntityCreatedDate<>Source.LegalEntityCreatedDate
				  OR Target.LegalEntityUpdatedDate<>Source.LegalEntityUpdatedDate
				  OR Target.LegalEntityDeletedDate<>Source.LegalEntityDeletedDate
				  OR Target.Source_AccountId<>Source.Source_AccountId
				  )
  THEN UPDATE SET Target.EmpPublicHashedId=Source.EmpPublicHashedId
                 ,Target.EmpName=Source.EmpName
				 ,Target.LegalEntityId=Source.LegalEntityId
				 ,Target.LegalEntityPublicHashedId=Source.LegalEntityPublicHashedId
				 ,Target.LegalEntityName=Source.LegalEntityName
				 ,Target.OrganisationType=Source.OrganisationType
				 ,Target.LegalEntityAddress=Source.LegalEntityAddress
				 ,Target.LegalEntityCreatedDate=Source.LegalEntityCreatedDate
				 ,Target.LegalEntityUpdatedDate=Source.LegalEntityUpdatedDate
				 ,Target.LegalEntityDeletedDate=Source.LegalEntityDeletedDate
                 ,Target.Asdm_UpdatedDate=getdate()
				 ,Target.Source_AccountId=Source.Source_AccountId
				 ,Target.Data_Source='Commitments-Accounts'
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (EmpHashedId
              ,EmpPublicHashedID
              ,EmpName
			  ,LegalEntityId
			  ,LegalEntityPublicHashedId
			  ,LegalEntityName
			  ,OrganisationType
			  ,LegalEntityAddress
			  ,LegalEntityCreatedDate
			  ,LegalEntityUpdatedDate
			  ,LegalEntityDeletedDate
			  ,Data_Source
			  ,Source_AccountId) 
       VALUES (Source.EmpHashedId
	         ,Source.EmpPublicHashedId
	         , Source.EmpName
			 , Source.LegalEntityId
			 , Source.LegalEntityPublicHashedId
			 , Source.LegalEntityName
			 , Source.OrganisationType
			 , Source.LegalEntityAddress
			 , Source.LegalEntityCreatedDate
			 , Source.LegalEntityUpdatedDate
			 , Source.LegalEntityDeletedDate
			 , 'Commitments-Accounts'
			 , Source.Source_AccountId);
 
 
 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
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
	  ,Run_Id
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'uSP_Import_Employer',
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
