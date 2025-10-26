# input the data

DROP TABLE IF EXISTS merchants_underline;
DROP TABLE IF EXISTS sales_underline;
DROP TABLE IF EXISTS refunds_underline;
DROP TABLE IF EXISTS satisfaction_underline;

CREATE TABLE merchants_underline (
    merchant_id INT PRIMARY KEY,
    merchant_name VARCHAR(50),
    industry VARCHAR(20)
);

CREATE TABLE sales_underline (
    sale_id INT PRIMARY KEY,
    merchant_id INT,
    sale_amount DECIMAL(10, 2)
);

CREATE TABLE refunds_underline (
    refund_id INT PRIMARY KEY,
    merchant_id INT,
    refund_amount DECIMAL(10, 2)
);

CREATE TABLE satisfaction_underline (
    satisfaction_id INT PRIMARY KEY,
    merchant_id INT,
    satisfaction_score INT
);

-- 插入数据
INSERT INTO merchants_underline (merchant_id, merchant_name, industry)
VALUES (1, '商家 A', '服装'),
       (2, '商家 B', '电子产品');

INSERT INTO sales_underline (sale_id, merchant_id, sale_amount)
VALUES (1, 1, 5000.00),
       (2, 2, 8000.00),
       (3, 1, 4000.00),
       (4, 2, 6000.00);

INSERT INTO refunds_underline (refund_id, merchant_id, refund_amount)
VALUES (1, 1, 1000.00),
       (2, 2, 1500.00);

INSERT INTO satisfaction_underline (satisfaction_id, merchant_id, satisfaction_score)
VALUES (1, 1, 80),
       (2, 2, 90),
       (3, 1, 70),
       (4, 2, 60);


select * from merchants_underline;
select * from sales_underline;
select * from refunds_underline;
select * from satisfaction_underline;


# process the data
with total_sales as(
    select 
    merchant_id,
    sum(sale_amount) as total_sales_amount
    from sales_underline
    group by merchant_id
),
total_refund as(
    select 
    merchant_id,
    sum(refund_amount) as total_refund_amount
    from refunds_underline
    group by merchant_id
),
satisfaction as(
    select
    merchant_id,
    round(avg(satisfaction_score), 2) as average_satisfaction_score
    from satisfaction_underline
    group by merchant_id
)

select
mu.merchant_id,
mu.merchant_name,
ts.total_sales_amount,
tr.total_refund_amount,
s.average_satisfaction_score
from merchants_underline as mu
left join total_sales as ts
on ts.merchant_id = mu.merchant_id
left join total_refund as tr
on tr.merchant_id = mu.merchant_id
left join satisfaction as s
on s.merchant_id = mu.merchant_id
order by mu.merchant_id asc

