/****** Object:  View [funded].[v_MS_KPI_NQR_TU_002]    Script Date: 27/03/2025 10:58:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [ASData_PL].[v_MS_KPI_NQR_TU_002]
AS
/*##################################################################################################
	-Name:				NQR TU 002
	-Description:		Average time between “shared with Ofqual|IfATE” to outcome decision 
						(grouped by Ofqual and IfATE)

						KPI Indicator Type - Take-Up (Ofqual/IfATE)
						Baseline - 20 weeks
						Target - < 1 week
####################################################################################################
	Version No.			Updated By		Updated Date		Description of Change
####################################################################################################
	1					Adam Leaver		18/03/2025			Original
##################################################################################################*/

Select  A.QualificationNumber
	   ,AO.RecognitionNumber
	   ,AO.Id as AwardingOrganisationId
	   ,AO.NameLegal As AwardingOrganisationName
	   ,SW.SharedWithDate
	   ,De.AOInformedOfDecisionDate
	   ,DateDiff(Hour, SW.SharedWithDate, De.AOInformedOfDecisionDate) As Duration

From [ASData_PL].[AODP_Applications] A 
Left Outer Join [ASData_PL].[AODP_AwardingOrganisation] AO ON A.OrganisationId = AO.Id

Left Outer Join (

select M.ApplicationId
	   ,M.SentAt as SharedWithDate
	   ,M.Type
	   ,Case M.Type
			When 'ApplicationSharedWithOfqual' Then 'Ofqual'
			When 'ApplicationSharedWithSkillsEngland' Then 'SkillsEngland / IfATE'
			Else ''
		End As SharedWith
	    ,Rank() Over (Partition By M.ApplicationId order by M.SentAt Asc) as R_K
		
From [ASData_PL].[AODP_Messages] M

Where M.Type in ('ApplicationSharedWithOfqual', 'ApplicationSharedWithSkillsEngland')) SW On SW.ApplicationId = A.Id

Left Outer Join (
select M.ApplicationId
	   ,M.SentAt as AOInformedOfDecisionDate
	   ,M.Type
	   ,Case M.Type
			When 'ApplicationSharedWithOfqual' Then 'Ofqual'
			When 'ApplicationSharedWithSkillsEngland' Then 'SkillsEngland / IfATE'
			Else ''
		End As SharedWith
	    ,Rank() Over (Partition By M.ApplicationId order by M.SentAt Asc) as R_K
		
From [ASData_PL].[AODP_Messages] M

Where M.Type = 'AoInformedOfDecision' ) as De ON De.ApplicationId = A.Id


Where SW.R_K = 1 and De.R_K = 1
GO


