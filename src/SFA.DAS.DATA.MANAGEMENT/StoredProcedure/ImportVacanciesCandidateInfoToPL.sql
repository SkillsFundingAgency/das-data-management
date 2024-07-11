CREATE PROCEDURE [dbo].[ImportVacanciesCandidateInfo] (@RunId int)
AS
-- ===============================================================================
-- Author:      Manju Nagarajan
-- Create Date: 23/01/2023
-- Description: Import Vacancies Candidate Info from v1 and v2
--              
-- ===============================================================================

BEGIN TRY

    DECLARE @LogID int
    DEClARE @quote varchar(5) = ''''

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
           'ImportVacanciesCandidateInfoToPL',
           getdate(),
           0

    SELECT @LogID = MAX(LogId)
    FROM Mgmt.Log_Execution_Results
    WHERE StoredProcedureName = 'ImportVacanciesCandidateInfoToPL'
          AND RunId = @RunID

    BEGIN TRANSACTION

    TRUNCATE TABLE ASData_PL.Va_CandidateInfo

    INSERT INTO [ASData_PL].[Va_CandidateInfo]
    (
        [SourceCandidateId_v1],
	    [SourceCandidateId_v2], 
        [SourceCandidateId_v3],
        [Gender],
        [DisabilityStatus],
        [InstitutionName],
        [IsGenderIdentifySameSexAtBirth],
        [SourceDb]
    )
    /* Insert Candidate school,gender and disability Details for RAAv1(AVMS) from FAA to Presentation Layer Table */
    SELECT C.CandidateId as SourceCandidateId_v1,
            '' as SourceCandidateId_v2,
            '' as SourceCandidateId_v3,
           cgc.FullName as Gender,
           cd.Category as DisabilityStatus,
           s.OtherSchoolName as InstitutionName,
           '' as IsGenderIdentifySameSexAtBirth,
           'FAA-Avms' as SourceDb
    FROM Stg.Avms_Candidate C
        left join Stg.Avms_CandidateGender CGC
            ON CGC.CandidateGenderId = C.Gender
        left join
        (
            Select CandidateDisabilityId,
                   case
                       when candidatedisabilityId = 0
                            or candidatedisabilityId = 12 then
                           'Unknown'
                       when candidatedisabilityId > 0
                            and candidatedisabilityId < 12
                            or candidatedisabilityId = 13 then
                           'Yes'
                       when candidatedisabilityId = 14 then
                           'PreferNotToSay'
                       else
                           'No'
                   end as Category
            from [Stg].[Avms_CandidateDisability]
        ) CD
            ON CD.CandidateDisabilityId = C.Disability
        left join
        (
            Select CandidateId,
                   otherschoolname
            from
            (
                Select CandidateId,
                       otherschoolname,
                       ROW_NUMBER() OVER (PARTITION BY CandidateId ORDER BY ENDDATE DESC, STARTDATE DESC) as Rnk
                from Stg.Avms_SchoolAttended
                where applicationId is not null
            ) sa
            where sa.Rnk = 1
        ) s
            ON s.CandidateId = C.CandidateId
    union
    /* Insert Candidate school,gender and disability Details for RAAv2(Cosmos) from FAA to Presentation Layer Table*/
    SELECT DISTINCT
         ''as SourceCandidateId_v1,
        FU.BinaryId as SourceCandidateId_v2,
        ''as SourceCandidateId_v3,
        cgc.Category as Gender,
        cdc.Category as DisabilityStatus,
        ceh.Institution as InstitutionName,
        '' as IsGenderIdentifySameSexAtBirth,
        'FAA-Cosmos' as SourceDb
    FROM Stg.FAA_Users FU
        LEFT JOIN Stg.FAA_CandidateGenderDisabilityStatus CGDC
            ON CGDC.CandidateId = FU.BinaryId
        LEFT JOIN Stg.FAA_CandidateEducationHistory CEH
            ON CEH.CandidateId = FU.BinaryId
        JOIN Stg.CandidateGenderConfig CGC
            ON CGC.ShortCode = cgdc.Gender
        JOIN Stg.CandidateDisabilityConfig CDC
            ON CDC.ShortCode = cgdc.DisabilityStatus

    UNION

    SELECT DISTINCT
         ''    as SourceCandidateId_v1,
         ''    as SourceCandidateId_v2,
         c.id  as SourceCandidateId_v3,
        CGC.Category Gender,
          a.DisabilityStatus as DisabilityStatus,
         'N/A' as InstitutionName,
          ay.IsGenderIdentifySameSexAtBirth ,
         'FAAV2' as SourceDb
    FROM Stg.FAAV2_AboutYou Ay
    JOIN Stg.FAAV2_Candidate c on Ay.[CandidateId] = C.id
    LEFT JOIN Stg.CandidateGenderConfig CGC ON CGC.ShortCode = Ay.sex
    LEFT JOIN stg.FAAv2_Application a on a.candidateid=C.id
    where sourcedb='FAAV2'

       

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
           'ImportVacanciesCandidateInfoToPL',
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
