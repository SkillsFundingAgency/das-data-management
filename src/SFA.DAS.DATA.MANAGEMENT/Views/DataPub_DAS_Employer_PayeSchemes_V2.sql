﻿CREATE VIEW [Data_Pub].[DAS_Employer_PayeSchemes_V2]	
AS 
	SELECT 
			 ISNULL(CAST(ah.Id as bigint),-1)																			 as Id
			,ISNULL(CAST(a.HashedId as nvarchar(100)),'XXXXXX')                                                          as DasAccountId 		
			,p.Ref                                                                                                       AS PAYEReference
			, Cast( p.Name AS nvarchar(100))                                                                             as PAYESchemeName
			,ISNULL(Cast(ah.AddedDate AS DateTime),'9999-12-31')                                                         as AddedDate
			,ah.RemovedDate                                                                                              as RemovedDate
			,ISNULL(CASE -- make up a last changed date from added/removed.
			WHEN ah.RemovedDate > ah.AddedDate THEN ah.RemovedDate
			ELSE ah.AddedDate 
			END,'9999-12-31')                                                                                            as UpdateDateTime
			,CASE -- make up a last changed date from added/removed.
				WHEN ah.RemovedDate > ah.AddedDate THEN Cast ( ah.RemovedDate as DATE ) 
				ELSE Cast ( ah.AddedDate AS DATE ) 
			 END                                                                                                         as UpdateDate
			,ISNULL(CASE  -- work out IsLatest as the views that reference this view select out the islatest = 1 
			 WHEN RANK () OVER (PARTITION BY a.ID, AH.PayeRef ORDER BY ah.RemovedDate DESC, ah.AddedDate DESC ) = 1 THEN Cast(1 AS BIT ) 
			 ELSE Cast ( 0 AS BIT ) 
			 END,-1)                                                                                                     AS Flag_Latest
	FROM [ASData_PL].[Acc_Account] a
	INNER JOIN [ASData_PL].[Acc_AccountHistory] ah ON a.Id = ah.AccountID
	INNER JOIN [ASData_PL].[Acc_Paye] p ON ah.PayeRef = p.Ref
	
GO