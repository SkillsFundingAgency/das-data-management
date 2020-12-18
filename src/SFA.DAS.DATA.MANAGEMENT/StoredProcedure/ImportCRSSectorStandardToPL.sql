
CREATE PROCEDURE [dbo].[ImportCRSSectorStandardToPL]
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
				   ,'ImportCRSSectorStandardToPL'
				   ,getdate()
				   ,0

			  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
			  WHERE StoredProcedureName='ImportCRSSectorStandardToPL'
			  AND RunId=@RunID

			BEGIN TRANSACTION

					DELETE FROM [ASData_PL].[CRS_SectorStandard]

					INSERT [ASData_PL].[CRS_SectorStandard]
					(												
						[Id],
						[Title],
						[Level],
						[IntegratedDegree],
						[OverviewOfRole],
						[RouteId],
						[Route],
						[Keywords],
						[TypicalJobTitles],
						[StandardPageUrl],
						[Version],
						[RegulatedBody],
						[Skills],
						[Knowledge],
						[Behaviours],
						[Duties],
						[CoreAndOptions]
					)
					select
						std.[Id],
						[Title],
						[Level],
						[IntegratedDegree],
						[OverviewOfRole],
						[RouteId],
						sector.[Route],
						[Keywords],
						[TypicalJobTitles],
						[StandardPageUrl],
						[Version],
						[RegulatedBody],
						[Skills],
						[Knowledge],
						[Behaviours],
						[Duties],
						[CoreAndOptions]
					FROM [Stg].[CRS_Standard] std JOIN [Stg].[CRS_Sector] sector 
					ON std.[RouteId] =  sector.[Id]		

					IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='CRS_Standard' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
					DROP TABLE [Stg].[CRS_Standard]
				
					IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='CRS_Sector' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
					DROP TABLE [Stg].[CRS_Sector]

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
				'ImportCRSSectorStandardToPL',
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