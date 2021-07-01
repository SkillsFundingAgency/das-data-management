CREATE PROCEDURE [dbo].[Build_AS_DataMart]
AS
-- ==========================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Master Stored Proc that builds AS DataMart
-- ==========================================================


/* Generate Run Id for Logging Execution */

DECLARE @RunId int

EXEC @RunId= dbo.GenerateRunId

EXEC UpdateCalendarMonth @RunId

EXEC LoadReferenceData @RunId

EXEC PopulateSourceDbMetadataForImport @RunId

EXEC LoadCandidateEthLookUp @RunId

EXEC LoadCandidateConfig @RunId

EXEC [dbo].[CreateStdsAndFrameworksView] @RunID

EXEC [dbo].[UpdateApprenticeshipStdRoute] @RunID

EXEC [dbo].[CreateDataDictionaryView] @RunID

EXEC [dbo].[LoadRPLookupData] @RunID


/* Populate Metadata for Marketo Import */

EXEC [dbo].[PopulateMarketoFilterConfigForImport] @RunId

EXEC [dbo].[PopulateMetadataForRefreshDataset] @RunId

EXEC [dbo].[PopulateMetadataNationalMinimumWageRates] @RunId

/* Populate Metadata For Roles and Permissions */

EXEC [dbo].[PopulateMetadataRolesAndPermissions] @RunId


/* Grant Permissions to Roles -- Should always be kept last */

EXEC [dbo].[AssignPermissionsToRoles] @RunId