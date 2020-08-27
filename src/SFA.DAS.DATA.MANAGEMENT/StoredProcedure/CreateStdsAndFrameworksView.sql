CREATE PROCEDURE [dbo].[CreateStdsAndFrameworksView]
(
   @RunId int
)
AS
-- ===========================================================================
-- Author:      Sarma EVani
-- Create Date: 27/07/2020
-- Description: Standards and Frameworks data view
-- ===========================================================================

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
		   ,'Step-4'
		   ,'CreateStdsAndFrameworksView'
		   ,getdate()
		   ,0

	  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
	   WHERE StoredProcedureName='CreateStdsAndFrameworksView'
		 AND RunId=@RunID


		DECLARE @VSQL1 NVARCHAR(MAX)
		DECLARE @VSQL2 VARCHAR(MAX)
		DECLARE @VSQL3 VARCHAR(MAX)
		DECLARE @VSQL4 VARCHAR(MAX)

		SET @VSQL1='
		if exists(select 1  from INFORMATION_SCHEMA.VIEWS    Where TABLE_NAME =''DAS_Dashboard_StdsAndFrameworks'' And Table_Schema =''AsData_PL'')
			Drop View AsData_PL.DAS_Dashboard_StdsAndFrameworks'
		SET @VSQL2='
		Create View AsData_PL.DAS_Dashboard_StdsAndFrameworks
		As 	
			select cast(AppStd.[LarsCode] As varchar(100)) as Code,[StandardFullName] Name,AppStdRoute.Route,Avms_Standard.EducationLevelNumber   As Level,''Standard'' As lookupDataType
			from ASData_PL.Va_ApprenticeshipStandard AppStd JOIN [Stg].[Avms_Standard] Avms_Standard  
			on AppStd.LarsCode = Avms_Standard.LarsCode JOIN AsData_PL.ApprenticeshipStdRoute AppStdRoute 
			on AppStd.LarsCode = AppStdRoute.LarsCode 
			where AppStdRoute.LarsCode != ''TBC'' 
			UNION 	
			Select ProgrammeId_v2 As Code,FrameworkTitle_v2 As Name,ApprenticehipOccupationFullName As Route,EducationLevelNumber As Level,''Framework'' As lookupDataType
			from [ASData_PL].[Va_ApprenticeshipFrameWorkAndOccupation] FrameworkData JOIN stg.RAA_ReferenceDataApprenticeshipProgrammes RefData 
			on FrameworkData.ProgrammeId_v2 =  RefData.ProgrammeId
			where [ProgrammeId_v2]  != ''N/A'''
			
		EXEC SP_EXECUTESQL @VSQL1 -- run check to drop view if it exists. 
		EXEC (@VSQL2) -- run sql to create view. 

		UPDATE Mgmt.Log_Execution_Results
		   SET Execution_Status=1
			  ,EndDateTime=getdate()
			  ,FullJobStatus='Pending'
		 WHERE LogId=@LogID
		   AND RunId=@RunId

 
END TRY
BEGIN CATCH
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
			'CreateStdsAndFrameworksView',
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
