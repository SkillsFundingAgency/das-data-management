CREATE TABLE [dbo].[CandidateEthLookUp_FAAv2]
(
   ID BIGINT IDENTITY(1,1) PRIMARY KEY
  ,EthnicCode INT
  ,EthnicGroup nvarchar(255)
  ,EthnicSubGroup INT
  ,EthnicDesc nvarchar(100)
)
