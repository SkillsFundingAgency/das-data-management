CREATE TABLE [AsData_PL].[Va_ApprenticeshipFrameWorkAndOccupation]
(
	 [ApprenticeshipFrameworkId] int
    ,[ApprenticeshipOccupationId] int
    ,FrameworkCodeName nvarchar(3)
    ,FrameworkShortName nvarchar(100)
    ,FrameWorkFullName nvarchar(200)
	,ApprenticeshipFrameworkStatus varchar(100)
    ,FrameworkClosedDate datetime
    ,[PreviousApprenticeshipOccupationId] int
    ,[StandardId] int
	,ApprenticeshipOccupationCodeName nvarchar(3)
	,ApprenticeshipOccupationShortName nvarchar(50)
	,ApprenticehipOccupationFullName nvarchar(100)
	,ApprenticeshipOccupationStatus varchar(100)
	,ApprenticeshipOccupationClosedDate datetime
)
