Create Table [ASData_PL].[Assessor_Certificates]
(
[Id]											[uniqueidentifier]		PRIMARY KEY NOT NULL,
[AchievementDate]								[DateTime2](7)			NULL,
[BatchNumber]								    [Int]					NULL,
[CertificateReference]							[NVarchar](50)			NULL,
[CertificateReferenceId]						[Int]					NULL,
[ContactOrganisation]							[NVarchar](200)			NULL,
[ContactPostCode]								[NVarchar](20)			NULL,
[CourseOption]									[NVarchar](200)			NULL,
[EPADate]										[DateTime2](7)			NULL,
[CreatedAt]										[DateTime2](7)			NULL,
[CreatedBy]										[NVarchar](100)			NULL,
[CreateDay]										[Date]					NULL,	
[DeletedAt]										[DateTime2](7)			NULL,
[Department]									[NVarchar](200)			NULL,
[IsPrivatelyFunded]								[Bit]					NULL,
[LearningStartDate]								[DateTime2](7)			NULL,
[OrganisationId]								[uniqueidentifier]		NULL,
[OverallGrade]									[NVarchar](100)			NULL,
[PrivatelyFundedStatus]							[NVarchar](20)			NULL,
[ProviderName]									[NVarchar](200)			NULL,
[ProviderUkPrn]									[Int]					NULL,
[Registration]									[NVarchar](100)			NULL,
[StandardCode]									[Int]					NULL,
[StandardLevel]									[Int]					NULL,
[StandardName]									[NVarchar](200)			NULL,
[StandardPublicationDate]						[DateTime2](7)			NULL,
[StandardReference]								[NVarchar](100)			NULL,
[StandardUId]									[NVarchar](50)			NULL,
[Status]										[NVarchar](20)			NULL,
[ToBePrinted]									[DateTime2](7)			NULL,
[Uln]											[BigInt]				NULL,
[UpdatedAt]										[DateTime2](7)			NULL,
[Version]										[Varchar](10)			NULL,
[AsDm_UpdatedDateTime]							[Datetime2](7)			default getdate()
)

CREATE NONCLUSTERED INDEX IDX_Certificates_Active 
ON [ASData_PL].[Assessor_Certificates] ([Id], [Status]) 
WHERE DeletedAt IS NULL;