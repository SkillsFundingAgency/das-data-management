CREATE TABLE [AsData_PL].[Va_ApprenticeshipFrameWorkAndOccupation]
(
	 ApprenticeshipFrameworkId INT IDENTITY(1,1) PRIMARY KEY
	,[SourceApprenticeshipFrameworkId] int
	,[ProgrammeId_v2] varchar(256)
	,[SourceDb] Varchar(100)
    ,[ApprenticeshipOccupationId] int
    ,FrameworkCodeName nvarchar(3)
    ,FrameworkShortName nvarchar(100)
    ,FrameWorkFullName nvarchar(200)
	,FrameworkTitle_v2 nvarchar(256)
	,ApprenticeshipFrameworkStatus varchar(100)
    ,FrameworkClosedDate datetime
    ,[PreviousApprenticeshipOccupationId] int
    ,[StandardId] int
	,ApprenticeshipOccupationCodeName nvarchar(3)
	,ApprenticeshipOccupationShortName nvarchar(50)
	,ApprenticehipOccupationFullName nvarchar(100)
	,ApprenticeshipOccupationStatus varchar(100)
	,ApprenticeshipOccupationClosedDate datetime
	,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
