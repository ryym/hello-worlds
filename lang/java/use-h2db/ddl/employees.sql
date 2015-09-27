create table employees (
  employee_code char(8) not null
  , employee_name nvarchar(30) not null
  , department_code char(6) not null
  , age int not null
  , gender char(1) not null
  , primary key (employee_code)
);
