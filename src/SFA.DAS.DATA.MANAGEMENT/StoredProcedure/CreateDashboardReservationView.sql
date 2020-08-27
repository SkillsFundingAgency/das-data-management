CREATE PROCEDURE [dbo].[CreateDashboardReservationView]
(
   @RunId int
)
AS
-- ===========================================================================
-- Author:      Sarma EVani
-- Create Date: 27/07/2020
-- Description: Campaign Dashboard Reservations View
-- ===========================================================================

BEGIN TRY
	DECLARE @LogID int

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
		   ,'Step-4'
		   ,'CreateDashboardReservationView'
		   ,getdate()
		   ,0

	  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
	   WHERE StoredProcedureName='CreateDashboardReservationView'
		 AND RunId=@RunID


		DECLARE @VSQL1 NVARCHAR(MAX)
		DECLARE @VSQL2 VARCHAR(MAX)
		DECLARE @VSQL3 VARCHAR(MAX)
		DECLARE @VSQL4 VARCHAR(MAX)	
	
		

		SET @VSQL1='
		if exists(select 1  from INFORMATION_SCHEMA.VIEWS Where TABLE_NAME =''DAS_Dashboard_Reservation'' And Table_Schema =''AsData_PL'')
			Drop View AsData_PL.DAS_Dashboard_Reservation'

	
	    SET @VSQL2='Create view AsData_PL.DAS_Dashboard_Reservation
		  as 
		  with saltkeydata as 
		  (
			 Select TOP 1 SaltKeyID,SaltKey From AsData_PL.SaltKeyLog Where SourceType =''CampaignDashboard''  Order by SaltKeyID DESC 
		  ),
		  reservationbase as 
		  (
		   SELECT		CASE 
						WHEN Apprenticeship.Id IS NOT NULL THEN convert(NVarchar(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(Apprenticeship.Id, saltkeydata.SaltKey)))),2) 
						END AS B1,												
						Case when Cast(Apprenticeship.CreatedOn as Date) != cast(''9999-12-31'' as Date) then Apprenticeship.CreatedOn Else NULl End AS B2,				
						Reservation.CreatedDate AS B3,				
						CASE 
						WHEN Reservation.Id IS NOT NULL THEN CONVERT(NVARCHAR(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(Reservation.Id, saltkeydata.SaltKey)))),2) 
						END AS B4,
						Case when Cast(Reservation.StartDate as Date) != cast(''9999-12-31'' as Date) then Reservation.StartDate Else NULl End AS B5, 				
						Case when Cast(Reservation.ExpiryDate as Date) != cast(''9999-12-31'' as Date) then Reservation.ExpiryDate Else NULl End AS B6, 				
						Cast(COALESCE(Reservation.Status, -1) as Int) AS B7, 				
						Case when upper(trim(Reservation.CourseId)) =''NULL''  Or  trim(Reservation.CourseId) = '''' Or trim(Reservation.CourseId) = ''-99999'' Then NULL 
							Else  trim(Reservation.CourseId) 
						End AS B8, 
						Case when Cast(Course.Level As Int) != -1 Then Cast(Course.Level As Int) Else NULL End AS B9,
						SaltKeyID
			FROM		Comt.Ext_Tbl_Apprenticeship Apprenticeship
						FULL OUTER JOIN Resv.Ext_Tbl_Reservation Reservation
						ON Reservation.Id = Apprenticeship.ReservationId				
						FULL OUTER JOIN Resv.Ext_Tbl_Course Course
						ON Course.CourseId = Reservation.CourseId
						CROSS JOIN saltkeydata 
			WHERE		Reservation.CreatedDate >= ''01-Jan-2020''
		   )         
		   , stdFrameworks as 
		   (
				select Code,[Name],[Route],[Level]
				from AsData_PL.DAS_Dashboard_StdsAndFrameworks
		   )
		   Select B8 As Code,a.B4,b.any_B1,b.any_B2,b.any_B3,b.any_B5,b.any_B6,average_B7,average_B9,stdFrameworks.[Name],stdFrameworks.[Route],stdFrameworks.[Level],b.SaltKeyID
		   from 
		   (
				Select B4,B8,AVG(B7) AS average_B7,AVG(B9) as average_B9 From reservationbase  group by B4,B8
			) as a 
			JOIN 
			(
				select  B4,B1 as any_B1,B2 As any_B2,B3 As any_B3,B5 as any_B5,B6 as any_B6,SaltKeyID 
				from reservationbase 
				where B5 IS NOT NULL 
				group by B4,B1,B2,B3,B5,B6,SaltKeyID
		   ) as b 
		   on a.B4 = b.B4
		   LEFT JOIN stdFrameworks on a.B8 = stdFrameworks.Code and stdFrameworks.Code IS NOT NULL
		   Where a.B8  IS NOT NULL  '

			   EXEC SP_EXECUTESQL @VSQL1 -- run check to drop view if it exists. 
			   EXEC (@VSQL2) -- run sql to create view. 

		UPDATE Mgmt.Log_Execution_Results
		   SET Execution_Status=1
			  ,EndDateTime=getdate()
			  ,FullJobStatus='Pending'
		 WHERE LogId=@LogID
		   AND RunId=@RunId

 
END TRY
BEGIN CATCH
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
			'CreateDashboardReservationView',
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

