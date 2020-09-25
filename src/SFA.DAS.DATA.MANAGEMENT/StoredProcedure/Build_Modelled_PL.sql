CREATE PROCEDURE [dbo].[Build_Modelled_PL]
(@RunId bigint)
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 25/09/2020
-- Description: Master Stored Proc that builds Modelled Presentation Layer
-- =========================================================================


EXEC dbo.ImportAppRedundancyToPL @RunId

