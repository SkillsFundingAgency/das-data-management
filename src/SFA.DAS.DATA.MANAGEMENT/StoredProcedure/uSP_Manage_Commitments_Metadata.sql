

CREATE PROCEDURE mgmt.usp_Manage_Commitments_Lookup

AS

-- ====================================================================================================================
-- Author:		Himabindu Uddaraju
-- Create date: 14/03/2019
-- Description:	Stored Procedure to Manage FIU Campaign Metadata that contains the Heirarchy of Feedback Counts where 
--              Counts below the heirarchy are subset of the one's above the heirarchy
-- ====================================================================================================================

BEGIN
	
	SET NOCOUNT ON;

	/* Truncate Existing Metadata Table before re-loading */

	Truncate Table Mtd.Commitments_Metadata

	/* Insert Metadata Values */

	INSERT INTO Mtd.Commitments_Metadata
	(Table_Name
	,Attribute_Name
	,LookUp_Value 
	,LookUp_Description )
	VALUES 
	('Commitment','CommitmentStatus',0,'New'),
	('Commitment','CommitmentStatus',1,'Active'),
	('Commitment','CommitmentStatus',2,'Deleted'),
	('Commitment','EditStatus',0,'Both'),
	('Commitment','EditStatus',1,'Employer'),
	('Commitment','EditStatus',2,'Provider'),
	('Commitment','EditStatus',3,'Neither'),
	('Commitment','EditStatus',3,'Neither'),
	('Commitment','LastAction',0,'New Cohort'),
	('Commitment','LastAction',1,'Amended by a Party'),
	('Commitment','LastAction',2,'Approved by a Party'),
	('Commitment','LastAction',3,'Amended By Employer Following Transfer Sender Rejection'),
	('Commitment','Transfer Approval Status',null,'N/A'),
	('Commitment','Transfer Approval Status',1,'Approved'),
	('Commitment','Transfer Approval Status',2,'Rejected'),
	('Apprenticeship','AgreementStatus',0,'NotAgreed'),
	('Apprenticeship','AgreementStatus',1,'EmployerAgreed'),
	('Apprenticeship','AgreementStatus',2,'ProviderAgreed'),
	('Apprenticeship','AgreementStatus',3,'BothAgreed'),
	('Apprenticeship','PaymentStatus',0,'PendingApproval'),
	('Apprenticeship','PaymentStatus',1,'Active'),
	('Apprenticeship','PaymentStatus',2,'Paused'),
	('Apprenticeship','PaymentStatus',3,'Cancelled'),
	('Apprenticeship','PaymentStatus',4,'Completed'),
	('Apprenticeship','PaymentStatus',5,'Deleted'),
	('Apprenticeship','PaymentStatus',0,'PendingApproval'),
	('ApprenticeshipUpdate','Status',0,'Pending'),
	('ApprenticeshipUpdate','Status',1,'Approved'),
	('ApprenticeshipUpdate','Status',2,'Rejected'),
	('ApprenticeshipUpdate','Status',3,'Deleted'),
	('ApprenticeshipUpdate','Status',4,'Superceded'),
	('ApprenticeshipUpdate','Status',5,'Expired'),
	('ApprenticeshipUpdate','Status',0,'Pending'),
	('ApprenticeshipUpdate','Originator',0,'Employer'),
	('ApprenticeshipUpdate','Originator',0,'Provider'),
	('DataLockStatus','TriageStatus',0,'Unknown'),
	('DataLockStatus','TriageStatus',1,'Change to Commitments Requested'),
	('DataLockStatus','TriageStatus',2,'Stop/Restart requested'),
	('DataLockStatus','TriageStatus',3,'FixIlr'),
	('DataLockStatus','Status',0,'Unknown'),
	('DataLockStatus','Status',1,'Pass'),
	('DataLockStatus','Status',2,'Fail'),
	('DataLockStatus','UpdateType',0,'ApproveChanges'),
	('DataLockStatus','UpdateType',1,'RejectChanges')









   
END
GO
