-- Input Data

drop table if exists  `login_tb` ;   
CREATE TABLE `login_tb` (
`log_id` int(11) NOT NULL,
`user_id` int(11) NOT NULL,
`log_time` datetime NOT NULL,
PRIMARY KEY (`log_id`));
INSERT INTO login_tb VALUES(101,101,'2022-02-06 07:24:00');
INSERT INTO login_tb VALUES(102,102,'2022-02-06 07:24:00');
INSERT INTO login_tb VALUES(103,103,'2022-02-06 09:36:00');
INSERT INTO login_tb VALUES(104,102,'2022-02-07 09:37:00');
INSERT INTO login_tb VALUES(105,103,'2022-02-07 12:01:00');
INSERT INTO login_tb VALUES(106,101,'2022-02-07 12:23:00');
INSERT INTO login_tb VALUES(107,102,'2022-02-08 08:37:00');
INSERT INTO login_tb VALUES(108,103,'2022-02-09 10:43:00');
INSERT INTO login_tb VALUES(109,101,'2022-02-09 14:56:00');

drop table if exists  `user_action_tb` ;   
CREATE TABLE `user_action_tb` (
`user_id` int(11) NOT NULL,
`hobby` varchar(8) NOT NULL,
`score` int(11) NOT NULL,
PRIMARY KEY (`user_id`));
INSERT INTO user_action_tb VALUES(101,'健身',88);
INSERT INTO user_action_tb VALUES(102,'影视',81);
INSERT INTO user_action_tb VALUES(103,'美妆',78);
INSERT INTO user_action_tb VALUES(104,'健身',68);
INSERT INTO user_action_tb VALUES(105,'体育',90);
INSERT INTO user_action_tb VALUES(106,'影视',56);
INSERT INTO user_action_tb VALUES(107,'体育',89);
INSERT INTO user_action_tb VALUES(108,'影视',77);


-- Process Data


with login_date as(
    select
    user_id,
    log_time,
    DATE(log_time) as log_date
    from login_tb
),

first_login as(
    select
    user_id,
    log_date,
    dense_rank() over(partition by log_date order by log_time) as dr
    from login_date
)

select
    fl.log_date as log_day,
    fl.user_id,
    uat.hobby
from first_login as fl
left join user_action_tb as uat on uat.user_id = fl.user_id
where fl.dr = 1
order by fl.log_date asc