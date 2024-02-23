CREATE PROCEDURE FlattenvacancyReviewArrays
AS
BEGIN
    -- Create a temporary table to store the parsed JSON values
    CREATE TABLE #TempTable (vacref varchar(256), detailsJSONValue varchar(max)); -- Adjust the data type based on your JSON structure

    -- Insert parsed JSON values into the temporary table
    INSERT INTO #TempTable (vacref, detailsJSONValue)
    SELECT
        VacancyReference,
        JSON_VALUE(value, '$') AS JSONValue
    FROM
        stg.RAA_VacancyReviews_AutoQAoutcome
        CROSS APPLY OPENJSON(Rule_Details);

    -- Update the target table with flattened values
    UPDATE AD
    SET
        Details_BinaryID = ISNULL(t1.JSONValue, $binary), -- Replace Column1 with the actual column name
        Details_RuleID = ISNULL(t2.JSONValue, ruleId),
        Details_score = ISNULL(t3.JSONValue, score),
        Details_narrative = ISNULL(t4.JSONValue, narrative),
        Details_data = ISNULL(t5.JSONValue, data),
        Details_target = ISNULL(t6.JSONValue, target)
    FROM
        stg.RAA_VacancyReviews_AutoQAoutcomedetails AD
        LEFT JOIN #TempTable t1 ON AD.VacancyReference = t1.VacancyReference AND t1.JSONValue IS NOT NULL
        LEFT JOIN #TempTable t2 ON AD.VacancyReference = t2.VacancyReference AND t2.JSONValue IS NOT NULL
        LEFT JOIN #TempTable t3 ON AD.VacancyReference = t3.VacancyReference AND t3.JSONValue IS NOT NULL
        LEFT JOIN #TempTable t4 ON AD.VacancyReference = t4.VacancyReference AND t4.JSONValue IS NOT NULL
        LEFT JOIN #TempTable t5 ON AD.VacancyReference = t5.VacancyReference AND t5.JSONValue IS NOT NULL
        LEFT JOIN #TempTable t6 ON AD.VacancyReference = t6.VacancyReference AND t6.JSONValue IS NOT NULL
      

    -- Drop the temporary table
    DROP TABLE #TempTable;
END;
