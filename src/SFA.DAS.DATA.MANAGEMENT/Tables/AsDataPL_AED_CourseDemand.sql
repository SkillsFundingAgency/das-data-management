﻿CREATE TABLE [AsData_PL].[AED_CourseDemand]
(
	Id						uniqueidentifier, 	
	OrganisationName		varchar(1000),
	ContactEmailAddress		varchar(255),
	NumberOfApprentices     int, 
	CourseId				int, 
	CourseTitle				varchar(1000),
	CourseLevel				int, 
	CourseRoute				varchar(500),
	LocationName			varchar(1000),
	Lat						varchar(20), 
	Long					varchar(20), 
	DateCreated				datetime, 
	EmailVerified			bit, 
	DateEmailVerified		datetime, 	
	Stopped					bit, 
	DateStopped				datetime, 	
	ExpiredCourseDemandId   uniqueidentifier, 
	EntryPoint				smallint,
	Asdm_UpdatedDateTime datetime2 default getdate()
)
