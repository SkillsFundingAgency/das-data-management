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

EXEC LoadCandidateDisabilityLookup @RunId

EXEC LoadCandidateGendrLookup @RunId

EXEC [dbo].[CreateStdsAndFrameworksView] @RunID

EXEC [dbo].[UpdateApprenticeshipStdRoute] @RunID

EXEC [dbo].[CreateDataDictionaryView] @RunID

EXEC [dbo].[LoadRPLookupData] @RunID


EXEC [dbo].[LoadSICLookupData] @RunID

EXEC [dbo].[PopulateMetadataForRefreshDataset] @RunId

EXEC [dbo].[PopulateMetadataNationalMinimumWageRates] @RunId

EXEC [dbo].[PopulateMetadataDataRetention] @RunId
/* Populate Metadata For Roles and Permissions */

EXEC [dbo].[PopulateMetadataRolesAndPermissions] @RunId

EXEC [dbo].[PopulatePipelineController] @RunId

EXEC [dbo].[PopulateDQ_TablesToExclude] @RunId

EXEC [dbo].[PopulateStgPmnts] @RunId
/* Grant Permissions to Roles -- Should always be kept last */

EXEC [dbo].[AssignPermissionsToRoles] @RunId

EXEC [dbo].[LoadNatAppSerLookupData] @RunId
