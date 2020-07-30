CREATE FUNCTION [dbo].[Fn_ConvertTimeStampToDateTime] (@UnixTimeStamp BIGINT)
RETURNS DATETIME2
AS
BEGIN
DECLARE @DateTime DateTime2
     IF (TRY_CONVERT(BIGINT,@UnixTimeStamp) IS NULL)
	 SET @DateTime= NULL
	 ELSE 
	 IF (LEN(@UnixTimeStamp)>13)
	 SET @DateTime=NULL
	 ELSE
	 SET @DateTime= CAST(DATEADD(ms, CAST(RIGHT(@UnixTimeStamp,3) AS smallint), DATEADD(s, @UnixTimeStamp / 1000, '1970-01-01')) AS datetime2(3))
	 RETURN @DateTime
END;