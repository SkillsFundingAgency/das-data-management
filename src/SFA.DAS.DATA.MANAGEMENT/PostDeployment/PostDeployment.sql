--REVOKE UNMASK TO [Himabindu.Uddaraju@citizenazuresfabisgov.onmicrosoft.com]

--if exists (select * from sys.objects where name = 'Stg_FIC_Feedback' and type = 'u')
--DROP TABLE dbo.Stg_FIC_Feedback

EXEC dbo.USP_UnitTest1_CheckCounts


  alter table dbo.stg_fiu_feedback
  add Created_Date date default(getdate())