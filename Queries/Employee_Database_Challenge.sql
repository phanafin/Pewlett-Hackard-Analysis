-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (dept_no, emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (title, from_date),
	UNIQUE (from_date)
);

SELECT * FROM titles;
SELECT * FROM departments;
SELECT * FROM dept_emp;
DROP TABLE dept_emp
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (dept_no, emp_no)
);
SELECT * FROM dept_emp;
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (title, from_date),
	UNIQUE (from_date)
);
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (title, from_date),
	UNIQUE (emp_no)
);
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retire_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM retire_dept;

SELECT * FROM salaries

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	  AND (de.to_date = '9999-01-01');
SELECT * FROM emp_info;	  
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);	  
SELECT * FROM manager_info;		
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);
SELECT * FROM dept_info;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    titles.title
FROM retirement_info
LEFT JOIN titles
ON retirement_info.emp_no = titles.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (retirement_info.emp_no)
    retirement_info.first_name,
retirement_info.last_name,
    titles.title
	INTO ret_titles
	FROM retirement_info
	LEFT JOIN titles
	ON retirement_info.emp_no = titles.emp_no
	ORDER BY retirement_info.emp_no, title DESC;

SELECT * FROM ret_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (retirement_info.emp_no) retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    titles.title
	INTO ret_titles
	FROM retirement_info
	LEFT JOIN titles
	ON retirement_info.emp_no = titles.emp_no
	ORDER BY retirement_info.emp_no, title DESC;
SELECT * FROM ret_titles;

SELECT COUNT(ret_titles), ret_titles.title
FROM ret_titles
LEFT JOIN titles
ON ret_titles.emp_no = titles.emp_no
GROUP BY ret_titles.title;

--DELIVERABLE ONE

--# of retiring employees (retirement_info)
DROP TABLE if exists retirement_titles;
-- Create new table for retiring employees
SELECT e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date, ti.to_date
INTO retirement_titles
FROM employees AS e
LEFT JOIN titles AS ti
	ON e.emp_no = ti.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

SELECT * FROM retirement_titles;

DROP TABLE if exists unique_titles;
--use distinct with order by to remove duplicate rows (unique titles)
SELECT DISTINCT ON (retirement_titles.emp_no) retirement_titles.emp_no,
    retirement_titles.first_name,
retirement_titles.last_name,
    retirement_titles.title
	INTO unique_titles
	FROM retirement_titles
	ORDER BY retirement_titles.emp_no, retirement_titles.to_date DESC;
SELECT * FROM unique_titles;


DROP TABLE if exists retiring_titles;
--counting # of each employee per title (retiring_titles)
SELECT COUNT(unique_titles.title), unique_titles.title
INTO retiring_titles
FROM unique_titles
GROUP BY unique_titles.title
ORDER BY COUNT (unique_titles.title) DESC;
SELECT * FROM retiring_titles;

--DELIVERABLE 2
SELECT emp_no, first_name, last_name, birth_date
FROM employees
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31';

SELECT from_date, to_date
FROM dept_emp;
SELECT title
FROM titles;

SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.birth_date,
    de.to_date,
	de.from_date,
	ti.title
INTO ment_info
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
     AND (de.to_date = '9999-01-01')
ORDER BY (e.emp_no) ASC;

SELECT * FROM ment_info;

SELECT DISTINCT ON (ment_info.emp_no) ment_info.emp_no,
    ment_info.first_name,
	ment_info.last_name,
	ment_info.birth_date,
	ment_info.from_date,
	ment_info.to_date,
    ment_info.title
	INTO mentorship
	FROM ment_info
	ORDER BY ment_info.emp_no, title ASC;
SELECT * FROM mentorship;