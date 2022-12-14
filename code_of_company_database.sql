USE code;
CREATE TABLE employee_data(
    name VARCHAR(20),
    gender VARCHAR(1),
    emp_id INT  PRIMARY KEY,
    birth_date DATE,
    SALARY INT,
    sup_id INT,
    branch_id INT
);
CREATE TABLE branch(
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY (mgr_id) REFERENCES employee_data(emp_id) ON DELETE SET NULL
);
ALTER TABLE employee_data 
ADD FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL;

ALTER TABLE employee_data
ADD FOREIGN KEY(sup_id) REFERENCES branch(mgr_id) ON DELETE SET NULL;

CREATE TABLE client(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);
CREATE TABLE works_with(
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY (emp_id )REFERENCES employee_data(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id )REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier(
    branch_id INT,
    supplier_name VARCHAR(40),
    supplier_type VARCHAR(20),
    PRIMARY KEY(branch_id,supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE  CASCADE
);
---------------------------------------------------------------------------------
--insertind data into the tables:
--in corporate branch
INSERT INTO employee_data VALUES('David','M',100,'1967-11-17',250000,NULL,NULL);

INSERT INTO branch VALUES(1,'Corporate',100,'2006-02-09');
UPDATE employee_data
SET branch_id =1
WHERE emp_id=100;
INSERT INTO employee_data VALUES('Jan','F',101,'1961-05-11',110000,100,1);

-- in Scraton branch
INSERT INTO employee_data VALUES('Michel','M',102,'1964-03-15',75000,100,NULL);

INSERT INTO branch VALUES(2,'Scraton',102,'1992-04-06');
UPDATE employee_data
SET branch_id=2
WHERE emp_id=102;
INSERT INTO employee_data VALUES('Angela','F',103,'1971-06-25',63000,102,2);
INSERT INTO employee_data VALUES('Kelly','F',104,'1980-02-05',65000,102,2);
INSERT INTO employee_data VALUES('Stanley','M',105,'1958-02-19',69000,102,2);

--in Stanford branch
INSERT INTO employee_data VALUES('JOSH','M',106,'1969-09-05',78000,100,NULL);
INSERT INTO branch VALUES(3,'Stanford',106,'1998-02-13');
UPDATE employee_data
SET branch_id=3
WHERE emp_id=106;
INSERT INTO employee_data VALUES('Andy','M',107,'1973-07-22',65000,106,3);
INSERT INTO employee_data VALUES('Jim','M',108,'1978-10-01',71000,106,3);

--INTO Branch_supplier TABLE
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

--into client table
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

--into works_with table
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

---------------------------------------------------------------------------
--queries:
--1. find all the employees
SELECT * FROM employee_data;

--2. find all the client 
SELECT * FROM client;

--3. find all the employees ordered by salary:
SELECT *FROM  employee_data
ORDER BY salary DESC;

--4. find all the employee by sex and then name
SELECT * FROM employee_data
ORDER BY gender ,name ;
--LIMIT 5;

--5. find out all the different genders
SELECT DISTINCT gender 
FROM employee_data;

--6. find out all the different btanch ids
SELECT  DISTINCT branch_id FROM employee_data;




--- FUNCTIONS:
--1. no. of  employee:
SELECT  COUNT(emp_id)
FROM employee_data;

--2. no. of employee having supervisor:
SELECT COUNT(sup_id)
FROM employee_data;

--3. find no. of female employees born afetr 1978
SELECT COUNT(emp_id)
FROM employee_data
WHERE gender='F'AND birth_date >'1971-01-01';

--4. find the average of all the employees:
SELECT AVG(salary)
FROM employee_data;

--------------------------
--FIND THE CLIENT WHO ARE LLC:
SELECT * FROM client 
WHERE client_name LIKE '%LLC';

--
SELECT *FROM branch_supplier
WHERE supplier_name LIKE '% Labels';




-------UNIONS:
-- display employee name and branch names:
SELECT branch_name
FROM branch
UNION
SELECT name 
FROM employee_data;

----JOINS:
--TYPES OF JOIN: INNER , LEFT , RIGTH AND (FULL OUTER JOIN)
--INNER JOIN:
INSERT INTO branch VALUES(4,'Buffalo',NULL,NULL);
SELECT employee_data.emp_id, employee_data.name,branch.branch_name
FROM employee_data
JOIN branch 
ON employee_data.emp_id  = branch.mgr_id; 

-- LEFT JOIN:
SELECT employee_data.emp_id, employee_data.name,branch.branch_name
FROM employee_data
LEFT JOIN branch 
ON employee_data.emp_id  = branch.mgr_id;

--RIGHT JOIN:
SELECT employee_data.emp_id, employee_data.name,branch.branch_name
FROM employee_data
RIGHT JOIN branch 
ON employee_data.emp_id  = branch.mgr_id;

----------------------------------------
--NESTED QUERIES:
----1: Find the names of all the employees who have sold over 30000 to a single client
SELECT employee_data.name
FROM employee_data
WHERE employee_data.emp_id IN(
    SELECT works_with.emp_id 
    FROM works_with
    WHERE works_with.total_sales>30000
);


--2: Find all the clients who are handled by the branch that Michel manages
--assume we know the michel's id
SELECT client.client_name
FROM client
WHERE client.branch_id =(
    SELECT branch.branch_id
    FROM branch
    WHERE branch.mgr_id=102
);


