CREATE TABLE [Mtd].[RefreshDatasetConfig]
(
	ILRSnapshotReference			Varchar(20),
	Dataset							Varchar(50),
	PaymentsExtractionDate			Date,
	DatamartRefreshDate				Date,
	Isprocessed						Smallint  DEFAULT(0)
)
GO
