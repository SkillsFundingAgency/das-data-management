CREATE TABLE [Mgmt].[Config_StgPmnts](
	SourceDBName NVARCHAR(50),
	SourceTable NVARCHAR(200),
	DestTable NVARCHAR(200),
    LoadType NVARCHAR(10),  -- 'Full' or 'Incremental'
    WhereClause NVARCHAR(1000) 
	)