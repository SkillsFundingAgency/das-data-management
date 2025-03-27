/****** Object:  View [funded].[v_MS_KPI_NQR_CR_CT_001]    Script Date: 27/03/2025 10:47:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [ASData_PL].[v_MS_KPI_NQR_CR_CT_001]
AS
/*##################################################################################################
	-Name:				NQR-CR/CT-001
	-Description:		Decision Outcome within 4-week review cycle (excluding ‘hold’ status)

						KPI Indicator Type - Completion Rate / Completion Time
						Baseline CR - 60%
						Baseline CT - 4 weeks
						Target CR - > 70%
						Target CT - < 2 week
####################################################################################################
	Version No.			Updated By		Updated Date		Description of Change
####################################################################################################
	1					Adam Leaver		14/03/2025			Original
##################################################################################################*/

Select QualificationNumber
	  ,RecognitionNumber
	  ,AwardingOrganisationId
	  ,AwardingOrganisationName
	  ,FormSubmissionDate
	  ,StatusChangeDate
	  ,Status
	  ,StatusType
	  ,DATEDIFF(Hour, StatusChangeDate, FormSubmissionDate) as Duration
	  
From (

Select  A.QualificationNumber
	   ,AO.RecognitionNumber
	   ,AO.Id as AwardingOrganisationId
	   ,AO.NameLegal As AwardingOrganisationName
	   ,A.Status
	   ,M.SentAt as FormSubmissionDate
	   ,A.UpdatedAt As StatusChangeDate
	   ,RANK() Over (Partition By A.QualificationNumber Order By M.SentAt ASC) as R_K
	   ,Case When A.Status in ('Approved', 'NotApproved', 'Withdrawn') Then 'Outcome'
			 Else 'Not Outcome'
		End As StatusType



From [ASData_PL].[AODP_Applications] A 
Left Outer Join [ASData_PL].[AODP_Messages] M ON M.ApplicationId = A.Id
Left Outer Join [ASData_PL].[AODP_AwardingOrganisation] AO ON A.OrganisationId = AO.Id

Where M.Type = 'ApplicationSubmitted'  ) as COM

Where COM.R_K = 1
GO


