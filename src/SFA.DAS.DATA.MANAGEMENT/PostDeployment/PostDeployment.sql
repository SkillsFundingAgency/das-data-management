﻿--REVOKE UNMASK TO [Himabindu.Uddaraju@citizenazuresfabisgov.onmicrosoft.com]

--if exists (select * from sys.objects where name = 'Stg_FIC_Feedback' and type = 'u')
--DROP TABLE dbo.Stg_FIC_Feedback


DROP TABLE mgmt.Metadata_GA_Hierarchy

DROP PROCEDURE Mgmt.usp_Manage_Commitments_Lookup

DROP PROCEDURE Mgmt.usp_Manage_GA_Hierarchy_Metadata


EXEC Mgmt.USP_UnitTest1_CheckCounts


EXEC Mtd.usp_Manage_GA_Hierarchy_Metadata


EXEC mtd.usp_Manage_Commitments_Lookup




