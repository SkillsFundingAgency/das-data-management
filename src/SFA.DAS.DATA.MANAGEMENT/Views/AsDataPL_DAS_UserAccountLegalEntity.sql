CREATE VIEW [AsData_PL].[DAS_UserAccountLegalEntity]
	AS 
SELECT AA.HashedId                            as dasAccountId
      ,AALE.LegalEntityId                     as legalEntityId
      ,EAUU.ID                                as employerUserId
	  ,AA.PublicHashedId                      as publicHashedAccountId
	  ,AA.Name                                as accountName
	  ,CASE WHEN AA.Name='My Account' THEN 0
			ELSE 1
	    END                                   as accountStatus
	  ,AUR.Role                               as accountRole
	  ,AA.CreatedDate                         as accountCreatedDate
	  ,AA.ModifiedDate                        as accountModifiedDate
	  ,AA.ApprenticeshipEmployerType          as levyPayingEmployer
	  ,AALE.SignedAgreementId                 as signedAgreementId
	  ,SEA.Name                               as signedAgreementStatus
	  ,SEA.SignedDate                         as signedAgreementSignedDate
	  ,AALE.SignedAgreementVersion            as signedAgreementVersion
	  ,AALE.PendingAgreementId                as pendingAgreementId
	  ,PEA.Name                               as pendingAgreementStatus
	  ,AALE.PendingAgreementVersion           as pendingAgreementVersion
	  ,AALE.Created							  as legalEntityCreatedDate
	  ,AALE.Modified                          as legalEntityModifiedDate
  FROM ASData_PL.EAU_User EAUU
  LEFT
  JOIN ASData_PL.Acc_User AU
    ON EAUU.ID=AU.UserRef
  LEFT
  JOIN AsData_PL.Acc_AccountUserRole AUR
    ON AU.ID=AUR.UserId
  LEFT
  JOIN ASData_PL.Acc_Account AA
    ON AA.ID=AUR.AccountId
  LEFT
  JOIN AsData_PL.Acc_AccountLegalEntity AALE
    ON AALE.AccountId=AA.Id
  LEFT
  JOIN ASData_PL.Acc_LegalEntity ALE
    ON ALE.ID=AALE.LegalEntityId
  LEFT
  JOIN (SELECT AEA.ID , AEAS.Name , AEA.SignedDate
          FROM ASData_PL.Acc_EmployerAgreement AEA
          LEFT
		  JOIN AsData_PL.Acc_EmployerAgreementStatus AEAS
		    ON AEA.StatusId=AEAS.Id) SEA
	ON SEA.ID=AALE.SignedAgreementId
  LEFT
  JOIN (SELECT AEA.ID , AEAS.Name
          FROM ASData_PL.Acc_EmployerAgreement AEA
          LEFT
		  JOIN AsData_PL.Acc_EmployerAgreementStatus AEAS
		    ON AEA.StatusId=AEAS.Id) PEA
    ON PEA.ID=AALE.PendingAgreementId
 WHERE AA.HashedId is not null
