CREATE TABLE [lkp].[NatAppSerLookupData]
(
    [NatAppID] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [Pst_LOCAL_AUTHO_Desc] NVARCHAR(MAX) NULL, 
    [National_Apprenticeship_Service_Area] NVARCHAR(MAX) NULL,
    [National_Apprenticeship_Service_Division] NVARCHAR(MAX) NULL
) ON [Primary]
GO