CREATE TABLE [AsData_PL].[Comt_DataLockStatus]
(
	   [Id] bigint Primary Key not null
      ,[DataLockEventId] bigint not null
      ,[DataLockEventDatetime] datetime not null
      ,[PriceEpisodeIdentifier] nvarchar(25) not null
      ,[ApprenticeshipId] Bigint Not null
      ,[IlrTrainingCourseCode] nvarchar(20)
      ,[IlrTrainingType] tinyint
      ,[IlrActualStartDate] datetime
      ,[IlrEffectiveFromDate] datetime
      ,[IlrPriceEffectiveToDate] datetime
      ,[IlrTotalCost] decimal(18,0)
      ,[ErrorCode] int not null
      ,[Status] tinyint not null
      ,[TriageStatus] tinyint not null
      ,[ApprenticeshipUpdateId] bigint 
      ,[IsResolved] bit not null
      ,[EventStatus] tinyint not null
      ,[IsExpired] bit not null
      ,[Expired] datetime null
)
