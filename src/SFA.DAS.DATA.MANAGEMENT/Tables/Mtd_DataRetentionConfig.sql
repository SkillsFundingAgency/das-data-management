CREATE TABLE [Mtd].[DataRetentionConfig]
(
  DRC_Id BIGINT Identity(1,1) PRIMARY KEY
 ,SFCI_Id BIGINT
 ,DataSetName VARCHAR(25)
 ,DataSetTable VARCHAR(25)
 ,DataSetSchema VARCHAR(25)
 ,PrimaryJOINColumn  VARCHAR(50)
 ,RetentionPeriodInMonths INT
 ,SensitiveColumns VARCHAR(255)
 ,RetentionColumn VARCHAR(50)
 ,RefColumn  VARCHAR(50)
 ,RefDataSetTable  VARCHAR(50)
 ,RefDataSetSchema VARCHAR(50)
 ,PreImportRetention BIT
 ,PostImportRetention BIT
 ,IsActive BIT
 ,CreatedDate DATETIME2 default(getdate())
 ,UpdatedDate DATETIME2
 )

