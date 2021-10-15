CREATE PROCEDURE [dbo].[ImportSubmittedApplicationAnswersToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Sarma Evani
-- Create Date: 15/Oct/2021
-- Description: Import, Transform and Load SubmittedApplicationAnswers Presentation Layer Table
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
			   ,'ImportSubmittedApplicationAnswersToPL'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		  WHERE StoredProcedureName='ImportSubmittedApplicationAnswersToPL'
			 AND RunId=@RunID

		BEGIN TRANSACTION

				DELETE FROM [ASData_PL].[RP_SubmittedApplicationAnswers]
				
				INSERT [ASData_PL].[RP_SubmittedApplicationAnswers]
				(																		
						[Id],
						[ApplicationId],
						[SequenceNumber],
						[SectionNumber],
						[PageId],
						[QuestionId],
						[QuestionType],
						[Answer],
						[ColumnHeading],
						[RowNumber],
						[ColumnNumber]
				)
						SELECT 
						[Id],
						[ApplicationId],
						[SequenceNumber],
						[SectionNumber],
						[PageId],
						[QuestionId],
						[QuestionType],
						ISNULL(Answer1,'') + ISNULL(Answer2,'')
						[ColumnHeading],
						[RowNumber],
						[ColumnNumber]
					FROM [Stg].[RP_SubmittedApplicationAnswers]						
								
				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='RP_SubmittedApplicationAnswers' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[RP_SubmittedApplicationAnswers]	
				
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
				'ImportSubmittedApplicationAnswersToPL',
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