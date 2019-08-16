CREATE TABLE dbo.EmployerAccount
( Id INT IDENTITY(1,1) NOT NULL
 ,EmpHashedId NCHAR(6)
 ,EmpPublicHashedId NCHAR(6)
 ,EmpName nvarchar(255)
 ,AccountCreatedDate datetime2
 ,AccountUpdatedDate datetime2
 ,Data_Source varchar(255)
 ,Source_AccountId int
 ,RunId bigint default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate())
 ,AsDm_UpdatedDate datetime2 default(getdate())
 ,CONSTRAINT PK_EmployerAccount_Id PRIMARY KEY(ID)
 )
