CREATE FUNCTION [dbo].[Fn_CleanseHTMLText] (@HTMLText VARCHAR(MAX))
RETURNS VARCHAR(MAX) AS
BEGIN
 
    DECLARE    @Start INT
    DECLARE    @End INT
    DECLARE    @Length INT



    SELECT @HTMLText=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@HTMLText,'&amp;','&'),'&lt;','<'),'&gt;','>'),'&amp;amp;','&'),'&nbsp;',' '),'<br>', ' ')
 
   
    SELECT @HTMLText=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@HTMLText,'<br/>',' '),'<br />', ' '),'<ul>',' '),'<li>', ' '),'</ul>',' '),'</li>','.')
                      ,'<p>',' '),'</p>',' '),'&bull',' '), CHAR(13), ''), CHAR(10), ' ')
 
 
    
    SET @Start = CHARINDEX('<', @HTMLText)
    SET @End = CHARINDEX('>', @HTMLText, CHARINDEX('<', @HTMLText))
    SET @Length = (@End - @Start) + 1
 
    WHILE (@Start > 0 AND @End > 0 AND @Length > 0)
    BEGIN
        SET @HTMLText = STUFF(@HTMLText, @Start, @Length, '')
        SET @Start = CHARINDEX('<', @HTMLText)
        SET @End = CHARINDEX('>', @HTMLText, CHARINDEX('<', @HTMLText))
        SET @Length = (@End - @Start) + 1
    END
 
    SET @HTMLText = LTRIM(RTRIM(@HTMLText))
   
    RETURN case when charindex(',',REVERSE(@HTMLText)) =1 then left(@HTMLText,len(@HTMLText)-1)				
	         else @HTMLText			
			 end
END
GO