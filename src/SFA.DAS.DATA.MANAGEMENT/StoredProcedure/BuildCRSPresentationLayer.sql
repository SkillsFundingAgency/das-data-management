CREATE PROCEDURE [dbo].[BuildCRSPresentationLayer]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Sarma Evani
-- Create Date: 18/12/2020
-- Description: Build Vacancies Presentation Layer
-- ===============================================================================
BEGIN

		/* Import CRS Data to Presentation Layer */

		EXEC dbo.ImportCRSFrameworkToPL @RunId

		EXEC dbo.ImportCRSSectorStandardToPL @RunId

END