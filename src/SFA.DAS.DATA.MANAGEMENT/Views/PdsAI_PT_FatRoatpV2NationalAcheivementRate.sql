CREATE VIEW [Pds_AI].[PT_FRoatpV2]
	AS 
SELECT FNAR.[Id]                                       AS F1
      ,convert(NVarchar(500),HASHBYTES('SHA2_512',LTRIM(RTRIM(CONCAT(FP.UkPrn , skl.SaltKey)))),2) AS F2
      ,FNAR.[Age]                                      AS F3
	  ,SSA2.SectorSubjectAreaTier2                AS F4
      ,FNAR.[ApprenticeshipLevel]                      AS F5
      ,FNAR.[OverallCohort]                            AS F6
      ,FNAR.[OverallAchievementRate]                   AS F7
      ,FNAR.[AsDm_UpdatedDateTime]                     AS F8
  FROM [ASData_PL].[FAT_ROATPV2_NationalAchievementRate] FNAR
  LEFT
  JOIN
  [ASData_PL].[FAT_ROATPV2_Provider] FP ON FP.Id = FNAR.ProviderId
  LEFT
  JOIN (select distinct sectorsubjectareatier2,SectorSubjectAreaTier2Desc
          from ASData_PL.FAT2_SectorSubjectAreaTier2
         union 
        select 99,'All Sector Subject Area  Tier 2') SSA2
	ON SSA2.SectorSubjectAreaTier2Desc=FNAR.SectorSubjectArea
 CROSS
  JOIN (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType ='EmployerReference'  Order by SaltKeyID DESC ) Skl 

