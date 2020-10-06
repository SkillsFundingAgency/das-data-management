CREATE TABLE [AsData_PL].[Campaign_Leads]
(
 LeadId bigint
,FirstName nvarchar(255)
,LastName nvarchar(255)
,EmailAddress nvarchar(255)
,CONSTRAINT [PK_ML_LeadId] PRIMARY KEY CLUSTERED([LeadId] ASC)
)
go