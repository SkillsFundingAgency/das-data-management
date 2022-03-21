CREATE TABLE [Mgmt].[Log_Marketo_ExportJobDetails] (
    [LogId]          BIGINT      NOT NULL,
    [RunId]            BIGINT         NOT NULL DEFAULT(-1),
	[ADFTaskType] VARCHAR(256) NULL,
    [LogMessage]     VARCHAR (MAX) NULL,
    [LogDateTime]    DATETIME2 (7) default(Getdate()) NULL,
    CONSTRAINT [FK_MLD_RunId] FOREIGN KEY ([RunId]) REFERENCES [Mgmt].[Log_RunId] ([RunId])
);
