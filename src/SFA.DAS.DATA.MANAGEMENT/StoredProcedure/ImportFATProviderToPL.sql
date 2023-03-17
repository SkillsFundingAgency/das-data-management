
CREATE PROCEDURE [dbo].[ImportFATProviderToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Manju Nagarajan
-- Create Date: 27/Feb/2023
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
			   ,'ImportFATProviderToPL'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		  WHERE StoredProcedureName='ImportFATProviderToPL'
			 AND RunId=@RunID

		BEGIN TRANSACTION

				 TRUNCATE TABLE [ASData_PL].[FAT_ROATPV2_Provider]
				
				set @DynSQL = ' INSERT [ASData_PL].[FAT_ROATPV2_Provider]
				(		[Id],																
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
						FATProvider.Id,
						coalesce(ComtProvider.UkPrn,FATProvider.UkPrn) as UkPrn,
						coalesce(ComtProvider.Name,FATProvider.LegalName) as Name,
						FATProvider.TradingName,
						FATProvider.EmployerSatisfaction,
						FATProvider.LearnerSatisfaction,
						FATProvider.Email,
						ComtProvider.[Created],
						ComtProvider.[Updated] 
				From	[Stg].[FAT_ROATPV2_Provider] FATProvider FULL OUTER JOIN stg.Comt_Providers  ComtProvider
				ON		FATProvider.UkPrn = ComtProvider.UKPRN  AND FATProvider.LegalName = ComtProvider.Name '
				
				exec SP_EXECUTESQL @DynSQL

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Comt_Providers' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Comt_Providers]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='FAT_ROATPV2_Provider' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[FAT_ROATPV2_Provider]
				
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
				'ImportFATProviderToPL',
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