CREATE TABLE [lkp].[RP_QuestionTitles]
(
	[SequenceNumber]			INT NOT NULL,
	[SectionNumber]				INT NOT NULL,
	[PageId]					NVARCHAR(50) NOT NULL,
	[QuestionId]				NVARCHAR(50) NOT NULL,
	[Title]						NVARCHAR(250)
)
GO