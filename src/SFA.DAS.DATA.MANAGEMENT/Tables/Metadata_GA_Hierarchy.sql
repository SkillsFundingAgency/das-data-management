Create Table mgmt.Metadata_GA_Hierarchy
(
Id int Identity(1,1) not null,
Feedback_Category varchar(100) not null,
Feedback_Action varchar(255) not null,
Hierarchy int not null,
CreatedDate datetime default(getdate())
)
