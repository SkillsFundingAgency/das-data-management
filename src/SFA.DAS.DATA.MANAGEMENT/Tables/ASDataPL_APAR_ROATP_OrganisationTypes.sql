CREATE TABLE [ASData_PL].[APAR_ROATP_OrganisationTypes]

(

    [Id] int NOT NULL,

    [Type] NVARCHAR(100)  NULL,

    [Description] NVARCHAR(255) NULL,

    [CreatedAt] [datetime2](7) NOT NULL,

    [UpdatedAt] [datetime2](7) NULL,

    [Status] NVARCHAR(20)  NULL

)