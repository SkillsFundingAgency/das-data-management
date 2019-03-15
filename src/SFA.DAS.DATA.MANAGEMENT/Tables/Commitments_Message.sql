CREATE TABLE [Comt].[Message]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY, 
    [CommitmentId] BIGINT NOT NULL, 
    [Text] NVARCHAR(MAX) NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [Author] NVARCHAR(255) NOT NULL, 
    [CreatedBy] TINYINT NOT NULL, 
	[AsDm_Created_Date] datetime default(getdate()),
	[AsDm_Updated_Date] datetime default(getdate()),
	[Load_Id] int
    CONSTRAINT [FK_Message_Commitment] FOREIGN KEY ([CommitmentId]) REFERENCES [Comt].[Commitment]([Id])
)
GO

CREATE NONCLUSTERED INDEX [IX_Message_CommitmentId] ON [Comt].[Message] ([CommitmentId]) INCLUDE ([Author], [CreatedBy], [CreatedDateTime], [Text]) WITH (ONLINE = ON)