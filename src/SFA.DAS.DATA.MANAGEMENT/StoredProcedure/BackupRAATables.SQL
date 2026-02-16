CREATE OR ALTER PROCEDURE stg.BackupRAATables
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @SchemaName SYSNAME,
        @TableName SYSNAME,
        @BackupSchema SYSNAME = 'StgRAA',
        @SQL NVARCHAR(MAX),
        @SourceCount INT,
        @BackupCount INT;

  
    DECLARE TableCursor CURSOR FOR
        SELECT TABLE_SCHEMA, TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'stg'
          AND TABLE_NAME LIKE 'RAA\_%' ESCAPE '\'
        ORDER BY TABLE_NAME;

    OPEN TableCursor;
    FETCH NEXT FROM TableCursor INTO @SchemaName, @TableName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @BackupTable SYSNAME = @TableName;

        -- Dynamically count source rows
        SET @SQL = '
            SELECT @RC = COUNT(*) 
            FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ';';

        EXEC sys.sp_executesql @SQL, N'@RC INT OUTPUT', @RC = @SourceCount OUTPUT;

        -- Count backup rows (if table exists)
        IF OBJECT_ID(@BackupSchema + '.' + @BackupTable, 'U') IS NOT NULL
        BEGIN
            SET @SQL = '
                SELECT @RC = COUNT(*) 
                FROM ' + QUOTENAME(@BackupSchema) + '.' + QUOTENAME(@BackupTable) + ';';

            EXEC sys.sp_executesql @SQL, N'@RC INT OUTPUT', @RC = @BackupCount OUTPUT;
        END
        ELSE
        BEGIN
            SET @BackupCount = -1;  -- force initial load
        END;

        PRINT 'Source table ' + @TableName + ' count = ' + CAST(@SourceCount AS VARCHAR(20));
        PRINT 'Backup table ' + @BackupTable + ' count = ' + CAST(@BackupCount AS VARCHAR(20));

        -- Only backup if source has more rows than backup
        IF (@SourceCount > @BackupCount)
        BEGIN
            PRINT 'Backing up ' + @TableName + ' because source > backup';

            SET @SQL = '
                IF OBJECT_ID(''' + @BackupSchema + '.' + @BackupTable + ''', ''U'') IS NOT NULL
                BEGIN
                    DROP TABLE ' + QUOTENAME(@BackupSchema) + '.' + QUOTENAME(@BackupTable) + ';
                END;

                SELECT *
                INTO ' + QUOTENAME(@BackupSchema) + '.' + QUOTENAME(@BackupTable) + '
                FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ';
            ';

            EXEC sys.sp_executesql @SQL;
        END
        ELSE
        BEGIN
            PRINT 'Skipping backup for ' + @TableName + ' (source NOT > backup)';
        END;

        FETCH NEXT FROM TableCursor INTO @SchemaName, @TableName;
    END;

    CLOSE TableCursor;
    DEALLOCATE TableCursor;

END;
GO