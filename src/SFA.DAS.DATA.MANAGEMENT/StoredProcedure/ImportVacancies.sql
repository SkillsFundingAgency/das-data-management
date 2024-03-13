CREATE PROCEDURE [dbo].[ImportVacanciesToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import Vacancies Data from v1 and v2
--              Fields that are in v1 but not in v2 or viceversa are replaced with Defaults/Dummy Values
-- ==========================================================================================================

BEGIN TRY

DECLARE @LogID int
DEClARE @quote varchar(5) = ''''

/* Start Logging Execution */

  INSERT INTO Mgmt.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,Execution_Status
	  )
  SELECT 
        @RunId
	   ,'Step-6'
	   ,'ImportVacanciesToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.Va_Application  -- Delete Application First to be able to resolve Foreign key conflicts */

TRUNCATE TABLE ASData_PL.Va_Apprenticeships -- Delete Apprenticeships First to be able to resolve Foreign key conflicts */

TRUNCATE TABLE ASData_PL.va_VacancyReviews -- Delete VacancyReviews First to be able to resolve Foreign key conflicts */

DELETE FROM ASData_PL.Va_Vacancy

/* Load RAAv1 */

INSERT INTO [ASData_PL].[Va_Vacancy]
           ([VacancyGuid]
           ,[VacancyReferenceNumber]
           ,[VacancyStatus]
           ,[VacancyTitle]
           --,[VacancyLocalAuthorityId]
           --,[VacancyLocalAuthorityName]
           --,[VacancyPostcode]
           --,[VacancyCountyId]
           --,[VacancyCounty]
		   ,VacancyPostcode
           ,VacancyAddressLine1
           ,VacancyAddressLine2
           ,VacancyAddressLine3
           ,VacancyAddressLine4
		   ,VacancyAddressLine5
           ,VacancyTown
           ,SkillsRequired
           ,QualificationsRequired
           ,PersonalQualities
           ,[EmployerId]
           ,[EmployerFullName]
           --,[LegalEntitiyId]
           --,[LegalEntityName]
           ,[ProviderId]
           ,[ProviderUkprn]
           ,[ProviderFullName]
           ,[ProviderTradingName]
         --  ,[VacancyOwner_v2]
           ,[ApprenticeshipType]
           ,[VacancyShortDescription]
           ,[VacancyDescription]
           --,[VacancyLocationTypeId_v1]
           --,[VacancyLocationType_v1]
           ,[NumberOfPositions]
           ,[SectorName]
           ,[FrameworkOrStandardID]
           ,[FrameworkOrStandardLarsCode]
           ,[FrameworkOrStandardName]
           ,[EducationLevel]
           ,[WeeklyWage_v1]
           ,[WageLowerBound_v1]
           ,[WageUpperBound_v1]
           ,[WageType]
           ,[WageText]
           ,[WageUnitId_v1]
           ,[WageUnitDesc]
           ,[WorkingWeek]
           ,[HoursPerWeek]
           ,[DurationTypeId]
           ,[DurationTypeDesc]
           ,[ApplicationClosingDate]
           ,[InterviewsFromDate_v1]
           ,[ExpectedStartDate]
           ,[ExpectedDuration]
           ,[NumberOfViews_v1]
           ,[MaxNumberOfApplications_v1]
           ,[ApplyOutsideNAVMS_v1]
           ,[NoOfOfflineApplicants_v1]
           ,[MasterVacancyId_v1]
           ,[NoOfOfflineSystemApplicants_v1]
           ,[SmallEmployerWageIncentive_v1]
           ,[SubmissionCount_v1]
           ,[StartedToQADateTime_v1]
           ,[TrainingTypeId]
           ,[TrainingTypeFullName]
           ,[VacancyTypeId]
           ,[VacancyTypeDesc]
           ,[UpdatedDateTime]
           ,[EditedInRaa_v1]
           ,[VacancySourceId_v1]
           ,[VacancySource]
           ,[OfflineVacancyTypeId_v1]
           ,[CreatedDate]
		   ,[DatePosted]
		   ,[HasHadLiveStatus]
           ,[SourceVacancyId]
           ,[SourceDb]
           ,[RowNumber]
           ,[RAFDuplicateFlag])
Select vd.*,
case when RowNumber > 1 and NumberOfPositions >= 20 and DatePosted >= '01-Mar-2023' and DatePosted < '01-Nov-2023' and EmployerFullName in( 'RAF','Royal Air Force') then 1
else 0 end as RAFDuplicateFlag from 
(
select  vv.*
  ,ROW_NUMBER() OVER (PARTITION BY VacancyTitle, NumberofPositions,EmployerFullName,EducationLevel,datepart(year,DatePosted), datepart(month,DatePosted) ORDER BY VacancyReferenceNumber) as RowNumber
from
  
  (SELECT v.VacancyGuid                                     as VacancyGuid
           ,v.[VacancyReferenceNumber]                        as VacancyReferenceNumber
           ,vs.FullName                                       as VacancyStatus
	       ,REPLACE(REPLACE(v.[Title], CHAR(13), ''), CHAR(10), ' ')  as VacancyTitle
		   ,v.PostCode                                        as VacancyPostCode
           ,v.AddressLine1                                    as VacancyAddressLine1
           ,v.AddressLine2                                    as VacancyAddressLine2
           ,v.AddressLine3                                    as VacancyAddressLine3
           ,v.AddressLine4                                    as VacancyAddressLine4
           ,v.AddressLine5                                    as VacancyAddressLine5
           ,v.Town                                            as VacancyTown
           ,dbo.Fn_CleanseHTMLText(sr.skillsrequired)          as SkillsRequired
		   ,dbo.Fn_CleanseHTMLText(QR.QualificationsRequired)  as QualificationsRequired
           ,dbo.Fn_CleanseHTMLText(PQ.PersonalQualities)       as PersonalQualities
	       ,E.EmployerId                                      as EmployerId
           ,E.FullName                                        as EmployerFullNAME
           ,P.ProviderID                                      as ProviderId
           ,p.UKPRN                                           as ProviderUKPrn
           ,P.FullName                                        as ProviderFullName
           ,P.TradingName                                     as ProviderTradingName
	 --  , psrt.ProviderSiteRelationshipTypeName as ProviderSiteRelationshipType
	       ,AT.FullName                                       as ApprenticeshipType
           ,v.[ShortDescription]                              as VacancyShortDescription
           ,dbo.Fn_CleanseHTMLText(v.[Description])            as VacancyDescription
           ,v.[NumberofPositions]                             as NumberOfPositions
	       ,CASE WHEN V.ApprenticeshipFrameworkId is not null 
                 then AF.ApprenticehipOccupationFullName
                 WHEN V.StandardId is not null then Std.StandardSectorName 
                 ELSE 'Unknown' 
             END                                              as [Framework/Standard Sector] 
           ,CASE WHEN V.ApprenticeshipFrameworkId is not null 
                 then AF.ApprenticeshipFrameworkId
                 WHEN V.StandardId is not null then Std.StandardId 
                 ELSE -1 
             END                                              as [Framework/StandardId] 
           ,CASE WHEN AF.FrameworkCodeName IS NOT NULL THEN AF.FrameworkCodeName
                 WHEN Std.LarsCode IS NOT NULL THEN CAST(Std.LarsCode AS Varchar)
		         ELSE ''
		     END                                              as LarsCode
            ,CASE WHEN V.ApprenticeshipFrameworkId is not null 
                  then Af.FrameWorkFullName 
                  WHEN V.StandardId is not null then Std.StandardFullName 
                  ELSE '' 
              END                                             as [Framework/Standard Name] 
            ,Std.EducationLevelFullName +' '+Std.EducationLevelNamev2
			                                                  as EducationLevel
            ,v.[WeeklyWage]                                   as WeeklyWage
            ,v.[WageLowerBound]                               as WageLowerBound
            ,v.[WageUpperBound]                               as WageUpperBound
            ,WT.FullName                                      AS WageType 
	        ,v.WageText                                       as WageText
	        ,v.WageUnitId                                     as WageUnitId
	        ,WU.FullName                                      as WageUnit
	        ,v.[WorkingWeek]                                  as WorkingWeek
	        ,v.[HoursPerWeek]                                 as HoursPerWeek
	        ,v.DurationTypeId                                 as DurationTypeId
	        ,v.DurationValue                                  as DurationValue
            ,v.[ApplicationClosingDate]                       as ApplicationClosingDate
            ,v.[InterviewsFromDate]                           as InterviewFromDate
            ,v.[ExpectedStartDate]                            as ExpectedStartDate
            ,v.[ExpectedDuration]                             as ExpectedDuration
            ,v.[NumberOfViews]                                as NumberOfViews
	        ,v.MaxNumberofApplications                        as MaxNumberOfApplications
	        ,v.ApplyOutsideNAVMS                              as ApplyOutsideNAVMS
	        ,v.[NoOfOfflineApplicants]                        AS NoOfOfflineApplicants
	        ,v.MasterVacancyId                                as MasterVacancyId
	        ,v.NoOfOfflineSystemApplicants                    as NoOfOfflineSystemApplicants
	        ,v.SmallEmployerWageIncentive                     as SmallEmployerWageIncentive
	        ,v.SubmissionCount                                as SubmissionCount
	        ,v.StartedToQADateTime                            as StartedToQADateTime
	        ,CASE WHEN V.ApprenticeshipFrameworkId is not null 
                  then 1 
                  WHEN V.StandardId is not null then 2 
                  ELSE 0
              END                                             as TrainingTypeId
	        ,CASE WHEN V.ApprenticeshipFrameworkId is not null 
                  then 'Framework' 
                  WHEN V.StandardId is not null then 'Standard'
                  ELSE 'Unknown' 
              END                                             as TrainingTypeDesc
	        ,v.VacancyTypeId
            ,CASE WHEN v.[VacancyTypeId]=1 THEN 'Apprenticeship'
	              WHEN V.VacancyTypeId=2 THEN 'Traineeship'
			      ELSE 'Unknown'
			  end                                             as VacancyType
	        ,v.UpdatedDateTime                                as UpdatedDateTime
	        ,v.EditedInRaa                                    as EditedInRAA
	        ,v.VacancySourceId                                as VacancySourceId
	        ,vas.FullName                                     as VacancySource
            ,v.OfflineVacancyTypeId                           as OfflineVacancyTypeId   
	        ,ISNULL(VH.CreatedDate,V.UpdatedDateTime)         as CreatedDate
			,VL.DatePosted                                    as DatePosted
			,CASE WHEN VL.DatePosted IS NULL THEN 0
			      ELSE 1
				  END                                         as HasHadLiveStatus
			,v.VacancyId                                      as SourceVacancyId
			,'RAAv1'                                          as SourceDb
       FROM Stg.[Avms_Vacancy] V
	   left
       join Stg.Avms_VacancyStatusType vs 
	     on V.VacancyStatusId = vs.VacancyStatusTypeId
	   left
       join Stg.Avms_VacancyOwnerRelationship vor 
	     on V.VacancyOwnerRelationshipId = vor.VacancyOwnerRelationshipId
	   left
       join ASData_PL.Va_Employer E 
	     on vor.EmployerId = e.SourceEmployerId_v1
		and E.SourceDb='RAAv1'
	   left
       join (SELECT ps.providersiteid,psr.ProviderID
               from stg.Avms_ProviderSite ps 
               join (SELECT ProviderID,ProviderSiteID
                       FROM
                    (select *, Row_number() over (partition by providersiteid order by providersiterelationshiptypeid) rn 
                       from stg.Avms_ProviderSiteRelationship) PSR
                      WHERE rn=1) PSR
                 ON PSR.ProviderSiteID=PS.ProviderSiteID) Ps
          on vor.ProviderSiteID=ps.ProviderSiteID
		left
        join ASData_PL.Va_Provider p 
		  on ps.ProviderID = p.SourceProviderID_v1
		 and p.SourceDb='RAAv1'
        LEFT 
		JOIN (SELECT AST.*,EL.EducationLevelFullName,EL.EducationLevelNamev2
        	    FROM ASData_PL.Va_ApprenticeshipStandard AST
			    LEFT 
			    JOIN AsData_PL.Va_EducationLevel EL
			      ON EL.EducationLevelId=AST.EducationLevelId) Std 
          ON Std.StandardId=V.StandardId 
        LEFT
		JOIN ASData_PL.Va_ApprenticeshipFrameWorkAndOccupation AF 
          ON AF.SourceApprenticeshipFrameworkId=V.ApprenticeshipFrameworkId
	     AND AF.SourceDb='RAAv1'
        left
        join (select vacancyid,min(HistoryDate) DatePosted
                from Stg.Avms_VacancyHistory vh
			   WHERE [VacancyHistoryEventSubTypeId] = 2 --Live
		       group by vacancyid) VL
          ON VL.VacancyId=V.VacancyId
		left
        join (select vacancyid,min(HistoryDate) CreatedDate
                from Stg.Avms_VacancyHistory vh
			   group by vacancyid) VH
          ON VH.VacancyId=V.VacancyId
        left
        join Stg.Avms_ApprenticeshipType AT
          ON AT.ApprenticeshipTypeId=v.ApprenticeshipType
        left 
        join Stg.Avms_WageType WT
          ON WT.WageTypeId=V.WageType
        left
        join Stg.Avms_VacancySource VaS
          on VaS.VacancySourceId=V.VacancySourceId
        left
        join stg.Avms_WageUnit wu
          on v.WageUnitId=wu.WageUnitId
		left
		join (select Value as QualificationsRequired,VacancyId
                from Stg.Avms_VacancyTextField
               where Field=2) QR
		  on QR.VacancyId=V.VacancyId
		left
		join (select Value as SkillsRequired,VacancyId
                from Stg.Avms_VacancyTextField
               where Field=3) SR
		  on SR.VacancyId=V.VacancyId
        left
		join (select Value as PersonalQualities,VacancyId
                from Stg.Avms_VacancyTextField
               where Field=4) PQ
		  on PQ.VacancyId=V.VacancyId)vv)vd






/* Load RAAv2 */

INSERT INTO [ASData_PL].[Va_Vacancy]
           ([VacancyGuid]
           ,[VacancyReferenceNumber]
           ,[VacancyStatus]
           ,[VacancyTitle]
           --,[VacancyLocalAuthorityId]
           --,[VacancyLocalAuthorityName]
           --,[VacancyPostcode]
           --,[VacancyCountyId]
           --,[VacancyCounty]
		   ,VacancyPostcode
           ,VacancyAddressLine1
           ,VacancyAddressLine2
           ,VacancyAddressLine3
           ,VacancyAddressLine4
           ,VacancyTown
           ,SkillsRequired
           ,QualificationsRequired
           ,PersonalQualities
           ,[EmployerId]
           ,[EmployerFullName]
           ,[LegalEntitiyId]
           ,[LegalEntityName]
           ,[ProviderId]
           ,[ProviderUkprn]
           ,[ProviderFullName]
           ,[ProviderTradingName]
         --  ,[VacancyOwner_v2]
           ,[ApprenticeshipType]
           ,[VacancyShortDescription]
           ,[VacancyDescription]
           --,[VacancyLocationTypeId_v1]
           --,[VacancyLocationType_v1]
           ,[NumberOfPositions]
           ,[SectorName]
           ,[FrameworkOrStandardID]
           ,[FrameworkOrStandardLarsCode]
           ,[FrameworkOrStandardName]
           ,[EducationLevel]
           --,[WeeklyWage_v1]
           --,[WageLowerBound_v1]
           --,[WageUpperBound_v1]
           ,[WageType]
           ,[WageText]
      --     ,[WageUnitId_v1]
           ,[WageUnitDesc]
           ,[WorkingWeek]
           ,[HoursPerWeek]
       --    ,[DurationTypeId]
           ,[DurationTypeDesc]
           ,[ApplicationClosingDate]
        --   ,[InterviewsFromDate_v1]
           ,[ExpectedStartDate]
           ,[ExpectedDuration]
           --,[NumberOfViews_v1]
           --,[MaxNumberOfApplications_v1]
           --,[ApplyOutsideNAVMS_v1]
           --,[NoOfOfflineApplicants_v1]
           --,[MasterVacancyId_v1]
           --,[NoOfOfflineSystemApplicants_v1]
           --,[SmallEmployerWageIncentive_v1]
           --,[SubmissionCount_v1]
           --,[StartedToQADateTime_v1]
           ,[TrainingTypeId]
           ,[TrainingTypeFullName]
           ,[VacancyTypeId]
           ,[VacancyTypeDesc]
           ,[UpdatedDateTime]
           --,[EditedInRaa_v1]
           --,[VacancySourceId_v1]
           ,[VacancySource]
           --,[OfflineVacancyTypeId_v1]
           ,[CreatedDate]
		   ,[DatePosted]
		   ,[HasHadLiveStatus]
           ,[IsDeleted_v2]
           ,[DeletedDateTime_v2]
           ,[SubmittedDateTime_v2]
           ,[SourceVacancyId]
           ,[SourceDb]
           ,[RowNumber]
           ,[RAFDuplicateFlag])
  
Select vd.*,
case when RowNumber > 1 and NumberOfPositions >= 20 and DatePosted >= '01-Mar-2023' and DatePosted < '01-Nov-2023' and EmployerFullName in( 'RAF','Royal Air Force') then 1
else 0 end as RAFDuplicateFlag from 
(
select  vv.*
  ,ROW_NUMBER() OVER (PARTITION BY VacancyTitle, NumberofPositions,EmployerFullName,EducationLevel,datepart(year,DatePosted), datepart(month,DatePosted) ORDER BY VacancyReference) as RowNumber from
  
  (
SELECT  cast(v.BinaryId as varchar(256))                        as VacancyGuid
	      ,cast(VacancyReference as bigint)                           as VacancyReference
		  ,cast(VacancyStatus as varchar(100))                     as VacancyStatus
		  ,REPLACE(REPLACE(VacancyTitle, CHAR(13), ''), CHAR(10), ' ') as VacancyTitle
		  ,CASE WHEN len(EmployerPostCode)>8 
		        THEN CASE WHEN Mgmt.fn_ExtractPostCodeUKFromAddress(EmployerPostCode)='ZZ99 9ZZ'
				          THEN CASE WHEN Mgmt.fn_ExtractPostCodeUKFromAddress(ISNULL(EmployerAddressLine1,'')+','+ISNULL(EmployerAddressLine2,'')+','+ISNULL(EmployerAddressLine3,'')+','+ISNULL(EmployerAddressLine4,'')) ='ZZ99 9ZZ'
						            THEN EmployerPostCode
									ELSE Mgmt.fn_ExtractPostCodeUKFromAddress(ISNULL(EmployerAddressLine1,'')+','+ISNULL(EmployerAddressLine2,'')+','+ISNULL(EmployerAddressLine3,'')+','+ISNULL(EmployerAddressLine4,''))
							   END
						  ELSE Mgmt.fn_ExtractPostCodeUKFromAddress(EmployerPostCode)
					  END
				ELSE EmployerPostCode
			END                                                    as VacancyPostCode
          ,EmployerAddressLine1                                    as VacancyAddressLine1
          ,EmployerAddressLine2                                    as VacancyAddressLine2
          ,EmployerAddressLine3                                    as VacancyAddressLine3
          ,EmployerAddressLine4                                    as VacancyAddressLine4
          ,COALESCE(EmployerAddressLine4,EmployerAddressLine3,EmployerAddressLine2) as VacancyTown
          ,dbo.Fn_CleanseJSONText([Skills])  as SkillsRequired
          ,dbo.Fn_CleanseJSONText([Qualifications]) as QualificationsRequired
          ,dbo.Fn_CleanseJSONText([Skills]) as PersonalQualities
		  ,E.EmployerId                                            as EmployerId
		  ,V.EmployerName                                          as EmployerFullName
		  ,LE.LegalEntityId                                        as LegalEntityId
      ,V.LegalEntityName
		  --,LE.LegalEntityName                                      as LegalEntityName
		  ,P.ProviderID                                            as ProviderId
		  ,cast(v.TrainingProviderUkprn as int)                    as ProviderUkprn
	      ,v.TrainingProviderName                                  as ProviderName
		  ,v.TrainingProviderName                                  as ProviderTradingName
		  ,EL.EducationLevelFullName +' Level Apprenticeship'      as ApprenticeshipType
          ,dbo.Fn_CleanseHTMLText([VacancyDescription])             as VacancyShortDesc
          ,dbo.Fn_CleanseHTMLText([VacancyDescription])             as VacancyDesc
		  ,cast(v.NumberOfPositions as int)                        as NumberOfPositions
	      ,CASE WHEN AP.ApprenticeshipType='Standard' THEN ST.StandardSectorName
                WHEN AP.ApprenticeshipType='Framework' then AF.ApprenticehipOccupationFullName
                ELSE 'Unknown' 
            END                                                    as [Framework/Standard Sector] 
	      ,CASE WHEN AP.ApprenticeshipType='Framework' then AF.ApprenticeshipFrameworkId
                WHEN AP.ApprenticeshipType='Standard' then ST.StandardId 
                ELSE -1 
            END                                                    as [Framework/StandardId] 
          ,V.ProgrammeId                                           as LarsCode
          , CASE WHEN ApprenticeshipType='Framework'  
                 then AF.FrameWorkFullName 
                 WHEN ApprenticeshipType='Standard' 
			     then ST.StandardFullName 
                 ELSE '' 
             END                                                   as [Framework/Standard Name] 
          ,EL.EducationLevelFullName+' '+EL.EducationLevelNamev2   as EducationLevel
		  ,v.[WageType]                                            as WageType
          ,isnull((CASE WHEN v.WageType='NationalMinimumWageForApprentices'
		                THEN CAST(AMW.WageRateInPounds*52*v.WeeklyHours as varchar)
			            WHEN v.WageType='NationalMinimumWage'
			            THEN CAST(NMR.MinWage*52*v.WeeklyHours as varchar) + '-' + CAST(NMR.MaxWage*52*v.WeeklyHours as Varchar)
			            ELSE v.FixedWageYearlyAmount 
	                     END) ,'') 
						 +' '
						 +ISNULL(v.WageAdditionalInformation,'')   as WageText
          -- ,[WageUnitId]
          ,'Annually'                                              as WageUnitDesc
          ,v.WorkingWeekDescription                                as WorkingWeek
          ,cast(v.WeeklyHours as decimal(10,2))                    as HoursPerWeek
         --  ,[DurationTypeId]
          ,cast(v.WageDuration as int)                             as DurationTypeDesc
	      ,dbo.Fn_ConvertTimeStampToDateTime(v.ClosingDateTimeStamp) as ClosingDateTime
         --  ,[InterviewsFromDate]
          ,dbo.Fn_ConvertTimeStampToDateTime(v.StartDateTimeStamp) as ExpectedStartDate
          ,v.WageDuration+ ' '+v.WageDurationUnit + CASE WHEN v.WageDuration<>1 then 's' ELSE '' END 
		                                                           as ExpectedDuration
		  ,CASE WHEN AP.ApprenticeshipType='Framework' THEN 1
                WHEN AP.ApprenticeshipType='Standard' THEN 2
                ELSE 0
              END                                                  as TrainingTypeId
	      ,ISNULL(AP.ApprenticeshipType,'Unknown')                 as TrainingTypeFullName
	      ,CASE WHEN AP.EducationLevelNumber=8 THEN 2
	            WHEN AP.EducationLevelNumber IN (2,3,4,6) THEN 1
			    ELSE 0
			END                                                    as VacancyTypeId
	      ,CASE WHEN AP.EducationLevelNumber=8 THEN 'Traineeship'
	            WHEN AP.EducationLevelNumber IN (2,3,4,6) THEN 'Apprenticeship'
			    ELSE 'Unknown'
			END                                                    as VacancyTypeDesc
          ,dbo.Fn_ConvertTimeStampToDateTime(v.LastUpdatedTimeStamp) as UpdateDateTime
          ,v.SourceOrigin                                            as VacancySource
          ,dbo.Fn_ConvertTimeStampToDateTime(v.CreatedDateTimeStamp) as CreatedDateTime
		  ,dbo.Fn_ConvertTimeStampToDateTime(v.[LiveDateTimeStamp])  as DatePosted
		  ,CASE WHEN v.[LiveDateTimeStamp] is null then 0
		        ELSE 1
				END                                                  as HasHadLiveStatus
		  ,v.IsDeleted                                               as IsDeleted
		  ,dbo.Fn_ConvertTimeStampToDateTime(v.DeletedDateTimeStamp) as DeletedDateTime
		  ,dbo.Fn_ConvertTimeStampToDateTime(v.SubmittedDateTimeStamp) as SubmittedDateTime
		  ,v.SourseSK                                                as SourceVacancyId
		  ,'RAAv2'                                                   as SourceDb
	  FROM Stg.RAA_Vacancies V
	  LEFT
	  JOIN ASData_PL.Va_Employer E
	    ON E.DasAccountId_v2=V.EmployerAccountId
	   and E.SourceDb='RAAv2'
	  LEFT
	  JOIN ASData_PL.Va_LegalEntity LE
	    ON LE.SourceLegalEntityId=V.LegalEntityId
	   AND LE.EmployerAccountId=v.EmployerAccountId
	   AND LE.SourceDb='RAAv2'
	  LEFT
	  JOIN (SELECT providerid ,UKPRN
              FROM 
           (SELECT providerid,Ukprn,row_number() over (partition by ukprn order by providerstatustypeid asc) rn -- ToSelectOnlyActivatedProviders
	          FROM ASData_PL.Va_Provider) Provider
             WHERE rn=1) P
	    ON P.UKPRN=V.TrainingProviderUkprn
	 --  AND P.SourceDb='RAAv2'
	  LEFT
	  JOIN Stg.RAA_ReferenceDataApprenticeshipProgrammes ap
	    on V.ProgrammeId=ap.ProgrammeId
	  LEFT 
	  JOIN ASData_PL.Va_EducationLevel EL
        ON EL.EducationLevelCodeName=ap.EducationLevelNumber
	  LEFT
      JOIN (SELECT AST.*,EL.FullName AS EducationLevel
        	  FROM ASData_PL.Va_ApprenticeshipStandard AST
			  LEFT 
			  JOIN Stg.Avms_EducationLevel EL
			    ON EL.EducationLevelId=AST.EducationLevelId
				) ST
	    on cast(ST.LarsCode as Varchar)=V.ProgrammeId 
      LEFT 
	  JOIN ASData_PL.Va_ApprenticeshipFrameWorkAndOccupation AF
        ON AF.ProgrammeId_v2=V.ProgrammeId
	   AND AF.SourceDb='RAAv2'
	  LEFT
	  JOIN (SELECT StartDate,EndDate,WageRateInPounds
             FROM  Mtd.NationalMinimumWageRates
            WHERE AgeGroup='Apprentice') AMW  -- ApprenticeMinimumWage
		ON dbo.Fn_ConvertTimeStampToDateTime(v.LiveDateTimeStamp) >= AMW.StartDate AND dbo.Fn_ConvertTimeStampToDateTime(v.LiveDateTimeStamp) <= AMW.EndDate
	  LEFT
	  JOIN (SELECT StartDate,EndDate, MIN(WageRateInPounds) MinWage,MAX(WageRateInPounds) MaxWage
              FROM  Mtd.NationalMinimumWageRates
             WHERE AgeGroup<>'Apprentice'
          GROUP BY StartDate,EndDate) NMR
		ON dbo.Fn_ConvertTimeStampToDateTime(v.LiveDateTimeStamp) >= NMR.StartDate AND dbo.Fn_ConvertTimeStampToDateTime(v.LiveDateTimeStamp) <= NMR.EndDate) vv)vd




COMMIT TRANSACTION



UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

    DECLARE @ErrorId int

  INSERT INTO Mgmt.Log_Error_Details
	  (UserName
	  ,ErrorNumber
	  ,ErrorState
	  ,ErrorSeverity
	  ,ErrorLine
	  ,ErrorProcedure
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,RunId
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'ImportVacanciesToPL',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunId

  END CATCH

GO