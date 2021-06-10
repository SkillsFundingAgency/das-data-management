/* Execute Stored Procedure */

EXEC [dbo].[Build_AS_DataMart]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AsDataPl_Assessor_OrganisationStandardVersion]') AND type in (N'U'))
DROP TABLE [dbo].[AsDataPl_Assessor_OrganisationStandardVersion]
GO