CREATE PROCEDURE [dbo].[PopulateLTMReferenceData]
(
   @RunId int
)
AS
-- =======================================================
-- Author:      Sarma Evani
-- Create Date: 19/10/2021
-- Description: Populate LTM Reference Data
-- =======================================================

		BEGIN TRY

			SET NOCOUNT ON

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
			   ,'Step-3'
			   ,'PopulateLTMReferenceData'
			   ,getdate()
			   ,0

		   SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		   WHERE StoredProcedureName='PopulateLTMReferenceData'
			 AND RunId=@RunID


		IF @@TRANCOUNT=0
		BEGIN
		BEGIN TRANSACTION

			Set @DynSQL = 'Insert into [ASData_PL].[LTM_Pledge]
				(
					[Id],
					[EmployerAccountId],
					[Amount],
					[RemainingAmount],
					[IsNamePublic],
					[CreatedOn],
					[JobRoles],
					[Levels],
					[Sectors]					
				) 
				SELECT [Id]
					  ,[EmployerAccountId]
					  ,[Amount]
					  ,[RemainingAmount]
					  ,[IsNamePublic]
					  ,[CreatedOn]
					  ,[JobRoles]
					  ,[Levels]
					  ,[Sectors]
			    [stg].[LTM_Pledge]'
				exec SP_EXECUTESQL @DynSQL

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='LTM_Pledge' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				  DROP TABLE [stg].[LTM_Pledge]

				/*Loading Pledge Sector data */				
				DELETE FROM [ASData_PL].[LTM_PledgeSector]
				INSERT INTO [ASData_PL].[LTM_PledgeSector]
				(
					PledgeID,
					SectorValue,
					SectorDescription
				) 
				SELECT p.Id As PledgeID,l.FieldValue,l.FieldDesc 
				FROM [ASData_PL].[LTM_Pledge] p
				join [dbo].[ReferenceData] l on p.Sectors & l.FieldValue > 0 and l.Category = 'LevyTransferMatching' and l.FieldName = 'Sector' 
				order by 1,cast(l.FieldValue as int) asc


				/*Loading Pledge Level data */				
				DELETE FROM [ASData_PL].[LTM_PledgeLevel]
				INSERT INTO [ASData_PL].[LTM_PledgeLevel]
				(
					PledgeID,
					LevelValue,
					LevelDescription
				) 
				SELECT p.Id As PledgeID,l.FieldValue,l.FieldDesc 
				FROM [ASData_PL].[LTM_Pledge] p
				join [dbo].[ReferenceData] l on p.Levels & l.FieldValue > 0 and l.Category = 'LevyTransferMatching' and l.FieldName = 'Level' 
				order by 1,cast(l.FieldValue as int) asc

				/*Loading Pledge JobRole data */
				DELETE FROM [ASData_PL].[LTM_PledgeJobRole]
				INSERT INTO [ASData_PL].[LTM_PledgeJobRole]
				(
					PledgeID,
					JobRoleValue,
					JobRoleDescription
				) 
				SELECT p.Id As PledgeID,l.FieldValue,l.FieldDesc 
				FROM [ASData_PL].[LTM_Pledge] p
				join [dbo].[ReferenceData] l on p.jobRoles & l.FieldValue > 0 and l.Category = 'LevyTransferMatching' and l.FieldName = 'JobRole' 
				order by 1,cast(l.FieldValue as int) asc


			  IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='LTM_Pledge' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				  DROP TABLE [Stg].[FAT2_Framework]

		COMMIT TRANSACTION
		END

		/* Update Log Execution Results as Success if the query ran succesfully*/

		UPDATE Mgmt.Log_Execution_Results
		   SET Execution_Status=1
			  ,EndDateTime=getdate()
			  ,FullJobStatus='Pending'
		 WHERE LogId=@LogID
		   AND RunID=@RunId

 
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION

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
				'PopulateLTMReferenceData',
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
