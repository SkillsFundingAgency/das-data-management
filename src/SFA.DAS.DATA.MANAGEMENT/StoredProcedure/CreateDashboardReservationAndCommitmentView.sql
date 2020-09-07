CREATE PROCEDURE [dbo].[CreateDashboardReservationAndCommitmentView]
(
   @RunId int
)
AS
-- ===========================================================================
-- Author:      Sarma Evani
-- Create Date: 27/07/2020
-- Description: Compaign Dashboard Reservation and Commitments 
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
		   ,'CreateDashboardReservationAndCommitmentView'
		   ,getdate()
		   ,0

	  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
	   WHERE StoredProcedureName='CreateDashboardReservationAndCommitmentView'
		 AND RunId=@RunID

		DECLARE @VSQL1 NVARCHAR(MAX)
		DECLARE @VSQL2 VARCHAR(MAX)
		DECLARE @VSQL3 VARCHAR(MAX)
		DECLARE @VSQL4 VARCHAR(MAX)	

		SET @VSQL1='
		if exists(select 1  from INFORMATION_SCHEMA.VIEWS    Where TABLE_NAME =''DAS_Dashboard_ReservationAndCommitment'' And Table_Schema =''AsData_PL'')
			Drop View AsData_PL.DAS_Dashboard_ReservationAndCommitment'
		  
		SET @VSQL2='CREATE VIEW [ASData_PL].[DAS_Dashboard_ReservationAndCommitment] As
		with SaltKeyData as 
		(Select TOP 1 SaltKeyID,SaltKey From AsData_PL.SaltKeyLog Where SourceType =''CampaignDashboard''  Order by SaltKeyID DESC)
		,reservationbase as 
		(
				SELECT B1,B2,B3,B4,B5,B6,B7,B8,B9,CommDateTransfer,CommDateBase,case when CommDateTransfer IS NULL Then 1 Else 0 End as NoTransfer,case when CommDateTransfer IS NULL Then CommDateBase Else CommDateTransfer End as ApprovedDate
				FROM(
					 SELECT Apprenticeship.Id As B1,						
							Case when Cast(Apprenticeship.CreatedOn as Date) != cast(''9999-12-31'' as Date) then Apprenticeship.CreatedOn Else NULl End AS B2,
							Reservation.CreatedDate AS B3,
							Reservation.Id As B4,						
							Case when Cast(Reservation.StartDate as Date) != cast(''9999-12-31'' as Date) then Reservation.StartDate Else NULl End AS B5, 
							Case when Cast(Reservation.ExpiryDate as Date) != cast(''9999-12-31'' as Date) then Reservation.ExpiryDate Else NULl End AS B6, 
							Cast(COALESCE(Reservation.Status, -1) as Int) AS B7,
							Case when upper(trim(Reservation.CourseId)) =''NULL''  Or  trim(Reservation.CourseId) = '''' Or trim(Reservation.CourseId) = ''-99999'' Then NULL Else  trim(Reservation.CourseId) End AS B8, 
							Case when Cast(Course.Level As Int) != -1 Then Cast(Course.Level As Int) Else NULL End AS B9, 														
							Case when COALESCE(Commitment.TransferApprovalStatus, 1) = 7 Then case when cast(Commitment.TransferApprovalActionedOn as date) != cast(''9999-12-31'' as Date) then cast(Commitment.TransferApprovalActionedOn as date) Else NULL End else NULL End	as CommDateTransfer,										
							Case when COALESCE(Commitment.Approvals, 1) = 3 AND COALESCE(Commitment.TransferApprovalStatus, 1) = 1 Then cast(Commitment.EmployerAndProviderApprovedOn as datetime) Else NULL End as CommDateBase						
					FROM	Comt.Ext_Tbl_Apprenticeship Apprenticeship FULL OUTER JOIN Resv.Ext_Tbl_Reservation Reservation ON Reservation.Id = Apprenticeship.ReservationId 
							FULL OUTER JOIN Resv.Ext_Tbl_Course Course ON Course.CourseId = Reservation.CourseId FULL OUTER JOIN Comt.Ext_Tbl_Commitment Commitment ON Commitment.Id = Apprenticeship.CommitmentId 						
							WHERE	Reservation.CreatedDate >= ''01-Jan-2020''						
				) As reservation
		)	
		, reservationtraining as 
		(	
				Select  r.B1,r.B2,r.B4,r.B5,case when r.B5 IS NULL Then 0 Else 1 End as ReservedFlag,r.ApprovedDate,case when r.ApprovedDate IS NULL Then 0 Else 1 End ApprovedFlag,
						DateDiff(day,r.B2,r.ApprovedDate) as CommittedApprovedLag,p.Min_C2,case when p.Min_C2 IS NULL then 0 Else 1 End as StartedFlag,datediff(day,r.ApprovedDate,p.min_c2) as ApprovedtoStartedLag
				FROM	reservationbase r left join 				
						(	Select C1,Case When MIN(C2) = 6 Then Convert(Date,''01/01/2020'',103)  When MIN(C2) = 7 Then Convert(Date,''01/02/2020'',103) 
									When MIN(C2) = 8 Then Convert(Date,''01/03/2020'',103)  When MIN(C2) = 9 Then Convert(Date,''01/04/2020'' ,103)
									When MIN(C2) = 10 Then Convert(Date,''01/05/2020'',103) When MIN(C2) = 11 Then Convert(Date,''01/06/2020'',103) 
									When MIN(C2) = 12 Then Convert(Date,''01/07/2020'',103) End As Min_C2 
					FROM (	SELECT	DISTINCT App.Id As C1,Pay.CollectionPeriod AS C2 FROM Comt.Ext_Tbl_Apprenticeship App JOIN StgPmts.Payment Pay ON Pay.LearnerUln = App.Uln 
							WHERE		Pay.AcademicYear = ''1920'' AND	Pay.CollectionPeriod IN (6, 7, 8, 9, 10, 11, 12, 13, 14)
					)  as outerquery group by C1
				) p 				
				on r.B1 = p.C1 				
		)'
		Set @VSQL3 = 'select  
					CASE WHEN reseravations.B4 IS NOT NULL THEN CONVERT(NVARCHAR(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(reseravations.B4, SaltKeyData.SaltKey)))),2) END AS B4,					
					CASE WHEN reservationtraining.B1 IS NOT NULL THEN CONVERT(NVARCHAR(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(reservationtraining.B1, SaltKeyData.SaltKey)))),2) END AS B1,
					case when reseravations.any_B1 IS NOT NULL Then  1 Else 0 End as CommitmentFlag,
					reservationcourse.B8 as Code,
					CASE WHEN reseravations.any_B1 IS NOT NULL THEN CONVERT(NVARCHAR(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(reseravations.any_B1, SaltKeyData.SaltKey)))),2) END AS any_B1,
					reseravations.any_B2,reseravations.any_B3,
					Datediff(day,reseravations.Any_B3,reseravations.Any_B2) as [Reserve-Commit Lag],
					reseravations.any_B5,reseravations.any_B6,reservationcourse.average_B7,reservationcourse.average_B9,
					sf.Name,sf.Route,sf.Level,reservationtraining.ApprovedDate,					
					Case when reservationtraining.ApprovedFlag IS NULL then 0 Else reservationtraining.ApprovedFlag End as ApprovedFlag,
					reservationtraining.CommittedApprovedLag as [Committed-ApprovedLag],
					reservationtraining.min_C2,
					Case when reservationtraining.StartedFlag IS NULL then 0 Else reservationtraining.StartedFlag End as StartedFlag,
					reservationtraining.ApprovedtoStartedLag,
					SaltKeyData.SaltKeyID							  
				FROM 						
				(	SELECT Apprenticeship.Id As any_B1,							
							Case when Cast(Apprenticeship.CreatedOn as Date) != cast(''9999-12-31'' as Date) then Apprenticeship.CreatedOn Else NULl End AS any_B2,
							Reservation.CreatedDate AS any_B3,
							Reservation.Id As B4,						
							Case when Cast(Reservation.StartDate as Date) != cast(''9999-12-31'' as Date) then Reservation.StartDate Else NULl End AS any_B5, 
							Case when Cast(Reservation.ExpiryDate as Date) != cast(''9999-12-31'' as Date) then Reservation.ExpiryDate Else NULl End AS any_B6						
					FROM	Comt.Ext_Tbl_Apprenticeship Apprenticeship FULL OUTER JOIN Resv.Ext_Tbl_Reservation Reservation ON Reservation.Id = Apprenticeship.ReservationId 
					WHERE	Reservation.CreatedDate >= ''01-Jan-2020''							
					group by Apprenticeship.Id,Apprenticeship.CreatedOn,Reservation.CreatedDate,Reservation.Id,Reservation.StartDate,Reservation.ExpiryDate				
			) as reseravations JOIN 		
			(
					Select  Reservation.Id As B4,AVG(Cast(COALESCE(Reservation.Status, -1) as Int)) AS average_B7,
							Case when upper(trim(Reservation.CourseId)) =''NULL''  Or  trim(Reservation.CourseId) = '''' Or trim(Reservation.CourseId) = ''-99999'' Then NULL Else  trim(Reservation.CourseId) End AS B8, 
							AVG(Case when Cast(Course.Level As Int) != -1 Then Cast(Course.Level As Int) Else NULL End) As average_B9 
					FROM	Resv.Ext_Tbl_Reservation Reservation 					
					FULL OUTER JOIN Resv.Ext_Tbl_Course Course ON Course.CourseId = Reservation.CourseId					
					WHERE	Reservation.CreatedDate >= ''01-Jan-2020''
					group by Reservation.Id,Reservation.CourseId
			) as 
			reservationcourse on reseravations.B4 = reservationcourse.B4
				LEFT JOIN reservationtraining on reseravations.B4 = reservationtraining.B4			
				LEFT JOIN ( Select code,[Name],[Route],[Level] from AsData_PL.DAS_Dashboard_StdsAndFrameworks ) sf on reservationcourse.B8 = sf.code						
				CROSS JOIN SaltKeyData' 	
								
		   EXEC SP_EXECUTESQL @VSQL1 -- run check to drop view if it exists. 							   
		   EXEC (@VSQL2 + @VSQL3) -- run sql to create view. 

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
			'CreateDashboardReservationAndCommitmentView',
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
