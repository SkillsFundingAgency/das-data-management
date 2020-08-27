CREATE PROCEDURE [dbo].[CreateDashboardRegistrationView]
(
   @RunId int
)
AS
-- ===========================================================================
-- Author:      Sarma EVani
-- Create Date: 27/07/2020
-- Description: Campaign Dashboard Registrations View
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
		   ,'CreateDashboardRegistrationView'
		   ,getdate()
		   ,0

	  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
	   WHERE StoredProcedureName='CreateDashboardRegistrationView'
		 AND RunId=@RunID


		DECLARE @VSQL1 NVARCHAR(MAX)
		DECLARE @VSQL2 VARCHAR(MAX)
		DECLARE @VSQL3 VARCHAR(MAX)
		DECLARE @VSQL4 VARCHAR(MAX)


		SET @VSQL1='
		if exists(select 1  from INFORMATION_SCHEMA.VIEWS    Where TABLE_NAME =''DAS_Dashboard_Registration'' And Table_Schema =''AsData_PL'')
			Drop View AsData_PL.DAS_Dashboard_Registration'
	    SET @VSQL2='
		Create View AsData_PL.DAS_Dashboard_Registration
		As	
		with SaltKeyData as 
		(
			Select TOP 1 SaltKeyID,SaltKey From AsData_PL.SaltKeyLog Where SourceType =''CampaignDashboard''  Order by SaltKeyID DESC 
		),
		regbasequery as 
		(
		SELECT		
					Case When Account.ApprenticeshipEmployerType = 2 Then NULL Else Account.ApprenticeshipEmployerType End AS AAET,  
					CASE 				
					WHEN Account.Id IS NOT NULL THEN convert(NVarchar(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(Account.Id, SaltKeyData.SaltKey)))),2)  					
					END AS AID,		
					AccountLegalEntity.Created AS LECD, 
					Case when AccountLegalEntity.SignedAgreementVersion != -1 Then AccountLegalEntity.SignedAgreementVersion Else NULL End AS ASV,
					SaltKeyID
		FROM		Acct.Ext_Tbl_AccountLegalEntity AccountLegalEntity
					FULL OUTER JOIN Acct.Ext_Tbl_Account Account 
					ON Account.Id = AccountLegalEntity.AccountId
					CROSS JOIN SaltKeyData 
					WHERE Account.CreatedDate >= ''01-Jan-2020''	
		)
		Select AID,AAET As ''L/NL'',ASV As any_ASV,RegistrationDate,DATEPART(m, RegistrationDate) as MonthNumber,datename(month,RegistrationDate) as [Month],SaltKeyID
		FROM 
		(		
				Select AIDwithMinLECD.AID,AIDWithOthers.AAET,AIDWithOthers.ASV,AIDwithMinLECD.MIN_LECD,
						Case when AIDWithOthers.ASV IS NOT NULL Then AIDwithMinLECD.MIN_LECD Else NULL End As RegistrationDate,SaltKeyID
				from
				(
					select AID,MIN(LECD) MIN_LECD from regbasequery group by AID
				) AIDwithMinLECD  join 
				(
					select AID,AAET,ASV,SaltKeyID from regbasequery group by  AID,AAET,ASV,SaltKeyID 
				) AIDWithOthers on AIDwithMinLECD.AID =  AIDWithOthers.AID 	
		) As finalQuery 
		Where RegistrationDate  IS NOT NULL'

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
			'CreateDashboardRegistrationView',
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

