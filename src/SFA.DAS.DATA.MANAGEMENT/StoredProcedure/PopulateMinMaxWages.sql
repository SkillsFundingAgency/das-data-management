CREATE PROCEDURE [dbo].[PopulateMinMaxWages] (@RunId int)
AS
BEGIN TRY

    DECLARE @LogID int

    /* Start Logging Execution */

    INSERT INTO Mgmt.Log_Execution_Results
    (
        RunId,
        StepNo,
        StoredProcedureName,
        StartDateTime,
        Execution_Status
    )
    SELECT @RunId,
           'Step-6',
           'PopulateMinMaxWages',
           getdate(),
           0

    SELECT @LogID = MAX(LogId)
    FROM Mgmt.Log_Execution_Results
    WHERE StoredProcedureName = 'PopulateMinMaxWages'
          AND RunId = @RunID

    BEGIN TRANSACTION

    TRUNCATE TABLE ASData_PL.Va_VacancyWages

    INSERT INTO ASData_PL.Va_VacancyWages
    (
        VacancyId,
        NumberOfPositions,
        WageType,
        AnnaualMinimumWage,
        AnnualMaximumWage
    )
    ----Unknown salary amounts
    SELECT distinct
        vacancyid,
        NumberOfPositions,
        Wagetype = 'Unknown Wage',
        [Annual Minimum wage] = null,
        [Annual Maximum wage] = null
    FROM [ASData_PL].[Va_Vacancy]
    where HasHadLiveStatus = 1
          and dateposted >= '01-Aug-2018'
          and VacancyTypeDesc NOT LIKE 'Traineeship%'
          and (
                  wagetype in ( 'Competitive salary', 'To be agreed upon appointment', 'Unwaged','Unspecified' )
                  or [WageText] like '%unknown%'
              )
    UNION ALL

    --------------Apprenticeship Minimum Wage
    SELECT distinct
        vacancyid,
        NumberOfPositions,
        Wagetype = 'Apprenticeship Minimum Wage',
        case
            when [WageUnitDesc] = 'Weekly'
                 and CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) < 1000 then
        (CONVERT(DECIMAL(18, 5), replace(WageText, '£', '')) * 52)
            when [WageUnitDesc] = 'Weekly'
                 and CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) >= 1000
                 and CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) < 5000 then
        (CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) * 12)
            when [WageUnitDesc] = 'Monthly'
                 and CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) < 5000 then
        (CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) * 12)
            when [WageUnitDesc] = 'Monthly'
                 and CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) >= 5000 then
        (CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')))
            when [WageUnitDesc] = 'Annually' then
                CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', ''))
            else
                CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', ''))
        end as [Annual Minimum wage],
        case
            when [WageUnitDesc] = 'Weekly'
                 and CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) < 1000 then
        (CONVERT(DECIMAL(18, 5), replace(WageText, '£', '')) * 52)
            when [WageUnitDesc] = 'Weekly'
                 and CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) >= 1000
                 and CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) < 5000 then
        (CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) * 12)
            when [WageUnitDesc] = 'Monthly'
                 and CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) < 5000 then
        (CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) * 12)
            when [WageUnitDesc] = 'Monthly'
                 and CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')) >= 5000 then
        (CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', '')))
            when [WageUnitDesc] = 'Annually' then
                CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', ''))
            else
                CONVERT(DECIMAL(18, 5), REPLACE(replace(WageText, '£', ''), ',', ''))
        end as [Annual Maximum wage]
    FROM [ASData_PL].[Va_Vacancy]
    where HasHadLiveStatus = 1
          and dateposted >= '01-Aug-2018'
          and VacancyTypeDesc NOT LIKE 'Traineeship%'
          and wagetype = 'Apprenticeship Minimum Wage'
          and [WageText] not like '%unknown%'
    UNION ALL
    --------------custom wage
    select vacancyid,
           NumberOfPositions,
           Wagetype,
           [Annual Minimum wage] = case
                                       when [Annual Minimum wage] > 50000
                                            and [Annual Minimum wage] <= 300000 then
                                           [Annual Minimum wage] / 10
                                       when [Annual Minimum wage] > 300000 then
                                           [Annual Minimum wage] / 100
                                       else
                                           [Annual Minimum wage]
                                   end,
           [Annual Maximum wage] = case
                                       when [Annual Maximum wage] > 50000
                                            and [Annual Maximum wage] <= 300000 then
                                           [Annual Maximum wage] / 10
                                       when [Annual Maximum wage] > 300000 then
                                           [Annual Maximum wage] / 100
                                       else
                                           [Annual Maximum wage]
                                   end
    from
    (
        SELECT distinct
            vacancyid,
            NumberOfPositions,
            Wagetype = 'Custom Wage',
            case
                when [WageUnitDesc] = 'Weekly'
                     and [WeeklyWage_v1] < 1000 then
            ([WeeklyWage_v1] * 52)
                when [WageUnitDesc] = 'Weekly'
                     and [WeeklyWage_v1] >= 1000
                     and [WeeklyWage_v1] < 5000 then
            ([WeeklyWage_v1] * 12)
                when [WageUnitDesc] = 'Monthly'
                     and [WeeklyWage_v1] < 5000 then
            ([WeeklyWage_v1] * 12)
                when [WageUnitDesc] = 'Monthly'
                     and [WeeklyWage_v1] >= 5000 then
            ([WeeklyWage_v1])
                when [WageUnitDesc] = 'Annually' then
                    [WeeklyWage_v1]
                else
                    [WeeklyWage_v1]
            end as [Annual Minimum wage],
            case
                when [WageUnitDesc] = 'Weekly'
                     and [WeeklyWage_v1] < 1000 then
            ([WeeklyWage_v1] * 52)
                when [WageUnitDesc] = 'Weekly'
                     and [WeeklyWage_v1] >= 1000
                     and [WeeklyWage_v1] < 5000 then
            ([WeeklyWage_v1] * 12)
                when [WageUnitDesc] = 'Monthly'
                     and [WeeklyWage_v1] < 5000 then
            ([WeeklyWage_v1] * 12)
                when [WageUnitDesc] = 'Monthly'
                     and [WeeklyWage_v1] >= 5000 then
            ([WeeklyWage_v1])
                when [WageUnitDesc] = 'Annually' then
                    [WeeklyWage_v1]
                else
                    [WeeklyWage_v1]
            end as [Annual Maximum wage]
        FROM [ASData_PL].[Va_Vacancy]
        where HasHadLiveStatus = 1
              and dateposted >= '01-Aug-2018'
              and VacancyTypeDesc NOT LIKE 'Traineeship%'
              and wagetype = 'Custom Wage'
              and [WeeklyWage_v1] is not null
              and [WageText] not like '%unknown%'
    ) k
    UNION ALL
    -------------------------------Custom wage range

    select vacancyid,
           NumberOfPositions,
           Wagetype,
           [Annual Minimum wage] = case
                                       when [Annual Minimum wage] > 50000
                                            and [Annual Minimum wage] <= 300000 then
                                           [Annual Minimum wage] / 10
                                       when [Annual Minimum wage] > 300000 then
                                           [Annual Minimum wage] / 100
                                       else
                                           [Annual Minimum wage]
                                   end,
           [Annual Maximum wage] = case
                                       when [Annual Maximum wage] > 50000
                                            and [Annual Maximum wage] <= 300000 then
                                           [Annual Maximum wage] / 10
                                       when [Annual Maximum wage] > 300000 then
                                           [Annual Maximum wage] / 100
                                       else
                                           [Annual Maximum wage]
                                   end
    from
    (
        SELECT distinct
            vacancyid,
            NumberOfPositions,
            Wagetype = 'Custom Wage Range',
            case
                when [WageUnitDesc] = 'Weekly'
                     and [WageLowerBound_v1] < 1000 then
            ([WageLowerBound_v1] * 52)
                when [WageUnitDesc] = 'Weekly'
                     and [WageLowerBound_v1] >= 1000
                     and [WageLowerBound_v1] < 5000 then
            ([WageLowerBound_v1] * 12)
                when [WageUnitDesc] = 'Monthly'
                     and [WageLowerBound_v1] < 5000 then
            ([WageLowerBound_v1] * 12)
                when [WageUnitDesc] = 'Monthly'
                     and [WageLowerBound_v1] >= 5000 then
            ([WageLowerBound_v1])
                when [WageUnitDesc] = 'Annually'
                     and [WageLowerBound_v1] < 1000 then
                    [WageLowerBound_v1] * 52
                when [WageUnitDesc] = 'Annually'
                     and (
                             [WageLowerBound_v1] >= 1000
                             and [WageLowerBound_v1] < 5000
                         ) then
                    [WageLowerBound_v1] * 12
                when [WageUnitDesc] = 'Annually' then
                    [WageLowerBound_v1]
                else
                    [WageLowerBound_v1]
            end as [Annual Minimum wage],
            case
                when [WageUnitDesc] = 'Weekly'
                     and [WageUpperBound_v1] < 1000 then
            ([WageUpperBound_v1] * 52)
                when [WageUnitDesc] = 'Weekly'
                     and [WageUpperBound_v1] >= 1000
                     and [WageUpperBound_v1] < 5000 then
            ([WageUpperBound_v1] * 12)
                when [WageUnitDesc] = 'Monthly'
                     and [WageUpperBound_v1] < 5000 then
            ([WageUpperBound_v1] * 12)
                when [WageUnitDesc] = 'Monthly'
                     and [WageUpperBound_v1] >= 5000 then
            ([WageUpperBound_v1])
                when [WageUnitDesc] = 'Annually'
                     and [WageUpperBound_v1] < 1000 then
                    [WageUpperBound_v1] * 52
                when [WageUnitDesc] = 'Annually'
                     and (
                             [WageUpperBound_v1] >= 1000
                             and [WageUpperBound_v1] < 5000
                         ) then
                    [WageLowerBound_v1] * 12
                when [WageUnitDesc] = 'Annually' then
                    [WageUpperBound_v1]
                else
                    [WageUpperBound_v1]
            end as [Annual Maximum wage]
        FROM [ASData_PL].[Va_Vacancy]
        where HasHadLiveStatus = 1
              and dateposted >= '01-Aug-2018'
              and VacancyTypeDesc NOT LIKE 'Traineeship%'
              and wagetype = 'Custom Wage Range'
              and [WageText] not like '%unknown%'
    ) k
    UNION ALL

    -----------------------------National Minimum Wage,FixedWage,NationalMinimumWageForApprentices,NationalMinimumWage
   
        
	select vacancyid,
           NumberOfPositions,
           Wagetype,
           [Annual Minimum wage] = case
                                       when [Annual Minimum wage] > 50000
                                            and [Annual Minimum wage] <= 300000 then
                                           [Annual Minimum wage] / 10
                                       when [Annual Minimum wage] > 300000 then
                                           [Annual Minimum wage] / 100
                                       else
                                           [Annual Minimum wage]
                                   end,
           [Annual Maximum wage] = case
                                       when [Annual Maximum wage] > 50000
                                            and [Annual Maximum wage] <= 300000 then
                                           [Annual Maximum wage] / 10
                                       when [Annual Maximum wage] > 300000 then
                                           [Annual Maximum wage] / 100
                                       else
                                           [Annual Maximum wage]
                                   end
    from( 
	 
	 
	 select  vacancyid,
               NumberOfPositions,
               Wagetype = 'National Minimum or Fixed Wage',
               case
                   when [WageUnitDesc] = 'Weekly' then
                       minimumwage * 52
                   when [WageUnitDesc] = 'Monthly' then
                       minimumwage * 12
                   else
                       minimumwage
               end as [Annual Minimum wage],
               case
                   when [WageUnitDesc] = 'Weekly' then
                       maximumwage * 52
                   when [WageUnitDesc] = 'Monthly' then
                       maximumwage * 12
                   else
                       maximumwage
               end as [Annual Maximum wage] from(

SELECT VacancyID,
                   [NumberOfPositions],
                   [WageUnitDesc],				  
                   CONVERT(
                              DECIMAL(18, 5),ISNULL(NULLIF(
                              REPLACE(
                                         case
                                             when [WageType] = 'National Minimum Wage'
                                                  and WageText like '%to%'
                                                  and SourceDb = 'RAAv1' THEN
                                                 substring(
                                                              replace([WageText], ' ', ''),
                                                              2,
                                                              charindex(
                                                                           'to',
                                                                           ltrim(rtrim(replace([WageText], ' ', '')))
                                                                       ) - 2
                                                          )
                                             when [WageType] = 'National Minimum Wage'
                                                  and WageText like '%-%'
                                                  and SourceDb = 'RAAv1' THEN
                                                 substring(
                                                              replace([WageText], ' ', ''),
                                                              2,
                                                              charindex('-', ltrim(rtrim(replace([WageText], ' ', ''))))
                                                              - 2
                                                          )
										    WHEN WageType = 'NationalMinimumWage'
                                                  and DatePosted < '2022-04-01' THEN
                                                 CAST(NMR.MinWage * 52 * HoursPerWeek as varchar)
											when [WageType] = 'NationalMinimumWage'
                                                  and WageText like '%-%'
                                                  --and SourceDb = 'RAAv1'
												  THEN
                                                 substring(
                                                              replace([WageText], ' ', ''),
                                                              1,
                                                              charindex('-', ltrim(rtrim(replace([WageText], ' ', ''))))
                                                              - 2
                                                          )
                                             when [WageType] = 'FixedWage'
                                                  and WageText like '% %' THEN
                                                 substring([WageText], 1, charindex(' ', WageText) - 1)
                                             WHEN WageType = 'NationalMinimumWageForApprentices'
                                                  and DatePosted < '2022-04-01' THEN
                                                 CAST(AMW.WageRateInPounds * 52 * HoursPerWeek as varchar)
                                            
                                             WHEN WageType = 'NationalMinimumWageForApprentices'
                                                  and DatePosted >= '2022-04-01'
                                                  and DatePosted <= '2023-03-31' THEN
                                                 cast(4.81 * HoursPerWeek * 52 as varchar)
                                             WHEN WageType = 'NationalMinimumWage'
                                                  and DatePosted >= '2022-04-01'
                                                  and DatePosted <= '2023-03-31' THEN
                                                 cast(4.81 * HoursPerWeek * 52 as varchar)
                                             ELSE
                                                 --'0.000'
												  replace(WageText, '£', '')
                                         END,
                                         ',',
                                         ''
                                     )
                          , ''), '0')) 
						  AS MinimumWage,
                   CONVERT(
                              DECIMAL(18, 5), ISNULL(NULLIF(
                              replace(
                                         case
                                             when [WageType] = 'National Minimum Wage'
                                                  and WageText like '%to%'
                                                  and SourceDb = 'RAAv1' THEN
                                                 substring(
                                                              replace([WageText], ' ', ''),
                                                              charindex(
                                                                           'to',
                                                                           ltrim(rtrim(replace([WageText], ' ', '')))
                                                                       ) + 3,
                                                              len(replace([WageText], ' ', ''))
                                                          )
                                             when [WageType] = 'National Minimum Wage'
                                                  and WageText like '%-%'
                                                  and SourceDb = 'RAAv1' THEN
                                                 substring(
                                                              replace([WageText], ' ', ''),
                                                              charindex('-', ltrim(rtrim(replace([WageText], ' ', ''))))
                                                              + 2,
                                                              len(replace([WageText], ' ', ''))
                                                          )
                                             when [WageType] = 'FixedWage'
                                                  and WageText like '% %' THEN
                                                 substring([WageText], 1, charindex(' ', WageText) - 1)
                                             WHEN WageType = 'NationalMinimumWageForApprentices'
                                                  and DatePosted < '2022-04-01' THEN
                                                 CAST(AMW.WageRateInPounds * 52 * HoursPerWeek as varchar)
                                             WHEN WageType = 'NationalMinimumWage'
                                                  and DatePosted < '2022-04-01' THEN
                                                 CAST(NMR.MaxWage * 52 * HoursPerWeek as Varchar)
											 when [WageType] = 'NationalMinimumWage'
                                                  and WageText like '%-%'
                                                  --and SourceDb = 'RAAv1'
												  THEN
                                                 substring(
                                                              replace([WageText], ' ', ''),
                                                              charindex('-', ltrim(rtrim(replace([WageText], ' ', ''))))
                                                              + 1,
                                                              len(replace([WageText], ' ', ''))
                                                          )
                                             WHEN WageType = 'NationalMinimumWageForApprentices'
                                                  and DatePosted >= '2022-04-01'
                                                  and DatePosted <= '2023-03-31' THEN
                                                 cast(4.81 * HoursPerWeek * 52 as varchar)
                                             WHEN WageType = 'NationalMinimumWage'
                                                  and DatePosted >= '2022-04-01'
                                                  and DatePosted <= '2023-03-31' THEN
                                                 cast(9.50 * HoursPerWeek * 52 as varchar)
                                             ELSE
											 --'0.000'
                                                 replace(WageText, '£', '')
                                         END,
                                         ',',
                                         ''
                                     )
                          , ''), '0'))
						  AS MaximumWage from(
						   SELECT VacancyID,
                   [NumberOfPositions],
                   [WageUnitDesc],
				   SUBSTRING(wagetext, 0, CHARINDEX(' ', wagetext))as wagetext,				  
				   [WageType],
				   DatePosted,
				   HasHadLiveStatus,
				   VacancyTypeDesc,
				   HoursPerWeek,
				   SourceDb,
				   ASDm_updatedDatetime
            FROM [ASData_PL].[Va_Vacancy]) Va
                LEFT JOIN
                (
                    SELECT StartDate,
                           EndDate,
                           WageRateInPounds
                    FROM Mtd.NationalMinimumWageRates
                    WHERE AgeGroup = 'Apprentice'
                ) AMW -- ApprenticeMinimumWage
                    ON convert(date, Va.DatePosted) >= AMW.StartDate
                       AND convert(Date, Va.DatePosted) <= AMW.EndDate
                LEFT JOIN
                (
                    SELECT StartDate,
                           EndDate,
                           MIN(WageRateInPounds) MinWage,
                           MAX(WageRateInPounds) MaxWage
                    FROM Mtd.NationalMinimumWageRates
                    WHERE AgeGroup <> 'Apprentice'
                    GROUP BY StartDate,
                             EndDate
                ) NMR
                    ON convert(date, DatePosted) >= NMR.StartDate
                       AND convert(date, DatePosted) <= NMR.EndDate
            where Va.HasHadLiveStatus = 1
                  and Va.dateposted >= '01-Aug-2018'
                  and Va.VacancyTypeDesc NOT LIKE 'Traineeship%'
                  and Va.wagetype in ( 'National Minimum Wage', 'FixedWage', 'NationalMinimumWageForApprentices',
                                    'NationalMinimumWage')
								  )k)z



    COMMIT TRANSACTION



    UPDATE Mgmt.Log_Execution_Results
    SET Execution_Status = 1,
        EndDateTime = getdate(),
        FullJobStatus = 'Pending'
    WHERE LogId = @LogID
          AND RunId = @RunId


END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @ErrorId int

    INSERT INTO Mgmt.Log_Error_Details
    (
        UserName,
        ErrorNumber,
        ErrorState,
        ErrorSeverity,
        ErrorLine,
        ErrorProcedure,
        ErrorMessage,
        ErrorDateTime,
        RunId
    )
    SELECT SUSER_SNAME(),
           ERROR_NUMBER(),
           ERROR_STATE(),
           ERROR_SEVERITY(),
           ERROR_LINE(),
           'PopulateMinMaxWages',
           ERROR_MESSAGE(),
           GETDATE(),
           @RunId as RunId;

    SELECT @ErrorId = MAX(ErrorId)
    FROM Mgmt.Log_Error_Details

    /* Update Log Execution Results as Fail if there is an Error*/

    UPDATE Mgmt.Log_Execution_Results
    SET Execution_Status = 0,
        EndDateTime = getdate(),
        ErrorId = @ErrorId
    WHERE LogId = @LogID
          AND RunID = @RunId

END CATCH

GO