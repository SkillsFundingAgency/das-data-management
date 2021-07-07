CREATE TABLE [Mtd].[DataRetentionConfig]
(
  DRC_Id BIGINT Identity(1,1) PRIMARY KEY
 ,SFCI_Id BIGINT
 ,DataSetName VARCHAR(25)
 ,DataSetTable VARCHAR(25)
 ,SensitiveColumns VARCHAR(255)
 ,PreImportRetention BIT
 ,PostImportRetention BIT
 ,IsActive BIT
 ,CreatedDate DATETIME2 default(getdate())
 ,UpdatedDate DATETIME2
 )

