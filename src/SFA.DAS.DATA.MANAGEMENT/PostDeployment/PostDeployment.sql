/* Execute Stored Procedure */

EXEC [dbo].[Build_AS_DataMart]


DROP TABLE If Exists Stg.Comt_PledgeSector
DROP TABLE If Exists [dbo].[ASDataPL_LTM_PledgeLocation]


DROP TABLE If Exists [ASData_PL].[LTM_PledgeSector]
DROP TABLE If Exists [ASData_PL].[LTM_PledgeRole]
DROP TABLE If Exists [ASData_PL].[LTM_PledgeLevel]