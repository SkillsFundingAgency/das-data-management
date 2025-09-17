CREATE VIEW [ASData_PL].[v_MS_KPI_NQS_NQR_US_001] As

/*##################################################################################################
	-Name:				NQS / NQR US 001
	-Description:		Average Score
####################################################################################################
	Version No.			Updated By		Updated Date		Description of Change
####################################################################################################*/

SELECT Id AS SurveyId
	  ,Case When CHARINDEX('apply', Page) > 0 AND
				 CHARINDEX('organisations', Page) > 0 AND
				 CHARINDEX('applications', Page) > 0 AND
				 CHARINDEX('submit', Page) > 0 AND
				 CHARINDEX('confirmed', Page) > 0 
			Then 'Funding Feedback'
			When CHARINDEX('Review', Page) > 0 AND
				 CHARINDEX('New', Page) > 0
			Then 'New Qualification Feedback'
			When CHARINDEX('Changed', Page) > 0 
			Then 'New Qualification Feedback'
	   End AS FeedbackType
	  ,Case SatisfactionScore
			When 5 Then 'Very Satisfied'
			When 4 Then 'Satisfied'
			When 3 Then 'Neither Satisfied nor Dissatisfied'
			When 2 Then 'Dissatisfied'
			When 1 Then 'Very Dissatisfied'
		End As SatisfactionScore
      ,Comments
      ,Timestamp
  FROM [ASData_PL].[AODP_Surveys]
GO


