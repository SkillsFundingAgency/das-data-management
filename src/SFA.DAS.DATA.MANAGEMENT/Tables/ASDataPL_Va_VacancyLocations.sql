CREATE TABLE AsData_Pl.Va_VacancyLocations
(
 VacancyLocationsId BIGINT IDENTITY(1,1) PRIMARY KEY
,VacancyId bigint
,EmployerId int
,VacancyPostcode varchar(256)
,VacancyAddressLine1 nvarchar(max)
,VacancyAddressLine2 nvarchar(max)
,VacancyAddressLine3 nvarchar(max)
,VacancyAddressLine4 nvarchar(max)
,VacancyTown nvarchar(max)
,SourceVacancyLocationsId varchar(256)
,SourceDb varchar(100)
,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())

)