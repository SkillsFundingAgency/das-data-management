CREATE TABLE [Asdata_pl].[RAT_EmployerRequestRegion]
 (
    EmployerRequestId UNIQUEIDENTIFIER NOT NULL,   
    RegionId INT NOT NULL,                         
    ModifiedBy UNIQUEIDENTIFIER NOT NULL,          
    ValidFrom DATETIME2(0) , 
    ValidTo DATETIME2(0) ,
    AsDm_UpdatedDateTime datetime2 default getdate() NULL

    PRIMARY KEY (EmployerRequestId, RegionId),

    CONSTRAINT FK_EmployerRequestRegion FOREIGN KEY (EmployerRequestId) REFERENCES [Asdata_pl].[RAT_EmployerRequest](Id),
    CONSTRAINT FK_Region FOREIGN KEY (RegionId) REFERENCES [Asdata_pl].[RAT_Region](Id)
) 