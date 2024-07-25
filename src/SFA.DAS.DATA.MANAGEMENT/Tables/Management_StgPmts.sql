CREATE TABLE [Mgmt].[Config_StgPmnts](
	SourceDBName NVARCHAR(200),
	SourceTable NVARCHAR(200),
	DestSchema NVARCHAR(200),
	DestTable NVARCHAR(200),
    LoadType NVARCHAR(20),  -- 'Full' or 'Incremental'
    WhereClause NVARCHAR(1000),
	ColumnsToInclude VARCHAR(MAX),
	MergeStoredProcedure NVARCHAR(200)
	)