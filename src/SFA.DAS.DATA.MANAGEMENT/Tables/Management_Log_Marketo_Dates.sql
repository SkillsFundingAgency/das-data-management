CREATE TABLE [Mgmt].[Log_Marketo_Dates] (
    [Id]                    BIGINT        IDENTITY (1, 1) NOT NULL,
    [LogId]                 BIGINT NOT NULL,
    [StartDate]             DATE NULL,
    [EndDate]               DATE NULL,
    [TransactionTime]       DATETIME2 DEFAULT CURRENT_TIMESTAMP ,
    CONSTRAINT [PK_LMD_ID] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_LMD_LogID] FOREIGN KEY ([LogId]) REFERENCES [Mgmt].[Log_Execution_Results] ([LogId])
);

