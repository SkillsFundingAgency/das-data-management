CREATE VIEW [Data_Pub].[DAS_LevyDeclarations_v2]
AS 
with saltkeydata as 
(
	Select TOP 1 SaltKeyID,SaltKey From AsData_PL.SaltKeyLog Where SourceType ='LevyDeclarations'  Order by SaltKeyID DESC 
)
SELECT  ISNULL(CAST(LD.[Id] AS bigint),-1)                                  AS Id
      , ISNULL(CAST(EA.HashedId as nvarchar(100)),'XXXXXX')					AS DASAccountID
      , ISNULL(CAST(LD.ID as bigint),-1)                                    AS LevyDeclarationID         	              	  
	  , CASE 
			WHEN LD.empRef IS NOT NULL THEN convert(NVarchar(500),HASHBYTES('SHA2_512',LTRIM(RTRIM(CONCAT(LD.empRef, saltkeydata.SaltKey)))),2)  
			Else NULL 
	    End AS PAYEReference
	  , CAST(LD.LevyDueYTD AS decimal(18,5))                                AS LevyDueYearToDate
      , CAST(LD.[LevyAllowanceForYear] as decimal(18,5))                    AS LevyAllowanceForYear
      , LD.[SubmissionDate]                                                 AS SubmissionDateTime
      , CAST(LD.[SubmissionDate] AS DATE)                                   AS SubmissionDate
      , ISNULL(CAST(LD.[SubmissionId] as bigint),-1)                        AS SubmissionID
      , ISNULL(CAST(LD.[PayrollYear] as nvarchar(10)),-1)                   AS PayrollYear
      , ISNULL(CAST(LD.[PayrollMonth] as tinyint),0)                        AS PayrollMonth
      , ISNULL(LD.[CreatedDate],'9999-12-31')                               AS CreatedDateTime
      , CAST(LD.CreatedDate AS DATE)                                        AS CreatedDate
      , ISNULL(LD.[EndOfYearAdjustment],-1)                                 AS EndOfYearAdjustment
      , CAST(LD.[EndOfYearAdjustmentAmount] as Decimal(18,5))               AS EndOfYearAdjustmentAmount
      , LD.[DateCeased]                                                     AS DateCeased
      , LD.[InactiveFrom]                                                   AS InactiveFrom
      , LD.[InactiveTo]                                                     AS InactiveTo
      , LD.[HmrcSubmissionId]                                               AS HMRCSubmissionID
      , ISNULL(CAST(LD.[EnglishFraction] as decimal(18,5)),-1)              AS EnglishFraction
      , ISNULL(CAST(LD.[TopupPercentage] as decimal(18,5)),-1)              AS TopupPercentage
      , ISNULL(CAST(TopUp as decimal(18,5)),-1)                             AS TopupAmount
      , ISNULL(LD.CreatedDate,'9999-12-31')                                 AS UpdateDateTime
	 -- Additional Columns for UpdateDateTime represented as a Date
      ,	CAST(LD.CreatedDate AS DATE)                                         AS UpdateDate
	-- Flag to say if latest record from subquery, Using Coalesce to set null value to 0
      , ISNULL(CAST(1 as Bit),-1)                                            AS Flag_Latest
	  , cast(CM.CalendarMonthShortNameYear AS Varchar(20))                   AS PayrollMonthShortNameYear 
      , Cast(LD.LevyDeclaredInMonth AS decimal(18,5))                        AS LevyDeclaredInMonth
      , Cast(LD.TotalAmount as Decimal(18,5))                                AS LevyAvailableInMonth                            
      , cast(LD.LevyDeclaredInMonth * LD.EnglishFraction as decimal(37,10))  AS LevyDeclaredInMonthWithEnglishFractionApplied
  FROM [ASData_PL].[Fin_GetLevyDeclarationAndTopUp] AS LD
    LEFT JOIN [ASData_PL].[Acc_Account] EA 
           ON EA.ID=LD.AccountId
	LEFT JOIN dbo.DASCalendarMonth AS CM 
	       ON LD.PayrollYear = CM.TaxYear AND LD.PayrollMonth = CM.TaxMonthNumber
	CROSS JOIN saltkeydata 
 WHERE LD.LastSubmission=1
GO

