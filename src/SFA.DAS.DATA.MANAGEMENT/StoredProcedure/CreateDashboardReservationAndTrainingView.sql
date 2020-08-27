CREATE PROCEDURE [dbo].[CreateDashboardReservationAndTrainingView]
(
   @RunId int
)
AS
-- ===========================================================================
-- Author:      Sarma EVani
-- Create Date: 27/07/2020
-- Description: Campaign Dashboard Reservation and Training
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
		   ,'CreateDashboardReservationAndTrainingView'
		   ,getdate()
		   ,0

	  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
	   WHERE StoredProcedureName='CreateDashboardReservationAndTrainingView'
		 AND RunId=@RunID


		DECLARE @VSQL1 NVARCHAR(MAX)
		DECLARE @VSQL2 VARCHAR(MAX)
		DECLARE @VSQL3 VARCHAR(MAX)
		DECLARE @VSQL4 VARCHAR(MAX)	


		SET @VSQL1='
		if exists(select 1  from INFORMATION_SCHEMA.VIEWS    Where TABLE_NAME =''DAS_Dashboard_ReservationAndTraining'' And Table_Schema =''AsData_PL'')
			Drop View AsData_PL.DAS_Dashboard_ReservationAndTraining'


		SET @VSQL2='Create View [ASData_PL].[DAS_Dashboard_ReservationAndTraining]
		As	
		with SaltKeyData as 
		(
		Select TOP 1 SaltKeyID,SaltKey From AsData_PL.SaltKeyLog Where SourceType =''CampaignDashboard''  Order by SaltKeyID DESC 
		), reservationbase as 
		(
			SELECT	B1,B2,B4,B5,B11,B13,B16,B17,B26,B32,Approved,TransferApproved,CommDateTransfer,CommDateBase,
				case when CommDateTransfer IS NULL Then 1 Else 0 End as NoTransfer,
				case when CommDateTransfer IS NULL Then CommDateBase Else CommDateTransfer End as ApprovedDate,
				SaltKeyID
					FROM 
					(	
						SELECT 
						CASE 
						WHEN Apprenticeship.Id IS NOT NULL THEN CONVERT(NVARCHAR(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(Apprenticeship.Id, SaltKeyData.SaltKey)))),2) 
						END AS B1,												
						Case when Cast(Apprenticeship.CreatedOn as Date) != cast(''9999-12-31'' as Date) then Apprenticeship.CreatedOn Else NULl End AS B2,							
						CASE 
						WHEN Reservation.Id IS NOT NULL THEN CONVERT(NVARCHAR(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(Reservation.Id, SaltKeyData.SaltKey)))),2) 
						END AS B4,
						Case when Cast(Reservation.StartDate as Date) != cast(''9999-12-31'' as Date) then Reservation.StartDate Else NULl End AS B5, 										
						Case when Cast(Apprenticeship.StartDate as Date) != cast(''9999-12-31'' as Date) then Apprenticeship.StartDate Else NULl End AS B11, 								
						case when upper(trim(Apprenticeship.TrainingCode)) =''NULL'' or  upper(trim(Apprenticeship.TrainingCode)) = '''' or trim(Apprenticeship.TrainingCode) = ''-99999'' Then NULL 
								Else trim(Apprenticeship.TrainingCode) End 
						AS B13,												
						COALESCE(Apprenticeship.IsApproved, -1)	AS B16,				
						Apprenticeship.Cost AS B17,												
						Case when Cast(Commitment.ApprenticeshipEmployerTypeOnApproval As Int) != -1 Then Cast(Commitment.ApprenticeshipEmployerTypeOnApproval As Int) Else NULL End AS B26,									
						Case when Cast(Apprenticeship.CompletionDate as Date) != cast(''9999-12-31'' as Date) then Apprenticeship.CompletionDate Else NULl End AS B32,						
						Case when COALESCE(Commitment.Approvals, 1) = 3 AND COALESCE(Commitment.TransferApprovalStatus, 1) = 1 Then 1 Else 0 End as Approved,						
						Case when COALESCE(Commitment.TransferApprovalStatus, 1) = 7 Then 1 Else 0 End as TransferApproved,						
						Case when COALESCE(Commitment.TransferApprovalStatus, 1) = 7 Then 
								case when cast(Commitment.TransferApprovalActionedOn as date) != cast(''9999-12-31'' as Date) then cast(Commitment.TransferApprovalActionedOn as date) Else NULL End 
							else NULL 		
						End		as CommDateTransfer,						
						Case when COALESCE(Commitment.Approvals, 1) = 3 AND COALESCE(Commitment.TransferApprovalStatus, 1) = 1 Then cast(Commitment.EmployerAndProviderApprovedOn as datetime) Else NULL End as CommDateBase,
						SaltKeyData.SaltKeyID
			FROM		Comt.Ext_Tbl_Apprenticeship Apprenticeship
						FULL OUTER JOIN Resv.Ext_Tbl_Reservation Reservation
						ON Reservation.Id = Apprenticeship.ReservationId
						FULL OUTER JOIN Comt.Ext_Tbl_Commitment Commitment
						ON Commitment.Id = Apprenticeship.CommitmentId
						CROSS JOIN SaltKeyData 
			WHERE		Reservation.CreatedDate >= ''01-Jan-2020''
		) As reservations
		),   
		stdFrameworks as 
		(
			select Code,[Name],[Route],[Level] from AsData_PL.DAS_Dashboard_StdsAndFrameworks
		) '
		SET @VSQL3 =  ', payments as    
		(	
			Select C1,
					Case When MIN(C2) = 6 Then Convert(Date,''01/01/2020'',103)
						When MIN(C2) = 7 Then Convert(Date,''01/02/2020'',103)
						When MIN(C2) = 8 Then Convert(Date,''01/03/2020'',103)
						When MIN(C2) = 9 Then Convert(Date,''01/04/2020'',103)
						When MIN(C2) = 10 Then Convert(Date,''01/05/2020'',103)
						When MIN(C2) = 11 Then Convert(Date,''01/06/2020'',103)
						When MIN(C2) = 12 Then Convert(Date,''01/07/2020'',103)	
					End As Min_C2
			from 
			(
						SELECT	DISTINCT CASE 									
								WHEN App.Id IS NOT NULL THEN  CONVERT(NVARCHAR(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(App.Id, SaltKeyData.SaltKey)))),2)
								END AS C1,
								Pay.CollectionPeriod AS C2
					FROM		Comt.Ext_Tbl_Apprenticeship App
								JOIN StgPmts.Payment Pay
								ON Pay.LearnerUln = App.Uln
								CROSS JOIN SaltKeyData 
					WHERE		Pay.AcademicYear = ''1920''
					AND		Pay.CollectionPeriod IN (6, 7, 8, 9, 10, 11, 12, 13, 14)
			)  as outerquery
			group by C1
		)
		Select  
				r.B1,
				r.B13,
				r.B2,
				r.B4,
				r.B5,
				case when r.B5 IS NULL Then 0 Else 1 End as ReservedFlag,
				r.B11,
				r.B16,
				r.B17,
				r.B26,
				r.ApprovedDate,
				case when r.ApprovedDate IS NULL Then 0 Else 1 End ApprovedFlag,
				DateDiff(day,r.B2,r.ApprovedDate) as [Committed-ApprovedLag],
				s.Name,
				s.Route,
				s.[Level],
				p.Min_C2,
				case when p.Min_C2 IS NULL then 0 Else 1 End as StartedFlag,
				datediff(day,r.ApprovedDate,p.min_c2) as ApprovedtoStartedLag,
				r.SaltKeyID									
		from	reservationbase r 			
		left join stdFrameworks s on r.B13 = s.Code 
		left join payments p on r.B1 = p.C1
		Where r.B1 IS NOT NULL  '		   

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
			'CreateDashboardReservationAndTrainingView',
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

