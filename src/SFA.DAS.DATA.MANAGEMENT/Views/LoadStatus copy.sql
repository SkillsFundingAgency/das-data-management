CREATE VIEW [Mgmt].[MarketoLoadStatus]
as
WITH cte AS (
    SELECT * FROM (
        VALUES
            ('ImportMarketoProgramsToDMStaging','ImportMarketoReferenceTablesToPL'),
            ('ImportMarketoProgramsToDMStaging','ImportMarketoReferenceTablesToPL'),
			('ImportMarketoLeadActivitiesToDMStaging','ImportMarketoBulkExtractTablesToPL')
        ) AS a (StagingActivity, PLActivity)
    )

select b.RunId
		,b.ADFTaskType
		,a.StartDate 
		,a.EndDate 
		,b.Execution_status as StagingExecutionStatus
		,d.Execution_Status as PLExecutionStatus 
		from mgmt.Log_Marketo_Dates a
inner join mgmt.Log_Execution_Results b on a.LogId = b.LogId
inner join cte c on c.StagingActivity = b.ADFTaskType
inner join mgmt.Log_Execution_Results d on d.RunId = b.RunId
and d.StoredProcedureName = c.PLActivity
GO