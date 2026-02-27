	
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
				   ,'ImportFAT2SectorStandardToPL'
				   ,getdate()
				   ,0

			  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
			  WHERE StoredProcedureName='ImportFAT2SectorStandardToPL'
			  AND RunId=@RunID

			BEGIN TRANSACTION

				TRUNCATE TABLE [ASData_PL].[FAT2_StandardSector]

					set @DynSQL = 'INSERT INTO [ASData_PL].[FAT2_StandardSector]
						   (
								[StandardUId]
								,[IfateReferenceNumber]
								,[LarsCode]
								,[Status]
								,[VersionEarliestStartDate]
								,[VersionLatestStartDate]
								,[VersionLatestEndDate]
								,[Title]
								,[Level]
								,[ProposedTypicalDuration]
								,[ProposedMaxFunding]
								,[IntegratedDegree]
								,[VaApprenticeshipStandardId]
								,[OverviewOfRole]
								,[RouteCode]						   
								,[Route]
								,[AssessmentPlanUrl]
								,[ApprovedForDelivery]
								,[ApprenticeshipType]
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
								,[CoreDuties]
								,[TypicalDuration]
								,[MaxFunding]
								,[IsActive]
								,[VersionApprovedForDelivery]	
								,[EffectiveFrom]
								,[EffectiveTo]
								,[VersionMajor]
								,[VersionMinor]
								,[IsLatestVersion]								
							
								,[EPAChanged]
								,[CoronationEmblem]
								,[EpaoMustBeApprovedByRegulatorBody]
						   )				
					SELECT
					  std.[StandardUId]
					  ,std.[IfateReferenceNumber]
					  ,std.[LarsCode]
					  ,std.[Status]
					  ,std.[VersionEarliestStartDate]
					  ,std.[VersionLatestStartDate]
					  ,std.[VersionLatestEndDate]
					  ,std.[Title]
					  ,std.[Level]
					  ,std.[ProposedTypicalDuration]
					  ,std.[ProposedMaxFunding]
					  ,[IntegratedDegree]
					  ,AppStandard.[StandardId]
					  ,[OverviewOfRole]
					  ,[RouteCode]
					  ,tblRoute.[Name]
					  ,[AssessmentPlanUrl]
					  ,[ApprovedForDelivery]
					  ,std.[ApprenticeshipType]
					  ,[TrailBlazerContact]
					  ,[EqaProviderName]
					  ,[EqaProviderContactName]
					  ,[EqaProviderContactEmail]
					  ,[EqaProviderWebLink]
					  ,[Keywords]
					  ,[TypicalJobTitles]
					  ,std.[StandardPageUrl]
					  ,std.[Version]
					  ,[RegulatedBody]
					  ,[Skills]
					  ,[Knowledge]
					  ,[Behaviours]
					  ,[Duties]
					  ,[CoreAndOptions]
					  ,[IntegratedApprenticeship]
					  ,[Options]    
					  ,[CoreDuties]
					  ,AssessorStandard.[TypicalDuration]
					  ,AssessorStandard.[MaxFunding]
					  ,AssessorStandard.[IsActive]
					  ,AssessorStandard.[VersionApprovedForDelivery]
					  ,ComtStandard.EffectiveFrom
					  ,ComtStandard.EffectiveTo
					  ,ComtStandard.VersionMajor
					  ,ComtStandard.VersionMinor
					  ,ComtStandard.IsLatestVersion
				
					  ,std.[EPAChanged]
					  ,std.[CoronationEmblem]	
					  ,std.[EpaoMustBeApprovedByRegulatorBody]		 
					FROM [Stg].[FAT2_Standard] std JOIN [Stg].[FAT2_Route] tblRoute 
					ON std.[RouteCode] =  tblRoute.[Id]	LEFT JOIN [ASData_PL].[Va_ApprenticeshipStandard] AppStandard ON std.LarsCode = AppStandard.LarsCode AND std.Title = AppStandard.StandardFullName
					LEFT JOIN [stg].[Assessor_Standards] AssessorStandard ON std.LarsCode = AssessorStandard.LarsCode AND std.StandardUId = AssessorStandard.StandardUId
					LEFT JOIN [AsData_PL].[Comt_Standard] ComtStandard ON std.LarsCode = ComtStandard.LarsCode AND std.StandardUId = ComtStandard.StandardUId'

					 exec SP_EXECUTESQL @DynSQL

					IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='FAT2_Standard' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
					DROP TABLE [Stg].[FAT2_Standard]
				
					IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='FAT2_Sector' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
					DROP TABLE [Stg].[FAT2_Sector]

					IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Standards' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
					DROP TABLE [stg].[Assessor_Standards]

					IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Comt_Standard' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
					DROP TABLE [stg].[Comt_Standard]

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