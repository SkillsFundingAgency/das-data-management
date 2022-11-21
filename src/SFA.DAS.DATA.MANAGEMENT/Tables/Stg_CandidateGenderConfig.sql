CREATE TABLE [Stg].[CandidateGenderConfig]
(
   CGId BIGINT IDENTITY(1,1) PRIMARY KEY
  ,SourceDb Varchar(255)
  ,Category Varchar(255)
  ,ShortCode Varchar(255)  
)
