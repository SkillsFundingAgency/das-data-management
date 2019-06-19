--REVOKE UNMASK TO [Himabindu.Uddaraju@citizenazuresfabisgov.onmicrosoft.com]

--if exists (select * from sys.objects where name = 'Stg_FIC_Feedback' and type = 'u')
--DROP TABLE dbo.Stg_FIC_Feedback


EXEC Mgmt.USP_UnitTest1_CheckCounts


EXEC Mtd.usp_Manage_GA_Hierarchy_Metadata


EXEC mtd.usp_Manage_Commitments_Lookup


--GRANT UNMASK TO [Himabindu.Uddaraju@citizenazuresfabisgov.onmicrosoft.com]

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('dbo.Ext_Options') )
   DROP EXTERNAL TABLE dbo.Ext_Options
GO

CREATE EXTERNAL TABLE dbo.Ext_Options
(ID int,
 StdCode int,
 OptionName nvarchar(max)
 )
with (data_source=ASSDBConnection,Schema_Name='dbo',Object_Name='Options')


  INSERT INTO dbo.Ext_EPAO_Options
  (ID,StdCode,OptionName)
  SELECT ID
        ,StdCode
		,OptionName
	FROM dbo.Ext_Options







