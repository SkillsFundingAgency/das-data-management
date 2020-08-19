CREATE TABLE [dbo].[CandidateEthLookUp]
(
   CELId BIGINT IDENTITY(1,1) PRIMARY KEY
  ,ShortName nvarchar(255)
  ,FullName nvarchar(255)
  ,SourceDb nvarchar(100)
)
