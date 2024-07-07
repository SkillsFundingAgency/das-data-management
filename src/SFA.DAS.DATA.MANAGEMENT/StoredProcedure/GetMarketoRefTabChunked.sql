CREATE PROCEDURE GetMarketoRefTabChunkedData 
    @Offset INT,
    @FetchNext INT
AS
BEGIN
    SELECT * FROM [AsData_PL].[ExportMarketoRefTablesToInt]
    ORDER BY SomeColumn
    OFFSET @Offset ROWS
    FETCH NEXT @FetchNext ROWS ONLY
END