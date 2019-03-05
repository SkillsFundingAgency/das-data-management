 CREATE PROCEDURE dbo.USP_UnitTest1_CheckCounts
 as
 -- =======================================================================================================
-- Author:		Himabindu Uddaraju
-- Create date: 05/03/2019
-- Description:	Does Unit Testing Post Deployment by checking Record Counts between Source and Destination
-- ========================================================================================================
 BEGIN TRY
 
 DECLARE @COUNT INT

 SET @COUNT=
 (
 SELECT count(*)
   FROM dbo.Deployment_Audit
  WHERE Source_Object_Count<>Target_Object_Count
    AND ExpectedToMatchCount=1
 )
 
 -- Raise Error if there are Tables where the Import Counts Don't Match

If @COUNT>0
RAISERROR ('Error raised in TRY block.', 
               16,
               1
               );  
END TRY  

BEGIN CATCH  

    DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
    SELECT   
        @ErrorMessage = ERROR_MESSAGE(),  
        @ErrorSeverity = ERROR_SEVERITY(),  
        @ErrorState = ERROR_STATE();  
  
   
    RAISERROR (@ErrorMessage, -- Message text.  
               @ErrorSeverity, -- Severity.  
               @ErrorState -- State.  
               );  

END CATCH