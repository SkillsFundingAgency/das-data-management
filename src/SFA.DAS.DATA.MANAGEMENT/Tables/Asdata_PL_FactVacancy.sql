CREATE TABLE Asdata_PL.FactVacancy (
    VacancyReferenceNumber INT,
    VacancyId INT,
    VacancyURL NVARCHAR(255),
    Vacancy_CurrentStatus NVARCHAR(50),
    Vacancy_HasBeenLive  BIT,
    VacancyIsLive INT,
    Vacancy_Title NVARCHAR(MAX),
    Vacancy_Description NVARCHAR(MAX),
    SkillsRequired NVARCHAR(MAX),
    QualificationsRequired NVARCHAR(MAX),
    Vacancy_Employer NVARCHAR(255),
    Vacancy_EmployerSize1 NVARCHAR(50),
    Vacancy_EmployerSize2 NVARCHAR(50),
    Vacancy_EmployerHashedId NVARCHAR(255),
    Vacancy_EmployerType NVARCHAR(50),
    Vacancy_TrainingProvider NVARCHAR(255),
    Vacancy_TrainingProviderUKPRN INT,
    Vacancy_StandardLARSCode INT,
    Vacancy_StandardIFATENumber NVARCHAR(50),
    Vacancy_Standard NVARCHAR(255),
    Vacancy_StandardLevel NVARCHAR(255),
    Vacancy_StandardIntegratedDegree NVARCHAR(255),
    IFATE_OccupationalRoute NVARCHAR(255),
    IFATE_OccupationalRouteCode INT,
    Vacancy_StandardMaxFunding INT,
    Vacancy_StandardRegulatedBody NVARCHAR(255),
    Vacancy_StandardTrainingType NVARCHAR(255),
    VacancyTool_Programme NVARCHAR(255),
    VacancyTool_VacancyType NVARCHAR(255),
    Vacancy_StandardApprenticeshipType NVARCHAR(255),
    Vacancy_StandardEducationLevel NVARCHAR(255),
    Vacancy_StandardLevel_Detailed NVARCHAR(255),
    Vacancy_StandardLevel_Simple NVARCHAR(255),
    Vacancy_StandardDegreeLevel NVARCHAR(10),
    Vacancy_StandardFAASector NVARCHAR(255),
    VacancyTool_Sector NVARCHAR(255),
    WageType NVARCHAR(50),
    WageText NVARCHAR(MAX),
    VacancyTool_Wage NVARCHAR(MAX),
    WageUnitDesc NVARCHAR(50),
    HoursPerWeek DECIMAL(5, 2),
    WorkingWeek NVARCHAR(100),
    SourceDb NVARCHAR(50),
    VacancyPostcode NVARCHAR(20),
    VacancyTown NVARCHAR(255),
    VacancyConstituency NVARCHAR(255),
    VacancyLocalAuthority NVARCHAR(255),
    VacancyCounty NVARCHAR(255),
    VacancyRegion NVARCHAR(255),
    VacancyLocalEnterprisePartnershipPrimary NVARCHAR(255),
    VacancyLocalEnterprisePartnershipSecondary NVARCHAR(255),
    NationalApprenticeshipServiceArea NVARCHAR(255),
    NationalApprenticeshipServiceDivision NVARCHAR(255),
    VacancyDatePosted DATE,
    VacancyDatePosted_FirstDayOfMonth DATE,
    VacancyClosingDate DATE,
    DaysLeftToVacancyClosingDate INT,
    DatePosted_AcademicYear INT,
    DatePosted_FinancialYear INT,
    DatePosted_CalendarMonthNumber INT,
    DatePosted_AcademicMonthNumber INT,
    DatePosted_MonthLongName NVARCHAR(20),
    DatePosted_MonthShortName NVARCHAR(10),
    DatePosted_FinancialMonthNumber INT,
    Vacancy_ExpectedStartDate DATE,
    ExpectedDuration NVARCHAR(50),
    ExpectedStartDate_AcademicYear INT,
    ExpectedStartDate_FinancialYear INT,
    ExpectedStartDate_CalendarMonthNumber INT,
    ExpectedStartDate_AcademicMonthNumber INT,
    ExpectedStartDate_MonthLongName NVARCHAR(20),
    ExpectedStartDate_MonthShortName NVARCHAR(10),
    ExpectedStartDate_FinancialMonthNumber INT,
    ApprenticeshipName NVARCHAR(255),
    Vacancy_ApplicationsHandledOnEmployerWebsite NVARCHAR(10),
    Vacancy_CanApplicationsBeCounted NVARCHAR(10),
    Vacancy_ApplicationsLiveVacancyToolFlag NVARCHAR(255),
    RAFDuplicateFlag NVARCHAR(10),
    Vacancy_Adverts INT,
    Vacancy_NumberOfPositions INT,
    Vacancy_Applications INT,
    VacancyTool_NumberOfApplicantsPerAdvert INT,
    VacancyTool_NumberOfVacanciesAvailable INT,
    RowNumber INT,
    Vacancy_NumberOfPositions_NoDuplicates INT,
    VacancyDuplicateFlag INT,
    VacancyDuplicateFlagIdentity INT,
    AsDm_UpdatedDateTime DATETIME
);























