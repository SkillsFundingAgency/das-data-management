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
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = 'DROP VIEW [ASData_PL].[EmployerDim];';
        EXEC sp_executesql @sql;
    END
    
END
