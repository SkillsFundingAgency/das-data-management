CREATE VIEW [Pds_AI].[PT_F]
	AS 
SELECT distinct FNAR.[Id]                                       AS F1
      ,convert(NVarchar(500),HASHBYTES('SHA2_512',LTRIM(RTRIM(CONCAT(FP.UkPrn , skl.SaltKey)))),2) AS F2
      ,FNAR.[Age]                                      AS F3
      ,SSA1.SectorSubjectAreaTier1                     AS F4
      ,FNAR.[ApprenticeshipLevel]                      AS F5
      ,FNAR.[OverallCohort]                            AS F6
      ,FNAR.[OverallAchievementRate]                   AS F7
      ,FNAR.[AsDm_UpdatedDateTime]                     AS F8
  FROM [ASData_PL].[FAT_ROATPV2_NationalAchievementRate] FNAR
  LEFT
  JOIN
  [ASData_PL].[FAT_ROATPV2_Provider] FP ON FP.UkPrn = FNAR.UkPrn
  LEFT
  JOIN (select distinct sectorsubjectareatier1,SectorSubjectAreaTier1Desc
          from ASData_PL.FAT2_SectorSubjectAreaTier1
         union 
        select 99,'All Sector Subject Area  Tier 1') SSA1
	ON SSA1.SectorSubjectAreaTier1Desc=FNAR.SectorSubjectAreaTier1
 CROSS
  JOIN (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType ='EmployerReference'  Order by SaltKeyID DESC ) Skl 

