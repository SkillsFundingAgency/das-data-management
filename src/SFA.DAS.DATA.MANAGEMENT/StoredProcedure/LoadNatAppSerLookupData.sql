CREATE PROCEDURE [dbo].[LoadNatAppSerLookupData]
(
   @RunId int
)
AS

BEGIN TRY

    SET NOCOUNT ON

 DECLARE @LogID int

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
	   ,'Step-3'
	   ,'LoadNatAppSerLookupData'
	   ,getdate()
	   ,0

   SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='LoadNatAppSerLookupData'
     AND RunId=@RunID


IF @@TRANCOUNT=0
BEGIN
	BEGIN TRANSACTION

	DELETE FROM [lkp].[NatAppSerLookupData]

	/* Insert into [lkp].[NatAppSerLookupData] */
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Allerdale', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Amber Valley', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Arun', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Ashfield', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Ashford', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Babergh', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Barnet', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Barnsley', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Barrow in Furness', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Basildon', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Basingstoke and Deane', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bassetlaw', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bath and North East Somerset', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bedford', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bexley', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Birmingham', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Blaby', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Blackburn with Darwen', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bolsover', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bolton', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Boston', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bournemouth  Christchurch and Poole', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bracknell Forest', 'Thames Valley','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bradford', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Braintree', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Breckland', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Brent', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Brentwood', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Brighton and Hove', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bristol  City of', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bromley', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bromsgrove', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Broxbourne', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Broxtowe', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Buckinghamshire', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Burnley', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Bury', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Calderdale', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Cambridge', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Camden', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Canterbury', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Carlisle', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Castle Point', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Central Bedfordshire', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Charnwood', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Chelmsford', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Cheltenham', 'Thames Valley','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Cherwell', 'Thames Valley','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Cheshire East', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Cheshire West and Chester', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Chesterfield', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Chichester', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Chorley', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('City of London', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Colchester', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Cornwall', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('County Durham', 'North East','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Coventry', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Craven', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Crawley', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Croydon', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Cumberland', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Dacorum', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Darlington', 'North East','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Dartford', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Derby', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Derbyshire Dales', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Doncaster', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Dorset', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Dudley', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Ealing', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('East Cambridgeshire', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('East Hampshire', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('East Hertfordshire', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('East Lindsey', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('East Riding of Yorkshire', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('East Staffordshire', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('East Suffolk', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Eastbourne', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Eastleigh', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Elmbridge', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Enfield', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Epping Forest', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Epsom and Ewell', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Erewash', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Exeter', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Fareham', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Folkestone and Hythe', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Forest of Dean', 'Thames Valley','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Gateshead', 'North East','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Gedling', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Gloucester', 'Thames Valley','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Gosport', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Greenwich', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Guildford', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Hackney', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Halton', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Hambleton', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Hammersmith and Fulham', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Harborough', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Haringey', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Harlow', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Harrogate', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Harrow', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Hart', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Hartlepool', 'North East','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Hastings', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Havant', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Havering', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Herefordshire  County of', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Hertsmere', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Hillingdon', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Horsham', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Hounslow', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Huntingdonshire', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Hyndburn', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Ipswich', 'East of England','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Isle of Wight', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Islington', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Kensington and Chelsea', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Kettering', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('King''s Lynn and West Norfolk', 'Central Eastern','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Kingston upon Hull  City of', 'Yorkshire and the Humber','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Kingston upon Thames', 'London','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Kirklees', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Knowsley', 'Liverpool City Region  Cumbria and Lancashire','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Lambeth', 'London','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Lancaster', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Leeds', 'Yorkshire and the Humber','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Leicester', 'East Midlands','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Lewes', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Lewisham', 'London','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Lichfield', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Lincoln', 'East Midlands','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Liverpool', 'Liverpool City Region  Cumbria and Lancashire','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Luton', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Maidstone', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Maldon', 'East of England','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Malvern Hills', 'West Midlands','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Manchester', 'Greater Manchester  Cheshire/Warrington and Staffordshire','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Mansfield', 'East Midlands','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Medway', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Melton', 'East Midlands','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Mendip', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Merton', 'London','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Mid Devon', 'South West','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Mid Suffolk', 'South East','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Mid Sussex', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Middlesbrough', 'North East','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Milton Keynes', 'Central Eastern','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Mole Valley', 'South Central','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('New Forest', 'South Central','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Newark and Sherwood', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Newcastle upon Tyne', 'North East','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Newcastle-under-Lyme', 'Greater Manchester  Cheshire/Warrington and Staffordshire','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Newham', 'London','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North Devon', 'South West','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North East Derbyshire', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North East Lincolnshire', 'Yorkshire and the Humber','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North Hertfordshire', 'Central Eastern','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North Kesteven', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North Lincolnshire', 'Yorkshire and the Humber','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North Norfolk', 'East of England','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North Somerset', 'South West','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North Tyneside', 'North East','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North Warwickshire', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('North West Leicestershire', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Northampton', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Northumberland', 'North East','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Norwich', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Nottingham', 'East Midlands','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Nuneaton and Bedworth', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Oadby and Wigston', 'East Midlands','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Oldham', 'Greater Manchester  Cheshire/Warrington and Staffordshire','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Oxford', 'Thames Valley','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Pendle', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Peterborough', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Plymouth', 'South West','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Portsmouth', 'South Central','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Preston', 'Liverpool City Region  Cumbria and Lancashire','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Reading', 'Thames Valley','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Redbridge', 'London','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Redcar and Cleveland', 'North East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Redditch', 'West Midlands','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Reigate and Banstead', 'South Central','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Ribble Valley', 'Liverpool City Region  Cumbria and Lancashire','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Richmond upon Thames', 'London','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Richmondshire', 'Yorkshire and the Humber','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Rochdale', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Rochford', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Rossendale', 'Liverpool City Region  Cumbria and Lancashire','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Rother', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Rotherham', 'Yorkshire and the Humber','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Rugby', 'West Midlands','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Runnymede', 'South Central','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Rushcliffe', 'East Midlands','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Rushmoor', 'South Central','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Rutland', 'East Midlands','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Ryedale', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Salford', 'Greater Manchester  Cheshire/Warrington and Staffordshire','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Sandwell', 'West Midlands','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Scarborough', 'Yorkshire and the Humber','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Sedgemoor', 'South West','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Sefton', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Selby', 'Yorkshire and the Humber','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Sevenoaks', 'South East','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Sheffield', 'Yorkshire and the Humber','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Shropshire', 'West Midlands','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Slough', 'Thames Valley','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Solihull', 'West Midlands','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Somerset West and Taunton', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Cambridgeshire', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Derbyshire', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Gloucestershire', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Hams', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Holland', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Kesteven', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Lakeland', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Norfolk', 'East of England','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Northamptonshire', 'Central Eastern','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Oxfordshire', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Ribble', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Somerset', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Staffordshire', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South Tyneside', 'North East','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Southampton', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Southend-on-Sea', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Southwark', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Spelthorne', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('St Albans', 'Central Eastern','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('St. Helens', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Stafford', 'Greater Manchester  Cheshire/Warrington and Staffordshire','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Staffordshire Moorlands', 'Greater Manchester  Cheshire/Warrington and Staffordshire','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Stevenage', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Stockport', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Stockton-on-Tees', 'North East','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Stoke-on-Trent', 'Greater Manchester  Cheshire/Warrington and Staffordshire','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Stratford-on-Avon', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Stroud', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Suffolk Coastal', 'East of England','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Sunderland', 'North East','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Surrey Heath', 'South Central','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Sutton', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Swale', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Swindon', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Tameside', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Tamworth', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Tandridge', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Teignbridge', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Telford and Wrekin', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Tendring', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Test Valley', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Tewkesbury', 'Thames Valley','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Thanet', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Three Rivers', 'Central Eastern','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Thurrock', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Tonbridge and Malling', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Torbay', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Torridge', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Tower Hamlets', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Trafford', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Tunbridge Wells', 'South East','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Uttlesford', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Vale of White Horse', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wakefield', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Walsall', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Waltham Forest', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wandsworth', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Warrington', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Warwick', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Watford', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Waverley', 'South East','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wealden', 'South East','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wellingborough', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Welwyn Hatfield', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('West Berkshire', 'South Central','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('West Devon', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('West Lancashire', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('West Lindsey', 'East Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('West Oxfordshire', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('West Suffolk', 'East of England','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Westminster',Null ,'London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Weymouth and Portland',Null, 'South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wigan', 'Greater Manchester  Cheshire/Warrington and Staffordshire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wiltshire', 'South West','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Winchester', 'South Central','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Windsor and Maidenhead', 'South Central','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wirral', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Woking', 'South East','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wokingham', 'South Central','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wolverhampton', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Worcester', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Worthing', 'South East','South')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wrexham', Null,'North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wychavon', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wycombe', 'South Central','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wyre', 'Liverpool City Region  Cumbria and Lancashire','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('Wyre Forest', 'West Midlands','Central')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('York', 'Yorkshire and the Humber','North')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('London', 'London','London and the South East')
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) Values('South West', 'South West','South')



COMMIT TRANSACTION
END

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
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'LoadNatAppSerLookupData',
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