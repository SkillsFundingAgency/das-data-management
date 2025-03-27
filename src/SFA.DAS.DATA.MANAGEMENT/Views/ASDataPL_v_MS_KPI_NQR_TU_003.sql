/****** Object:  View [funded].[v_MS_KPI_NQR_TU_003]    Script Date: 27/03/2025 11:42:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [ASData_PL].[v_MS_KPI_NQR_TU_003]
AS
/*##################################################################################################
	-Name:				NQR TU 003
	-Description:		AO average time from first saved draft of a form to submitting the form 
						(grouped by form name and version)

						KPI Indicator Type - Take-Up (DfE)
						Baseline - 2 weeks
						Target - < 3 Days


####################################################################################################
	Version No.			Updated By		Updated Date		Description of Change
####################################################################################################
	1					Adam Leaver		18/03/2025			Original
##################################################################################################*/

select  MM_MSG.ApplicationId
	   ,A.QualificationNumber
	   ,AO.RecognitionNumber
	   ,AO.Id as AwardingOrganisationId
	   ,AO.NameLegal As AwardingOrganisationName
	   ,MM_MSG.Type
	   ,MM_MSG.SentAt


from 

(Select M.ApplicationId
	   ,M.Type
	   ,Min(M.SentAt) as SentAt
   
From [ASData_PL].[AODP_Messages] M 

Where M.Type in ('ApplicationSubmitted', 'Draft')
Group By M.ApplicationId, M.Type ) As MM_MSG

Left Outer Join [ASData_PL].[AODP_Applications] A ON A.Id = MM_MSG.ApplicationId
Left Outer Join [ASData_PL].[AODP_AwardingOrganisation] AO ON A.OrganisationId = AO.Id
GO


