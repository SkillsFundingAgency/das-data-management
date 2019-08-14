CREATE TABLE [Mgmt].[Log_Error_Details] (
    [ErrorId]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [Run_Id]         BIGINT        NOT NULL,
    [UserName]       VARCHAR (100) NULL,
    [ErrorNumber]    BIGINT        NULL,
    [ErrorSeverity]  INT           NULL,
    [ErrorState]     INT           NULL,
    [ErrorLine]      INT           NULL,
    [ErrorProcedure] VARCHAR (MAX) NULL,
    [ErrorMessage]   VARCHAR (MAX) NULL,
    [ErrorDateTime]  DATETIME2 (7) NULL,
    CONSTRAINT [PK_LED_ErrorID] PRIMARY KEY CLUSTERED ([ErrorId] ASC),
    CONSTRAINT [FK_LED_RunId] FOREIGN KEY ([Run_Id]) REFERENCES [Mgmt].[Log_RunId] ([Run_Id])
);
