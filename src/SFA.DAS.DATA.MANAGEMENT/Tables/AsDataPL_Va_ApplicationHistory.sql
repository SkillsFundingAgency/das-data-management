﻿CREATE TABLE [AsData_PL].[Va_ApplicationHistory]
(
	  ApplicationHistoryId int
     ,ApplicationId int
     ,ApplicationHistoryEventDate datetime
     ,ApplicationHistoryEventTypeId int
     ,ApplicationHistoryEventTypeDesc Varchar(100)
	 ,Foreign Key (ApplicationId)  References [AsData_PL].[Va_Application](ApplicationId)
)
