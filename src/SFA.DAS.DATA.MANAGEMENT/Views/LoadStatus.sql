CREATE VIEW [Mgmt].[LoadStatus]
as
SELECT LR.RunId
	  ,LER.LogId
	  ,LER.StoredProcedureName
	  ,LER.Execution_Status
	  ,LER.Execution_Status_Desc
	--  ,LER.FullJobStatus
	  ,LER.StartDateTime
	  ,LER.EndDateTime
	  ,LED.ErrorMessage as ErrorMessage
	  ,ISNULL(LRC.SourceTableName,'N/A') as SourceTableName
	  ,ISNULL(LRC.TargetTableName,'N/A') as TargetTableName
	  ,LRC.SourceRecordCount as SourceRecordCount
	  ,LRC.TargetRecordCount as TargetRecordCount
	--  ,LRC.InvalidRecordCount as InvalidRecordCount
  FROM Mgmt.Log_RunId LR
  LEFT
  JOIN Mgmt.Log_Execution_Results LER
    ON LER.RunId=LR.RunId
  LEFT
  JOIN Mgmt.Log_Error_Details LED
    ON LED.ErrorId=LER.ErrorId
  LEFT
  JOIN Mgmt.Log_Record_Counts LRC
    ON LRC.LogId=LER.LogId
   AND LRC.RunId=LR.RunId
GO