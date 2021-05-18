-- SaltKeyLog 
Go
Create Table [Mgmt].[SaltKeyLog](
	SaltKeyID BigInt PRIMARY KEY,
	SaltKey  Varbinary(max) MASKED WITH (FUNCTION = 'default()') DEFAULT CRYPT_GEN_RANDOM(4096) ,
	SourceType Varchar(50),
	CreatedDateTime DateTime2 default (getdate())
) ON [PRIMARY]
Go