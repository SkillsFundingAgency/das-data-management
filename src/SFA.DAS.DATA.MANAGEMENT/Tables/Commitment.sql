Create Table dbo.Commitment
(Id int identity(1,1) primary key not null
,EmployerAccountId int Foreign Key References dbo.EmployerAccount(Id)
,EmployerAccountLegalEntityId int Foreign Key References dbo.EmployerAccountLegalEntity(Id)
,ProviderId int Foreign Key References dbo.Provider(Id)
,Reference nvarchar(100) not null
,CommitmentStatus int not null
,CommitmentStatusDesc as (CASE WHEN CommitmentStatus=1 then 'Active' when CommitmentStatus=2 then 'Deleted' when CommitmentStatus=0 then 'New' else 'Unknown' end) PERSISTED
,EditStatus int not null
,EditStatusDesc  as (Case when EditStatus=0 then 'Both' when EditStatus=1 then 'Employer' when EditStatus=2 then 'Provider' when EditStatus=3 then 'Neither' else 'Unknown' end) PERSISTED
,CommitmentCreatedOn datetime
,LastAction smallint not null
,LastActionDesc as (Case when LastAction=0 then 'New Cohort' when LastAction=1 then 'Amended by a Party' when LastAction=2 then 'Approved by a Party' when lastaction=3 then 'Amended by Employer Following Transfer Sender Rejection' else ' Unknown' end) PERSISTED
,LastUpdatedByEmployerName nvarchar(255) 
,LastUpdatedByEmployerEmail nvarchar(255)
,LastUpdatedByProviderName nvarchar(255)
,LastUpdatedByProviderEmail nvarchar(255)
,EmployerProviderPaymentPriority int
,ProviderCanApproveCommitment int
,EmployerCanApproveCommitment int
,Originator varchar(255)
,OriginatorDesc as (Case when Originator=0 then 'Employer' when Originator=1 then 'Provider' else 'Unknown' end) PERSISTED
,Data_Source varchar(255)
,Commitments_SourceId int
,AsDm_CreatedDate datetime2 default(getdate()) not null
,AsDm_UpdatedDate datetime2 default(getdate()) not null
)