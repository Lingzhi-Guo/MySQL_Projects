# input the data needed 

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product;

CREATE TABLE product (
  product_id INT PRIMARY KEY,
  category VARCHAR(32) NOT NULL,
  price DECIMAL(10,2) NOT NULL
);
CREATE TABLE orders (
  order_id BIGINT PRIMARY KEY,
  buyer_id INT NOT NULL,
  order_date DATE NOT NULL
);
CREATE TABLE order_items (
  order_id BIGINT NOT NULL,
  product_id INT NOT NULL,
  qty INT NOT NULL
);

INSERT INTO product VALUES
(1,'Electronics',500.00),
(2,'Books',50.00),
(3,'Electronics',1200.00),
(4,'Toys',30.00),
(5,'Books',80.00);

INSERT INTO orders VALUES
(101,1,'2024-08-03'),
(102,2,'2024-08-05'),
(103,1,'2024-08-20'),
(104,3,'2024-07-30'),  -- 非目标月
(105,4,'2024-08-31'),
(106,2,'2024-09-01');  -- 非目标月

INSERT INTO order_items VALUES
(101,1,1),(101,2,2),     -- 500 + 100
(102,3,1),               -- 1200
(103,2,1),(103,4,3),     -- 50 + 90
(104,5,1),               -- 非目标月
(105,4,10),(105,1,1),    -- 300 + 500
(106,2,1);               -- 非目标月




# process the data

with main_data as(
select
product.category, 
count(distinct orders.order_id) as orders_cnt,
count(distinct orders.buyer_id) as buyers_cnt,
sum(order_items.qty) as items_qty,
sum(order_items.qty * product.price) as revenue,
round(sum(order_items.qty * product.price) / count(distinct orders.order_id), 2) as avg_order_value
from order_items
left join orders on orders.order_id = order_items.order_id
left join product on product.product_id = order_items.product_id
where orders.order_date between '2024-08-01' and '2024-08-31'
group by product.category
)

select *,
rank() over(order by revenue desc, orders_cnt desc, category asc) as rank_by_revenue
from main_data
order by revenue desc, orders_cnt desc, category asc

