CREATE VIEW [Pds_AI].[PT_F]
	AS 
SELECT [Id]                                       AS F1
      ,convert(NVarchar(500),HASHBYTES('SHA2_512',LTRIM(RTRIM(CONCAT(UkPrn , skl.SaltKey)))),2) AS F2
      ,[Age]                                      AS F3
	  ,SSA2.SectorSubjectAreaTier2                AS F4
      ,[ApprenticeshipLevel]                      AS F5
      ,[OverallCohort]                            AS F6
      ,[OverallAchievementRate]                   AS F7
      ,[AsDm_UpdatedDateTime]                     AS F8
  FROM [ASData_PL].[FAT2_NationalAchievementRate] FNAR
  LEFT
  JOIN (select distinct sectorsubjectareatier2,SectorSubjectAreaTier2Desc
          from ASData_PL.FAT2_SectorSubjectAreaTier2
         union 
        select 99,'All Sector Subject Area  Tier 2') SSA2
	ON SSA2.SectorSubjectAreaTier2Desc=FNAR.SectorSubjectArea
 CROSS
  JOIN (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType ='EmployerReference'  Order by SaltKeyID DESC ) Skl

