# input the data

drop table if exists products;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(255)
);

INSERT INTO products (product_id, name, category)
VALUES
    (1, 'Product A', 'Category 1'),
    (2, 'Product B', 'Category 1'),
    (3, 'Product C', 'Category 2'),
    (4, 'Product D', 'Category 2'),
    (5, 'Product E', 'Category 3');


drop table if exists orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    order_date DATE
);

INSERT INTO orders (order_id, product_id, quantity, order_date)
VALUES
    (101, 1, 5, '2023-08-01'),
    (102, 2, 3, '2023-08-01'),
    (103, 3, 8, '2023-08-02'),
    (104, 4, 10, '2023-08-02'),
    (105, 5, 15, '2023-08-03'),
    (106, 1, 7, '2023-08-03'),
    (107, 2, 4, '2023-08-04'),
    (108, 3, 6, '2023-08-04'),
    (109, 4, 12, '2023-08-05'),
    (110, 5, 9, '2023-08-05');

# process the data

select
products.name as product_name,
sum(orders.quantity) as total_sales,
row_number() over(partition by products.category order by products.category, sum(quantity) desc) as category_rank
from orders
join products on products.product_id = orders.product_id
group by orders.product_id 
order by products.category asc, total_sales desc