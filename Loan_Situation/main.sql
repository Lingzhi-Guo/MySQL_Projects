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

WITH t1 AS (
    SELECT
        c.city,
        SUM(la.loan_amount) AS total_loan_amount,
        round(SUM(la.loan_amount) / COUNT(DISTINCT la.customer_id), 2) AS average_loan_amount,
        COUNT(DISTINCT la.customer_id) AS total_customers
    FROM loan_applications AS la
    LEFT JOIN customers AS c ON c.customer_id = la.customer_id
    LEFT JOIN loan_application_types AS lat ON lat.application_id = la.application_id
    LEFT JOIN loan_types AS lt ON lt.loan_type_id = lat.loan_type_id
    GROUP BY c.city
),
t2 AS (
    SELECT
        c.city,
        lt.loan_type_name,
        COUNT(*) AS loan_type_count,
        rank () OVER (PARTITION BY c.city ORDER BY COUNT(*) DESC) AS rn
    FROM loan_applications AS la
    LEFT JOIN customers AS c ON c.customer_id = la.customer_id
    LEFT JOIN loan_application_types AS lat ON lat.application_id = la.application_id
    LEFT JOIN loan_types AS lt ON lt.loan_type_id = lat.loan_type_id
    GROUP BY c.city, lt.loan_type_name
)
SELECT
    t1.city,
    t1.total_loan_amount,
    t1.average_loan_amount,
    t1.total_customers,
    t2.loan_type_name AS most_applied_loan_type
FROM t1
LEFT JOIN t2 ON t1.city = t2.city
WHERE t2.rn = 1
ORDER BY t1.city;
