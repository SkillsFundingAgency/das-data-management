/****** Object:  View [funded].[v_MS_KPI_NQS_CR_CT_001]    Script Date: 27/03/2025 11:47:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [ASData_PL].[v_MS_KPI_NQS_CR_CT_001]
AS
/*##################################################################################################
	-Name:				NQS-CR/CT-001
	-Description:		Started forms are submitted within 2 weeks /
	                    Average Time (time between starting and submitting a form)

						KPI Indicator Type - Completion Rate / Completion Time
						Baseline CR - N/A
						Baseline CT - 1 week
						Target CR - > 95%
						Target CT - < 1 week

####################################################################################################
	Version No.			Updated By		Updated Date		Description of Change
####################################################################################################
*/


Select QualificationNumber
	  ,RecognitionNumber
	  ,AwardingOrganisationId
	  ,AwardingOrganisationName
	  ,FormStartDate
	  ,FormSubmissionDate
	  ,DATEDIFF(Hour, FormStartDate, FormSubmissionDate) as Duration
	  
From (

Select  A.QualificationNumber
	   ,AO.RecognitionNumber
	   ,AO.Id as AwardingOrganisationId
	   ,AO.NameLegal As AwardingOrganisationName
	   ,A.CreatedAt As FormStartDate
	   ,M.SentAt as FormSubmissionDate
	   ,RANK() Over (Partition By A.QualificationNumber Order By M.SentAt ASC) as R_K

From [ASData_PL].[AODP_Applications] A 
Left Outer Join [ASData_PL].[AODP_Messages] M ON M.ApplicationId = A.Id
Left Outer Join [ASData_PL].[AODP_AwardingOrganisation] AO ON A.OrganisationId = AO.Id

Where M.Type = 'ApplicationSubmitted'  ) as COM

Where COM.R_K = 1
GO


