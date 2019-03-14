--REVOKE UNMASK TO [Himabindu.Uddaraju@citizenazuresfabisgov.onmicrosoft.com]

--if exists (select * from sys.objects where name = 'Stg_FIC_Feedback' and type = 'u')
--DROP TABLE dbo.Stg_FIC_Feedback

EXEC Mgmt.USP_UnitTest1_CheckCounts


EXEC mgmt.usp_Manage_GA_Hierarchy_Metadata


--DROP PROCEDURE [dbo].[USP_UnitTest1_CheckCounts]

--DROP TABLE [dbo].[Deployment_Audit]

DROP TABLE [dbo].Stg_FIU_Feedback
