-- SaltKeyLog 
Go
Create Table [AsData_PL].[SaltKeyLog](
	SaltKeyID BigInt PRIMARY KEY,
	SaltKey  Varbinary(max) DEFAULT CRYPT_GEN_RANDOM(4096),
	SourceType Varchar(50)
) ON [PRIMARY]
Go