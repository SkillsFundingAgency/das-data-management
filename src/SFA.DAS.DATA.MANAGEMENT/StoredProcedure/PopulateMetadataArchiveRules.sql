CREATE PROCEDURE [dbo].[PopulateMetadataArchiveRules]
(
    @RunId int
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM [Mgmt].[ArchiveRule]
        WHERE [RuleId] = 'MarketoLeadActivities_20200801'
    )
    BEGIN
        INSERT INTO [Mgmt].[ArchiveRule]
        (
            [RuleId], [DatabaseName], [SchemaName], [TableName], [RuleType],
            [ArchiveColumn], [ArchiveBeforeDate], [SelectionProcedure], [DeleteProcedure],
            [ArchiveTarget], [ArchiveFormat], [Enabled]
        )
        VALUES
        (
            'MarketoLeadActivities_20200801', DB_NAME(), 'ASData_PL', 'MarketoLeadActivities', 'DateBased',
            'ActivityDate', '2020-08-01', 'dbo.SelectArchiveRows', 'dbo.DeleteArchivedRows',
            'Marketo/MarketoLeadActivities', 'Parquet', 0
        );
    END;
END;
