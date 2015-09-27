create table customers (
  customer_code char(6) not null
  , customer_name nvarchar(80) not null
  , furigana nvarchar(160) not null
  , age int not null
  , gender smallint not null
  , zip_num char(8) not null
  , address1 nvarchar(80) not null
  , address2 nvarchar(80) not null
  , primary key (customer_code)
);
