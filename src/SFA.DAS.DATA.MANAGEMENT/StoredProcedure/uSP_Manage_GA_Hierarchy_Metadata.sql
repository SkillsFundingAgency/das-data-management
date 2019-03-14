

CREATE PROCEDURE mgmt.usp_Manage_GA_Hierarchy_Metadata

AS

-- ====================================================================================================================
-- Author:		Himabindu Uddaraju
-- Create date: 14/03/2019
-- Description:	Stored Procedure to Manage FIU Campaign Metadata that contains the Heirarchy of Feedback Counts where 
--              Counts below the heirarchy are subset of the one's above the heirarchy
-- ====================================================================================================================

BEGIN
	
	SET NOCOUNT ON;

	/* Truncate Existing Metadata Table before re-loading */

	Truncate Table Mgmt.Metadata_GA_Hierarchy

	/* Insert Metadata Values */

	INSERT INTO Mgmt.Metadata_GA_Hierarchy
	(Feedback_Category,
     Feedback_Action,
     Hierarchy)
	VALUES 
	('FIU','Sessions',1),
	('FIU','Sessions>10 Sec',2),
	('FIU','Register Interest',3),
	('FAA','Sessions',1),
	('FAA','FAA View Vacancy',2),
	('FAA','FAA Start Apply',3),
	('FAA','FAA Apply',4),
	('FAT','Sessions',1),
	('FAT','Standard Search',2),
	('FAT','Provider Search',3),
	('FAT','View Provider',4)

   
END
GO
