CREATE TABLE [AsData_PL].[Va_LocalAuthority]
(
  LocalAuthorityId int primary key
 ,CodeName nchar(4)
 ,ShortName nvarchar(50)
 ,FullName nvarchar(100)
 ,CountyId int
 )