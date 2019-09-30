CREATE FUNCTION [Mgmt].[fn_ExtractPostCodeUKFromAddress]
(
       @Address VARCHAR(MAX)
)
RETURNS VARCHAR(8)
AS
BEGIN
--function to extract a postcode from an address string

DECLARE @DefaultPostcode VARCHAR(8) = 'ZZ99 9ZZ'
       RETURN case
				    --Odd postcodes
				    --GIRO Bank
				    when patindex('%GIR 0AA%', @Address) > 0
					   then substring(@Address, patindex('%GIR 0AA%',@Address),7)
				    --SANTA 
				    when patindex('%SAN TA1%', @Address) > 0
					   then substring(@Address, patindex('%SAN TA1%',@Address),7)
				    --Anguilla 
				    when patindex('%AI-2640%', @Address) > 0
					   then substring(@Address, patindex('%AI-2640%',@Address),7)
				    --Ascension Island
				    when patindex('%ASCN 1ZZ%', @Address) > 0
					   then substring(@Address, patindex('%ASCN 1ZZ%',@Address),8)
				    --Saint Helena
				    when patindex('%STHL 1ZZ%', @Address) > 0
					   then substring(@Address, patindex('%STHL 1ZZ%',@Address),8)
				    --Tristan da Cunha 
				    when patindex('%TDCU 1ZZ%', @Address) > 0
					   then substring(@Address, patindex('%TDCU 1ZZ%',@Address),8)
				    --British Indian Ocean Territory 
				    when patindex('%BBND 1ZZ%', @Address) > 0
					   then substring(@Address, patindex('%BBND 1ZZ%',@Address),8)
				    --British Antarctic Territory 
				    when patindex('%BIQQ 1ZZ%', @Address) > 0
					   then substring(@Address, patindex('%BIQQ 1ZZ%',@Address),8)
				    --Falkland Islands
				    when patindex('%FIQQ 1ZZ%', @Address) > 0
					   then substring(@Address, patindex('%FIQQ 1ZZ%',@Address),8)
				    --Gibraltar
				    when patindex('%GX11 1AA%', @Address) > 0
					   then substring(@Address, patindex('%GX11 1AA%',@Address),8)
				    --Pitcairn Islands 
				    when patindex('%PCRN 1ZZ%', @Address) > 0
					   then substring(@Address, patindex('%PCRN 1ZZ%',@Address),8)
				    --South Georgia and the South Sandwich Islands
				    when patindex('%SIQQ 1ZZ%', @Address) > 0
					   then substring(@Address, patindex('%SIQQ 1ZZ%',@Address),8)
				    --Turks and Caicos Islands
				    when patindex('%TKCA 1ZZ%', @Address) > 0
					   then substring(@Address, patindex('%TKCA 1ZZ%',@Address),8)
				    --Standard Postcodes
				    when patindex('%[A-Z][A-Z][0-9][0-9] [0-9][A-Z][A-Z]%', @Address) > 0
					   then substring(@Address, patindex('%[A-Z][A-Z][0-9][0-9] [0-9][A-Z][A-Z]%',@Address),8)
				    when patindex('%[A-Z][0-9][0-9] [0-9][A-Z][A-Z]%', @Address) > 0
					   then substring(@Address, patindex('%[A-Z][0-9][0-9] [0-9][A-Z][A-Z]%',@Address),7)
				    when patindex('%[A-Z][A-Z][0-9] [0-9][A-Z][A-Z]%', @Address) > 0
					   then substring(@Address, patindex('%[A-Z][A-Z][0-9] [0-9][A-Z][A-Z]%',@Address),7)
				    when patindex('%[A-Z][0-9] [0-9][A-Z][A-Z]%', @Address) > 0
					   then substring(@Address, patindex('%[A-Z][0-9] [0-9][A-Z][A-Z]%',@Address),6)
				    when patindex('%[A-Z][A-Z][0-9][A-Z] [0-9][A-Z][A-Z]%', @Address) > 0
					   then substring(@Address, patindex('%[A-Z][A-Z][0-9][A-Z] [0-9][A-Z][A-Z]%',@Address),8)
				    when patindex('%[A-Z][0-9][A-Z] [0-9][A-Z][A-Z]%', @Address) > 0
					   then substring(@Address, patindex('%[A-Z][0-9][A-Z] [0-9][A-Z][A-Z]%',@Address),7) 
                        ELSE @DefaultPostcode  
                END
END
