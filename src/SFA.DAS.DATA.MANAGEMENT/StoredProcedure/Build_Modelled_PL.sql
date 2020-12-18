CREATE PROCEDURE [dbo].[Build_Modelled_PL]
(@RunId bigint)
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 25/09/2020
-- Description: Master Stored Proc that builds Modelled Presentation Layer
-- =========================================================================

EXEC dbo.ImportAppRedundancyToPL @RunId

EXEC dbo.ImportAccountsToPL @RunId


/* Import CRS and CRS Delivery Data to Presentation Layer */

EXEC dbo.ImportProviderToPL @RunId

EXEC dbo.ImportCRSFrameworkToPL @RunId

EXEC dbo.ImportCRSSectorStandardToPL @RunId
