CREATE PROCEDURE [dbo].[CreateEmployerTransferRelationshipView]
(
   @RunId int
)
AS
-- ===========================================================================
-- Author:      Simon Heath
-- Create Date: 03/10/2019
-- Description: Create Views for EmployerTransfersRElationship that mimics RDS view
-- ===========================================================================

BEGIN TRY


DECLARE @LogID int
DECLARE @Quote varchar(5) = ''''

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
	   ,'CreateEmployerTransferRelationshipView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateEmployerTransferRelationshipView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_Employer_Transfer_Relationship'')
Drop View Data_Pub.DAS_Employer_Transfer_Relationship
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[DAS_Employer_Transfer_Relationship]	AS 
	 SELECT     a.[Id]
      ,[SenderAccountId]
      ,[ReceiverAccountId]
	  , CASE WHEN [status] = 2
	            THEN ' + @Quote + 'Approved' + @Quote + '
			 WHEN [status] = 1
				THEN ' + @Quote + 'Pending'  + @Quote + '
		ELSE ' + @Quote + 'Rejected' + @Quote + '
		END [RelationshipStatus]
        ,isnull(d.UserID,0) AS [SenderUserId]
        ,isnull(e.UserID,0) as [ApproverUserId]
        ,isnull(f.UserID,0) as [RejectorUserId]
        ,g.CreatedDate as UpdateDateTime
	    ,Cast (1 AS BIT ) as [IsLatest]
      , b.Hashedid as [SenderDasAccountID]
      , c.Hashedid as [RecieverDasAccountID]
   from acct.Ext_Tbl_TransferConnectionInvitation a
     LEFT JOIN  acct.Ext_Tbl_Account b
   ON a.[SenderAccountId] = b.Id
     LEFT JOIN acct.Ext_Tbl_Account c
   ON a.ReceiverAccountID = c.Id
   LEFT join 
	      (
		    SELECT TransferConnectionInvitationID
			       , max(CreatedDate) as CreatedDate 
				   , max(UserId) as UserID
			FROM acct.Ext_Tbl_TransferConnectionInvitationChange
			WHERE [Status] = 1
			GROUP BY TransferConnectionInvitationID
		  ) d
	ON a.id = d.TransferConnectionInvitationID
	LEFT join 
	      (
		    SELECT TransferConnectionInvitationID
			       , max(CreatedDate) as CreatedDate 
				   , max(UserId) as UserID
			FROM acct.Ext_Tbl_TransferConnectionInvitationChange
			WHERE [Status] = 2
			GROUP BY TransferConnectionInvitationID
		  ) e
	ON a.id = e.TransferConnectionInvitationID
	LEFT join 
	      (
		    SELECT TransferConnectionInvitationID
			       , max(CreatedDate) as CreatedDate 
				   , max(UserId) as UserID
			FROM acct.Ext_Tbl_TransferConnectionInvitationChange
			WHERE [Status] = 3
			GROUP BY TransferConnectionInvitationID
		  ) f
	ON a.id = f.TransferConnectionInvitationID
	LEFT join 
	      (
		    SELECT TransferConnectionInvitationID,
			        max(CreatedDate) as CreatedDate 
			FROM acct.Ext_Tbl_TransferConnectionInvitationChange
			GROUP BY TransferConnectionInvitationID
		  ) g
	ON a.id = g.TransferConnectionInvitationID
'
-- SET @VSQL3='  ' 
-- SET @VSQL4='  ' 

EXEC SP_EXECUTESQL @VSQL1 -- run check to drop view if it exists. 
EXEC (@VSQL2) -- run sql to create view. 
-- +@VSQL3+@VSQL4) -- no 3 or 4 as small view. 

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
	    'CreateEmployerTransferRelationshipView',
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
