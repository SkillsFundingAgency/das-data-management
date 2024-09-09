CREATE VIEW [ASData_PL].[DimGeography]
As
SELECT
    p.Pst_Postcode AS Postcode -- Spine table doesn't appear to have all the countys (eg buckinghamshire)
            , pg.Pst_GOR AS [Government Office Region code] 
            , pg.Pst_GOR_Gov_Off_Desc AS [Government Office Region] 
            , co.Pst_COUNTY AS [County_Council_Code]
            , co.Pst_COUNTY_Coun_Desc AS [County_Council] 
            , cnty.County AS County
            , pla.Pst_LOC_AUTH_TYPE AS [Local authority type code]
            , pla.Pst_LOC_AUTH_TYPE_Desc AS [Local authority type]
            , pla.Pst_LOCAL_AUTHORITY AS [Local authority code]
            , pla.Pst_LOCAL_AUTHO_Desc AS [Local authority]
            , pc.Pst_CONSTITUENCY AS [Constituency code]
            , pc.Pst_CONSTITUENC_Desc AS [Constituency]
            , lea.Pst_LEA AS [Local Education Authority code] 
            , lea.Pst_LEA_Loc_Educ_Auth_Desc AS [Local Education Authority] 
            , lep.LEP_Code AS [Local Enterprise Partnership Primary code] 
            , lep.LEP_Code_Desc AS [Local Enterprise Partnership Primary] 
            , lep2.LEP_Code AS [Local Enterprise Partnership Secondary code] 
            , lep2.LEP_Code_Desc AS [Local Enterprise Partnership Secondary] 
            , ca.Pst_COMBINED_AUTHORITY AS [Combined authority code]
            , ca.Pst_COMBINED_AUTHORITY_Desc AS [Combined authority]
            ,CASE WHEN Pst_GOR_Gov_Off_Desc = 'London' THEN 'London'
                  WHEN Pst_GOR_Gov_Off_Desc = 'South West' THEN 'South West'
             ELSE  COALESCE(na.National_Apprenticeship_Service_Area, '?')
              END National_Apprenticeship_Service_Area,
             CASE WHEN Pst_GOR_Gov_Off_Desc = 'London' THEN 'London and the South East'
                  WHEN Pst_GOR_Gov_Off_Desc = 'South West' THEN 'South'
	         ELSE  COALESCE(na.National_Apprenticeship_Service_Division, '?')
              END National_Apprenticeship_Service_Division
			,Latitude
			,Longitude
FROM [lkp].[Postcode_GeographicalAttributes] p
    LEFT JOIN [lkp].[Pst_GOR_20011_12_Format] pg
    ON p.PST_GOR = pg.PST_GOR
    LEFT JOIN [lkp].[Pst_COUNTY_20011_12_Format] co
    ON p.Pst_County = co.Pst_COUNTY
    LEFT JOIN [lkp].[PST_Local_Authority_20011_12_Format] pla
    ON p.Pst_Local_Authority = pla.Pst_LOCAL_AUTHORITY
    LEFT JOIN [lkp].[PST_CONSTITUENCY_20011_12_Format]  pc
    ON p.Pst_Constituency = pc.Pst_CONSTITUENCY
    LEFT JOIN [lkp].[Pst_LEA] lea
    ON p.Pst_LEA = lea.Pst_LEA
    LEFT JOIN  [lkp].[Pst_LEP_CODE] lep
    ON p.Pst_LEP_Primary = lep.LEP_Code
    LEFT JOIN [lkp].[Pst_LEP_CODE] lep2
    ON p.Pst_LEP_Secondary = lep2.LEP_Code
    LEFT JOIN [lkp].[Pst_COMBINED_AUTHORITY] ca
    ON p.Pst_Local_Authority = ca.Pst_LOCAL_AUTHORITY
    LEFT JOIN [lkp].[Pst_Local_Authority_20011_12_Format] la
    ON p.Pst_Local_Authority = la.Pst_LOCAL_AUTHORITY
    LEFT JOIN [lkp].[NatAppSerLookupData] Na
    ON la.[Pst_LOCAL_AUTHO_Desc] = na.[Pst_LOCAL_AUTHO_Desc]
	LEFT JOIN [Stg].[Pst_latlong] ll
	ON p.pst_postcode=ll.postcode 
    LEFT JOIN [Stg].[Pst_County] cnty
    ON  p.pst_postcode=cnty.postcode
