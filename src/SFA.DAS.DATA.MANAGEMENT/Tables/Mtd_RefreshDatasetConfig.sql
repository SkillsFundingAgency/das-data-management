CREATE TABLE [Mtd].[RefreshDatasetConfig]
(
	ID int IDENTITY(1,1),
	ILRSnapshotReference			Varchar(20),
	Dataset							Varchar(50),
	PaymentsExtractionDate			Date,
	DatamartRefreshDate				Date,
	Isprocessed						Smallint  DEFAULT(0)
)
GO
