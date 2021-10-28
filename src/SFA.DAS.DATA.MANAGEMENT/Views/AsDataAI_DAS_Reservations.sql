CREATE VIEW [AsData_AI].[Das_Reservations]
	AS 
SELECT DISTINCT 
       Reservation.AccountId                            AS A1
      ,Reservation.Id                                   AS A2	
      ,COALESCE(Reservation.CreatedDate,'9999-12-31') AS A3			
      ,COALESCE(Reservation.StartDate, '9999-12-31')  AS A4
      ,COALESCE(Reservation.ExpiryDate,'9999-12-31')  AS A5 
      ,COALESCE(Reservation.Status, -1)                 AS A6
	  ,COALESCE(Course.Level, -1)                       AS A7
      ,COALESCE(ao.[ApprenticeshipOccupationId],-1)     AS A8
      ,Reservation.AsDm_UpdatedDateTime                 AS A9
 FROM ASData_PL.Resv_Reservation Reservation
 LEFT
 JOIN ASData_PL.Resv_Course Course
   ON Course.CourseId =reservation.[courseid]
 LEFT 
 JOIN ASData_PL.Va_ApprenticeshipStandard ast
   ON left(reservation.courseid,3)= ast.larscode
 LEFT 
 JOIN Stg.Avms_ApprenticeshipOccupation ao
   ON ast.ApprenticeshipOccupationId=ao.ApprenticeshipOccupationId
where Reservation.IsLevyAccount=0


