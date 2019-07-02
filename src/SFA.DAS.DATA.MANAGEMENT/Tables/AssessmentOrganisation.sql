
CREATE TABLE [dbo].[AssessmentOrganisation]
(
	 [Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL 
    ,EPAOId nvarchar(100)
	,EPAO_Name nvarchar(255)
	,Data_Source varchar(255) 
	,Source_EPAOId int
	,AsDm_CreatedDate datetime2 default(getdate()) not null
	,AsDm_UpdatedDate datetime2 default(getdate()) not null
)


