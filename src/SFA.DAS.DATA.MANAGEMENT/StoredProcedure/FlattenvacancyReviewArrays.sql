Create PROCEDURE [dbo].[FlattenvacancyReviewArrays]
AS
BEGIN
    -- Create a temporary table to store the parsed JSON values
    DELETE FROM Stg.RAA_VacancyReviews_AutoQAoutcomedetails

    -- Insert parsed JSON values into the temporary table

    INSERT into Stg.RAA_VacancyReviews_AutoQAoutcomedetails
        ([BinaryId]
        ,[UserId]
        ,[VacancyReference]
        ,[RuleoutcomeID] 
        ,[Details_BinaryID]
        ,[Details_RuleID]
        ,[Details_score]
        ,[Details_narrative]
        ,[Details_data]
        ,[Details_target])

    Select ad.binaryid,ad.UserId,ad.vacancyreference,ad.ruleoutcomeID,c.Detailsbinaryid,b.ruleId,b.score,b.narrative,b.data,b.target
          From stg.RAA_VacancyReviews_AutoQARuleoutcome Ad
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
    
    DELETE FROM Stg.RAA_VacancyReviews_AutoQAoutcome
    
    INSERT into Stg.RAA_VacancyReviews_AutoQAoutcome
    (BinaryId
    ,VacancyReference
    ,UserId
    ,RuleoutcomeID
    ,Rule_RuleId
    ,Rule_Score
    ,Rule_Narrative
    ,Rule_Target
    ,Details_BinaryID
    ,Details_RuleID
    ,Details_score
    ,Details_narrative
    ,Details_data
    ,Details_target)

    SELECT  A.BinaryId
           ,A.VacancyReference
           ,A.UserId 
           ,A.RuleOutcomeID
           ,A.Rule_Ruleid
           ,A.Rule_Score
           ,A.Rule_Narrative
           ,A.Rule_Target
           ,AD.Details_BinaryID
           ,AD.Details_RuleId 
           ,AD.Details_score 
           ,AD.Details_narrative
           ,AD.Details_data 
           ,AD.Details_target
     FROM stg.RAA_VacancyReviews_AutoQAoutcomedetails AD
   INNER JOIN stg.RAA_VacancyReviews_AutoQARuleoutcome A
       on AD.binaryid=A.binaryid
       and AD.ruleoutcomeId= A.ruleoutcomeID
       and AD.VacancyReference = A.VacancyReference 

    

END;

