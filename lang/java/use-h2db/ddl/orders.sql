create table orders (
  order_id int identity not null
  , order_date datetime not null
  , total_price decimal(6, 0) not null
  , customer_code char(6) not null
  , employee_code char(8) not null
  , primary key (order_id)
);
