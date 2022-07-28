CREATE VIEW [Data_Pub].[DAS_Employer_Account_Transfers_V2]	
AS 
	SELECT
      MAX( ISNULL(CAST(AT.Id AS bigint),-1) )                                                As TransferId
    , ISNULL(CAST(AT.TransferSenderAccountId AS bigint),-1)                                  As SenderAccountId
    , ISNULL(CAST(AT.AccountId AS bigint),-1)                                                As ReceiverAccountId
    , MAX( ISNULL(at.eventid,'00000000-0000-0000-0000-000000000000') )                       As RequiredPaymentId
    , ISNULL(CAST(ApprenticeshipId AS bigint),-1)                                            As CommitmentId
    , SUM(CAST(at.Amount as decimal(18,5)))                                                  As Amount
    , ISNULL(CAST(at.ApprenticeshipEmployerType as nvarchar(50)),'NA')                       As Type
    , ISNULL(CAST (at.PeriodEnd AS NVARCHAR(10)),'XXXX')                                     As CollectionPeriodName
    , MAX(ISNULL(at.eventtime,'9999-12-31'))                                                 As UpdateDateTime
    FROM (SELECT *,  Cast( sp.AcademicYear AS varchar) + '-R' + RIGHT( '0' + Cast (sp.CollectionPeriod AS varchar),2)  As PeriodEnd
                FROM stgpmts.Payment sp
                WHERE FundingSource=5) AT
	GROUP BY AT.TransferSenderAccountId
            ,AT.AccountId
            ,AT.ApprenticeshipId
            ,AT.PeriodEnd,AT.ApprenticeshipEmployerType
GO