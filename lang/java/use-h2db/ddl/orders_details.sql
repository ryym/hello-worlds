create table orders_details (
  order_id int not null
  , seq int not null
  , product_code char(4) not null
  , product_num int not null
  , primary key (order_id,seq)
);
