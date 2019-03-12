--REVOKE UNMASK TO [Himabindu.Uddaraju@citizenazuresfabisgov.onmicrosoft.com]

--if exists (select * from sys.objects where name = 'Stg_FIC_Feedback' and type = 'u')
--DROP TABLE dbo.Stg_FIC_Feedback

EXEC dbo.USP_UnitTest1_CheckCounts