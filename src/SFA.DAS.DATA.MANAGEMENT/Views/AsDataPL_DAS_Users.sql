CREATE VIEW [AsData_PL].[DAS_Users]
	AS 
SELECT EAUU.ID                   as UserId
      ,EAUU.FirstName            as firstName
      ,EAUU.LastName             as lastName
      ,EAUU.Email                as email
   --   ,UAS.ReceiveNotifications  as ReceiveNotifications
FROM ASData_PL.EAU_User EAUU
LEFT
JOIN ASData_PL.Acc_User AU
  ON AU.UserRef=EAUU.Id
LEFT
JOIN AsData_PL.Acc_UserAccountSettings UAS
  ON AU.ID=UAS.UserId
