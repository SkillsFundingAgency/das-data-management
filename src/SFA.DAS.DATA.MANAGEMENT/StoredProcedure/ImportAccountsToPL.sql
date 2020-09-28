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

				DELETE FROM [ASData_PL].[Acc_Account]

				INSERT [ASData_PL].[Acc_Account]
				(
						[Id],
						[HashedId],
						[Name],
						[CreatedDate],
						[ModifiedDate],
						[ApprenticeshipEmployerType],
						[PublicHashedId],
						[AsDm_UpdatedDateTime],
						[ComtAccountID],
						[ComtLevyStatus],
						[EIAccountID],
						[HasSignedIncentivesTerms]
				)
				SELECT 
					stgAcc.Id,
					stgAcc.HashedId,
					stgAcc.Name,
					stgAcc.CreatedDate,
					stgAcc.ModifiedDate,
					stgAcc.ApprenticeshipEmployerType,
					stgAcc.PublicHashedId,
					getdate(),
					stgcAcc.ID,
					stgcAcc.LevyStatus,
					stgEAcc.ID,
					stgEAcc.HasSignedIncentivesTerms
				FROM stg.Acc_Account stgAcc LEFT JOIN Stg.Comt_Accounts stgcAcc on 
				stgAcc.id = stgcAcc.id  LEFT JOIN Stg.EI_Accounts stgEAcc on stgAcc.Id = stgEAcc.Id
				group by stgAcc.Id,stgAcc.HashedId,stgAcc.Name,stgAcc.CreatedDate,
					stgAcc.ModifiedDate,stgAcc.ApprenticeshipEmployerType,stgAcc.PublicHashedId,
					stgcAcc.ID,stgcAcc.LevyStatus,
					stgEAcc.ID,stgEAcc.HasSignedIncentivesTerms

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='EI_Accounts' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[EI_Accounts]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Comt_Accounts' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Comt_Accounts]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Acc_Account' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Acc_Account]

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
  GO