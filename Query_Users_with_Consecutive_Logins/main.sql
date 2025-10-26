# input the data

drop table if exists  `register_tb` ; 
CREATE TABLE `register_tb` (
`user_id` int(11) NOT NULL,
`reg_time` datetime NOT NULL,
`reg_port` varchar(8) NOT NULL,
PRIMARY KEY (`user_id`));
INSERT INTO register_tb VALUES(1101,'2022-02-08 07:23:15','pc');
INSERT INTO register_tb VALUES(1102,'2022-02-08 09:12:22','app');
INSERT INTO register_tb VALUES(1103,'2022-02-08 09:35:45','m');
INSERT INTO register_tb VALUES(1104,'2022-02-08 09:41:01','app');
INSERT INTO register_tb VALUES(1105,'2022-02-08 12:01:01','app');
INSERT INTO register_tb VALUES(1106,'2022-02-08 17:22:13','app');
INSERT INTO register_tb VALUES(1107,'2022-02-08 18:26:21','pc');
INSERT INTO register_tb VALUES(1108,'2022-02-08 19:16:21','pc');
INSERT INTO register_tb VALUES(1109,'2022-02-08 19:56:21','pc');

drop table if exists  `login_tb` ;   
CREATE TABLE `login_tb` (
`log_id` int(11) NOT NULL,
`user_id` int(11) NOT NULL,
`log_time` datetime NOT NULL,
`log_port` varchar(8) NOT NULL,
PRIMARY KEY (`log_id`));
INSERT INTO login_tb VALUES(101,1101,'2022-02-09 07:24:15','pc');
INSERT INTO login_tb VALUES(102,1102,'2022-02-09 09:12:57','app');
INSERT INTO login_tb VALUES(103,1003,'2022-02-09 09:36:11','m');
INSERT INTO login_tb VALUES(104,1102,'2022-02-10 09:37:01','app');
INSERT INTO login_tb VALUES(105,1104,'2022-02-10 12:01:46','app');
INSERT INTO login_tb VALUES(106,1106,'2022-02-10 10:23:01','app');
INSERT INTO login_tb VALUES(107,1003,'2022-02-10 10:43:01','m');
INSERT INTO login_tb VALUES(108,1102,'2022-02-11 11:56:47','app');
INSERT INTO login_tb VALUES(109,1104,'2022-02-11 14:52:37','app');
INSERT INTO login_tb VALUES(1010,1106,'2022-02-11 16:56:27','app');
INSERT INTO login_tb VALUES(1011,1003,'2022-02-11 17:43:01','m');
INSERT INTO login_tb VALUES(1012,1106,'2022-02-12 10:56:17','app');


# process the data

WITH user_login AS (
    SELECT 
        user_id,
        DATE(log_time) AS log_date
    FROM login_tb
    WHERE user_id IN (SELECT user_id FROM register_tb)
    GROUP BY user_id, DATE(log_time)   
),


login_with_rn AS (
    SELECT
        user_id,
        log_date,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY log_date) AS rn
    FROM user_login
),


login_grouped AS (
    SELECT
        user_id,
        MIN(log_date) AS start_date,
        MAX(log_date) AS end_date,
        COUNT(*) AS consecutive_days
    FROM login_with_rn
    GROUP BY user_id, DATE_SUB(log_date, INTERVAL rn DAY)
)


SELECT *
FROM login_grouped
WHERE consecutive_days >= 30
ORDER BY user_id;
