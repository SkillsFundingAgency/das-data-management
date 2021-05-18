CREATE PROCEDURE [dbo].[ImportAccountsToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Sarma Evani
-- Create Date: 25/09/2020
-- Description: Import, Transform and Load Accounts Presentation Layer Table
-- ==========================================================================================================

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
			   ,'Step-6'
			   ,'ImportAccountsToPL'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		   WHERE StoredProcedureName='ImportAccountsToPL'
			 AND RunId=@RunID

		BEGIN TRANSACTION

		DECLARE @VSQL NVARCHAR(MAX)

		DELETE FROM [ASData_PL].[Acc_Account]

        SET @VSQL='

			 INSERT [ASData_PL].[Acc_Account]
				(
						[Id],
						[HashedId],
						[Name],
						[CreatedDate],
						[ModifiedDate],
						[ApprenticeshipEmployerType],
						[PublicHashedId],											
						[ComtLevyStatus]						
				)
				SELECT 
					stgAcc.Id,
					stgAcc.HashedId,
					stgAcc.Name,
					stgAcc.CreatedDate,
					stgAcc.ModifiedDate,
					stgAcc.ApprenticeshipEmployerType,
					stgAcc.PublicHashedId,										
					stgcAcc.LevyStatus					
				FROM stg.Acc_Account stgAcc LEFT JOIN Stg.Comt_Accounts stgcAcc on stgAcc.id = stgcAcc.id 
				group by stgAcc.Id,stgAcc.HashedId,stgAcc.Name,stgAcc.CreatedDate,stgAcc.ModifiedDate,stgAcc.ApprenticeshipEmployerType,
						 stgAcc.PublicHashedId,stgcAcc.LevyStatus
              '

			  EXEC SP_EXECUTESQL @VSQL
				
				/*Insert ASData_PL.Acc_AccountLegalEntity*/

			  SET @VSQL=''
			  				
				DELETE FROM [ASData_PL].[Acc_AccountLegalEntity]

			  SET @VSQL='
				INSERT INTO [ASData_PL].[Acc_AccountLegalEntity]
						   ([Id]
						   ,[Name]
						   ,[AccountId]
						   ,[LegalEntityId]
						   ,[Created]
						   ,[Modified]
						   ,[SignedAgreementVersion]
						   ,[SignedAgreementId]
						   ,[PendingAgreementVersion]
						   ,[PendingAgreementId]
						   ,[Deleted]
						   ,[HasSignedIncentivesTerms]
						   ,[IncentivesVrfVendorId]
						   ,[IncentivesVrfCaseId]
						   ,[IncentivesVrfCaseStatus]
						   ,[IncentivesVrfCaseStatusLastUpdatedDateTime]
						   ,[Address]
						   )
				Select 
							 Acc_AccLegalEntity.Id
							,Acc_AccLegalEntity.Name
							,Acc_AccLegalEntity.AccountId
							,Acc_AccLegalEntity.LegalEntityId
							,Acc_AccLegalEntity.Created
							,Acc_AccLegalEntity.Modified
							,Acc_AccLegalEntity.SignedAgreementVersion
							,Acc_AccLegalEntity.SignedAgreementId
							,Acc_AccLegalEntity.PendingAgreementVersion
							,Acc_AccLegalEntity.PendingAgreementId
							,Acc_AccLegalEntity.Deleted	
							,EI_Acc.HasSignedIncentivesTerms
							,EI_Acc.VrfVendorId
						    ,EI_Acc.VrfCaseId
						    ,EI_Acc.VrfCaseStatus
						    ,EI_Acc.VrfCaseStatusLastUpdatedDateTime
							,Acc_AccLegalEntity.[Address]
					FROM     stg.Acc_AccountLegalEntity As Acc_AccLegalEntity  LEFT JOIN stg.EI_Accounts AS EI_Acc
							ON Acc_AccLegalEntity.Id = EI_Acc.AccountLegalEntityId   
							AND Acc_AccLegalEntity.LegalEntityId = EI_Acc.LegalEntityId
					GROUP BY Acc_AccLegalEntity.Id
							,Acc_AccLegalEntity.Name
							,Acc_AccLegalEntity.AccountId
							,Acc_AccLegalEntity.LegalEntityId
							,Acc_AccLegalEntity.Created
							,Acc_AccLegalEntity.Modified
							,Acc_AccLegalEntity.SignedAgreementVersion
							,Acc_AccLegalEntity.SignedAgreementId
							,Acc_AccLegalEntity.PendingAgreementVersion
							,Acc_AccLegalEntity.PendingAgreementId
							,Acc_AccLegalEntity.Deleted
							,EI_Acc.HasSignedIncentivesTerms
							,EI_Acc.VrfVendorId
						    ,EI_Acc.VrfCaseId
						    ,EI_Acc.VrfCaseStatus
						    ,EI_Acc.VrfCaseStatusLastUpdatedDateTime
							,Acc_AccLegalEntity.[Address]
              '
			   EXEC SP_EXECUTESQL @VSQL

               /* Delete and Transform Paye Data */

                DELETE FROM ASData_PL.Acc_Paye

				SET @VSQL='
				INSERT INTO ASData_PL.Acc_Paye
				(      [Ref]
	                  ,[Name]
				)
				SELECT convert(NVarchar(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(EmpRef, saltkeydata.SaltKey)))),2) 
				      ,[Name]
				  FROM Stg.Acc_Paye AP
				 CROSS JOIN (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType =''EmployerReference''  Order by SaltKeyID DESC ) SaltKeyData

				/* Delete and Transform Account History Data */

				DELETE FROM ASData_PL.Acc_AccountHistory

				INSERT INTO ASData_PL.Acc_AccountHistory
				(      [Id] 
	                  ,[AccountId]
	                  ,[PayeRef] 
	                  ,[AddedDate] 
	                  ,[RemovedDate]
				)
				SELECT [Id] 
	                  ,[AccountId]
	                  ,convert(NVarchar(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(EmpRef, saltkeydata.SaltKey)))),2) [PayeRef] 
	                  ,[AddedDate] 
	                  ,[RemovedDate]
				 FROM Stg.Acc_AccountHistory AP
				 CROSS JOIN (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType =''EmployerReference''  Order by SaltKeyID DESC ) SaltKeyData
				 '
				EXEC SP_EXECUTESQL @VSQL


				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='EI_Accounts' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[EI_Accounts]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Comt_Accounts' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Comt_Accounts]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Acc_Account' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Acc_Account]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Acc_AccountLegalEntity' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Acc_AccountLegalEntity]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Acc_Paye' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Acc_Paye]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Acc_AccountHistory' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Acc_AccountHistory]

		COMMIT TRANSACTION

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
				'ImportAccountsToPL',
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