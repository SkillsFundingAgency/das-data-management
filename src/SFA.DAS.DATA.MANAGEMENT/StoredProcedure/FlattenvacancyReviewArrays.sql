Create PROCEDURE [dbo].[FlattenvacancyReviewArrays]
AS
BEGIN
    -- Create a temporary table to store the parsed JSON values
    DELETE FROM Stg.RAA_VacancyReviews_AutoQAoutcomedetails

    -- Insert parsed JSON values into the temporary table

    INSERT into Stg.RAA_VacancyReviews_AutoQAoutcomedetails
        ([BinaryId]
        ,[EmployerAccountId]
        ,[UserId]
        ,[VacancyReference]
        ,[Details_BinaryID]
        ,[Details_RuleID]
        ,[Details_score]
        ,[Details_narrative]
        ,[Details_data]
        ,[Details_target])

    Select ad.binaryid,ad.EmployerAccountId,ad.UserId,ad.vacancyreference,c.Deatilsbinaryid,b.ruleId,b.score,b.narrative,b.data,b.target
          From stg.RAA_VacancyReviews_AutoQAoutcome Ad
    Cross Apply OpenJSON(Ad.Rule_Details)
        WITH (
            _id     nvarchar(max) '$._id' as json,
            ruleId       varchar(100) '$.ruleId',
            score   nvarchar(100) '$.score',
            narrative nvarchar(max) '$.narrative' ,
            data nvarchar(max) '$.data',
	        target nvarchar(100)  '$.target'
            ) B
    cross apply  OpenJSON(b._id)
        WITH 
            ( [DetailsBinaryid] varchar(100) '$."$binary"') c


    -- Update the target table with flattened values
   /* UPDATE AD
    SET
        Details_BinaryID = ISNULL(t.binaryid, Details_BinaryID), -- Replace Column1 with the actual column name
        Details_RuleID = ISNULL(t.ruleId, Details_RuleID),
        Details_score = ISNULL(t.score,Details_score),
        Details_narrative = ISNULL(t.narrative, Details_narrative),
        Details_data = ISNULL(t.data, Details_data),
        Details_target = ISNULL(t.target, Details_target)
    FROM
        stg.RAA_VacancyReviews_AutoQAoutcomedetails AD
        LEFT JOIN #TempTable t ON AD.VacancyReference = t.VacancyReference 
        --and AD.Rule_RuleId=t.ruleId
        */

END;

