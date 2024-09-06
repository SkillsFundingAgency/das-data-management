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
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Allerdale', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Amber Valley', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Arun', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Ashfield', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Ashford', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Babergh', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Barnet', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Barnsley', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Barrow in Furness', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Basildon', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Basingstoke and Deane', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bassetlaw', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bath and North East Somerset', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bedford', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bexley', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Birmingham', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Blaby', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Blackburn with Darwen', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bolsover', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bolton', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Boston', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bournemouth  Christchurch and Poole', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bracknell Forest', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bradford', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Braintree', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Breckland', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Brent', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Brentwood', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Brighton and Hove', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bristol, City of', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bromley', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bromsgrove', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Broxbourne', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Broxtowe', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Buckinghamshire', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Burnley', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Bury', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Calderdale', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Cambridge', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Camden', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Canterbury', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Carlisle', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Castle Point', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Central Bedfordshire', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Charnwood', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Chelmsford', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Cheltenham', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Cherwell', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Cheshire East', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Cheshire West and Chester', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Chesterfield', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Chichester', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Chorley', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('City of London', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Colchester', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Cornwall', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('County Durham', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Coventry', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Craven', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Crawley', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Croydon', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Cumberland', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Dacorum', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Darlington', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Dartford', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Derby', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Derbyshire Dales', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Doncaster', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Dorset', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Dudley', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Ealing', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('East Cambridgeshire', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('East Hampshire', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('East Hertfordshire', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('East Lindsey', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('East Riding of Yorkshire', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('East Staffordshire', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('East Suffolk', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Eastbourne', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Eastleigh', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Elmbridge', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Enfield', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Epping Forest', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Epsom and Ewell', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Erewash', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Exeter', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Fareham', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Folkestone and Hythe', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Forest of Dean', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Gateshead', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Gedling', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Gloucester', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Gosport', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Greenwich', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Guildford', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hackney', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Halton', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hambleton', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hammersmith and Fulham', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Harborough', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Haringey', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Harlow', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Harrogate', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Harrow', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hart', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hartlepool', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hastings', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Havant', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Havering', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Herefordshire County of', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hertsmere', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hillingdon', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Horsham', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hounslow', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Huntingdonshire', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hyndburn', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Ipswich', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Isle of Wight', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Islington', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Kensington and Chelsea', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Kings Lynn and West Norfolk', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Kingston upon Hull  City of', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Kingston upon Thames', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Kirklees', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Knowsley', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Lambeth', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Lancaster', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Leeds', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Leicester', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Lewes', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Lewisham', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Lichfield', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Lincoln', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Liverpool', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Luton', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Maidstone', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Maldon', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Manchester', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Medway', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Melton', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Mendip', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Merton', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Mid Devon', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Mid Sussex', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Middlesbrough', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Milton Keynes', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Mole Valley', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('New Forest', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Newark and Sherwood', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Newcastle under Lyme', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Newcastle upon Tyne', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Newham', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North East Derbyshire', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North East Lincolnshire', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North Hertfordshire', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North Kesteven', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North Lincolnshire', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North Northamptonshire', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North Somerset', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North Tyneside', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North Warwickshire', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North West Leicestershire', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North Yorkshire', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Northumberland', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Norwich', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Nottingham', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Nuneaton and Bedworth', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Oadby and Wigston', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Oldham', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Oxford', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Pendle', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Peterborough', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Plymouth', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Portsmouth', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Preston', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Reading', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Redbridge', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Redcar and Cleveland', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Redditch', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Reigate and Banstead', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Richmond upon Thames', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Richmondshire', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Rochdale', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Rochford', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Rossendale', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Rother', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Rotherham', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Rugby', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Runnymede', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Rushcliffe', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Rushmoor', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Rutland', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Salford', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Sandwell', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Sedgemoor', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Sefton', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Selby', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Sevenoaks', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Sheffield', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Shropshire', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Slough', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Solihull', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Somerset West and Taunton', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Cambridgeshire', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Derbyshire', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Gloucestershire', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Hams', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Holland', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Kesteven', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Lakeland', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Norfolk', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Oxfordshire', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Ribble', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Staffordshire', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Tyneside', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Southampton', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Southend on Sea', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Southwark', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Spelthorne', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('St. Albans District (B)', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('St. Helens', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Stafford', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Staffordshire Moorlands', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Stevenage', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Stockport', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Stockton on Tees', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Stoke on Trent', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Stratford on Avon', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Stroud', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Sunderland', 'North East', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Surrey Heath', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Sutton', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Swale', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Swindon', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Tameside', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Tandridge', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Teignbridge', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Telford and Wrekin', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Tendring', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Test Valley', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Tewkesbury', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Thanet', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Three Rivers', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Thurrock', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Tonbridge and Malling', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Torbay', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Tower Hamlets', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Trafford', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Tunbridge Wells', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Uttlesford', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Vale of White Horse', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wakefield', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Walsall', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Waltham Forest', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wandsworth', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Warrington', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Warwick', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Watford', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Waverley', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wealden', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Welwyn Hatfield District (B)', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('West Berkshire', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('West Devon', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('West Lancashire', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Westmorland and Furness', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('West Northamptonshire', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('West Suffolk', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Westminster', 'London', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wigan', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wiltshire', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Winchester', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Windsor and Maidenhead', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wirral', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Woking', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wokingham', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wolverhampton', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Worcester', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Worthing', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wychavon', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wyre', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Wyre Forest', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('York', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Broadland', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Cannock Chase', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Dover', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Adur', 'South Central', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Blackpool', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Copeland', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Cotswold', 'Thames Valley', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('East Devon', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Eden', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Fenland', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Fylde', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Gravesham', 'South East', 'London and the South East');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Great Yarmouth', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('High Peak', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Hinckley and Bosworth', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Malvern Hills', 'West Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Mansfield', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Mid Suffolk', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Monmouthshire', 'Not Applicable/ Not Known', 'Not App/ Not Known');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Newport', 'Not Applicable/ Not Known', 'Not App/ Not Known');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North Devon', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('North Norfolk', 'Central Eastern', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Ribble Valley', 'Liverpool City Region  Cumbria and Lancashire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Ryedale', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Scarborough', 'Yorkshire and the Humber', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('South Somerset', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Tamworth', 'Greater Manchester  Cheshire/Warrington and Staffordshire', 'North');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('Torridge', 'South West', 'South');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('West Lindsey', 'East Midlands', 'Central');
INSERT INTO [lkp].[NatAppSerLookupData] ([Pst_LOCAL_AUTHO_Desc] ,  [National_Apprenticeship_Service_Area] , [National_Apprenticeship_Service_Division]) VALUES ('West Oxfordshire', 'Thames Valley', 'South');


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