CREATE TABLE [stg].[Pst_County]
(
    Id BigINT Not NUll,
    Postcode Nvarchar(30),
    County Nvarchar(50),
    AsDm_UpdatedDate datetime2 default(getdate())
) ON [Primary]
GO