
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
	   ,'Step-2'
	   ,'uSP_Import_Employer'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

  /* Get Employer Account Data into Temp Table */

IF OBJECT_ID ('tempdb..#tEmployerAccount') IS NOT NULL
DROP TABLE #tEmployerAccount

SELECT ETA.HashedId as EmpHashedId
      ,ETA.PublicHashedId as EmpPublicHashedId
	  ,ETA.Name as EmpName
      ,ETA.Created as AccountCreatedDate
	  ,ETA.Updated as AccountUpdatedDate
	  ,ETA.Id as Source_AccountId
INTO #tEmployerAccount
FROM Comt.Ext_Tbl_Accounts ETA

/* Full Refresh EmployerAccount*/

IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION

INSERT INTO dbo.EmployerAccount(EmpHashedId
              ,EmpPublicHashedID
              ,EmpName
			  ,AccountCreatedDate
			  ,AccountUpdatedDate
			  ,Data_Source
			  ,Source_AccountId) 
SELECT Source.EmpHashedId
	         , Source.EmpPublicHashedId
	         , Source.EmpName
			 , Source.AccountCreatedDate
			 , Source.AccountUpdatedDate
			 , 'Commitments-Accounts'
			 , Source.Source_AccountId
  FROM #tEmployerAccount Source

COMMIT TRANSACTION
END


/* Code for Delta */

 /*MERGE dbo.EmployerAccount as Target
 USING #tEmployerAccount as Source
    ON Target.EmpHashedID=Source.EmpHashedID
  WHEN MATCHED AND (Target.EmpPublicHashedId<>Source.EmpPublicHashedId
                  OR Target.EmpName<>Source.EmpName
				  OR Target.AccountCreatedDate<>Source.AccountCreatedDate
				  OR Target.AccountUpdatedDate<>Source.AccountUpdatedDate
				  OR Target.Source_AccountId<>Source.Source_AccountId
				  )
  THEN UPDATE SET Target.EmpPublicHashedId=Source.EmpPublicHashedId
                 ,Target.EmpName=Source.EmpName
	             ,Target.AccountCreatedDate=Source.AccountCreatedDate
				 ,Target.AccountUpdatedDate=Source.AccountUpdatedDate
                 ,Target.Asdm_UpdatedDate=getdate()
				 ,Target.Source_AccountId=Source.Source_AccountId
				 ,Target.Data_Source='Commitments-Accounts'
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (EmpHashedId
              ,EmpPublicHashedID
              ,EmpName
			  ,AccountCreatedDate
			  ,AccountUpdatedDate
			  ,Data_Source
			  ,Source_AccountId) 
       VALUES (Source.EmpHashedId
	         , Source.EmpPublicHashedId
	         , Source.EmpName
			 , Source.AccountCreatedDate
			 , Source.AccountUpdatedDate
			 , 'Commitments-Accounts'
			 , Source.Source_AccountId);

*/

  /* Get Employer Account Legal Entity Data into Temp Table */


IF OBJECT_ID ('tempdb..#tEmployerAccountLegalEntity') IS NOT NULL
DROP TABLE #tEmployerAccountLegalEntity

SELECT   ETAL.LegalEntityId 
        ,ETAL.PublicHashedId as LegalEntityPublicHashedId
        ,ETAL.Name as LegalEntityName
        ,ETAL.OrganisationType 
        ,ETAL.Address as LegalEntityAddress 
        ,ETAL.Created as LegalEntityCreatedDate 
        ,ETAL.Updated as LegalEntityUpdatedDate 
        ,ETAL.Deleted as LegalEntityDeletedDate 
		,ETAL.ID as Source_AccountLegalEntityId
		,ETAL.AccountId as Source_AccountId
		,EA.Id as EmployerAccountId
INTO #tEmployerAccountLegalEntity
FROM Comt.Ext_Tbl_AccountLegalEntities ETAL
LEFT
JOIN dbo.EmployerAccount EA
  ON EA.Source_AccountId=ETAL.AccountId

/* Full Refresh Employer Account Legal Entity*/

IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION


INSERT INTO dbo.EmployerAccountLegalEntity(LegalEntityId
			  ,LegalEntityPublicHashedId
			  ,LegalEntityName
			  ,OrganisationType
			  ,LegalEntityAddress
			  ,LegalEntityCreatedDate
			  ,LegalEntityUpdatedDate
			  ,LegalEntityDeletedDate
			  ,Data_Source
			  ,Source_AccountLegalEntityId
			  ,Source_AccountId
			  ,EmployerAccountId) 
SELECT Source.LegalEntityId
			 , Source.LegalEntityPublicHashedId
			 , Source.LegalEntityName
			 , Source.OrganisationType
			 , Source.LegalEntityAddress
			 , Source.LegalEntityCreatedDate
			 , Source.LegalEntityUpdatedDate
			 , Source.LegalEntityDeletedDate
			 , 'Commitments-AccountLegalEntity'
			 , Source.Source_AccountLegalEntityId
			 , Source.Source_AccountId
			 , Source.EmployerAccountId
  FROM #tEmployerAccountLegalEntity Source

COMMIT TRANSACTION
END

  /* Delta Code */
/*
 MERGE dbo.EmployerAccountLegalEntity as Target
 USING #tEmployerAccountLegalEntity as Source
    ON Target.LegalEntityPublicHashedId=Source.LegalEntityPublicHashedId
  WHEN MATCHED AND (Target.LegalEntityId<>Source.LegalEntityId
				  OR Target.LegalEntityPublicHashedId<>Source.LegalEntityPublicHashedId
				  OR Target.LegalEntityName<>Source.LegalEntityName
				  OR Target.OrganisationType<>Source.OrganisationType
				  OR Target.LegalEntityAddress<>Source.LegalEntityAddress
				  OR Target.LegalEntityCreatedDate<>Source.LegalEntityCreatedDate
				  OR Target.LegalEntityUpdatedDate<>Source.LegalEntityUpdatedDate
				  OR Target.LegalEntityDeletedDate<>Source.LegalEntityDeletedDate
				  OR Target.Source_AccountLegalEntityID<>Source.Source_AccountLegalEntityId
				  OR Target.Source_AccountId<>Source.Source_AccountId
				  OR Target.EmployerAccountId<>Source.EmployerAccountId
				  )
  THEN UPDATE SET Target.LegalEntityId=Source.LegalEntityId
				 ,Target.LegalEntityPublicHashedId=Source.LegalEntityPublicHashedId
				 ,Target.LegalEntityName=Source.LegalEntityName
				 ,Target.OrganisationType=Source.OrganisationType
				 ,Target.LegalEntityAddress=Source.LegalEntityAddress
				 ,Target.LegalEntityCreatedDate=Source.LegalEntityCreatedDate
				 ,Target.LegalEntityUpdatedDate=Source.LegalEntityUpdatedDate
				 ,Target.LegalEntityDeletedDate=Source.LegalEntityDeletedDate
				 ,Target.Data_Source='Commitments-AccountLegalEntity'
				 ,Target.Source_AccountLegalEntityID=Source.Source_AccountLegalEntityId
				 ,Target.Source_AccountId=Source.Source_AccountId
				 ,Target.EmployerAccountId=Source.EmployerAccountId
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (LegalEntityId
			  ,LegalEntityPublicHashedId
			  ,LegalEntityName
			  ,OrganisationType
			  ,LegalEntityAddress
			  ,LegalEntityCreatedDate
			  ,LegalEntityUpdatedDate
			  ,LegalEntityDeletedDate
			  ,Data_Source
			  ,Source_AccountLegalEntityId
			  ,Source_AccountId
			  ,EmployerAccountId) 
       VALUES (Source.LegalEntityId
			 , Source.LegalEntityPublicHashedId
			 , Source.LegalEntityName
			 , Source.OrganisationType
			 , Source.LegalEntityAddress
			 , Source.LegalEntityCreatedDate
			 , Source.LegalEntityUpdatedDate
			 , Source.LegalEntityDeletedDate
			 , 'Commitments-AccountLegalEntity'
			 , Source.Source_AccountLegalEntityId
			 , Source.Source_AccountId
			 , Source.EmployerAccountId);

			 */
 
 
 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION

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
