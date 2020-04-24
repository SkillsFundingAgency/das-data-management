CREATE TABLE [Stg].[RAA_ReferenceDataBankHolidays]
(
 SourseSK BIGINT IDENTITY(1,1) NOT NULL
,BinaryId VARCHAR(256)
,LastUpdatedDateTimeStamp Varchar(256)
,Division varchar(256)
,DivisionEvents Varchar(max)
,RunId bigint  default(-1)
,AsDm_CreatedDate datetime2 default(getdate()) 
,AsDm_UpdatedDate datetime2 default(getdatE())
)