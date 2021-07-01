CREATE TABLE [AsData_PL].[AED_CourseDemand]
(
	Id						uniqueidentifier, 
	ContactEmailAddress     varchar(255),
	OrganisationName		varchar(1000),
	NumberOfApprentices     int, 
	CourseId				int, 
	CourseTitle				varchar(1000),
	CourseLevel				int, 
	CourseRoute				varchar(500),
	LocationName			varchar(1000),
	Lat						float, 
	Long					float, 
	DateCreated				datetime, 
	EmailVerified			bit, 
	DateEmailVerified		datetime, 	
	Stopped					bit, 
	DateStopped				datetime, 	
	ExpiredCourseDemandId   uniqueidentifier, 
	EntryPoint				smallint,
	Asdm_UpdatedDateTime datetime2 default getdate()
)
