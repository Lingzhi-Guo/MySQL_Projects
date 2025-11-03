-- input the data

CREATE TABLE loan_applications (
    application_id INT PRIMARY KEY,
    customer_id INT,
    loan_amount DECIMAL(10, 2),
    application_date DATE
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    age INT
);

CREATE TABLE loan_types (
    loan_type_id INT PRIMARY KEY,
    loan_type_name VARCHAR(50)
);

CREATE TABLE loan_application_types (
    application_id INT,
    loan_type_id INT,
    PRIMARY KEY (application_id, loan_type_id)
);

INSERT INTO loan_applications (application_id, customer_id, loan_amount, application_date) VALUES
(1, 1, 10000.00, '2023-01-01'),
(2, 2, 15000.00, '2023-02-01'),
(3, 3, 20000.00, '2023-03-01'),
(4, 4, 25000.00, '2023-04-01'),
(5, 1, 30000.00, '2023-05-01');

INSERT INTO customers (customer_id, customer_name, city, age) VALUES
(1, 'Alice', 'New York', 30),
(2, 'Bob', 'Los Angeles', 25),
(3, 'Charlie', 'New York', 35),
(4, 'David', 'Chicago', 28);

INSERT INTO loan_types (loan_type_id, loan_type_name) VALUES
(1, 'Personal Loan'),
(2, 'Home Loan'),
(3, 'Auto Loan');

INSERT INTO loan_application_types (application_id, loan_type_id) VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 3),
(5, 2);


-- process the data

select s1.city,s1.total_loan_amount,s1.average_loan_amount,s1.total_customers,
s2.loan_type_name as most_applied_loan_type
from (
    select c.city,
    round(sum(la.loan_amount),2) as total_loan_amount,
    round(sum(la.loan_amount)/count(distinct c.customer_id),2) as average_loan_amount,
    count(distinct c.customer_id) as total_customers
    from loan_applications la
    join customers c on c.customer_id = la.customer_id
    join loan_application_types lat on lat.application_id = la.application_id
    join loan_types lt on lat.loan_type_id = lt.loan_type_id
    group by c.city
)s1
join (
        select c.city,lt.loan_type_id,lt.loan_type_name,
        rank() over(partition by c.city order by count(lat.loan_type_id) desc,lat.loan_type_id asc) as rk
        from loan_applications la
        join customers c on c.customer_id = la.customer_id
        join loan_application_types lat on lat.application_id = la.application_id
        join loan_types lt on lat.loan_type_id = lt.loan_type_id
        group by c.city,lt.loan_type_id,lt.loan_type_name
    )s2 on s2.city = s1.city
where rk = 1
