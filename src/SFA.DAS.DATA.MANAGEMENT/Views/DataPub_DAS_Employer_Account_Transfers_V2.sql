CREATE VIEW [Data_Pub].[DAS_Employer_Account_Transfers_V2]	
AS 
SELECT
      CAST(MAX( ISNULL(AT.Id ,-1) ) AS bigint)                                              As TransferId
    , CAST(ISNULL(AT.TransferSenderAccountId ,-1)  AS bigint  )                             As SenderAccountId
    , CAST(ISNULL(AT.AccountId ,-1) AS bigint)                                              As ReceiverAccountId
    , CAST(MAX( ISNULL(at.eventid,'00000000-0000-0000-0000-000000000000') ) as uniqueidentifier)                      As RequiredPaymentId
    , CAST(ISNULL(ApprenticeshipId ,-1) AS bigint)                                          As CommitmentId
    , CAST(SUM(at.Amount ) as decimal(18,5))                                                As Amount
    , CAST('Levy' as nvarchar(50))                                                          As Type
    , CAST(ISNULL(at.PeriodEnd ,'XXXX') AS NVARCHAR(10))                                    As CollectionPeriodName
    , CAST(MAX(ISNULL(at.eventtime,'9999-12-31'))  as datetime)                             As UpdateDateTime
    FROM (SELECT *,  Cast( sp.AcademicYear AS varchar) + '-R' + RIGHT( '0' + Cast (sp.CollectionPeriod AS varchar),2)  As PeriodEnd
                FROM stgpmts.Payment sp
                WHERE FundingSource=5) AT
	GROUP BY AT.TransferSenderAccountId
            ,AT.AccountId
            ,AT.ApprenticeshipId
            ,AT.PeriodEnd,AT.ApprenticeshipEmployerType
GO