CREATE TABLE [Mgmt].[Log_Execution_Results] (
    [LogId]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [RunId]                 BIGINT        NOT NULL DEFAULT(-1),
    [ErrorId]               BIGINT        NULL,
    [StepNo]                VARCHAR (100) NULL,
    [StoredProcedureName]   VARCHAR (100) NOT NULL,
    [Execution_Status]      BIT           NOT NULL,
    [Execution_Status_Desc] AS            (case when [Execution_Status]=(1) then 'Success' else 'Fail' end),
    [StartDateTime]         DATETIME2 (7) NULL,
    [EndDateTime]           DATETIME2 (7) NULL,
    [FullJobStatus]         VARCHAR (256) NULL,
    CONSTRAINT [PK_LER_LogID] PRIMARY KEY CLUSTERED ([LogId] ASC),
    CONSTRAINT [FK_LER_ErrorID] FOREIGN KEY ([ErrorId]) REFERENCES [Mgmt].[Log_Error_Details] ([ErrorId]),
    CONSTRAINT [FK_LER_RunID] FOREIGN KEY ([RunId]) REFERENCES [Mgmt].[Log_RunId] ([RunId])
);

