CREATE TABLE [AsData_PL].[Va_SavedSearches]
(
	   SavedSearchesId bigint
      ,CandidateId bigint
      ,CreatedDateTime datetime2
      ,UpdatedDateTime datetime2
	  ,SearchLocation varchar(256)
	  ,KeyWords varchar(256)
	  ,WithInDistance varchar(256)
	  ,ApprenticeshipLevel varchar(256)
      ,SourceSavedSearchesId varchar(256)
      ,SourceDb varchar(100)
)
