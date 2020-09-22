CREATE PROCEDURE [dbo].[PresentationLayerFullRefreshModel]
(
   @RunId int
  ,@PLTableName varchar(255)
  ,@StgTableName varchar(255)  
  ,@SourceDatabaseName varchar(255) NULL
  ,@ConfigSchema varchar(255) NULL
  ,@ConfigTable varchar(255) NULL
)
AS
/* ===============================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 24/08/2020
-- Description: Dynamically Refresh Data Mart Presentation Layer few tables  with joining other tables 
-- ===============================================================================================================
*/

BEGIN TRY
		DECLARE @LogID int,@SPName Varchar(max),@SQLCode Nvarchar(max),@K1 nvarchar(max),@K2 nvarchar(max),
				@InsertList NVARCHAR(MAX),@SelectList NVARCHAR(MAX),@JOINTable1 NVarchar(max),@JOINTable2 NVarchar(max)

		select @SPName = 'PresentationLayerFullRefresh-'+SUBSTRING(@PLTableName,CHARINDEX('.',@PLTableName)+1,LEN(@PLTableName))

		/* Start Logging Execution */

		  INSERT INTO Mgmt.Log_Execution_Results
			  (
				RunId
			   ,StepNo
			   ,StoredProcedureName
			   ,StartDateTime
			   ,Execution_Status
			  )
		  SELECT 
				@RunId
			   ,'Step-6'
			   ,@SPName
			   ,getdate()
			   ,0

			SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
			WHERE StoredProcedureName=@SPName
			AND RunId=@RunID

			SELECT @SQLCode='SELECT @K1=convert(nvarchar(max),'+SQLCode+',2)' From Stg.SQLCode Where [Type]='CRG'
			EXEC SP_EXECUTESQL @SQLCode, N'@K1 nvarchar(max) OUTPUT',@K1=@K1 OUTPUT

			SELECT @SQLCode='SELECT @K2=convert(nvarchar(max),'+SQLCode+',2)' From Stg.SQLCode Where [Type]='CRG'
			EXEC SP_EXECUTESQL @SQLCode, N'@K2 nvarchar(max) OUTPUT',@K2=@K2 OUTPUT
			
		/* Preparing Presentation Layer Tables Insert and Select List */		
		SELECT @SQLCode=SQLCode FROM Stg.SQLCode WHERE Type='DBPP'

		/* Check If ColumnNameToMask exists And Navigate to the Logic*/
		IF OBJECT_ID('tempdb..#TColList') IS NOT NULL DROP TABLE #TColList

		CREATE TABLE #TColList
		(OrigList varchar(255),TransformList nvarchar(max))

		IF ((SELECT SCFI_Id FROM Mtd.SourceConfigForImport SCFI
				WHERE SourceDatabaseName=@SourceDatabaseName
			AND SourceTableName=@ConfigTable
			AND SourceSchemaName=@ConfigSchema
			AND ColumnNamesToMask<>'') IS NOT NULL)
		BEGIN

				INSERT INTO #TColList
				(OrigList,TransformList)
				SELECT value as OrigList
						,'convert(nvarchar(512),'+replace(replace(replace(@SQLCode,'T1','['+SUBSTRING(REPLACE(Value,'[',''),1,2)+SUBSTRING(REVERSE(REPLACE(Value,']','')),1,2)+']'),'K1','0x'+@K1),'K2','0x'+@k2)+')' as TransformList
					FROM Mtd.SourceConfigForImport SCFI
					CROSS APPLY string_split(ColumnNamesToMask,',')
					WHERE SourceDatabaseName=@SourceDatabaseName
					AND SourceTableName=@ConfigTable
					AND SourceSchemaName=@ConfigSchema
					UNION
					SELECT value as ConfigList,  value as TransformList
					FROM Mtd.SourceConfigForImport SCFI
					CROSS APPLY string_split(ColumnNamesToInclude,',')
					WHERE SourceDatabaseName=@SourceDatabaseName
					AND SourceTableName=@ConfigTable
					AND SourceSchemaName=@ConfigSchema
		END
		ELSE 
		BEGIN
			INSERT INTO #TColList
			(OrigList,TransformList)
				SELECT value as ConfigList,  value as TransformList
				FROM Mtd.SourceConfigForImport SCFI
				CROSS APPLY string_split(ColumnNamesToInclude,',')
				WHERE SourceDatabaseName=@SourceDatabaseName
				AND SourceTableName=@ConfigTable
				AND SourceSchemaName=@ConfigSchema
		END

		SET @InsertList=STUFF((select ','+OrigList
								from #TColList AS ColList
								for XML PATH('')),1,1,'')
		--SELECT @InsertList

		SET @SelectList=STUFF((select ','+TransformList
								from #TColList AS ColList
								for XML PATH('')),1,1,'')
		--SELECT @SelectList,@InsertList		

		BEGIN TRANSACTION

		Declare @VSQL1 NVARCHAR(MAX)

		If @PLTableName = 'ASData_PL.Acc_Account' 
		Begin 
			Set @JOINTable1 = 'Stg.Comt_Accounts'; Set @JOINTable2 = 'Stg.EI_Accounts'

			Declare @JOINClause NVarchar(max) =  N' FROM '+ @StgTableName + ' aa left join ' + @JOINTable1 + ' ca on aa.id = ca.id  left join ' + @JOINTable2 + ' ea on aa.Id = ea.Id'
			Declare @GroupByCaluse NVarchar(max) = N' Group by ' + @SelectList

					Set @InsertList = @InsertList + ',ComtAccountID,ComtLevyStatus,EIAccountID,HasSignedIncentivesTerms'
					Set @SelectList = replace(@SelectList,'[Id]','aa.[Id]')
					Set @SelectList = replace(@SelectList,'[HashedId]','aa.[HashedId]')
					Set @SelectList = @SelectList + ',ca.ID,ca.[LevyStatus],ea.ID,ea.HasSignedIncentivesTerms'
					Set @GroupByCaluse = N' Group by ' + @SelectList

			SET @VSQL1=
			'
			DELETE FROM '+@PLTableName+'
			INSERT INTO '+@PLTableName+'
			('+@InsertList+')
			SELECT '+ @SelectList + @JOINClause + @GroupByCaluse

		End 
		Else
		Begin 
				SET @VSQL1=
				'
				DELETE FROM '+@PLTableName+'

				INSERT INTO '+@PLTableName+'
				('+@InsertList+')
				SELECT '+@SelectList+'
				  FROM '+@StgTableName+'
				'
		End 

		EXEC SP_EXECUTESQL @VSQL1


		COMMIT TRANSACTION

		/* Drop Staging Table */

			DECLARE @VSQL2 NVARCHAR(MAX)
			Declare @TableName Varchar(255)
			SELECT @TableName=SUBSTRING(@StgTableName,CHARINDEX('.',@StgTableName)+1,LEN(@StgTableName))

			SET @VSQL2=
			'
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'''+@TableName+''' AND TABLE_SCHEMA=N''Stg'') 
			DROP TABLE [Stg].'+@TableName+'
			'
			EXEC SP_EXECUTESQL @VSQL2

		if @JOINTable1  is not null 
		Begin 
			SELECT @TableName=SUBSTRING(@JOINTable1,CHARINDEX('.',@JOINTable1)+1,LEN(@JOINTable1))
			SET @VSQL2= 
			'
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'''+@TableName+''' AND TABLE_SCHEMA=N''Stg'') 
			DROP TABLE [Stg].'+@TableName+'
			'
			EXEC SP_EXECUTESQL @VSQL2
		End 

		if @JOINTable2  is not null 
		Begin 
			SELECT @TableName=SUBSTRING(@JOINTable2,CHARINDEX('.',@JOINTable2)+1,LEN(@JOINTable2))
			SET @VSQL2= 
			'
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'''+@TableName+''' AND TABLE_SCHEMA=N''Stg'') 
			DROP TABLE [Stg].'+@TableName+'
			'
			EXEC SP_EXECUTESQL @VSQL2
		End


		UPDATE Mgmt.Log_Execution_Results
		   SET Execution_Status=1
			  ,EndDateTime=getdate()
			  ,FullJobStatus='Pending'
		 WHERE LogId=@LogID
		   AND RunId=@RunId

 
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

    DECLARE @ErrorId int

  INSERT INTO Mgmt.Log_Error_Details
	  (UserName
	  ,ErrorNumber
	  ,ErrorState
	  ,ErrorSeverity
	  ,ErrorLine
	  ,ErrorProcedure
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,RunId
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    @SPName,
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunId

  END CATCH
GO