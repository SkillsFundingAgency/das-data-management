Create Table Mtd.Commitments_Metadata
(CM_ID int identity(1,1) not null,
 Table_Name varchar(255) not null,
 Attribute_Name varchar(255) not null,
 LookUp_Value int,
 LookUp_Description varchar(max)
 )