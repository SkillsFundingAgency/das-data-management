    CREATE VIEW [ASData_PL].[vw_DAS_RegistrationStages]
	AS

			SELECT
				UserEmail,
				AccountCount,
				EmployerAccountId,
				EmployerName,
				Stage1a,
				Stage1b,
				Stage2,
				Stage3,
				Stage4a,
				Stage4b,
				Stage5
			FROM ASData_PL.DAS_RegistrationStages;
			GO
