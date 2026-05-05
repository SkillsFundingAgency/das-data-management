/*
    CPG tables are full-copy presentation tables. Clear existing rows before the
    publish step applies source-schema-aligned datatype changes.
*/

IF OBJECT_ID(N'[AsData_PL].[CPG_BouncedEmails]', N'U') IS NOT NULL
    TRUNCATE TABLE [AsData_PL].[CPG_BouncedEmails];
GO

IF OBJECT_ID(N'[AsData_PL].[CPG_CampaignImportMetadata]', N'U') IS NOT NULL
    TRUNCATE TABLE [AsData_PL].[CPG_CampaignImportMetadata];
GO

IF OBJECT_ID(N'[AsData_PL].[CPG_Campaigns]', N'U') IS NOT NULL
    TRUNCATE TABLE [AsData_PL].[CPG_Campaigns];
GO

IF OBJECT_ID(N'[AsData_PL].[CPG_ClickedLinks]', N'U') IS NOT NULL
    TRUNCATE TABLE [AsData_PL].[CPG_ClickedLinks];
GO

IF OBJECT_ID(N'[AsData_PL].[CPG_DisplayedEmails]', N'U') IS NOT NULL
    TRUNCATE TABLE [AsData_PL].[CPG_DisplayedEmails];
GO

IF OBJECT_ID(N'[AsData_PL].[CPG_UnsubscribedContacts]', N'U') IS NOT NULL
    TRUNCATE TABLE [AsData_PL].[CPG_UnsubscribedContacts];
GO
