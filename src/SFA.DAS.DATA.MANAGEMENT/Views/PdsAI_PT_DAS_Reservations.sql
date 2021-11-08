CREATE VIEW [Pds_AI].[PT_C]
	AS 
SELECT DISTINCT 
       Reservation.AccountId                            AS C1
      ,Reservation.Id                                   AS C2	
      ,COALESCE(Reservation.CreatedDate,'9999-12-31') AS C3			
      ,COALESCE(Reservation.StartDate, '9999-12-31')  AS C4
      ,COALESCE(Reservation.ExpiryDate,'9999-12-31')  AS C5 
      ,COALESCE(Reservation.Status, -1)                 AS C6
	  ,COALESCE(Course.Level, -1)                       AS C7
      ,COALESCE(ao.[ApprenticeshipOccupationId],-1)     AS C8
      ,Reservation.AsDm_UpdatedDateTime                 AS C9
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


