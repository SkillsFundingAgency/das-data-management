CREATE PROCEDURE DropViewEmployerDim
AS
BEGIN
    -- Check if the view exists
    IF EXISTS (
        SELECT 1 
        FROM INFORMATION_SCHEMA.VIEWS 
        WHERE TABLE_SCHEMA = 'ASData_PL' 
        AND TABLE_NAME = 'EmployerDim'
    )
    BEGIN
        -- Drop the view if it exists
        DROP VIEW [ASData_PL].[EmployerDim];
    END
END