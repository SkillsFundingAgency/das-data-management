CREATE FUNCTION [dbo].[Fn_ConvertGuidToBase64] (@Guid nvarchar(256))
RETURNS nvarchar(25)
AS
BEGIN
DECLARE @VarBinary VARBINARY(MAX)
DECLARE @Base64Text NVARCHAR(25)

SELECT @VarBinary=cast(cast(@guid as uniqueidentifier) as varbinary(max))

SELECT @Base64Text= cast(N'' as XML).value(
                    'xs:base64Binary(xs:hexBinary(sql:variable("@varbinary")))'
                   ,'nvarchar(25)'
                    )   

	 RETURN @Base64Text
END;