create or alter view onb.vw_EmployeeWorking as
select
    ID as ID_Employee,
    case
        when
            isnull(DateEmployment, getdate()) <= getdate()
            and getdate() -1  < isnull(DateDismissal, '2100-01-01')
        then cast(1 as bit)
        else cast(0 as bit)
    end as FlagWorking
from onb.Employee