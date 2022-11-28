CREATE FUNCTION [dbo].[Fn_CleanseJSONText] (@JSONText VARCHAR(MAX))
RETURNS VARCHAR(MAX) AS
BEGIN

    SELECT @JSONText=LTRIM(RTRIM(Replace(Replace(Replace(Replace(Replace (@JSONText, '"', ''), '{', ''), '}',''),'[', ''), ']', '')))
    
    RETURN case when charindex(',',REVERSE(@JSONText)) =1 then left(@JSONText,len(@JSONText)-1)				
	         else @JSONText			
			 end
END
GO