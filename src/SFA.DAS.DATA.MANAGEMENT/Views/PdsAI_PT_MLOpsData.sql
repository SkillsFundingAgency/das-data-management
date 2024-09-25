CREATE VIEW [Pds_AI].[MLOpsData]
	AS 
WITH CTE_BASE AS(
	SELECT 	
	app.Id AS ApprenticeshipId
	,app.CommitmentId
	,Commitment.Id
	,app.CreatedOn
	,app.ULN
	,app.StandardUId
	,app.StartDate
	,app.EndDate	
	,app.StopDate
	,Learner.LearnStartDate
	,Learner.PlannedEndDate
	,Learner.LearnActEndDate
	,Commitment.ProviderId AS UKPRN	
	,Learner.DelLoc_Pst_Lower_Layer_SOA
	,Learner.CompletionStatus
	,Learner.IsTransfer
	FROM ASData_PL.Comt_Apprenticeship app
	LEFT JOIN ASData_PL.Comt_Commitment Commitment
	ON Commitment.Id=app.CommitmentId
	LEFT JOIN ASData_PL.Assessor_Learner Learner	
	ON Learner.ApprenticeshipId=app.Id	
	WHERE TRY_CONVERT(DATE,app.CreatedOn)>= DATEADD(DAY, -7, GETDATE())
),
 COURSES AS
(
	SELECT 
		Standards.StandardUId
		,Standards.LarsCode AS StandardCode
		,Standards.[Level]
		--,SSATLookup.SectorCode
		,SSATLookup.SectorSubjectAreaTier1
		,SSATLookup.SectorSubjectAreaTier2
		--,LKP_SSAT2.SectorSubjectAreaTier2
		,LKP_SSAT2.SectorSubjectAreaTier2_Desc
		,LKP_SSAT1.SectorSubjectAreaTier1_Desc
		--INTO #COURSES
		FROM
		ASData_PL.FAT2_StandardSector Standards
		LEFT JOIN ASData_PL.FAT2_LarsStandard SSATLookup
		ON Standards.LarsCode =SSATLookup.LarsCode
		LEFT JOIN lkp.LARS_SectorSubjectAreaTier2 LKP_SSAT2
		ON LKP_SSAT2.SectorSubjectAreaTier2=SSATLookup.SectorSubjectAreaTier2
		LEFT JOIN lkp.LARS_SectorSubjectAreaTier1 LKP_SSAT1
		ON LKP_SSAT1.SectorSubjectAreaTier1=SSATLookup.SectorSubjectAreaTier1
)

, STARRATING AS(
 SELECT
    UKPRN
    ,LARSCODE
    ,CASE
        WHEN NetRating<0 THEN 1
        ELSE 0 -- to cover nulls
        END
        AS FLAG_AGGREGATED_LOWRATING		
    FROM(
        SELECT
            UKprn AS UKPRN
            ,LarsCode AS LARSCODE
            ,SUM(
                CASE 
                    WHEN ProviderRating='VeryPoor' THEN -2
                    WHEN ProviderRating='Poor' THEN -1
                    WHEN ProviderRating='Good' THEN 1
                    WHEN ProviderRating='Excellent' THEN 2
                    ELSE 0 
                    END
                )
                AS NetRating
                FROM ASData_PL.Appfb_ApprenticeFeedbackTarget FeedbackTarget

                LEFT JOIN ASData_PL.Appfb_ApprenticeExitSurvey ExitSurvey
            ON FeedbackTarget.Id=ExitSurvey.ApprenticeFeedbackTargetId
            LEFT JOIN ASData_PL.Appfb_ApprenticeFeedbackResult FeedbackResult_Prov
            ON FeedbackResult_Prov.ApprenticeFeedbackTargetId=FeedbackTarget.Id
            GROUP BY 
                UKprn
                ,LarsCode
    ) ProviderApproval

)


,sic_part1 AS (
select
	id
	,[industry sector]
	,sicgroup
	,[sic code]
	,rn

	--into #sic_part1

	from(

	select 
	id
	,[industry sector]
	,sicgroup
	,[sic code]
	,rn

	from(

	select distinct
	id
	,[industry sector]
	,s.sicgroup
	,[sic code]
	,row_number() over(partition by id order by [industry sector]) as rn /*Create final de-dupe variable. 
	Where there are 2 rows created with SIC groups with equal live employees this arbitrarily choose the first one */	

	--into #sic

	from(

	select distinct 
	id	
	,employer
	,hashedid	
	,[industry sector]=[siccodesictext_1]	
	,[sic code]=trim(left([siccodesictext_1],5))
	,[employer type]
	,liveemployeecount
	,maxsic
	
	from	
	(	
	select
	a.[id],a.name as employer	
	,a.hashedid	
	,case when apprenticeshipemployertype=0 then 'non levy' else 'levy' end as [employer type]	
	,[siccodesictext_1]	
	,sum([liveemployeecount]) as liveemployeecount	
	,maxsic=max(sum([liveemployeecount])) over (partition by  a. [id] ) 
	
	from [asdata_pl].[acc_account] as a	
	left outer join [asdata_pl].[acc_accounthistory] as ah	
	on a.id=ah.accountid	
	left outer join [asdata_pl].[tpr_orgdetails] as tpr	
	on ah.payeref=tpr.empref	
	left outer join [asdata_pl].[cmphs_companieshousedata] as ch	
	on tpr.companieshousenumber=ch.companynumber	
	
	where
	apprenticeshipemployertype <>2 -- removed partially registered
	and name not like 'my account'-- removed partially registered	
	and	removeddate is null	-- only use active paye schemes
	and ch.siccodesictext_1 is not null -- remove any where no sic is returned	
	
	group by	
	a.[id]	
	,a.name	
	,case when apprenticeshipemployertype=0 then 'non levy' else 'levy' end 	
	,[siccodesictext_1]
	,hashedid
	
	) x	
	
	where 
	liveemployeecount=maxsic -- select the sic row with the dominant number of live employees

	) y

	left join [lkp].[pst_sic] s
	on y.[sic code] = s.siccode

	) z

	where rn = 1

	) a

	order by id
	OFFSET 0 ROWS
)


,sic as(
	select
	a.id
	,a.name as employer
	,case when s.sicgroup is null then 'Z:Unknown' else s.sicgroup end as sicgroup

	--into #sic

	from
	[asdata_pl].[acc_account] a
	left join sic_part1 s
	on a.id = s.id
)
,EMPLOYER_SECTOR AS (
	/* Apprenticeships table  for learner level data - joining with employer SIC, size etc */
	
	select
	app.id as ApprenticeshipId
	,com.EmployerAccountId
	,case 
	when acc.ApprenticeshipEmployerType = 1 then 'Levy'  -- larger levy paying employer
	when acc.ApprenticeshipEmployerType = 0 then 'Non-levy'  -- smaller non-levy paying employer
	when acc.ApprenticeshipEmployerType = 2 then 'Not fully registered' 
	else '?' end as 'Employer type'
	,case 
	when sic.SICGroup = 'Z Unknown' then 'Z:Unknown'
	when sic.SICGroup is null then 'Z:Unknown'
	else sic.SICGroup end as [Employer sector estimate]
	,case when sz.[Employee size] is null then 'F) Not known' else sz.[Employee size] end as Employee_size_estimate
	--INTO #EMPLOYER_SECTOR
	from [ASData_PL].[Comt_Apprenticeship] app
	left join [ASData_PL].[Comt_Commitment] com
	on app.CommitmentId = com.id
	left join [ASData_PL].[Acc_Account] acc
	on com.EmployerAccountId = acc.id
	left join  sic
	on acc.id = sic.id
	/* Add employer size- start */
	left join ( 
	select distinct a.[Id]
	,[Employee size]=case when sum([LiveEmployeeCount])<10 then 'A) 1-9 (Micro)'	
	when sum([LiveEmployeeCount])<50 then 'B) 10-49 (Small)'	
	when sum([LiveEmployeeCount])<250 then 'C) 50-249 (Medium)'	
	when sum([LiveEmployeeCount])<5000 then 'D) 250-4999 (Large)'	
	when sum([LiveEmployeeCount])>=5000   then 'E) 5000+ (Macro)' else 'F) Other' end	

	from [ASData_PL].[Acc_Account] as a	
	left outer join [ASData_PL].[Acc_AccountHistory] as ah	
	on a.id=ah.accountid	
	left outer join [ASData_PL].[Tpr_OrgDetails] as tpr	
	on ah.payeref=tpr.empref	
	
	where
	apprenticeshipemployertype<>2	
	and name not like 'my account'	
	and tpr.EmpRef is not null

	group by a.[Id]

	) sz on acc.id = sz.id

)

,wage AS (


	SELECT *

	FROM(
	SELECT distinct
	vacancyid, NumberOfPositions,
	Wagetype='Unknown Wage',
	[Annual Minimum wage]=null,
	[Annual Maximum wage]=null
	FROM [ASData_PL].[Va_Vacancy]
	where 
	HasHadLiveStatus=1
	and dateposted>='01-Aug-2018'
	and RAFDuplicateFlag = 0
	and VacancyTypeDesc NOT LIKE'Traineeship%'
	and (wagetype in ('Competitive salary','To be agreed upon appointment','Unwaged')
	or [WageText]  like '%unknown%')
	UNION ALL
	SELECT distinct
	vacancyid, NumberOfPositions,
	Wagetype='Apprenticeship Minimum Wage',
			case when [WageUnitDesc]='Weekly'  and CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))<1000  then (CONVERT(DECIMAL(18,5),replace(WageText,'£',''))*52) 
	when  [WageUnitDesc]='Weekly'  and CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',','')) >=1000 and CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',','')) <5000   then (CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))*12) 
	when  [WageUnitDesc]='Monthly' and CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))<5000  then (CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))*12) 
	when [WageUnitDesc]='Monthly' and CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))>=5000  then (CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))) 
	when  [WageUnitDesc]='Annually' then CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))
	else CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))end as [Annual Minimum wage],
			case when [WageUnitDesc]='Weekly'  and CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))<1000  then (CONVERT(DECIMAL(18,5),replace(WageText,'£',''))*52) 
	when  [WageUnitDesc]='Weekly'  and CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',','')) >=1000 and CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',','')) <5000   then (CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))*12) 
	when  [WageUnitDesc]='Monthly' and CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))<5000  then (CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))*12) 
	when [WageUnitDesc]='Monthly' and CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))>=5000  then (CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))) 
	when  [WageUnitDesc]='Annually' then CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))
	else CONVERT(DECIMAL(18,5),REPLACE(replace(WageText,'£',''),',',''))end as [Annual Maximum wage]


	  FROM [ASData_PL].[Va_Vacancy]
	where 
	HasHadLiveStatus=1
	and dateposted>='01-Aug-2018'
	and VacancyTypeDesc NOT LIKE'Traineeship%'
	and wagetype='Apprenticeship Minimum Wage'
	and [WageText] not like '%unknown%'
	and RAFDuplicateFlag = 0 
	UNION ALL

	select
	vacancyid, NumberOfPositions,
	Wagetype,
	[Annual Minimum wage]= case when [Annual Minimum wage]>50000 and [Annual Minimum wage]<=300000 then [Annual Minimum wage]/10
	when  [Annual Minimum wage] >300000 then [Annual Minimum wage]/100 else [Annual Minimum wage] end,
	[Annual Maximum wage]= case when [Annual Maximum wage]>50000 and [Annual Maximum wage]<=300000 then [Annual Maximum wage]/10
	when  [Annual Maximum wage] >300000 then [Annual Maximum wage]/100 else [Annual Maximum wage] end

	from(
	SELECT distinct
	vacancyid, NumberOfPositions,
	Wagetype='Custom Wage',
	case when  [WageUnitDesc]='Weekly'  and [WeeklyWage_v1]<1000  then ([WeeklyWage_v1]*52) 
	when  [WageUnitDesc]='Weekly'  and [WeeklyWage_v1] >=1000 and [WeeklyWage_v1] <5000   then ([WeeklyWage_v1]*12) 
	when  [WageUnitDesc]='Monthly' and [WeeklyWage_v1]<5000  then ([WeeklyWage_v1]*12) 
	when  [WageUnitDesc]='Monthly' and [WeeklyWage_v1]>=5000  then ([WeeklyWage_v1]) 
	when  [WageUnitDesc]='Annually' then [WeeklyWage_v1]
	else [WeeklyWage_v1] end  as [Annual Minimum wage],
	case when  [WageUnitDesc]='Weekly'  and [WeeklyWage_v1]<1000  then ([WeeklyWage_v1]*52) 
	when  [WageUnitDesc]='Weekly'  and [WeeklyWage_v1] >=1000 and [WeeklyWage_v1] <5000   then ([WeeklyWage_v1]*12) 
	when  [WageUnitDesc]='Monthly' and [WeeklyWage_v1]<5000  then ([WeeklyWage_v1]*12) 
	when  [WageUnitDesc]='Monthly' and [WeeklyWage_v1]>=5000  then ([WeeklyWage_v1]) 
	when  [WageUnitDesc]='Annually' then [WeeklyWage_v1]
	else [WeeklyWage_v1] end as [Annual Maximum wage]

	  FROM [ASData_PL].[Va_Vacancy]
	where 
	HasHadLiveStatus=1
	and dateposted>='01-Aug-2018'
	and VacancyTypeDesc NOT LIKE'Traineeship%'
	and wagetype='Custom Wage'
	and [WeeklyWage_v1] is not null
	and [WageText] not like '%unknown%'
	and RAFDuplicateFlag = 0 

	)k

	UNION ALL
	select
	vacancyid, NumberOfPositions,
	Wagetype,
	[Annual Minimum wage]= case when [Annual Minimum wage]>50000 and [Annual Minimum wage]<=300000 then [Annual Minimum wage]/10
	when  [Annual Minimum wage] >300000 then [Annual Minimum wage]/100 else [Annual Minimum wage] end,
	[Annual Maximum wage]= case when [Annual Maximum wage]>50000 and [Annual Maximum wage]<=300000 then [Annual Maximum wage]/10
	when  [Annual Maximum wage] >300000 then [Annual Maximum wage]/100 else [Annual Maximum wage] end
	from(
	SELECT distinct
	vacancyid, NumberOfPositions,
	Wagetype='Custom Wage Range',
	case when  [WageUnitDesc]='Weekly'  and [WageLowerBound_v1] <1000  then ([WageLowerBound_v1]*52) 
	when  [WageUnitDesc]='Weekly'  and [WageLowerBound_v1] >=1000 and [WageLowerBound_v1] <5000   then ([WageLowerBound_v1]*12) 
	when  [WageUnitDesc]='Monthly' and [WageLowerBound_v1]<5000  then ([WageLowerBound_v1]*12) 
	when  [WageUnitDesc]='Monthly' and [WageLowerBound_v1]>=5000  then ([WageLowerBound_v1]) 
	when  [WageUnitDesc]='Annually' and [WageLowerBound_v1] <1000 then [WageLowerBound_v1]*52
	when  [WageUnitDesc]='Annually' and ([WageLowerBound_v1] >=1000 and [WageLowerBound_v1]<5000 )then [WageLowerBound_v1]*12
	when  [WageUnitDesc]='Annually' then [WageLowerBound_v1]
	else [WageLowerBound_v1] end as [Annual Minimum wage],
	case when  [WageUnitDesc]='Weekly'  and [WageUpperBound_v1] <1000  then ([WageUpperBound_v1]*52) 
	when  [WageUnitDesc]='Weekly'  and [WageUpperBound_v1] >=1000 and [WageUpperBound_v1] <5000   then ([WageUpperBound_v1]*12) 
	when  [WageUnitDesc]='Monthly' and [WageUpperBound_v1]<5000  then ([WageUpperBound_v1]*12) 
	when  [WageUnitDesc]='Monthly' and [WageUpperBound_v1]>=5000  then ([WageUpperBound_v1]) 
	when  [WageUnitDesc]='Annually' and [WageUpperBound_v1] <1000 then [WageUpperBound_v1]*52
	when  [WageUnitDesc]='Annually' and ([WageUpperBound_v1] >=1000 and [WageUpperBound_v1]<5000 )then [WageLowerBound_v1]*12
	when  [WageUnitDesc]='Annually' then [WageUpperBound_v1]
	else [WageUpperBound_v1] end as [Annual Maximum wage]

	  FROM [ASData_PL].[Va_Vacancy]
	where 
	HasHadLiveStatus=1
	and dateposted>='01-Aug-2018'
	and VacancyTypeDesc NOT LIKE'Traineeship%'
	and wagetype='Custom Wage Range'
	and [WageText] not like '%unknown%'
	and RAFDuplicateFlag = 0
	)k

	UNION ALL

	select
	vacancyid, NumberOfPositions,
	Wagetype,
	[Annual Minimum wage]= case when [Annual Minimum wage]>50000 and [Annual Minimum wage]<=300000 then [Annual Minimum wage]/10
	when  [Annual Minimum wage] >300000 then [Annual Minimum wage]/100 else [Annual Minimum wage] end,
	[Annual Maximum wage]= case when [Annual Maximum wage]>50000 and [Annual Maximum wage]<=300000 then [Annual Maximum wage]/10
	when  [Annual Maximum wage] >300000 then [Annual Maximum wage]/100 else [Annual Maximum wage] end

	from(

	select 
	vacancyid, NumberOfPositions,
	Wagetype='National Minimum or Fixed Wage',
	case when [WageUnitDesc]='Weekly' then minimumwage*52
	when [WageUnitDesc]='Monthly' then minimumwage*12
	else minimumwage end as [Annual Minimum wage],
	case when [WageUnitDesc]='Weekly' then maximumwage*52
	when [WageUnitDesc]='Monthly' then maximumwage*12
	else maximumwage end as [Annual Maximum wage]

	from(

	select
	vacancyid,NumberOfPositions,[WageUnitDesc]
	,Wagetype='National Minimum or Fixed Wage'
	,case when isnumeric(MaximumWage) = 1 then cast(MaximumWage as decimal(18,5)) end as MaximumWage
	,case when isnumeric(MinimumWage) = 1 then cast(MinimumWage as decimal(18,5)) end as MinimumWage


	from(

	select
	VacancyID
	,[NumberOfPositions]
	,[WageUnitDesc]
	--,CONVERT(DECIMAL(18,5),
		 ,REPLACE(case when [WageType]='National Minimum Wage'  and WageText like '%to%' and SourceDb='RAAv1' 
		  THEN substring(replace([WageText],' ',''),2,charindex('to',ltrim(rtrim(replace([WageText],' ',''))))-2)
		  when [WageType]='National Minimum Wage'  and WageText like '%-%' and SourceDb='RAAv1'
		  THEN substring(replace([WageText],' ',''),2,charindex('-',ltrim(rtrim(replace([WageText],' ',''))))-2)
		  when [WageType]='FixedWage' and WageText like '% %'
		  THEN substring([WageText],1,charindex(' ',WageText)-1)
		  WHEN WageType='NationalMinimumWageForApprentices' and DatePosted<'2022-04-01'
		  THEN CAST(AMW.WageRateInPounds*52*HoursPerWeek as varchar)
		  WHEN WageType='NationalMinimumWage' and DatePosted<'2022-04-01'
		  THEN CAST(NMR.MinWage*52*HoursPerWeek as varchar)
		  WHEN WageType='NationalMinimumWageForApprentices' and DatePosted>='2022-04-01' and DatePosted<= '2023-03-31'
		  THEN cast(4.81*HoursPerWeek*52 as varchar)
		  WHEN WageType='NationalMinimumWage' and DatePosted>='2022-04-01' and DatePosted<= '2023-03-31'
		  THEN cast(4.81*HoursPerWeek*52 as varchar)
		  --ELSE replace(WageText,'£','')
		  ELSE NULL
		  END,',','')
		  AS MinimumWage
	--,CONVERT(DECIMAL(18,5),
		  ,replace(case when [WageType]='National Minimum Wage' and WageText like '%to%' and SourceDb='RAAv1'
		  THEN substring(replace([WageText],' ',''),charindex('to',ltrim(rtrim(replace([WageText],' ',''))))+3,len(replace([WageText],' ','')))
		  when [WageType]='National Minimum Wage' and WageText like '%-%' and SourceDb='RAAv1'
		  THEN substring(replace([WageText],' ',''),charindex('-',ltrim(rtrim(replace([WageText],' ',''))))+2,len(replace([WageText],' ','')))
		  when [WageType]='FixedWage' and WageText like '% %'
		  THEN substring([WageText],1,charindex(' ',WageText)-1)
		  WHEN WageType='NationalMinimumWageForApprentices' and DatePosted<'2022-04-01'
		  THEN CAST(AMW.WageRateInPounds*52*HoursPerWeek as varchar)
		  WHEN WageType='NationalMinimumWage' and DatePosted<'2022-04-01'
		  THEN CAST(NMR.MaxWage*52*HoursPerWeek as Varchar)
		  WHEN WageType='NationalMinimumWageForApprentices' and DatePosted>='2022-04-01' and DatePosted<= '2023-03-31'
		  THEN cast(4.81*HoursPerWeek*52 as varchar)
		  WHEN WageType='NationalMinimumWage' and DatePosted>='2022-04-01' and DatePosted<= '2023-03-31'
		  THEN cast(9.50*HoursPerWeek*52 as varchar)
		  --ELSE replace(WageText,'£','')
		  ELSE NULL
		  END,',','')
		  AS MaximumWage

	FROM [ASData_PL].[Va_Vacancy]
	LEFT
		  JOIN (SELECT StartDate,EndDate,WageRateInPounds
				 FROM  Mtd.NationalMinimumWageRates
				WHERE AgeGroup='Apprentice') AMW  -- ApprenticeMinimumWage
			ON convert(date,DatePosted) >= AMW.StartDate AND convert(Date,DatePosted) <= AMW.EndDate
		  LEFT
		  JOIN (SELECT StartDate,EndDate, MIN(WageRateInPounds) MinWage,MAX(WageRateInPounds) MaxWage
				  FROM  Mtd.NationalMinimumWageRates
				 WHERE AgeGroup<>'Apprentice'
			  GROUP BY StartDate,EndDate) NMR
			ON convert(date,DatePosted) >= NMR.StartDate AND convert(date,DatePosted) <= NMR.EndDate
	where 
	HasHadLiveStatus=1
	and dateposted>='01-Aug-2018'
	and VacancyTypeDesc NOT LIKE'Traineeship%'
	and wagetype in ('National Minimum Wage','FixedWage','NationalMinimumWageForApprentices','NationalMinimumWage')
	and RAFDuplicateFlag = 0

	)a

	)b

	)c

	)d


)

,vacancy AS 
(
	select distinct 
vacancyid,case when [FrameworkOrStandardLarsCode] like '%-%'
then left([FrameworkOrStandardLarsCode], charindex('-', [FrameworkOrStandardLarsCode]) - 1)
else [FrameworkOrStandardLarsCode] end as [FrameworkOrStandardLarsCode]
,[Level]=case when [ApprenticeshipType] not like '% %' then [ApprenticeshipType] else left([ApprenticeshipType], charindex(' ', [ApprenticeshipType]) - 1)end
--into #vacancy

from [ASData_PL].[Va_Vacancy]

where 
dateposted >='01-Aug-2018'
  AND HASHADLIVESTAtus=1
  and RAFDuplicateFlag = 0
)

,SALARYQUERY AS (
	select *

	
	from(
	SELECT DISTINCT v.[VacancyId]
	,[VacancyPostcode]
	,v.NumberOfPositions as Vacancies
		  ,v2.[FrameworkOrStandardLarsCode]
	
		  ,[Level]=case when v.[TrainingTypeId]=1  and EducationLevelCodeName> isnull(fwk.MaxLevel,fwk2.MaxLevel) then isnull(fwk.MaxLevel,fwk2.MaxLevel)
		  when v.[TrainingTypeId]=1  and EducationLevelCodeName<= isnull(fwk.MaxLevel,fwk2.MaxLevel) then EducationLevelCodeName
		  else s.[Level] end		 
		 
		  ,[Annual Minimum wage]
		  ,[Annual Maximum wage]
		 
		  ,V.ProviderUKPRN
		 

	  FROM [ASData_PL].[Va_Vacancy] as v
	------------------------------------------------------------------------------------------
	left outer join vacancy as v2
	on v.VacancyId=v2.VacancyId
	------------------------------------------------------------------------------------------
	LEFT OUTER JOIN  (SELECT DISTINCT StandardCode,[NotionalEndLevel] as [Level],[SectorSubjectAreaTier1_Desc] FROM [lkp].[LARS_Standard] AS STD
										LEFT OUTER JOIN [lkp].[LARS_SectorSubjectAreaTier1] AS SSA1
										ON STD.SectorSubjectAreaTier1=SSA1.SectorSubjectAreaTier1 ) AS S
	ON V2.FrameworkOrStandardLarsCode=S.STANDARDCODE and (v.TrainingTypeFullName in ('Standard','Standards') or [SectorName] in ('Standards'))
	------------------------------------------------------------------------------------------
	LEFT OUTER JOIN (select * from [ASData_PL].[Va_EducationLevel] where [EducationLevelId] not in ('998','999'))AS EL
	ON V2.Level=EL.[EducationLevelFullName]

	left outer join wage as w
	on v.VacancyId=w.VacancyId
	------------------------------------------------------------------------------------------
	left outer join (SELECT max(distinct   case 			
	when ProgType = 2 then 3			
	when ProgType = 3 then 2			
	when ProgType = 20 then 4			
	when ProgType = 21 then 5			
	when ProgType = 22 then 6			
	when ProgType = 23 then 7		else 0 end )as [MaxLevel]
	,PathwayName
	 FROM [lkp].[LARS_Framework]
	 where 
	 progtype in (2,3,20,21,22,23)
	 group by
	 PathwayName) as fwk
	 on trim(SUBSTRING(v.FrameworkOrStandardName,CHARINDEX(':',v.FrameworkOrStandardName)+1,LEN(v.FrameworkOrStandardName))) =trim(fwk.[PathwayName])
	------------------------------------------------------------------------------------------
	left outer join (SELECT max(distinct   case 			
	when ProgType = 2 then 3			
	when ProgType = 3 then 2			
	when ProgType in(10,20) then 4			
	when ProgType = 21 then 5			
	when ProgType = 22 then 6			
	when ProgType = 23 then 7		else 0 end )as [MaxLevel]
	,[NASTitle]
	 FROM [lkp].[LARS_Framework]
	 where 
	 progtype in (2,3,20,21,22,23)

	 group by
	[NASTitle]) as fwk2
	 on trim(SUBSTRING(v.FrameworkOrStandardName,CHARINDEX(':',v.FrameworkOrStandardName)+1,LEN(v.FrameworkOrStandardName))) =trim(fwk2.[NASTitle])
	------------------------------------------------------------------------------------------
	 ) k
)

, GROUPEDSALARYQUERY AS 
(
	SELECT 
  (SUM(s1.[Annual Minimum Wage] * s1.Vacancies) / (SUM(s1.Vacancies))) AS weighted_average_annual_minwage
 ,(SUM(s1.[Annual Maximum Wage] * s1.Vacancies) / (SUM(s1.Vacancies))) AS weighted_average_annual_maxwage
 ,s1.ProviderUkprn
 ,s1.FrameworkOrStandardLarsCode
 ,s1.[Level]
 FROM SALARYQUERY s1 
 GROUP BY 
	s1.ProviderUKPRN
	,s1.FrameworkOrStandardLarsCode
	,s1.[Level]
)



SELECT 
*
,CONVERT(DATE,CURRENT_TIMESTAMP)  AS CURR_STAMP
,DATEADD(day,-1,CONVERT(DATE,CURRENT_TIMESTAMP)) AS YESTERDAY
,DATEADD(day,-7,CONVERT(DATE,CURRENT_TIMESTAMP)) AS LASTWEEK
,TRY_CONVERT(DATE,basequery.CreatedOn) AS CreatedRecordDate
FROM CTE_BASE basequery
LEFT JOIN COURSES courses
ON basequery.StandardUId=courses.StandardUId
LEFT JOIN STARRATING opinionpoll
ON (basequery.UKPRN=opinionpoll.UKPRN  AND courses.StandardCode=opinionpoll.LARSCODE)
LEFT JOIN GROUPEDSALARYQUERY estim_salaries
ON (basequery.UKPRN=estim_salaries.ProviderUkprn
	AND courses.StandardCode=estim_salaries.FrameworkOrStandardLarsCode
	AND courses.[Level]=estim_salaries.[Level]
	)
LEFT JOIN EMPLOYER_SECTOR employersector
ON employersector.ApprenticeshipId=basequery.ApprenticeshipId

END
GO


