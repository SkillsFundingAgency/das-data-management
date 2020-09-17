CREATE VIEW [AsData_PL].[DAS_Users]
	AS 
SELECT EAUU.ID                             as employerUserId
      ,EAUU.FirstName                      as firstName
      ,EAUU.LastName                       as lastName
      ,EAUU.Email                          as email
	  ,1                                   as isEmployer
	  ,'DAS'                               as leadSource
	  ,getdate()                           as lastSync
   --   ,UAS.ReceiveNotifications  as ReceiveNotifications
FROM ASData_PL.EAU_User EAUU

