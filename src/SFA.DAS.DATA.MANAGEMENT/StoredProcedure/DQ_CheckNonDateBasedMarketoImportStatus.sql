CREATE PROCEDURE [dbo].[DQ_CheckNonDateBasedMarketoImportStatus] (@RunId int)
AS
BEGIN TRY

    Declare @Status BIT = 0;

    Declare @FailedTasks VARCHAR(MAX);

    
    /****** Script for SelectTopNRows command from SSMS  ******/
		WITH cte
		AS (SELECT *
			FROM
			(
				VALUES
					('ImportMarketoCampaignsToDMStaging', 'ImportMarketoBulkExtractTablesToPL'),
					('ImportMarketoLeadProgramsToDMStaging', 'ImportMarketoBulkExtractTablesToPL')
			) AS a (StagingActivity, PLActivity)
		   ),
			 LoadStatus
		as (select c.*,
				   CASE
					   WHEN l.Execution_Status is NULL THEN
						   0
					   ELSE
						   l.Execution_Status
				   END StagingStatus,
				   CASE
					   WHEN l2.Execution_Status is NULL THEN
						   0
					   ELSE
						   l2.Execution_Status
				   END PLStatus
			from CTE c
				left JOIN [Mgmt].[Log_Execution_Results] l
					ON c.StagingActivity = l.ADFTaskType
					   AND CAST(l.[StartDateTime] AS DATE) = CAST(GETDATE() AS DATE)
					   AND l.Execution_Status = 1
				left JOIN [Mgmt].[Log_Execution_Results] l2
					ON c.PLActivity = l2.StoredProcedureName
					   AND CAST(l2.[StartDateTime] AS DATE) = CAST(GETDATE() AS DATE)
					   AND l2.Execution_Status = 1
		   )
		SELECT @FailedTasks = String_AGG(StagingActivity, ', ')		
		FROM LoadStatus
		where StagingStatus = 0
			  or PLStatus = 0


    IF (@FailedTasks IS NULL)
        SET @Status = 1;
	ELSE
		set @FailedTasks = CONCAT('Failed Tasks: ', @FailedTasks)

    EXEC [dbo].[LogDQCheckStatus] @RunId,
                                  'CheckNonDateBasedMarketoImportStatus',
                                  @Status,
                                  @FailedTasks;


END TRY
BEGIN CATCH

    DECLARE @ErrorId int

    INSERT INTO Mgmt.Log_Error_Details
    (
        UserName,
        ErrorNumber,
        ErrorState,
        ErrorSeverity,
        ErrorLine,
        ErrorProcedure,
        ErrorMessage,
        ErrorDateTime,
        RunId
    )
    SELECT SUSER_SNAME(),
           ERROR_NUMBER(),
           ERROR_STATE(),
           ERROR_SEVERITY(),
           ERROR_LINE(),
           'CheckNonDateBasedMarketoImportStatus',
           ERROR_MESSAGE(),
           GETDATE(),
           @RunId as RunId;

END CATCH

GO
