CREATE FUNCTION [dbo].[Fn_ConvertTimeStampToDateTime] (@UnixTimeStamp BIGINT)
RETURNS DATETIME2
AS
BEGIN
     RETURN CAST(DATEADD(ms, CAST(RIGHT(@UnixTimeStamp,3) AS smallint), DATEADD(s, @UnixTimeStamp / 1000, '1970-01-01')) AS datetime2(3))
END;