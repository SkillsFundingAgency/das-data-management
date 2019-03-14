
CREATE TABLE [Mgmt].[Deployment_Audit]
(Deployment_Id int identity(1,1) PRIMARY KEY,
 Deployment_Start_Time datetime,
 Deployment_End_Time datetime,
 Object_Group varchar(255),
 Object_Type varchar(255),
 Source_Object_Schema varchar(255),
 Source_Object_Name varchar(255),
 Target_Object_Schema varchar(255),
 Target_Object_Name varchar(255),
 Source_Object_Count int,
 Target_Object_Count int,
 Error_Count int,
 ExpectedToMatchCount bit)
 