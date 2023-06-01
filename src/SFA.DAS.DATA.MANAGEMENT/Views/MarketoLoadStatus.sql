CREATE VIEW [Mgmt].[MarketoLoadStatus]
as
WITH cte AS (
    SELECT * FROM (
        VALUES
            ('ImportMarketoProgramsToDMStaging','ImportMarketoReferenceTablesToPL'),
            ('ImportMarketoSmartCampaignsToDMStaging','ImportMarketoReferenceTablesToPL'),
			('ImportMarketoLeadActivitiesToDMStaging','ImportMarketoBulkExtractTablesToPL'),
			('ImportMarketoLeadsToDMStaging','ImportMarketoBulkExtractTablesToPL')
        ) AS a (StagingActivity, PLActivity)
    )

select b.RunId
		,b.ADFTaskType
		,a.StartDate 
		,a.EndDate 
		,b.Execution_status as StagingExecutionStatus
		,d.Execution_Status as PLExecutionStatus 
		,a.transactiontime
		from mgmt.Log_Marketo_Dates a
inner join mgmt.Log_Execution_Results b on a.LogId = b.LogId
left join cte c on c.StagingActivity = b.ADFTaskType
left join mgmt.Log_Execution_Results d on d.RunId = b.RunId
and d.StoredProcedureName = c.PLActivity
order by a.transactiontime 
GO