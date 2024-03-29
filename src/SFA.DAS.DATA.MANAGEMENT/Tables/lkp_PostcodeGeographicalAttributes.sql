﻿CREATE TABLE [lkp].[Postcode_GeographicalAttributes](
	[Pst_Postcode]							[varchar](8) NOT NULL,
	[Pst_Country]							[varchar](9) NULL,
	[Pst_GOR]								[varchar](9) NULL,
	[Pst_LEA]								[varchar](3) NULL,
	[Pst_LEA_UK]							[varchar](3) NULL,
	[Pst_County]							[varchar](9) NULL,
	[Pst_Local_Authority]					[varchar](9) NULL,
	[Pst_Local_Authority_Upper]				[varchar](9) NULL,
	[Pst_Ward]								[varchar](9) NULL,
	[Pst_Constituency]						[varchar](9) NULL,
	[Pst_Output_Area]						[varchar](10) NULL,
	[Pst_Lower_Layer_SOA]					[varchar](9) NULL,
	[Pst_Lower_Layer_SOA2001]				[varchar](9) NULL,
	[Pst_Middle_Layer_SOA]					[varchar](9) NULL,
	[Pst_NHS_SHA]							[varchar](9) NULL,
	[Pst_Stnd_Stat_Reg]						[int] NULL,
	[Pst_Euro_Elec_Reg]						[varchar](9) NULL,
	[Pst_TEC_LEC]							[varchar](9) NULL,
	[Pst_Travel_Work_Area]					[varchar](9) NULL,
	[Pst_Prim_Care_Area]					[varchar](9) NULL,
	[Pst_ClinicalCommissGroup]				[varchar](9) NULL,
	[Pst_Cen_Area_Stat]						[varchar](6) NULL,
	[Pst_National_Park]						[varchar](9) NULL,
	[Pst_RuralUrbanClass2011]				[varchar](9) NULL,
	[Pst_BuiltUpArea]						[varchar](9) NULL,
	[Pst_BuiltUpAreaSubDiv]					[varchar](9) NULL,
	[Pst_WorkplaceZone2011]					[varchar](9) NULL,
	[Pst_Scot_Intermediate]					[varchar](9) NULL,
	[Pst_LEP_Primary]						[varchar](9) NULL,
	[Pst_LEP_Secondary]						[varchar](9) NULL,
	[Pst_Census_OA_Class]					[varchar](3) NULL,
	[Pst_Easting]							[int] NULL,
	[Pst_Northing]							[int] NULL,
	[Pst_PQI_Grid_Ref]						[int] NULL,
	[Pst_Intro_Date]						[date] NULL,
	[Pst_Termin_Date]						[date] NULL,
	[Pst_User_Type]							[int] NULL,
	[Pst_Version]							[varchar](15) NULL
) ON [Primary]
GO