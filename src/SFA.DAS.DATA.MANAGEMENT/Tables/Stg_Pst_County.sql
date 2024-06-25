CREATE TABLE [stg].[Pst_County]
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Postcode Nvarchar(30),
    County Nvarchar(50),
    AsDm_UpdatedDate datetime2 default(getdate())
) ON [Primary]
GO