CREATE TABLE [AsData_PL].[EI_CollectionCalendar]
(
    [Id]						INT NOT NULL,
	[PeriodNumber]				TINYINT NOT NULL,	
	[CalendarMonth]				TINYINT NOT NULL,
	[CalendarYear]				SMALLINT NOT NULL,
	[EIScheduledOpenDateUTC]	DATETIME2 NOT NULL,
	[CensusDate]				datetime NULL,
	[AcademicYear]				varchar(10) NULL,
	[Active]					bit NULL,
    AsDm_UpdatedDateTime datetime2 default getdate()
)
