CREATE TABLE [Mgmt].[Log_Marketo_Dates] (
    [Id]                    BIGINT        IDENTITY (1, 1) NOT NULL,
    [LogId]                 BIGINT NOT NULL,
    [StartDate]             DATETIME2 NULL,
    [EndDate]               DATETIME2 NULL,
    [TransactionTime]       DATETIME2 DEFAULT CURRENT_TIMESTAMP ,
    [IsCompleted]           BIT DEFAULT 0,
    CONSTRAINT [PK_LMD_ID] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_LMD_LogID] FOREIGN KEY ([LogId]) REFERENCES [Mgmt].[Log_Execution_Results] ([LogId])
);

