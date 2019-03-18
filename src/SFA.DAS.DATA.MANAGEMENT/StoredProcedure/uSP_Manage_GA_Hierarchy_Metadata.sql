

CREATE PROCEDURE mtd.usp_Manage_GA_Hierarchy_Metadata

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

	Truncate Table Mtd.Metadata_GA_Hierarchy

	/* Insert Metadata Values */

	INSERT INTO Mtd.Metadata_GA_Hierarchy
	(Feedback_Category,
     Feedback_Action,
	 Hierarchy_Grouping,
     Hierarchy)
	VALUES 
	('FIU','Sessions','G1',1),
	('FIU','Sessions>10 Sec','G1',2),
	('FIU','Register Interest','G1',3),
	('FAA','Sessions','G2',1),
	('FAA','FAA View Vacancy','G2',2),
	('FAA','FAA Start Apply','G2',3),
	('FAA','FAA Apply','G2',4),
	('FAT','Sessions','G3',1),
	('FAT','Standard Search','G3',2),
	('FAT','Provider Search','G3',3),
	('FAT','View Provider','G3',4)

   
END
GO
