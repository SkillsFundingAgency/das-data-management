CREATE TABLE [Comt].[PriceHistory]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY,
	[ApprenticeshipId] BIGINT NOT NULL, 
	[Cost] DECIMAL NOT NULL,
	[FromDate] DateTime NOT NULL,
	[ToDate] DateTime NULL,
	[AsDm_Created_Date] DateTime default(getdate()),
	[AsDm_Updated_Date] DateTime default(getdate()),
	[Load_Id] int,
	CONSTRAINT [FK_PriceHistory_Apprenticeship] FOREIGN KEY ([ApprenticeshipId]) REFERENCES [Comt].[Apprenticeship]([Id])
)
GO

CREATE NONCLUSTERED INDEX [IX_PriceHistory_ApprenticeshipId] ON [Comt].[PriceHistory] ([ApprenticeshipId]) INCLUDE ([Cost], [FromDate], [ToDate]) WITH (ONLINE = ON)
