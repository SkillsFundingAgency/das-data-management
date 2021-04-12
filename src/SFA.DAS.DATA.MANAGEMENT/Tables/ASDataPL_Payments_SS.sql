CREATE TABLE ASData_PL.Payments_SS
( 
		  ID							bigint IDENTITY(1,1) not null
		 ,PaymentID						nvarchar(100) null
		 ,UKPRN							bigint null
		 ,ULN							bigint null
		 ,EmployerAccountID				nvarchar(100) null
		 ,DasAccountId					nvarchar(100) null
		 ,CommitmentID					bigint not null
		 ,DeliveryMonth					int not null
		 ,DeliveryYear					int not null
		 ,CollectionMonth				int not null
		 ,CollectionYear				int not null
		 ,EvidenceSubmittedOn			datetime not null
		 ,EmployerAccountVersion		nvarchar(50) null
		 ,ApprenticeshipVersion			nvarchar(50) null
		 ,FundingSource					nvarchar(25) null
		 ,FundingAccountId				bigint null
		 ,TransactionType				nvarchar(50) null
		 ,Amount						decimal(18,5) not null
		 ,StdCode						int null
		 ,FworkCode						int null
		 ,ProgType						int null
		 ,PwayCode						int null
		 ,ContractType					nvarchar(50) null
		 ,UpdateDateTime				datetime not null
		 ,UpdateDate					date null
		 ,Flag_Latest					int not null
		 ,Flag_FirstPayment				int null
		 ,PaymentAge					int null
		 ,PaymentAgeBand				varchar(27) not null
		 ,DeliveryMonthShortNameYear	varchar(20) not null
		 ,DASAccountName				nvarchar(100) null
		 ,CollectionPeriodName			nvarchar(20) null
		 ,CollectionPeriodMonth			nvarchar(10) null
		 ,CollectionPeriodYear			nvarchar(10) null
		 ,LearningAimFundingLineType    nvarchar(100) null
 )