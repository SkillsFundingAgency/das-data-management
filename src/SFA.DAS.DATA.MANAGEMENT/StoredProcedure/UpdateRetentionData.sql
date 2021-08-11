CREATE PROCEDURE dbo.UpdateRetentionData 
    @RunId int,
	@DataSetName  As Varchar(25) = NULL, 
	@DataSetTable Varchar(50) = NULL,
	@DataSetSchema Varchar(50) = NULL
As

BEGIN TRY

SET NOCOUNT ON

 DECLARE	@LogID int, 			
			@PrimaryJOINColumn Varchar(50),
			@RetentionPeriodInMonths Varchar(50),
			@SensitiveColumns Varchar(50),
			@RetentionColumn Varchar(50),
			@RefColumn Varchar(50),
			@RefDataSetTable Varchar(50),
			@RefDataSetSchema Varchar(50)

Declare @UpdateQuery NVarchar(max) = NULL, 
			@UpdateClause  NVarchar(200) = NULL,
			@UpdateColsList  NVarchar(200) = NULL,
			@FromClause  NVarchar(200) = NULL,
			@WhereClause  NVarchar(200) = NULL,
			@JOINClause NVarchar(200) = NULL,
			@RetentioUpdateCluase  NVarchar(200) = NULL 

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
	   ,'Step-5'
	   ,'UpdateRetentionData'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='UpdateRetentionData'
     AND RunId=@RunID
   
BEGIN TRANSACTION
			/* Get all the parameter data from Mtd.DataRetentionConfig */
			Select
					@PrimaryJOINColumn = Case when trim(PrimaryJOINColumn) IS NULL Then '' Else trim(PrimaryJOINColumn) End,
					@RetentionPeriodInMonths = Case when trim(RetentionPeriodInMonths) IS NULL Then '' Else trim(RetentionPeriodInMonths) End,
					@SensitiveColumns = Case When trim(SensitiveColumns) IS NULL Then '' Else trim(SensitiveColumns) End,
					@RetentionColumn = Case When trim(RetentionColumn) IS NULL Then '' Else trim(RetentionColumn) End,
					@RefColumn = Case When trim(RefColumn) IS NULL Then '' Else trim(RefColumn) End,
					@RefDataSetTable = Case When trim(RefDataSetTable) IS NULL Then '' Else trim(RefDataSetTable) End,
					@RefDataSetSchema = Case When trim(RefDataSetSchema) IS NULL Then '' Else trim(RefDataSetSchema) End
			FROM Mtd.DataRetentionConfig
			Where DataSetName = @DataSetName AND DataSetTable = @DataSetTable AND DataSetSchema = @DataSetSchema
			
			Set @UpdateColsList = '' 

			If @RefDataSetTable = '' And @RefDataSetSchema = '' 
			Begin 
					Set @UpdateClause = 'UPDATE PT '
					Set @RetentioUpdateCluase = ' SET PT.IsRetentionApplied = 1,PT.RetentionAppliedDate = getdate() '
					If @SensitiveColumns != '' 
					Begin 			
						SELECT @UpdateColsList = COALESCE(@UpdateColsList + ',','') + Value
						FROM ( Select 'PT.' + Value + ' = NULL' As Value from (select * from STRING_SPLIT (@SensitiveColumns, ',')) As  uc)  ucl
						Set @UpdateColsList = ',' + @UpdateColsList
					End
					Set @FromClause  = ' FROM ' + @DataSetSchema + '.' + @DataSetTable +' PT '
					Set @WhereClause = ' Where Datediff(Month,PT.' + @RetentionColumn + ',GetDate()) >=' + Cast(@RetentionPeriodInMonths As Varchar(10))
					Set @UpdateQuery  = @UpdateClause + @RetentioUpdateCluase + @UpdateColsList +  @FromClause + @WhereClause
		
			End 
			Else If @RefDataSetTable != ''  And @RefDataSetSchema != '' 
			Begin 
					Set @UpdateClause = 'UPDATE ST '
		
					Set @RetentioUpdateCluase = ' SET ST.IsRetentionApplied = 1,ST.RetentionAppliedDate = getdate() '		

					If @SensitiveColumns != ''  
					Begin 			
						SELECT @UpdateColsList = COALESCE(@UpdateColsList + ',','') + Value
						FROM ( Select 'ST.' + Value + ' = NULL' As Value from (select * from STRING_SPLIT (@SensitiveColumns, ',')) As  uc)  ucl
						Set @UpdateColsList = ',' + @UpdateColsList
					End
					Else 
						Set @UpdateColsList = ''

					Set @FromClause  = ' FROM ' + @DataSetSchema + '.' + @DataSetTable +' ST ' + ' JOIN ' + @RefDataSetSchema + '.' + @RefDataSetTable + ' PT '				

					Set @JOINClause  = ' ON PT.' + @PrimaryJOINColumn + ' = ST.' + @RefColumn				

					If @RetentionColumn != '' 
						Set @WhereClause = ' Where Datediff(Month,PT.' + @RetentionColumn + ',GetDate()) >=' + Cast(@RetentionPeriodInMonths As Varchar(10))
					Else
						Set @WhereClause = ' Where PT.IsRetentionApplied = 1'		

					Set @UpdateQuery  = @UpdateClause + @RetentioUpdateCluase + @UpdateColsList +  @FromClause + @JOINClause + @WhereClause		
			End 

			exec sp_executeSQL @UpdateQuery

			COMMIT TRANSACTION

 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
			IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION

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
			  ,ErrorADFTaskType
			  )
		  SELECT 
				SUSER_SNAME(),
				ERROR_NUMBER(),
				ERROR_STATE(),
				ERROR_SEVERITY(),
				ERROR_LINE(),
				'UpdateRetentionData',
				ERROR_MESSAGE(),
				GETDATE(),
				@RunId as RunId,
				'UpdateRetentionData'; 

		  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

		/* Update Log Execution Results as Fail if there is an Error*/

		UPDATE Mgmt.Log_Execution_Results
		   SET Execution_Status=0
			  ,EndDateTime=getdate()
			  ,ErrorId=@ErrorId
		 WHERE LogId=@LogID
		   AND RunID=@RunId

  END CATCH
