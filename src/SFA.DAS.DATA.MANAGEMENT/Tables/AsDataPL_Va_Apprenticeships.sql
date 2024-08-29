CREATE TABLE AsData_PL.[Va_Apprenticeships]
(     
       Faa_ApprenticeshipID BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL
      ,CandidateId bigint
      ,ApplicationId bigint
      ,ApplicationGUID UNIQUEIDENTIFIER
      ,VacancyId bigint
      ,VacancyReference varchar(256)
      ,CreatedDateTime datetime2
      ,UpdatedDateTime datetime2
      ,AppliedDateTime datetime2
      ,IsRecruitVacancy varchar(256)
      ,ApplyViaEmployerWebsite varchar(256)
      ,SuccessfulDateTime datetime2
      ,UnsuccessfulDateTime datetime2
      ,WithdrawalDateTime datetime2
      ,WithDrawnOrDeclinedReason nvarchar(max)
      ,UnsuccessfulReason nvarchar(max)
      ,SourceApprenticeshipId varchar(256)
      ,SourceDb varchar(100)
      ,MigrationDate datetime2
      ,[Status] varchar(100)
	 ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
      ,Foreign Key (CandidateId)  References [AsData_PL].[Va_Candidate](CandidateId)
      ,Foreign Key (VacancyId) References [AsData_PL].[Va_Vacancy](VacancyId) 
 )