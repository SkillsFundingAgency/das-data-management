/*

View SQL and logic updated by analyst Ryan SLender 17/10/2024

Tested successfully : 17/10/2024 see Excel file:
https://educationgovuk.sharepoint.com/:x:/r/sites/Apprenticeships-PerformanceAnalyticsDataTeam/Shared%20Documents/General/Quality%20Feedback%20-%20apprentice/New%20scoring%20approach%2008%20oct%202024/Amending%20DataMart%20view/ASINTEL%204318%20QA.xlsx?d=w02bace5a749347f78d5faf4aca6fe01b&csf=1&web=1&e=xwzz4s


NOTE 
2 new columns have been added:

AcademicYear
[By UKPRN AcademicYear ReviewCount]


..the code for the view has been simplified.

*/

CREATE VIEW [ASData_PL].[Appfb_ApprenticeFeedback]
As
WITH LatestResultsCTE
/* 
START OF Step 1
Create combined table of learner feedback flagging at provider level
those published and not published on FAT
Needed to provide reporting capability for 'Matches FAT' or'Doesn't match FAT'
Providers are only shown where feedback received >=10 and where review is within last year
*/
as (SELECT ar1.ApprenticeFeedbackTargetId,
           ApprenticeFeedbackResultId,
           ar1.StandardUId,
           pa1.AttributeId,
           cast(ar1.DateTimeCompleted as date) as DateTimeCompleted,
           case
               when pa1.AttributeValue = 1 then
                   1
               else
                   0
           end as Agree,
           case
               when pa1.AttributeValue = 0 then
                   1
               else
                   0
           end as Disagree,
           pa1.AttributeValue,
           aft.Ukprn,
           ProviderRating,
           Academic_Year_Id as AcademicYear
    FROM
    (
        -- get latest feedback for each feedback target
        SELECT *
        FROM
        (
            SELECT d.Academic_Year_id,ROW_NUMBER() OVER (PARTITION BY ApprenticeFeedbackTargetId,d.Academic_Year_id
                                      ORDER BY DateTimeCompleted DESC
                                     ) seq,
                   afr.*
            FROM ASData_PL.Appfb_ApprenticeFeedbackResult afr
            LEFT JOIN [ASData_PL].[DimDate] d
            ON CAST(afr.DateTimeCompleted AS DATE) = CAST(d.Date_DT_Id AS DATE)
        ) ab1
        WHERE seq = 1
    ) ar1
        JOIN ASData_PL.Appfb_ProviderAttribute pa1
            on pa1.ApprenticeFeedbackResultId = ar1.Id
        JOIN ASData_PL.Appfb_ApprenticeFeedbackTarget aft
            on ar1.ApprenticeFeedbackTargetId = aft.Id
    WHERE FeedbackEligibility != 0
          -- AND DatetimeCompleted >= DATEADD(MONTH, -12, GETUTCDATE()) -- only includes feedback received in last 12 months /*commented out for ASINTEL-3524*/
   )

   /* 
END OF Step 1
Create combined table of learner feedback flagging at provider level
those published and not published on FAT
Needed to provide reporting capability for 'Matches FAT' or'Doesn't match FAT'
Providers are only shown where feedback received >=10 and where review is within last year
*/


/*
START OF STEP 2
Final output for DWH view
Final output for DWH view
*/

   SELECT 
   'Yes' AS [Published_FAT?],
      lr.ApprenticeFeedbackTargetId,
       lr.ApprenticeFeedbackResultId,
       lr.DateTimeCompleted,
       at.ApprenticeshipId,
       lr.UKPRN,
       app.StartDate,
       app.EndDate,
       at.LarsCode,
       lr.StandardUId,
       lr.AttributeId,
       att.AttributeName,
       att.Category,
       AttributeValue,
       lr.Agree,
       lr.Disagree,
       case
           when lr.Agree = 1 then
               'Agree'
           when lr.Disagree = 1 then
               'Disagree'
           else
               '?'
       end as Response,
       case
           when ProviderRating = 'VeryPoor' then
               1
           when ProviderRating = 'Poor' then
               2
           when ProviderRating = 'Good' then
               3
           when ProviderRating = 'Excellent' then
               4
           else
               99
       end as ProviderRating_score,
       ProviderRating,
       EligibilityCalculationDate,
       FeedbackEligibility,
       at.Status
        
FROM LatestResultsCTE lr

    LEFT JOIN ASData_PL.Appfb_ApprenticeFeedbackTarget at
        ON lr.ApprenticeFeedbackTargetId = at.id
    LEFT JOIN [ASData_PL].[Comt_Apprenticeship] app
        ON at.ApprenticeshipId = app.Id
    LEFT JOIN [ASData_PL].[Appfb_Attribute] att
        ON lr.AttributeId = att.AttributeId
    LEFT JOIN (
        SELECT COUNT(DISTINCT ApprenticeFeedbackTargetId) as ReviewCount -- Review count by UKPRN and Academic Year
        ,lr.UKPRN,lr.AcademicYear
        FROM LatestResultsCTE lr
        GROUP BY lr.UKPRN,lr.AcademicYear
    ) rc ON lr.UKPRN = rc.UKPRN and lr.AcademicYear = rc.AcademicYear

 WHERE 
 rc.ReviewCount >= 10 -- If 10 or more reviews by academic year and ukprn then they will be published
