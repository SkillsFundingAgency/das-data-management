CREATE VIEW [AsData_AI].[DAS_FPRFR]
	AS
SELECT  convert(NVarchar(500),HASHBYTES('SHA2_512',LTRIM(RTRIM(CONCAT(UkPrn , skl.SaltKey)))),2) AS E1
       ,prfr.rn                              AS E2
       ,[FeedbackCount]                      AS E3
       ,[AsDm_UpdatedDateTime]               AS E4
 FROM  [ASData_PL].[FAT2_ProviderRegistrationFeedbackRating] FPrfr
INNER
 JOIN  (SELECT  FeedbackName,row_number() over (order by FeedbackName desc) rn
          FROM (select distinct FeedbackName from AsData_PL.FAT2_ProviderRegistrationFeedbackRating) a) Prfr
   ON  FPrfr.FeedbackName=prfr.FeedbackName
CROSS
 JOIN (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType ='EmployerReference'  Order by SaltKeyID DESC ) Skl
