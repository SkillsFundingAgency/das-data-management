CREATE VIEW [AsData_AI].[DAS_M]
	AS 
SELECT  distinct 
       mla.leadid                                        AS G1
      ,mla.MarketoGUID                                   AS G2 
	  ,mat.ActivityTypeId                                AS G3
      ,case when [PrimaryLink] like '%_ApplyNow%'  then 1
            when  [PrimaryLink] like '%gov.uk/employer%' then 1
            when [Link] like '%_cta%'then '1' else '0' 
	    end                                              AS G4
	  ,Case when mla.[ActivityTypeId] in (1,3,10,11)    then 1 else 0     end as G5
	  ,mp.ProgramId                                      as G6
	  ,msc.SmartCampaignId                               as G7
	  ,COALESCE(aa.Id,-1)                                as G8
	  ,pesd.Emailsentdate                                as G9
FROM   asdata_pl.MarketoLeadActivities mla      
left 
JOIN   ASData_PL.MarketoActivityTypes mat       
ON     mla.ActivityTypeId = mat.ActivityTypeId
left 
JOIN   ASData_PL.MarketoSmartCampaigns msc      
ON     mla.CampaignId = msc.SmartCampaignId
left
JOIN   ASData_PL.MarketoPrograms MP     
ON     Mp.ProgramId = msc.ParentProgramId
left 
join   [ASData_PL].[MarketoLeadActivityLinkClicked] as mlac 
  on   mla.MarketoGUID=mlac.MarketoGUID and mla.leadid=mlac.leadid
left   
join   ASData_PL.MarketoLeads ml
  on   ml.LeadId=mla.LeadId
left 
join    ASData_PL.Acc_User au
  on    ml.EmailAddress=au.Email
left 
join   ASData_PL.Acc_UserAccountSettings auas
  on   auas.ID=au.Id
left
join   ASData_PL.Acc_Account aa
  on   auas.AccountId=aa.Id
left
join  (Select                            	
             mp.programid
            ,min(cast(activitydate as date)) as Emailsentdate
        from asdata_pl.MarketoLeadActivities mla  with (nolock)
        left outer JOIN     ASData_PL.MarketoSmartCampaigns msc      
          ON           mla.CampaignId = msc.SmartCampaignId
        left outer JOIN     ASData_PL.MarketoPrograms MP      
          ON           Mp.ProgramId = msc.ParentProgramId
       where mla.activitytypeID =6
         and programtype='Email'
         and programname like 'MA%'
       group by mp.programid ) PESD
   on PESD.ProgramId=mp.ProgramId 
where
    programtype='Email'
and programname like 'MA%'
and mla.activitytypeid <=11
and mla.activitytypeid <>2
and programname not like '%Sandbox%'

