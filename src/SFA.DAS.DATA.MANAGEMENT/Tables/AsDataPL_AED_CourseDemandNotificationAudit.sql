CREATE TABLE [AsData_PL].[AED_CourseDemandNotificationAudit]
(
	Id						uniqueidentifier, 
	CourseDemandId			uniqueidentifier, 
	DateCreated				datetime, 
	NotificationType		smallint, 
	Asdm_UpdatedDateTime	datetime2 default getdate()
)
