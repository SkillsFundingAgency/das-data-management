IF OBJECT_ID(N'[ASData_PL].[FAT_ROATPV2_Standard]', N'U') IS NOT NULL
AND EXISTS (
    SELECT 1
    FROM sys.columns c
    JOIN sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE c.object_id = OBJECT_ID(N'[ASData_PL].[FAT_ROATPV2_Standard]')
      AND c.name = N'LarsCode'
      AND (ty.name <> N'nvarchar' OR c.max_length <> 20)
)
    ALTER TABLE [ASData_PL].[FAT_ROATPV2_Standard] ALTER COLUMN [LarsCode] nvarchar(10) NULL;
GO
