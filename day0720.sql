-- SELECT��
-- p.92

--�޿��� 5000�� �Ѵ� �����ȣ�� ����� ��ȸ
SELECT * FROM employees; --107���� ������
SELECT 
    employee_id
    ,emp_name
    ,salary
FROM employees
WHERE salary<3000
ORDER BY employee_id;


-- �޿��� 5000�̻�, job_id�� it_prog, employee_id ������������
SELECT 
    employee_id
    ,emp_name
FROM employees
WHERE salary >5000
    AND job_id = 'IT_PROG'
ORDER BY employee_id;

--�޿��� 5000�̻��̰ų� job_id �� 'IT_PROG'�� ���

SELECT 
    employee_id
    ,emp_name
FROM employees
WHERE salary>5000
    OR job_id = 'IT_PROG'
ORDER BY employee_id;

-- emp_dept_vl ��ó�� �� �� �̻��� ���̺��� �����͸� ��ȸ�� �� �� �ִ�.

SELECT 
    a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name
FROM employees a,
    departments b
WHERE a.department_id = b.department_id;

--DEPARTMENT_NAME �� DEP_NAME ����
SELECT 
    a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name AS dep_name
FROM employees a,
    departments b
WHERE a.department_id = b.department_id;


-- �����ϴ� �÷��� ���� ���� ����, �׸��� ������ Ÿ���� ��ġ�ؾ� �Ѵ�.

CREATE TABLE ex3_1(
    col1 VARCHAR2(10),
    col2 NUMBER,
    col3 DATE);
    
INSERT INTO ex3_1(col1,col2, col3)
VALUES('ABC' , 10, SYSDATE);

INSERT INTO ex3_1(col3,col1, col2)
VALUES(SYSDATE,'DEF', 20);

-- �÷����� ������� ������ VALUES ������ ���̺��� �÷� ������� �ش� �÷� ���� ����ؾ� �ϴ� ����

INSERT INTO ex3_1
VALUES('GHI',10,SYSDATE);

--p.101
-- MERGE, �����͸� ��ġ�� �Ǵ� �߰��ϴ�
-- ������ ���ؼ� ���̺� �ش� ���ǿ� �´� �����Ͱ� ������ �߰�
-- ������ UPDATE ���� �����Ѵ�.

CREATE TABLE ex3_3(
    employee_id NUMBER
    ,bonus_amt NUMBER DEFAULT 0);
    
INSERT INTO ex3_3(employee_id)
SELECT e.employee_id
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
    AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e.employee_id;


SELECT *
FROM ex3_3
ORDER BY employee_id;

SELECT 
    employee_id
    , manager_id
    , salary
    , salary *0.01
FROM employees
WHERE employee_id IN (SELECT employee_id FROM ex3_3);


SELECT 
    employee_id
    , manager_Id
    , salary
    , salary*0.001
FROM employees
WHERE employee_id NOT IN (SELECT employee_id FROM ex3_3)
    AND manager_id =146;
    
-- merge

MERGE INTO ex3_3 d
    USING (SELECT employee_id, salary, manager_id
        FROM employees
        WHERE manager_id =146) b
    ON(d.employee_id= b.employee_id)
WHEN MATCHED THEN
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01
    DELETE WHERE (B.employee_id =161)
WHEN NOT MATCHED THEN
    INSERT (d.employee_id, d.bonus_amt) VALUES(b.employee_id, b.salary*.001)
    WHERE (b.salary <8000);
    
SELECT *
    FROM ex3_3 
    ORDER BY employee_id;
    
-- p.106
-- ���̺� ����

DELETE ex3_3;
SELECT *FROM ex3_3 ORDER BY employee_id;
DROP TABLE ex3_3;

-- p.107
-- commit & rollback
-- Commit �� ������ �����͸� �����ͺ��̽��� ���������� �ݿ�
-- Rollback�� �� �ݴ�� ������ �����͸������ϱ� ���� ���·� �ǵ����� ����

CREATE TABLE ex3_4(
    employee_id NUMBER
    );

INSERT INTO ex3_4 VALUES(100);
SELECT *FROm ex3_4;
COMMIT;

TRUNCATE TABLE ex3_4;
SELECT *FROM ex3_4;
rollback;

--p.110

SELECT 
    ROWNUM, employee_id
FROM employees
WHERE ROWNUM<5;

-- ROWID, �ּ� ��
-- DBA, DB �𵨸�(�����ӵ� ���� --> Ư¡)
SELECT 
    ROWNUM
    ,employee_id
    ,ROWID
FROM employees
WHERE ROWNUM<5;

-- ������
-- Operator ���� ����
-- ���� ������ & ���� ������
-- '||' �� ���ڸ� ���̴� ���� ������

SELECT
    employee_id||'-'||emp_name AS employee_info
FROM employees
WHERE ROWNUM <5;

-- ǥ����
-- ���ǹ�, if���ǹ�(PL/SQL)
-- CASE ǥ����
SELECT
    employee_id
    ,salary
    ,CASE WHEN salary <=5000 THEN 'C���'
        WHEN salary >5000 AND salary<=15000 THEN 'B���'
        ELSE 'A���'
    END AS salary_grade
FROM employees;

-- ���ǽ�
-- �� ���ǽ�
-- �м��� DB �����͸� ������ ��, ��������

SELECT 
    employee_id
    ,salary
FROM employees
WHERE salary = ANY(2000,3000,4000)
ORDER BY employee_id;

-- ANY --> OR ����

SELECT 
    employee_id
    ,salary
FROM employees
WHERE salary = 2000 OR salary=3000 OR salary =4000
ORDER BY employee_id;

--SOME
SELECT
    employee_id
    ,salary
FROM employees
WHERE salary = SOME(2000,3000,4000)
ORDER BY employee_id;

-- NOT ���ǽ�
SELECT
    employee_id
    ,salary
FROM employees
WHERE NOT(salary>=2500)
ORDER BY employee_id;

--IN ���ǽ�
-- �������� ����� ���� ���Ե� ���� ��ȯ�ϴµ� �տ��� ����� ANY
SELECT 
    employee_id
    ,salary
FROM employees
WHERE salary NOT IN(2000,3000,4000)
ORDER BY employee_id;

-- EXISTS ���ǽ�
-- "��������"�� �� �� ����

-- Like ���ǽ�
-- ���ڿ��� ������ �˻��ؼ� ����ϴ� ���ǽ�

 SELECT 
    emp_name
FROM employees
WHERE emp_name LIKE 'A%'
ORDER BY emp_name;

CREATE TABLE ex3_5(
    name VARCHAR2(30));
    
INSERT INTO ex3_5 VALUES('ȫ�浿');
INSERT INTO ex3_5 VALUES('ȫ���');
INSERT INTO ex3_5 VALUES('ȫ���');
INSERT INTO ex3_5 VALUES('ȫ���');

SELECT *
    FROM ex3_5
WHERE name LIKE 'ȫ��%';

SELECT *
    FROM ex3_5
WHERE name LIKE 'ȫ��_';

-- 4�� �����Լ�
-- p.126

SELECT ABS(10), ABS(-10),ABS(-10.123)
FROM DUAL;

-- ���� ��ȯ
-- �ø�
SELECT CEIL(10.123),CEIL(10.5541),CEIL(11.001)
FROM DUAL;

--����
SELECT FLOOR(10.123),FLOOR(10.5541),FLOOR(11.001)
FROM DUAL;

-- �ݿø�
SELECT ROUND(10.123,1),ROUND(10.5541,2),ROUND(11.001,3)
FROM DUAL;

-- TRUNC
-- �ݿø� ����. �Ҽ��� ����, �ڸ��� ���� ����

SELECT TRUNC(115.155),TRUNC(115.155,1),TRUNC(115.155,2),TRUNC(115.155,3)
FROM DUAL;

-- POWER
--POWER �Լ�, SQRT
SELECT POWER(3,2), POWER(3,3),POWER(3,3.001)
FROM DUAL;
--������ ��ȯ
SELECT SQRT(2),SQRT(5),SQRT(9)
FROM DUAL;

-- ���� �Լ�
SELECT INITCAP('never say goodbye'),INITCAP('never6isay*good�� bye')
FROM DUAL;

-- Lower�Լ�
-- �Ű������� ������ ���ڸ� ��� �ҹ��ڷ�, upper �Լ��� �빮�ڷ� ��ȯ
SELECT LOWER('NEVER SAY GOODBYE'),UPPER('never sya goodbye')
FROM DUAL;

-- CONCAT(char1,char2),
SELECT CONCAT('I Have','A Dream'),'I Have'||'A Dream'
FROM DUAL;

--SUBSTR
-- ���ڿ� �ڸ���
SELECT SUBSTR('ABCDEFG',1,4),SUBSTR('ABCDEFG',-1,4)
FROM DUAL;

SELECT SUBSTRB('ABCDEFG',1,4),SUBSTRB('�����ٶ󸶹ٻ�',1,4)
FROM DUAL;

-- LTRIM,RTRIM�Լ�
SELECT LTRIM('ABCDEFGABC','ABC')
FROM DUAL;

SELECT RTRIM('ABCDEFGABC','ABC')
FROM DUAL;

--LPAD, RPAD

-- ��¥ �Լ�(p.138)
SELECT SYSDATE,SYSTIMESTAMP
FROM DUAL;
--add_months
--add_months�Լ�, �Ű������� ���� ��¥, integer��ŭ ���� ����

SELECT ADD_MONTHS(SYSDATE,1)
FROM DUAL;

SELECT MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE,1))mon1,
        MONTHS_BETWEEN(ADD_MONTHS(SYSDATE,1),SYSDATE)mon2
FROM DUAL;

SELECT LAST_DAY(SYSDATE)
FROM DUAL;

SELECT SYSDATE, ROUND(SYSDATE,'month'),TRUNC(SYSDATE,'month')
FROM DUAL;

SELECT NEXT_DAY(SYSDATE,'�ݿ���')
FROM DUAL;

SELECT TO_CHAR(123456789,'999,999,999')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM DUAL;

SELECT TO_NUMBER('123456')
FROM DUAL;

SELECT TO_DATE('20140101','YYYY-MM-DD')
FROM DUAL;

SELECT TO_DATE('20140101 13:44:50','YYYY-MM-DD HH24:MI:SS')
FROM DUAL;

SELECT NVL(manager_id, employee_id)
FROM employees
WHERE manager_id IS NULL;


SELECT employee_id,
    NVL2(commission_pct, salary + (salary * commission_pct), salary)AS salary2
FROM employees;

SELECT employee_id
                , salary
                , commission_pct
                , NVL2(commission_pct, salary + (salary * commission_pct), salary) AS salary2
FROM employees
WHERE employee_id IN (118, 179);

-- COALESCE(expr1, expr2)
-- �Ű������� ������ ǥ���Ŀ��� NULL�� �ƴ� ù ��° ǥ���� ��ȯ

SELECT 
    employee_id
    ,salary
    ,commission_pct
    ,COALESCE(salary *commission_pct, salary)AS salary2
FROM employees;

-- DECODE
-- IF-ELIF -ELIF 

SELECT * FROM sales;

SELECT prod_id,
    DECODE(channel_id, 3, 'Direct',
                        9,'Direct',
                        5,'Indirect',
                        4,'Indirect',
                        'Others') decodes
FROM sales
WHERE rownum<10;