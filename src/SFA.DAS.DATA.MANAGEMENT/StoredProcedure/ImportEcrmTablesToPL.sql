CREATE PROCEDURE [dbo].[ImportEcrmTablesToPL]
(
   @RunId int
)
AS

-- ==================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 20/07/2021
-- Description: Import ECRM Tables to PL
-- ==================================================================

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
	   ,'Step-6'
	   ,'ImportEcrmTablesToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportEcrmTablesToPL'
     AND RunId=@RunID

IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION

DELETE FROM ASData_PL.ECRM_CONTACT

INSERT INTO ASData_PL.ECRM_CONTACT
([contactid] 
      ,[parentaccountid] 
      ,[parentaccountidname]
      ,[parentaccountidtype]
	  ,[accountid]
      ,[accountidname]
      ,[salutation]
	  ,[firstname]
	  ,[middlename]
	  ,[lastname]
	  ,[fullname]
	  ,[nickname]
	  ,[jobtitle]
	  ,[createdon]
	  ,[emailaddress1]
      ,[emailaddress2]
      ,[emailaddress3]
	  ,[donotbulkemail]
      ,[donotbulkpostalmail]
      ,[donotemail]
      ,[donotfax]
      ,[donotphone]
      ,[donotpostalmail]
      ,[donotsendmm]
      ,[msdyn_gdproptout]
      ,[msdyn_orgchangestatus]
      ,[preferredcontactmethodcode]
      ,[PreferredContactMethodValue]
      ,[accountrolecode]
      ,[company]
      ,[customertypecode]
      ,[department]
	  ,[employeeid]
      ,[followemail]
      ,[isautocreate]
      ,[isbackofficecustomer]
      ,[isprivate]
      ,[lastonholdtime]
      ,[lastusedincampaign]
      ,[lsc_navmsregistered]
      ,[lsc_uniquelearnernumber]
      ,[marketingonly]
      ,[mastercontactidname]
      ,[masterid]
      ,[merged]
      ,[modifiedon]
      ,[onholdtime]
      ,[originatingleadid]
      ,[originatingleadidname]
      ,[overriddencreatedon]
      ,[ownerid]
      ,[owneridname]
      ,[owneridtype] 
      ,[parentcontactid]
      ,[parentcontactidname]
      ,[participatesinworkflow]
      ,[preferredserviceid]
      ,[preferredserviceidname]
      ,[processid]
      ,[sfa_unknowemail]
      ,[stageid]
      ,[statecode]
      ,[statecodevalue]
      ,[statuscode]
      ,[statuscodevalue]
    )
SELECT [contactid] 
      ,[parentcustomerid] as [parentaccountid] 
      ,[parentcustomeridname] as [parentaccountidname]
      ,pctd.[value] as [parentaccountidtype]
	  ,[accountid]
      ,[accountidname]
      ,[salutation]
	  ,[firstname]
	  ,[middlename]
	  ,[lastname]
	  ,[fullname]
	  ,[nickname]
	  ,[jobtitle]
	  ,[createdon]
	  ,[emailaddress1]
      ,[emailaddress2]
      ,[emailaddress3]
	  ,[donotbulkemail]
      ,[donotbulkpostalmail]
      ,[donotemail]
      ,[donotfax]
      ,[donotphone]
      ,[donotpostalmail]
      ,[donotsendmm]
      ,[msdyn_gdproptout]
      ,[msdyn_orgchangestatus]
      ,[preferredcontactmethodcode]
      ,pcmc.[value] as [PreferredContactMethodValue]
      ,parc.[value] as [accountrolecode]
      ,[company]
      ,ctc.[value] as [customertypecode]
      ,[department]
	  ,[employeeid]
      ,[followemail]
      ,[isautocreate]
      ,[isbackofficecustomer]
      ,[isprivate]
      ,[lastonholdtime]
      ,[lastusedincampaign]
      ,[lsc_navmsregistered]
      ,[lsc_uniquelearnernumber]
      ,[marketingonly]
      ,[mastercontactidname]
      ,[masterid]
      ,[merged]
      ,[modifiedon]
      ,[onholdtime]
      ,[originatingleadid]
      ,[originatingleadidname]
      ,[overriddencreatedon]
      ,[ownerid]
      ,[owneridname]
      ,[owneridtype] 
      ,[parentcontactid]
      ,[parentcontactidname]
      ,[participatesinworkflow]
      ,[preferredserviceid]
      ,[preferredserviceidname]
      ,[processid]
      ,[sfa_unknowemail]
      ,[stageid]
      ,[statecode]
      ,sc.[value] as [statecodevalue]
      ,[statuscode]
      ,stc.[value] as [statuscodevalue]
FROM Stg.Ecrm_Contact c
LEFT
JOIN Stg.Ecrm_Lookup PCTD
  ON pctd.attributevalue=c.parentcustomeridtype
 and pctd.attributename='customertypecode'
 and pctd.objecttypecode='contact'
 LEFT
JOIN Stg.Ecrm_Lookup PCmc
  ON pcmc.attributevalue=c.[preferredcontactmethodcode]
 and pcmc.attributename='preferredcontactmethodcode'
 and pcmc.objecttypecode='contact'
  LEFT
JOIN Stg.Ecrm_Lookup Parc
  ON parc.attributevalue=c.accountrolecode
 and parc.attributename='accountrolecode'
 and parc.objecttypecode='contact'
   LEFT
JOIN Stg.Ecrm_Lookup ctc
  ON ctc.attributevalue=c.customertypecode
 and ctc.attributename='customertypecode'
 and ctc.objecttypecode='contact'
    LEFT
JOIN Stg.Ecrm_Lookup lsc
  ON lsc.attributevalue=c.leadsourcecode
 and lsc.attributename='leadsourcecode'
 and lsc.objecttypecode='contact'
     LEFT
JOIN Stg.Ecrm_Lookup sc
  ON sc.attributevalue=c.statecode
 and sc.attributename='statecode'
 and sc.objecttypecode='contact'
      LEFT
JOIN Stg.Ecrm_Lookup stc
  ON stc.attributevalue=c.statuscode
 and stc.attributename='statuscode'
 and stc.objecttypecode='contact'
 
 
 
 DELETE FROM ASData_PL.Ecrm_Account

 INSERT INTO ASData_PL.Ecrm_Account
 (
	   [accountid]
	  ,[name]
      ,[accountnumber]
	  ,[accountcategorycode]
	  ,[accountcategorycodevalue]
      ,[createdon]
      ,[customertypecode]
	  ,[customertypecodevalue]
      ,[donotbulkemail]
      ,[donotbulkpostalmail]
      ,[donotemail]
      ,[donotfax]
      ,[donotphone]
      ,[donotpostalmail]
      ,[donotsendmm]
      ,[emailaddress1]
      ,[emailaddress2]
      ,[emailaddress3]
	  ,[preferredcontactmethodcode]
	  ,[preferredcontactmethodvalue]
      ,[followemail]
      ,[importsequencenumber]
      ,[industrycode]
	  ,[industrycodevalue]
	  ,[sfa_employertype]
	  ,[sfa_employertypevalue]
	  ,[sfa_providertype]
	  ,[sfa_providertypevalue]
	  ,[sfa_intermediarytype]
	  ,[sfa_intermediaryvalue]
	  ,[sfa_tleveltype]
	  ,[sfa_tleveltypevalue]
      ,[isprivate]
      ,[lastonholdtime]
      ,[lastusedincampaign]
      ,[lsc_divisionid]
      ,[lsc_divisionidname]
      ,[lsc_learningproviderstatus]
      ,[lsc_managingproviderid]
	  ,[lsc_managingprovideridname]
      ,[lsc_navmsregistered]
      ,[lsc_noofemployees]
      ,[lsc_uniquelearnerprovidernumber]
      ,[lsc_urn]
      ,[lsc_urnstatus]
	  ,[lsc_urnstatusvalue]
      ,[marketingonly]
      ,[masteraccountidname]
      ,[masterid]
      ,[merged]
      ,[modifiedon]
      ,[numberofemployees]
      ,[onholdtime]
      ,[originatingleadid]
      ,[originatingleadidname]
      ,[ownerid]
	  ,[owneridname]
      ,[parentaccountid]
	  ,[parentaccountidname]
	  ,[sfa_automatedmarketingconsent]
	  ,[sfa_employerrelationship]
	  ,[sfa_employerapprenticeshipstatus]
	  ,[sfa_channelsource]
	  ,[sfa_couldtakepartinbamediversityhubs]
	  ,[sfa_couldtakepartinraisingvalueofapprenticesh]
	  ,[sfa_commsdate]
	  ,[sfa_datadigitalengagement]
	  ,[sfa_disabilitypart]
	  ,[sfa_employersegmentation]
	  ,[sfa_levelofengagement]
	  ,[sfa_levelofengagementvalue]
	  ,[sfa_tlevelstatusname]
      ,[statecode]
	  ,[statecodevalue]
	  ,[statuscode]
	  ,[statuscodevalue]
      ,[primarycontactid]
      ,[primarycontactidname]
    )
SELECT [accountid]
	  ,[name]
      ,[accountnumber]
	  ,[accountcategorycode]
	  ,acc.[value] as [accountcategorycodevalue]
      ,[createdon]
      ,[customertypecode]
	  ,ctc.[value] as [customertypecodevalue]
      ,[donotbulkemail]
      ,[donotbulkpostalmail]
      ,[donotemail]
      ,[donotfax]
      ,[donotphone]
      ,[donotpostalmail]
      ,[donotsendmm]
      ,[emailaddress1]
      ,[emailaddress2]
      ,[emailaddress3]
	  ,[preferredcontactmethodcode]
	  ,pcmc.[value] as [preferredcontactmethodvalue]
      ,[followemail]
      ,[importsequencenumber]
      ,[industrycode]
	  ,ic.[value] as [industrycodevalue]
	  ,[sfa_employertype]
	  ,et.[value] as [sfa_employertypevalue]
	  ,[sfa_providertype]
	  ,pt.[value] as [sfa_providertypevalue]
	  ,[sfa_intermediarytype]
	  ,it.[value] as [sfa_intermediaryvalue]
	  ,[sfa_tleveltype]
	  ,tt.[value] as [sfa_tleveltypevalue]
      ,[isprivate]
      ,[lastonholdtime]
      ,[lastusedincampaign]
      ,[lsc_divisionid]
      ,[lsc_divisionidname]
      ,[lsc_learningproviderstatus]
      ,[lsc_managingproviderid]
	  ,[lsc_managingprovideridname]
      ,[lsc_navmsregistered]
      ,[lsc_noofemployees]
      ,[lsc_uniquelearnerprovidernumber]
      ,[lsc_urn]
      ,[lsc_urnstatus]
	  ,us.[value] as [lsc_urnstatusvalue]
      ,[marketingonly]
      ,[masteraccountidname]
      ,[masterid]
      ,[merged]
      ,[modifiedon]
      ,[numberofemployees]
      ,[onholdtime]
      ,[originatingleadid]
      ,[originatingleadidname]
      ,[ownerid]
	  ,[owneridname]
      ,[parentaccountid]
	  ,[parentaccountidname]
	  ,[sfa_automatedmarketingconsent]
	  ,er.[value] as [sfa_employerrelationship]
	  ,eas.[value] as [sfa_employerapprenticeshipstatus]
	  ,scs.[value] as [sfa_channelsource]
	  ,[sfa_couldtakepartinbamediversityhubs]
	  ,[sfa_couldtakepartinraisingvalueofapprenticesh]
	  ,[sfa_commsdate]
	  ,[sfa_datadigitalengagement]
	  ,[sfa_disabilitypart]
	  ,es.[value] as [sfa_employersegmentation]
	  ,[sfa_levelofengagement]
	  ,loe.[value] as [sfa_levelofengagementvalue]
	  ,[sfa_tlevelstatusname]
      ,[statecode]
	  ,sc.[value] as [statecodevalue]
	  ,[statuscode]
	  ,stc.[value] as [statuscodevalue]
      ,[primarycontactid]
      ,[primarycontactidname]
 FROM Stg.Ecrm_Account EA
 LEFT
 JOIN Stg.Ecrm_Lookup acc
   ON acc.attributevalue=EA.accountcategorycode
  and acc.attributename='accountcategorycode'
  and acc.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup ctc
   ON ctc.attributevalue=EA.customertypecode
  and ctc.attributename='customertypecode'
  and ctc.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup pcmc
   ON pcmc.attributevalue=EA.preferredcontactmethodcode
  and pcmc.attributename='preferredcontactmethodcode'
  and pcmc.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup ic
   ON ic.attributevalue=EA.industrycode
  and ic.attributename='industrycode'
  and ic.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup et
   ON et.attributevalue=EA.sfa_employertype
  and et.attributename='sfa_employertype'
  and et.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup pt
   ON pt.attributevalue=EA.sfa_providertype
  and pt.attributename='sfa_providertype'
  and pt.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup it
   ON it.attributevalue=EA.sfa_intermediarytype
  and it.attributename='sfa_intermediarytype'
  and it.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup tt
   ON tt.attributevalue=EA.sfa_tleveltype
  and tt.attributename='sfa_tleveltype'
  and tt.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup us
   ON us.attributevalue=EA.lsc_urnstatus
  and us.attributename='lsc_urnstatus'
  and us.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup er
   ON er.attributevalue=EA.sfa_employerrelationship
  and er.attributename='sfa_employerrelationship'
  and er.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup eas
   ON eas.attributevalue=EA.sfa_employerapprenticeshipstatus
  and eas.attributename='sfa_employerapprenticeshipstatus'
  and eas.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup scs
   ON scs.attributevalue=EA.sfa_channelsource
  and scs.attributename='sfa_channelsource'
  and scs.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup es
   ON es.attributevalue=EA.sfa_employersegmentation
  and es.attributename='sfa_employersegmentation'
  and es.objecttypecode='account'
 LEFT
 JOIN Stg.Ecrm_Lookup loe
   ON loe.attributevalue=EA.sfa_levelofengagement
  and loe.attributename='sfa_levelofengagement'
  and loe.objecttypecode='account'
LEFT
JOIN Stg.Ecrm_Lookup sc
  ON sc.attributevalue=ea.statecode
 and sc.attributename='statecode'
 and sc.objecttypecode='account'
LEFT
JOIN Stg.Ecrm_Lookup stc
  ON stc.attributevalue=ea.statuscode
 and stc.attributename='statuscode'
 and stc.objecttypecode='account'




COMMIT TRANSACTION
END
 


 /* Update Log Execution Results as Success if the query ran succesfully*/

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
	    'ImportEcrmTablesToPL',
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
