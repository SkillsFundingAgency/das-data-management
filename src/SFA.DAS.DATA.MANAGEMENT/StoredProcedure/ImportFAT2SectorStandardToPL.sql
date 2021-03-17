
CREATE PROCEDURE [dbo].[ImportFAT2SectorStandardToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Sarma Evani
-- Create Date: 17/Dec/2020
-- Description: Import, Transform and Load FAT2 Framework Presentation Layer Table
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
				   ,'ImportFAT2SectorStandardToPL'
				   ,getdate()
				   ,0

			  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
			  WHERE StoredProcedureName='ImportFAT2SectorStandardToPL'
			  AND RunId=@RunID

			BEGIN TRANSACTION

				DELETE FROM [ASData_PL].[FAT2_StandardSector]

				INSERT INTO [ASData_PL].[FAT2_StandardSector]
					   (
						[StandardUId]
					   ,[IfateReferenceNumber]
					   ,[LarsCode]
					   ,[Status]
					   ,[EarliestStartDate]
					   ,[LatestStartDate]
					   ,[LatestEndDate]
					   ,[Title]
					   ,[Level]
					   ,[TypicalDuration]
					   ,[MaxFunding]
					   ,[IntegratedDegree]
					   ,[VaApprenticeshipStandardId]
					   ,[OverviewOfRole]
					   ,[RouteCode]
					   ,[SectorId]
					   ,[Sector]
					   ,[AssessmentPlanUrl]
					   ,[ApprovedForDelivery]
					   ,[TrailBlazerContact]
					   ,[EqaProviderName]
					   ,[EqaProviderContactName]
					   ,[EqaProviderContactEmail]
					   ,[EqaProviderWebLink]
					   ,[Keywords]
					   ,[TypicalJobTitles]
					   ,[StandardPageUrl]
					   ,[Version]
					   ,[RegulatedBody]
					   ,[Skills]
					   ,[Knowledge]
					   ,[Behaviours]
					   ,[Duties]
					   ,[CoreAndOptions]
					   ,[IntegratedApprenticeship]
					   ,[Options]
					   )				
				SELECT
				  [StandardUId]
				  ,[IfateReferenceNumber]
				  ,std.[LarsCode]
				  ,[Status]
				  ,[EarliestStartDate]
				  ,[LatestStartDate]
				  ,[LatestEndDate]
				  ,std.[Title]
				  ,[Level]
				  ,[TypicalDuration]
				  ,[MaxFunding]
				  ,[IntegratedDegree]
				  ,AppStandard.[StandardId]
				  ,[OverviewOfRole]
				  ,[RouteCode]
				  ,std.[RouteId]
				  ,sector.[Route]
				  ,[AssessmentPlanUrl]
				  ,[ApprovedForDelivery]
				  ,[TrailBlazerContact]
				  ,[EqaProviderName]
				  ,[EqaProviderContactName]
				  ,[EqaProviderContactEmail]
				  ,[EqaProviderWebLink]
				  ,[Keywords]
				  ,[TypicalJobTitles]
				  ,[StandardPageUrl]
				  ,[Version]
				  ,[RegulatedBody]
				  ,[Skills]
				  ,[Knowledge]
				  ,[Behaviours]
				  ,[Duties]
				  ,[CoreAndOptions]
				  ,[IntegratedApprenticeship]
				  ,[Options]      
				FROM [Stg].[FAT2_Standard] std JOIN [Stg].[FAT2_Sector] sector 
				ON std.[RouteId] =  sector.[Id]	LEFT JOIN [ASData_PL].[Va_ApprenticeshipStandard] AppStandard
				ON std.LarsCode = AppStandard.LarsCode AND std.Title = AppStandard.StandardFullName



					IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='FAT2_Standard' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
					DROP TABLE [Stg].[FAT2_Standard]
				
					IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='FAT2_Sector' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
					DROP TABLE [Stg].[FAT2_Sector]

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
				'ImportFAT2SectorStandardToPL',
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