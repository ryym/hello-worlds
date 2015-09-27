create table products (
  product_code char(4) not null
  , product_name nvarchar(50) not null
  , price decimal(6, 0) not null
  , primary key (product_code)
);
