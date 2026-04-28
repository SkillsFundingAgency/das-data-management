/*
    Convert only the target columns currently in scope for the LarsCode datatype change.
*/

IF OBJECT_ID(N'[ASData_PL].[FAT2_StandardSector]', N'U') IS NOT NULL
AND EXISTS (
    SELECT 1
    FROM sys.columns c
    JOIN sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE c.object_id = OBJECT_ID(N'[ASData_PL].[FAT2_StandardSector]')
      AND c.name = N'LarsCode'
      AND (ty.name <> N'varchar' OR c.max_length <> 8)
)
    ALTER TABLE [ASData_PL].[FAT2_StandardSector] ALTER COLUMN [LarsCode] varchar(8) NULL;
GO

IF OBJECT_ID(N'[ASData_PL].[FAT_ROATPV2_Audit]', N'U') IS NOT NULL
AND EXISTS (
    SELECT 1
    FROM sys.columns c
    JOIN sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE c.object_id = OBJECT_ID(N'[ASData_PL].[FAT_ROATPV2_Audit]')
      AND c.name = N'LARSCode'
      AND (ty.name <> N'varchar' OR c.max_length <> 8)
)
    ALTER TABLE [ASData_PL].[FAT_ROATPV2_Audit] ALTER COLUMN [LARSCode] varchar(8) NULL;
GO

IF OBJECT_ID(N'[ASData_PL].[FAT_ROATPV2_ProviderCourse]', N'U') IS NOT NULL
AND EXISTS (
    SELECT 1
    FROM sys.columns c
    JOIN sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE c.object_id = OBJECT_ID(N'[ASData_PL].[FAT_ROATPV2_ProviderCourse]')
      AND c.name = N'LarsCode'
      AND (ty.name <> N'varchar' OR c.max_length <> 8)
)
    ALTER TABLE [ASData_PL].[FAT_ROATPV2_ProviderCourse] ALTER COLUMN [LarsCode] varchar(8) NULL;
GO

IF OBJECT_ID(N'[ASData_PL].[FAT_ROATPV2_Standard]', N'U') IS NOT NULL
AND EXISTS (
    SELECT 1
    FROM sys.columns c
    JOIN sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE c.object_id = OBJECT_ID(N'[ASData_PL].[FAT_ROATPV2_Standard]')
      AND c.name = N'LarsCode'
      AND (ty.name <> N'varchar' OR c.max_length <> 8)
)
    ALTER TABLE [ASData_PL].[FAT_ROATPV2_Standard] ALTER COLUMN [LarsCode] varchar(8) NULL;
GO
