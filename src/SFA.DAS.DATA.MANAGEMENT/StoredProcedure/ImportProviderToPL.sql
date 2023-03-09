
CREATE PROCEDURE [dbo].[ImportProviderToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Sarma Evani
-- Create Date: 17/Dec/2020
-- Description: Import, Transform and Load Provider Presentation Layer Table
-- ==========================================================================================================
BEGIN TRY
		DECLARE @LogID int
		DECLARE @DynSQL   NVarchar(max)
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
			   ,'ImportProviderToPL'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		  WHERE StoredProcedureName='ImportProviderToPL'
			 AND RunId=@RunID

		BEGIN TRANSACTION

				TRUNCATE TABLE [ASData_PL].[Provider]
				
				set @DynSQL = ' INSERT [ASData_PL].[Provider]
				(																		
						[UkPrn],
						[Name],
						[TradingName],
						[EmployerSatisfaction],
						[LearnerSatisfaction],
						[Email],
						[Created],
						[Updated]												
				)
				select 						
						coalesce(ComtProvider.UkPrn,FAT2Provider.UkPrn),
						coalesce(ComtProvider.Name,FAT2Provider.Name),
						FAT2Provider.TradingName,
						FAT2Provider.EmployerSatisfaction,
						FAT2Provider.LearnerSatisfaction,
						FAT2Provider.Email,
						ComtProvider.[Created],
						ComtProvider.[Updated] 
				From	[Stg].[FAT2_Provider] FAT2Provider FULL OUTER JOIN stg.Comt_Providers  ComtProvider
				ON		FAT2Provider.UkPrn = ComtProvider.UKPRN  AND FAT2Provider.Name = ComtProvider.Name '
				
				exec SP_EXECUTESQL @DynSQL

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Comt_Providers' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Comt_Providers]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='FAT2_Provider' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[FAT2_Provider]
				
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
				'ImportProviderToPL',
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