Create PROCEDURE [dbo].[FlattenvacancyReviewArrays]
AS
BEGIN
    -- Create a temporary table to store the parsed JSON values
    CREATE TABLE #TempTable (VacancyReference varchar(256)--,binary varchar(256)
    ,ruleId varchar(256),score varchar(256),narrative varchar(256),data varchar(256),target varchar(256))

    -- Insert parsed JSON values into the temporary table
    INSERT INTO #TempTable 
    SELECT
        VacancyReference,
       -- JSON_VALUE(Rule_Details, '$.binary') AS binary,
        JSON_VALUE(Rule_Details, '$.ruleId') AS ruleId,
        JSON_VALUE(Rule_Details, '$.score') AS score,
        JSON_VALUE(Rule_Details, '$.narrative') AS narrative,
        JSON_VALUE(Rule_Details, '$.data') AS data,
        JSON_VALUE(Rule_Details, '$.target') AS target
    FROM
        stg.RAA_VacancyReviews_AutoQAoutcome
        CROSS APPLY OPENJSON(Rule_Details);

    -- Update the target table with flattened values
    UPDATE AD
    SET
       -- Details_BinaryIDDetails_BinaryID = ISNULL(t1.binary, Details_BinaryID), -- Replace Column1 with the actual column name
        Details_RuleID = ISNULL(t2.ruleId, Details_RuleID),
        Details_score = ISNULL(t3.score,Details_score),
        Details_narrative = ISNULL(t4.narrative, Details_narrative),
        Details_data = ISNULL(t5.data, Details_data),
        Details_target = ISNULL(t6.target, Details_target)
    FROM
        stg.RAA_VacancyReviews_AutoQAoutcomedetails AD
        --LEFT JOIN #TempTable t1 ON AD.VacancyReference = t1.VacancyReference AND t1.binary IS NOT NULL
        LEFT JOIN #TempTable t2 ON AD.VacancyReference = t2.VacancyReference AND t2.ruleId IS NOT NULL
        LEFT JOIN #TempTable t3 ON AD.VacancyReference = t3.VacancyReference AND t3.score IS NOT NULL
        LEFT JOIN #TempTable t4 ON AD.VacancyReference = t4.VacancyReference AND t4.narrative IS NOT NULL
        LEFT JOIN #TempTable t5 ON AD.VacancyReference = t5.VacancyReference AND t5.data IS NOT NULL
        LEFT JOIN #TempTable t6 ON AD.VacancyReference = t6.VacancyReference AND t6.target IS NOT NULL
      

    -- Drop the temporary table
    DROP TABLE #TempTable;
END;

