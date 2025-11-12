-- input the data

drop table if exists  `order_tb` ; 
CREATE TABLE `order_tb` (
`order_id` int(11) NOT NULL,
`user_id` int(11) NOT NULL,
`order_price` int(11) NOT NULL,
`order_time` datetime NOT NULL,
PRIMARY KEY (`order_id`));
INSERT INTO order_tb VALUES(101,11,380,'2022-09-01 09:00:00'); 
INSERT INTO order_tb VALUES(102,12,200,'2022-09-01 10:00:00'); 
INSERT INTO order_tb VALUES(103,13,260,'2022-09-01 12:00:00'); 
INSERT INTO order_tb VALUES(104,11,100,'2022-09-02 11:00:00'); 
INSERT INTO order_tb VALUES(105,12,150,'2022-09-02 12:00:00'); 
INSERT INTO order_tb VALUES(106,12,1200,'2022-09-02 13:00:00'); 
INSERT INTO order_tb VALUES(107,11,60,'2022-09-03 09:00:00'); 
INSERT INTO order_tb VALUES(108,13,380,'2022-09-03 09:30:00'); 

drop table if exists  `visit_tb` ; 
CREATE TABLE `visit_tb` (
`info_id` int(11) NOT NULL,
`user_id` int(11) NOT NULL,
`visit_time` datetime NOT NULL,
`leave_time` datetime NOT NULL,
PRIMARY KEY (`info_id`));
INSERT INTO visit_tb VALUES(0911,10,'2022-09-01 08:00:00','2022-09-01 09:02:00'); 
INSERT INTO visit_tb VALUES(0912,11,'2022-09-01 08:30:00','2022-09-01 09:10:00'); 
INSERT INTO visit_tb VALUES(0913,12,'2022-09-01 09:50:00','2022-09-01 10:12:00'); 
INSERT INTO visit_tb VALUES(0914,13,'2022-09-01 11:40:00','2022-09-01 12:22:00'); 
INSERT INTO visit_tb VALUES(0921,11,'2022-09-02 10:30:00','2022-09-02 11:05:00'); 
INSERT INTO visit_tb VALUES(0922,11,'2022-09-02 12:00:00','2022-09-02 12:02:00'); 
INSERT INTO visit_tb VALUES(0923,12,'2022-09-02 11:40:00','2022-09-02 13:15:00'); 
INSERT INTO visit_tb VALUES(0924,13,'2022-09-02 09:00:00','2022-09-02 09:02:00'); 
INSERT INTO visit_tb VALUES(0925,14,'2022-09-02 10:00:00','2022-09-02 10:40:00'); 
INSERT INTO visit_tb VALUES(0931,10,'2022-09-03 09:00:00','2022-09-03 09:22:00'); 
INSERT INTO visit_tb VALUES(0932,11,'2022-09-03 08:30:00','2022-09-03 09:10:00'); 
INSERT INTO visit_tb VALUES(0933,13,'2022-09-03 09:00:00','2022-09-03 09:32:00'); 


-- process the data

with daily_visits as(
    select
    date(visit_time) as visit_date,
    count(distinct user_id) as visit_num
    from visit_tb
    group by visit_date
),

daily_orders as(
    select
    date(order_time) as order_date,
    count(distinct user_id) as order_num
    from order_tb
    group by order_date
)

select
v.visit_date as date,
concat(round(coalesce(o.order_num, 0) / v.visit_num * 100, 1), '%') as cr
from daily_visits as v
left join daily_orders as o on v.visit_date = o.order_date