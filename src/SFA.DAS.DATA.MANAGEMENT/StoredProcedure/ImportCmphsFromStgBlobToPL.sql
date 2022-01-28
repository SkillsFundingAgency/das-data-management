
CREATE PROCEDURE [dbo].[ImportCmphsFromStgBlobToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 28/01/2022
-- Description: Transform and Load to PL Companies House Data that is imported from Blob to Stg.
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
			   ,'ImportCmphsFromStgBlobToPL'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		  WHERE StoredProcedureName='ImportCmphsFromStgBlobToPL'
			 AND RunId=@RunID

		BEGIN TRANSACTION

		        DELETE FROM ASData_PL.Cmphs_CompaniesHouseDataFromBlob

				INSERT INTO ASData_PL.Cmphs_CompaniesHouseDataFromBlob
				(CompanyNumber,CurrentAssets,Equity)
				select convert(NVarchar(500),HASHBYTES('SHA2_512',LTRIM(RTRIM(CONCAT(try_convert(varchar(200),CHN) , skl.SaltKey)))),2)
				      ,CurrentAssets,Equity
                  from (select [chn],[name],[value] from stg.CmphsDataFromBlob) cmp
                 pivot
                       (
                       MAX([VALUE])
                   for [Name] in (UKCompaniesHouseRegisteredNumber,CurrentAssets,Equity)
                       ) piv
				 CROSS
                  JOIN       (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType ='EmployerReference'  Order by SaltKeyID DESC ) Skl
				
				

				/* Drop Staging Table if PL is successful */

				--IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='CmphsDataFromBlob' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				--DROP TABLE [Stg].[CmphsDataFromBlob]

				
				
		COMMIT TRANSACTION

				UPDATE Mgmt.Log_Execution_Results
				   SET Execution_Status=1
					  ,EndDateTime=getdate()
					  ,FullJobStatus='Finish'
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
				'ImportCmphsFromStgBlobToPL',
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