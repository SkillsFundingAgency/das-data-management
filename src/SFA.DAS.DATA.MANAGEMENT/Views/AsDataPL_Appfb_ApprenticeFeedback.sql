CREATE VIEW [AsData_PL].[Appfb_ApprenticeFeedback]
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
           ProviderRating
    FROM
    (
        -- get latest feedback for each feedback target
        SELECT *
        FROM
        (
            SELECT ROW_NUMBER() OVER (PARTITION BY ApprenticeFeedbackTargetId
                                      ORDER BY DateTimeCompleted DESC
                                     ) seq,
                   *
            FROM ASData_PL.Appfb_ApprenticeFeedbackResult
        ) ab1
        WHERE seq = 1
    ) ar1
        JOIN ASData_PL.Appfb_ProviderAttribute pa1
            on pa1.ApprenticeFeedbackResultId = ar1.Id
        JOIN ASData_PL.Appfb_ApprenticeFeedbackTarget aft
            on ar1.ApprenticeFeedbackTargetId = aft.Id
    WHERE FeedbackEligibility != 0
          -- AND DatetimeCompleted >= DATEADD(MONTH, -12, GETUTCDATE()) -- only includes feedback received in last 12 months /*commented out for ASINTEL-3524*/
   ),
     FatPublishedCTE
as (
-- Published in FAT following publication  rules
SELECT 1 as [Published_FAT?],
           Ukprn,
           ab1.AttributeId,
           Category,
           AttributeName,
           SUM(AttributeValue) Agree,
           SUM(   CASE
                      WHEN AttributeValue = 1 THEN
                          0
                      ELSE
                          1
                  END
              ) Disagree,
           SUM(AttributeValue) + SUM(   CASE
                                            WHEN AttributeValue = 1 THEN
                                                0
                                            ELSE
                                                1
                                        END
                                    ) Total,
           GETUTCDATE() UpdatedOn
    FROM
    (
        SELECT *,
               COUNT(*) OVER (PARTITION BY Ukprn, AttributeId) ReviewCount
        FROM LatestResultsCTE
    ) ab1
        LEFT JOIN [ASData_PL].[Appfb_Attribute] at
            ON ab1.AttributeId = at.AttributeId
    WHERE ReviewCount >= 10 
    GROUP BY Ukprn,
             ab1.AttributeId,
             at.AttributeName,
             at.Category
    UNION ALL

    -- Not Published in FAT

    SELECT 2 as [Published_FAT?],
           Ukprn,
           ab1.AttributeId,
           Category,
           AttributeName,
           SUM(AttributeValue) Agree,
           SUM(   CASE
                      WHEN AttributeValue = 1 THEN
                          0
                      ELSE
                          1
                  END
              ) Disagree,
           SUM(AttributeValue) + SUM(   CASE
                                            WHEN AttributeValue = 1 THEN
                                                0
                                            ELSE
                                                1
                                        END
                                    ) Total,
           GETUTCDATE() UpdatedOn
    FROM
    (
        SELECT *,
               COUNT(*) OVER (PARTITION BY Ukprn, AttributeId) ReviewCount
        FROM LatestResultsCTE
    ) ab1
        LEFT JOIN [ASData_PL].[Appfb_Attribute] at
            ON ab1.AttributeId = at.AttributeId
    WHERE ReviewCount < 10 -- Restrict the review count to only those who won't show in published version
    GROUP BY Ukprn,
             ab1.AttributeId,
             at.AttributeName,
             at.Category
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

SELECT case
           when fp.[Published_FAT?] = 1 then
               'Yes'
           when fp.[Published_FAT?] = 2 then
               'No'
           else
               '?'
       end as [Published_FAT?],
       ApprenticeFeedbackTargetId,
       ApprenticeFeedbackResultId,
       lr.DateTimeCompleted,
       at.ApprenticeshipId,
       lr.UKPRN,
       app.StartDate,
       app.EndDate,
       at.LarsCode,
       lr.StandardUId,
       lr.AttributeId,
       fp.AttributeName,
       fp.Category,
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
    LEFT JOIN FatPublishedCTE fp
        ON lr.UKPRN = fp.Ukprn
           and lr.AttributeId = fp.AttributeId
    LEFT JOIN ASData_PL.Appfb_ApprenticeFeedbackTarget at
        ON lr.ApprenticeFeedbackTargetId = at.id
    LEFT JOIN [ASData_PL].[Comt_Apprenticeship] app
        ON at.ApprenticeshipId = app.Id
WHERE [Published_FAT?] = 1 -- Only included FAT published in results for DWH

