USE [payroll_service]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateEmployeeSalary]    Script Date: 09-06-2021 16:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[spUpdateEmployeeSalary]
@id int,
@month varchar(20),
@salary int,
@EmpId int
as
BEGIN
--below line will cause transaction uncommitable if constraint violation occur
set XACT_ABORT on;
begin try
begin TRANSACTION;
update SALARY
set EMPSAL=@salary
where SALARYId=@id and SALARYMONTH=@month and EmpId=@EmpId;
select e.EmpId,e.ENAME,s.EMPSAL,s.SALARYMONTH,s.SALARYId
from Employee1 e inner join SALARY s
ON e.EmpId=s.EmpId where s.SALARYId=@id;
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
select ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
IF(XACT_STATE())=-1
BEGIN
  PRINT N'The transaction is in an uncommitable state.'+'Rolling back transaction.'
  ROLLBACK TRANSACTION;
  END;

  IF(XACT_STATE())=1
  BEGIN
    PRINT 
	    N'The transaction is committable. '+'Committing transaction.'
       COMMIT TRANSACTION;
	END;
	END CATCH
END