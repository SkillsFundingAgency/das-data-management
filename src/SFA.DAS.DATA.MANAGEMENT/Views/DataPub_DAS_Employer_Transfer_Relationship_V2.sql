CREATE VIEW [Data_Pub].[DAS_Employer_Transfer_Relationship_V2]
    AS 
	SELECT     
				ISNULL(CAST(a.[Id] as bigint),-1)							as Id
			   ,ISNULL(Cast(SenderAccountId as bigint),-1)					as SenderAccountId
			   ,ISNULL(CAST(ReceiverAccountId as bigint),-1)				as ReceiverAccountId
			   ,ISNULL(CAST((CASE WHEN [status] = 2 THEN 'Approved'
			        WHEN [status] = 1 THEN 'Pending'
		            ELSE 'Rejected'
				END) AS nvarchar(50)),'NA')									as RelationshipStatus
			   ,ISNULL(CAST(d.UserID as bigint),0)							as SenderUserId
			  ,ISNULL(CAST(e.UserID as bigint),0)							as ApproverUserId
			  ,ISNULL(CAST(f.UserID as bigint),0)							as RejectorUserId
			  ,ISNULL(CAST(g.CreatedDate as datetime),'9999-12-31')			as UpdateDateTime
			  ,ISNULL(Cast (1 AS BIT),-1)									as IsLatest
			  ,CAST(b.Hashedid as nvarchar(100))							as SenderDasAccountID
			  ,CAST(c.Hashedid as nvarchar(100))							as RecieverDasAccountID
   FROM [ASData_PL].[Fin_TransferConnectionInvitation] a
     LEFT JOIN [ASData_PL].[Acc_Account]  b
   ON a.[SenderAccountId] = b.Id
     LEFT JOIN [ASData_PL].[Acc_Account] c
   ON a.ReceiverAccountID = c.Id
   LEFT join 
	      (
		    SELECT TransferConnectionInvitationID
			       , max(CreatedDate) as CreatedDate 
				   , max(UserId) as UserID
			FROM [ASData_PL].[Fin_TransferConnectionInvitationChange]
			WHERE [Status] = 1
			GROUP BY TransferConnectionInvitationID
		  ) d
	ON a.id = d.TransferConnectionInvitationID
	LEFT join 
	      (
		    SELECT TransferConnectionInvitationID
			       , max(CreatedDate) as CreatedDate 
				   , max(UserId) as UserID
			FROM [ASData_PL].[Fin_TransferConnectionInvitationChange]
			WHERE [Status] = 2
			GROUP BY TransferConnectionInvitationID
		  ) e
	ON a.id = e.TransferConnectionInvitationID
	LEFT join 
	      (
		    SELECT TransferConnectionInvitationID
			       , max(CreatedDate) as CreatedDate 
				   , max(UserId) as UserID
			FROM [ASData_PL].[Fin_TransferConnectionInvitationChange]
			WHERE [Status] = 3
			GROUP BY TransferConnectionInvitationID
		  ) f
	ON a.id = f.TransferConnectionInvitationID
	LEFT join 
	      (
		    SELECT TransferConnectionInvitationID,
			        max(CreatedDate) as CreatedDate 
			FROM [ASData_PL].[Fin_TransferConnectionInvitationChange]
			GROUP BY TransferConnectionInvitationID
		  ) g
	ON a.id = g.TransferConnectionInvitationID
GO

