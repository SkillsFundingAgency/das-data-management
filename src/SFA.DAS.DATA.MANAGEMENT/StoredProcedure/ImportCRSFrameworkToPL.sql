
CREATE PROCEDURE [dbo].[ImportCRSFrameworkToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Sarma Evani
-- Create Date: 17/Dec/2020
-- Description: Import, Transform and Load CRS Framework Presentation Layer Table
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
				   ,'ImportCRSFrameworkToPL'
				   ,getdate()
				   ,0

			  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
			  WHERE StoredProcedureName='ImportCRSFrameworkToPL'
			  AND RunId=@RunID

			BEGIN TRANSACTION

					DELETE FROM [ASData_PL].[CRS_Framework]

					INSERT [ASData_PL].[CRS_Framework]
					(												
							[Id],
							[FrameworkOccupationId],
							[Title],
							[FrameworkName],
							[PathwayName],
							[ProgType],
							[FrameworkCode],
							[PathwayCode],
							[Level],
							[TypicalLengthFrom],
							[TypicalLengthTo],
							[TypicalLengthUnit],
							[Duration],
							[CurrentFundingCap],
							[MaxFunding],
							[Ssa1],
							[Ssa2],
							[EffectiveFrom],
							[EffectiveTo],
							[IsActiveFramework],
							[ProgrammeType],
							[HasSubGroups],
							[ExtendedTitle]
					)
						SELECT [Id]
						  ,PLFrameWorkAndOccupation.ApprenticeshipFrameworkId
						  ,[Title]
						  ,[FrameworkName]
						  ,[PathwayName]
						  ,[ProgType]
						  ,[FrameworkCode]
						  ,[PathwayCode]
						  ,[Level]
						  ,[TypicalLengthFrom]
						  ,[TypicalLengthTo]
						  ,[TypicalLengthUnit]
						  ,[Duration]
						  ,[CurrentFundingCap]
						  ,[MaxFunding]
						  ,[Ssa1]
						  ,[Ssa2]
						  ,[EffectiveFrom]
						  ,[EffectiveTo]
						  ,[IsActiveFramework]
						  ,[ProgrammeType]
						  ,[HasSubGroups]
						  ,[ExtendedTitle]
				  FROM [Stg].[CRS_Framework] stgFramework LEFT JOIN 
				  [ASData_PL].[Va_ApprenticeshipFrameWorkAndOccupation] PLFrameWorkAndOccupation ON 
				  stgFramework.Id = PLFrameWorkAndOccupation.ProgrammeId_v2 AND    
				  stgFramework.FrameworkName = PLFrameWorkAndOccupation.FrameWorkFullName 				

					IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='CRS_Framework' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
					DROP TABLE [Stg].[CRS_Framework]
				
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
				'ImportCRSFrameworkToPL',
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