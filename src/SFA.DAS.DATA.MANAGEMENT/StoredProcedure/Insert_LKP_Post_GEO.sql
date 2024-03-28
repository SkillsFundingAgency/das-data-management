CREATE PROCEDURE dbo.InsertLkpPostGeo
AS 
BEGIN 
INSERT INTO [lkp].[Postcode_GeographicalAttributes]
           ([Pst_Postcode]
           ,[Pst_Country]
           ,[Pst_GOR]
           ,[Pst_LEA]
           ,[Pst_LEA_UK]
           ,[Pst_County]
           ,[Pst_Local_Authority]
           ,[Pst_Local_Authority_Upper]
           ,[Pst_Ward]
           ,[Pst_Constituency]
           ,[Pst_Output_Area]
           ,[Pst_Lower_Layer_SOA]
           ,[Pst_Lower_Layer_SOA2001]
           ,[Pst_Middle_Layer_SOA]
           ,[Pst_NHS_SHA]
           ,[Pst_Stnd_Stat_Reg]
           ,[Pst_Euro_Elec_Reg]
           ,[Pst_TEC_LEC]
           ,[Pst_Travel_Work_Area]
           ,[Pst_Prim_Care_Area]
           ,[Pst_ClinicalCommissGroup]
           ,[Pst_Cen_Area_Stat]
           ,[Pst_National_Park]
           ,[Pst_RuralUrbanClass2011]
           ,[Pst_BuiltUpArea]
           ,[Pst_BuiltUpAreaSubDiv]
           ,[Pst_WorkplaceZone2011]
           ,[Pst_Scot_Intermediate]
           ,[Pst_LEP_Primary]
           ,[Pst_LEP_Secondary]
           ,[Pst_Census_OA_Class]
           ,[Pst_Easting]
           ,[Pst_Northing]
           ,[Pst_PQI_Grid_Ref]
           ,[Pst_Intro_Date]
           ,[Pst_Termin_Date]
           ,[Pst_User_Type]
           ,[Pst_Version])
     VALUES
           ('MK41 7PH'
, 'E92000001'
, 'E12000006'
, '822'
, '822'
, 'E99999999'
, 'E06000055'
,  NULL
, 'E05014502'
, 'E14000552'
, 'E00088358'
, 'E01017498'
, 'E01017498'
, 'E02003625'
, 'E18000006'
, 5
, 'E15000006'
, 'E24000004'
, 'E30000166'
, 'E16000104'
, 'E38000249'
, '09UDGQ   '
, 'E65000001'
, 'C1       '
, 'E34004993'
, 'E35001257'
, 'E33025663'
, 'E99999999'
, 'E37000057'
, 'NA'
, '5A2'
, 504456
, 251376
, 1
, '01/06/1998'
, NULL
, '0'
, 'Nov-23'																																			
)
INSERT INTO [lkp].[Postcode_GeographicalAttributes]
           ([Pst_Postcode]
           ,[Pst_Country]
           ,[Pst_GOR]
           ,[Pst_LEA]
           ,[Pst_LEA_UK]
           ,[Pst_County]
           ,[Pst_Local_Authority]
           ,[Pst_Local_Authority_Upper]
           ,[Pst_Ward]
           ,[Pst_Constituency]
           ,[Pst_Output_Area]
           ,[Pst_Lower_Layer_SOA]
           ,[Pst_Lower_Layer_SOA2001]
           ,[Pst_Middle_Layer_SOA]
           ,[Pst_NHS_SHA]
           ,[Pst_Stnd_Stat_Reg]
           ,[Pst_Euro_Elec_Reg]
           ,[Pst_TEC_LEC]
           ,[Pst_Travel_Work_Area]
           ,[Pst_Prim_Care_Area]
           ,[Pst_ClinicalCommissGroup]
           ,[Pst_Cen_Area_Stat]
           ,[Pst_National_Park]
           ,[Pst_RuralUrbanClass2011]
           ,[Pst_BuiltUpArea]
           ,[Pst_BuiltUpAreaSubDiv]
           ,[Pst_WorkplaceZone2011]
           ,[Pst_Scot_Intermediate]
           ,[Pst_LEP_Primary]
           ,[Pst_LEP_Secondary]
           ,[Pst_Census_OA_Class]
           ,[Pst_Easting]
           ,[Pst_Northing]
           ,[Pst_PQI_Grid_Ref]
           ,[Pst_Intro_Date]
           ,[Pst_Termin_Date]
           ,[Pst_User_Type]
           ,[Pst_Version])
     VALUES
           ('CH49 6QG'
, 'E92000001'
, 'E12000002'
, '344      '
, '344      '
, 'E99999999'
, 'E08000015'
, NULL
, 'E05000961'
, 'E14001044'
, 'E00037027'
, 'E01007302'
, 'E01007302'
, 'E02001484'
, 'E18000002'
, 8
, 'E15000002'
, 'E24000023'
, 'E30000168'
, 'E16000091'
, 'E38000208'
, '00CBFX   '
, 'E65000001'
, 'A1       '
, 'E34004654'
, 'E35000841'
, 'E33003218'
, 'E99999999'
, 'E37000022'
, 'NA       '
, '8C1      '
, 326735
, 387579
, 1
, '01/06/1998'
, NULL
, 0
, 'Nov-23'
)																																			

END