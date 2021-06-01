/* Execute Stored Procedure */

EXEC [dbo].[Build_AS_DataMart]

/* Alter GA Table to Create Partition Index */


CREATE CLUSTERED INDEX IX_GASessionData_GASD_ID ON AsData_PL.GA_SessionData (GASD_ID)
  WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
        ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
  ON myPartitionScheme(PS_DatePartition)

CREATE NONCLUSTERED INDEX NIX_GASessionData_ClinetId ON AsData_PL.GA_SessionData (ClientId)
  WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
        ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
  
