/* Execute Stored Procedure */
EXEC [dbo].[Build_AS_DataMart]

DROP TABLE IF EXISTS  [ASData_PL].[Acc_TransferConnectionInvitationChange]
DROP TABLE IF EXISTS  [ASData_PL].[Acc_TransferConnectionInvitation]
DROP PROCEDURE IF EXISTS [dbo].[BuildVacanciesPresentationLayer]
DROP PROCEDURE IF EXISTS [dbo].[ImportVacanciesAdditionalInfoToPL]
