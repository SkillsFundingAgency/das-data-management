CREATE VIEW [Pds_AI].[PT_A]
	AS 
SELECT	   DISTINCT
        	COALESCE(Account.ApprenticeshipEmployerType, -1)   AS A1
           ,COALESCE(Account.CreatedDate, '9999-12-31')	       AS A2
		   ,Account.Id                                         AS A3
		   ,ISNULL(Ale.Id ,-1)                                 AS A4
		   ,ISNULL(AH.PayeRef,'-1')                            AS A5
		   ,CASE WHEN AEA.AccountLegalEntityId IS NOT NULL THEN 1
		         ELSE 0
			 END                                               AS A6
		   ,CASE WHEN FAT.SenderAccountId is not null then 1
		         ELSE 0
			 END                                               AS A7	
		   ,Account.AsDm_UpdatedDateTime                       AS A8			
FROM		ASData_PL.Acc_Account Account 
LEFT
JOIN        ASData_PL.Acc_AccountLegalEntity ALE
  ON        Account.Id=ALE.AccountId
LEFT
JOIN        (SELECT DISTINCT EA.AccountLegalEntityId FROM ASData_PL.Acc_EmployerAgreement EA WHERE StatusId=2 and TemplateId=(SELECT MAX(TemplateId) from ASData_PL.Acc_EmployerAgreement))	AEA
  ON        ale.Id=AEA.AccountLegalEntityId
LEFT
JOIN        ASDATA_PL.Fin_AccountTransfers FAT
  ON        FAT.SenderAccountId=Account.Id
LEFT
JOIN        ASData_PL.Acc_AccountHistory AH
  ON        AH.AccountId=Account.Id
