CREATE VIEW [dbo].[vw_FIU_GA_Segmented_View]
	AS 

  SELECT sfgf.Feedback_Id
        ,sfgf.Campaign_Category
		--,sfgf.Campaign_Action
		,cast(sfgf.campaignenddate as date) as WeekEnding
        ,iif(right(Campaign_Action+' but not ' +lead(campaign_action,1,'') over (partition by sfgf.campaignenddate,mgh.hierarchy_grouping order by sfgf.campaignenddate,mgh.hierarchy_grouping),9)=' but not '
             ,replace(Campaign_Action+' but not ' +lead(campaign_action,1,'') over (partition by sfgf.campaignenddate,mgh.hierarchy_grouping order by sfgf.campaignenddate,mgh.hierarchy_grouping),' but not ','')
			 ,Campaign_Action+' but not ' +lead(campaign_action,1,'') over (partition by sfgf.campaignenddate,mgh.hierarchy_grouping order by sfgf.campaignenddate,mgh.hierarchy_grouping)) as Campaign_Segmentation
        ,all_users_count-lead(all_users_count,1,0) over (partition by sfgf.campaignenddate,mgh.hierarchy_grouping order by sfgf.campaignenddate,mgh.hierarchy_grouping) Users_Count
		,FIU_Referred_Users_Count-lead(FIU_Referred_Users_Count,1,0) over (partition by sfgf.campaignenddate,mgh.hierarchy_grouping order by sfgf.campaignenddate,mgh.hierarchy_grouping) FIU_Referred_Users_Count
    FROM Fdb.Stg_FIU_GA_Feedback SFGF
	JOIN Mtd.Metadata_GA_Hierarchy MGH
	  ON SFGF.Campaign_Category=MGH.Feedback_Category
	 and sfgf.Campaign_Action=mgh.Feedback_Action
