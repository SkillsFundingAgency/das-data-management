CREATE TABLE Stg.[FAA_Traineeships]
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId varchar(256)
 ,TypeCode varchar(256)
 ,EntityId varchar(256)
 ,EntityTypeCode varchar(256)
 ,DateCreatedTimeStamp varchar(256)
 ,DateUpdatedTimeStamp varchar(256)
 ,DateAppliedTimeStamp varchar(256)
 ,CandidateId varchar(256)
 ,LegacyApplicationId varchar(256)
 ,VacancyId varchar(256)
 ,VacancyReferenceNumber varchar(256) 
 ,ApplyViaEmployerWebsite varchar(256) 
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
)

