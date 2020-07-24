CREATE TABLE [Stg].[CandidateEthLookUp]
(
   SourceSK BIGINT IDENTITY(1,1) PRIMARY KEY
  ,EID BIGINT
  ,ShortName nvarchar(255)
  ,FullName nvarchar(255)
  ,SourceDb nvarchar(100)
)
