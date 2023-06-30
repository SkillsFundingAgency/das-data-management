
CREATE PROCEDURE [dbo].[ImportFATAuditToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Manju Nagarajan
-- Create Date: 30/June/2023
-- Description: Import, Transform and Load Audit Presentation Layer Table
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
			   ,'ImportFATAuditToPL'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		  WHERE StoredProcedureName='ImportFATAuditToPL'
			 AND RunId=@RunID

		BEGIN TRANSACTION

				 TRUNCATE TABLE [ASData_PL].[FAT_ROATPV2_Audit]
				
				set @DynSQL = ' INSERT [ASData_PL].[FAT_ROATPV2_Audit]
				(		[Id]	
					[UserAction] 
					[AuditDate] 
					[InitialState]
					[UpdatedState] 
					[UKPRN]	
					[LARSCode]
					[ProviderId]
					[IsApprovedByRegulator]					 												
				)
			select 	
						Id,
						[UserAction],
						[AuditDate],
						[InitialState],
						[UpdatedState],
						[UKPRN],
						[LARSCode],
						[ProviderId],
						[IsApprovedByRegulator],
				From	[Stg].[FAT_ROATPV2_Audit]'
				
				exec SP_EXECUTESQL @DynSQL				

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='FAT_ROATPV2_Audit' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[FAT_ROATPV2_Audit]
				
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
				'ImportFATAuditToPL',
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