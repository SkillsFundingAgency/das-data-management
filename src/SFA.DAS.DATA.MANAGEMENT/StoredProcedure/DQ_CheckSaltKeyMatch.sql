CREATE PROCEDURE [dbo].[DQ_CheckSaltKeyMatch]
(
   @RunId int
)
AS
BEGIN TRY

Declare @RecordCount INT;
Declare @Status BIT = 0;

select @RecordCount = COUNT(*)
FROM [ASData_PL].[Acc_Account] as a		
inner join [ASData_PL].[Acc_AccountHistory] as ah		
on a.id=ah.accountid		
inner join [ASData_PL].[Tpr_OrgDetails] as tpr		
on ah.payeref=tpr.empref;

SELECT @Status = CASE WHEN @RecordCount >0 THEN 1 ELSE 0 END

EXEC [dbo].[LogDQCheckStatus] @RunId, 'CheckSaltKeyMatch', @Status, NULL;

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
	    'DQ_CheckEmptyPLTables',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  END CATCH

GO