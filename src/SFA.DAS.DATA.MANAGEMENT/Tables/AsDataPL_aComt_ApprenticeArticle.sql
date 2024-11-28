CREATE TABLE [AsData_PL].[aComt_ApprenticeArticle]
(
	[Id] uniqueidentifier NOT NULL,
	[EntryId] nvarchar(200) NOT NULL,
	[IsSaved] bit NULL,
	[LikeStatus] bit NULL,
	[SaveTime] datetime2(7) NOT NULL,
	[LastSaveStatusTime] datetime2(7) NOT NULL,
	[Asdm_UpdatedDateTime] datetime2 default getdate(),
    CONSTRAINT PK_aComt_ApprenticeArticleId PRIMARY KEY CLUSTERED (Id,EntryId)
)