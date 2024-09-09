CREATE TABLE [stg].[Pst_latlong]
(
    Id Int Identity,
    Postcode Nvarchar(30),
    Latitude DECIMAL(18,6 ),
    Longitude DECIMAL(18,6 ),
    AsDm_UpdatedDate datetime2 default(getdate())
) ON [Primary]
GO
