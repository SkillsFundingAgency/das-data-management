CREATE TABLE [Stg].[CandidateConfig]
(
   CCId BIGINT IDENTITY(1,1) PRIMARY KEY
  ,SourceDb Varchar(255)
  ,Category Varchar(255)
  ,ShortCode Varchar(255)
  ,RunId BIGINT
)
