-- Constrained to single row, see https://stackoverflow.com/questions/3967372/sql-server-how-to-constrain-a-table-to-contain-a-single-row

CREATE TABLE [Comt].[JobProgress]
(
    Lock char(1) NOT NULL DEFAULT 'X',
	[AddEpa_LastSubmissionEventId] [bigint] NULL,
	[IntTest_SchemaVersion] [int] NULL, 
	[AsDm_Created_Date] datetime default(getdate()),
	[AsDm_Updated_Date] datetime default(getdate()),
	[Load_Id] int,
    constraint PK_JobProgress PRIMARY KEY (Lock),
    constraint CK_JobProgress_Locked CHECK (Lock='X')
)