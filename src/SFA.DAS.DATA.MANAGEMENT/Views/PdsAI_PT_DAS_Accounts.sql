CREATE VIEW [Pds_AI].[PT_A]
	AS 
SELECT	   DISTINCT
        	COALESCE(Account.ApprenticeshipEmployerType, -1)   AS A1
           ,COALESCE(Account.CreatedDate, '9999-12-31')	       AS A2
		   ,Account.Id                                         AS A3
		   ,CASE WHEN AEA.AccountId IS NOT NULL THEN 1
		         ELSE 0
			 END                                               AS A6
		   ,CASE WHEN FAT.SenderAccountId is not null then 1
		         ELSE 0
			 END                                               AS A7	
		   ,Account.AsDm_UpdatedDateTime                       AS A8
		   ,COALESCE(TL.Amount,0)                              AS A9
FROM		ASData_PL.Acc_Account Account 
LEFT
JOIN        (SELECT distinct ale.accountid
               from ASData_PL.Acc_AccountLegalEntity ALE
               JOIN (SELECT DISTINCT EA.AccountLegalEntityId FROM ASData_PL.Acc_EmployerAgreement EA WHERE StatusId=2 and TemplateId=(SELECT MAX(TemplateId) from ASData_PL.Acc_EmployerAgreement))	AEA
                 ON        ale.Id=AEA.AccountLegalEntityId) AEA
  ON        AEA.AccountId=Account.Id
LEFT
JOIN        ASDATA_PL.Fin_AccountTransfers FAT
  ON        FAT.SenderAccountId=Account.Id
LEFT
JOIN       (select accountid,sum(amount)
              from asdata_pl.Fin_TransactionLine
          group by accountid
            having sum(amount)>0) TL
  ON      TL.AccountId=Account.Id

