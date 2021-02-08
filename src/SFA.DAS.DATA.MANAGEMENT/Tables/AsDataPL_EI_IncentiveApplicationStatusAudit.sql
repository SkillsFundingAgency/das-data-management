
CREATE TABLE [ASData_PL].[EI_IncentiveApplicationStatusAudit]
(
	[Id]											[uniqueidentifier]	Primary Key NOT NULL,
	[IncentiveApplicationApprenticeshipId]			[uniqueidentifier]				NOT NULL,
	[Process]										[nvarchar](20)					NOT NULL,
	[ServiceRequestTaskId]							[nvarchar](100)					NULL,
	[ServiceRequestDecisionReference]				[nvarchar](100)					NULL,
	[ServiceRequestCreatedDate]						[datetime2](7)					NULL,
	[CreatedDateTime]								[datetime2](7)					NOT NULL,
	[AsDm_UpdatedDateTime]							[datetime2](7)		DEFAULT (getdate())
) 
GO