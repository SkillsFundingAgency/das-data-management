/* Execute Stored Procedure */

EXEC [dbo].[Build_AS_DataMart]


IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Standards' AND TABLE_SCHEMA='ASData_PL' AND TABLE_TYPE='BASE TABLE')
DROP TABLE [ASData_PL].[Assessor_Standards]