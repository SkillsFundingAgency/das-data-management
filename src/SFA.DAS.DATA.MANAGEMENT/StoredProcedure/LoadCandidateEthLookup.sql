﻿CREATE PROCEDURE [dbo].[LoadCandidateEthLookUp]
(
   @RunId int
)
AS

-- =======================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 27/07/2020
-- Description: Load Candidate Ethnicity Reference Data
-- =======================================================

BEGIN TRY

    SET NOCOUNT ON

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
	   ,'Step-3'
	   ,'LoadCandidateEthLookUp'
	   ,getdate()
	   ,0

   SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='LoadCandidateEthLookUp'
     AND RunId=@RunID


IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION
DELETE FROM dbo.CandidateEthLookUp


/* RAAv2 */

INSERT INTO dbo.CandidateEthLookUp
(FullName,SourceDb)
VALUES
 ('Unknown','RAAv2')
,('Unknown','RAAv2')
,( 'English / Welsh / Scottish / Northern Irish / British','RAAv2')
,('Irish','RAAv2')
,('Gypsy or Irish Traveller','RAAv2')
,('Any Other White background','RAAv2')
,('White and Black Caribbean','RAAv2')
,('White and Black African','RAAv2')
,('White and Asian','RAAv2')
,('Any Other Mixed / multiple ethnic background','RAAv2')
,('Indian','RAAv2')
,('Pakistani','RAAv2')
,('Bangladeshi','RAAv2')
,('Chinese','RAAv2')
,('Any other Asian background','RAAv2')
,('African','RAAv2')
,('Caribbean','RAAv2')
,('Any other Black / African / Caribbean background','RAAv2')
,('Arab','RAAv2')
,('Any other ethnic group','RAAv2')
,('Not provided','RAAv2')

/* RAAv1 */

INSERT INTO dbo.CandidateEthLookUp
(ShortName,FullName,SourceDb)
VALUES
 ('Please Select','Select a group first','RAAv1')
,('Asian or Asian British','Please Select','RAAv1')
,('Asian or Asian British','Bangladeshi','RAAv1')
,('Asian or Asian British','Indian','RAAv1')
,('Asian or Asian British','Pakistani','RAAv1')
,('Asian or Asian British','Other Asian Background','RAAv1')
,('Black or black British','Please Select','RAAv1')
,('Black or black British','African','RAAv1')
,('Black or black British','Caribbean','RAAv1')
,('Black or black British','Other black background','RAAv1')
,('Mixed','Please Select','RAAv1')
,('Mixed','White Asian','RAAv1')
,('Mixed','White and black African','RAAv1')
,('Mixed','White and black Caribbean','RAAv1')
,('Mixed','Other mixed background','RAAv1')
,('White','Please Select','RAAv1')
,('White','British','RAAv1')
,('White','Irish','RAAv1')
,('White','Other white background','RAAv1')
,('Chinese','Chinese','RAAv1')
,('Other (please specify)','Not applicable','RAAv1')
,('Don''t know or don''t want to say','Not applicable','RAAv1')


INSERT INTO dbo.CandidateEthLookUp_FAAv2
(EthnicCode,EthnicGroup,EthnicSubGroup,EthnicDesc )
VALUES
 (1,'White',1,'EnglishOrWelshOrScottishOrNorthernIrishOrBritish')
,(1,'White',2,'Irish')
,(1,'White',3,'Gypsy or Irish Traveller')
,(1,'White',4,'Any other White background')
,(2,'MixedOrMultiple',6,'White and Black Caribbean')
,(2,'MixedOrMultiple',7,'White and Black African')
,(2,'MixedOrMultiple',8,'White and Asian')
,(2,'MixedOrMultiple',9,' AnyOtherMixedBackground ')
,(3,'AsianOrAsianBritish',11,'Indian')
,(3,'AsianOrAsianBritish',12,'Pakistani')
,(3,'AsianOrAsianBritish',13,'Bangladeshi')
,(3,'AsianOrAsianBritish',14,'Chinese')
,(3,'AsianOrAsianBritish',15,'Any other Asian background')
,(4,'BlackOrAfricanOrCaribbeanOrBlackBritish',17,'African')
,(4,'BlackOrAfricanOrCaribbeanOrBlackBritish',18,'Caribbean')
,(4,'BlackOrAfricanOrCaribbeanOrBlackBritish',19,'AnyOtherBlackAfricanOrCaribbeanBackground ')
,(5,'Other',21,'Arab')
,(5,'Other',22,'AnyOtherEthnicGroup')
,(6,'PreferNotToSay',5,'PreferNotToSayWhite')
,(6,'PreferNotToSay',10,'PreferNotToSayMixed')
,(6,'PreferNotToSay',16,'PreferNotToSayAsian')
,(6,'PreferNotToSay',20,'PreferNotToSayBlack ')
,(6,'PreferNotToSay',23,'PreferNotToSayArab')


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
	    'LoadCandidateEthLookUp',
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
