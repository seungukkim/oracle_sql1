-- SELECT문
-- p.92

--급여가 5000이 넘는 사원번호와 사원명 조회
SELECT * FROM employees; --107개의 데이터
SELECT 
    employee_id
    ,emp_name
    ,salary
FROM employees
WHERE salary<3000
ORDER BY employee_id;


-- 급여가 5000이상, job_id가 it_prog, employee_id 오름차순으로
SELECT 
    employee_id
    ,emp_name
FROM employees
WHERE salary >5000
    AND job_id = 'IT_PROG'
ORDER BY employee_id;

--급여가 5000이상이거나 job_id 가 'IT_PROG'인 사원

SELECT 
    employee_id
    ,emp_name
FROM employees
WHERE salary>5000
    OR job_id = 'IT_PROG'
ORDER BY employee_id;

-- emp_dept_vl 뷰처럼 한 개 이상의 테이블에서 데이터를 조회해 올 수 있다.

SELECT 
    a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name
FROM employees a,
    departments b
WHERE a.department_id = b.department_id;

--DEPARTMENT_NAME 을 DEP_NAME 으로
SELECT 
    a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name AS dep_name
FROM employees a,
    departments b
WHERE a.department_id = b.department_id;


-- 나열하는 컬럼과 값의 수와 순서, 그리고 데이터 타입이 일치해야 한다.

CREATE TABLE ex3_1(
    col1 VARCHAR2(10),
    col2 NUMBER,
    col3 DATE);
    
INSERT INTO ex3_1(col1,col2, col3)
VALUES('ABC' , 10, SYSDATE);

INSERT INTO ex3_1(col3,col1, col2)
VALUES(SYSDATE,'DEF', 20);

-- 컬럼명을 기술하지 않지만 VALUES 절에는 테이블의 컬럼 순서대로 해당 컬럼 값을 기술해야 하는 형태

INSERT INTO ex3_1
VALUES('GHI',10,SYSDATE);

--p.101
-- MERGE, 데이터를 합치다 또는 추가하다
-- 조건을 비교해서 테이블에 해당 조건에 맞는 데이터가 없으면 추가
-- 있으면 UPDATE 문을 수행한다.

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
-- 테이블 삭제

DELETE ex3_3;
SELECT *FROM ex3_3 ORDER BY employee_id;
DROP TABLE ex3_3;

-- p.107
-- commit & rollback
-- Commit 은 변경한 데이터를 데이터베이스에 마지막으로 반영
-- Rollback은 그 반대로 변경한 데이터를변경하기 이전 상태로 되돌리는 역할

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

-- ROWID, 주소 값
-- DBA, DB 모델링(쿼리속도 측정 --> 특징)
SELECT 
    ROWNUM
    ,employee_id
    ,ROWID
FROM employees
WHERE ROWNUM<5;

-- 연산자
-- Operator 연산 수행
-- 수식 연산자 & 문자 연산자
-- '||' 두 문자를 붙이는 연결 연산자

SELECT
    employee_id||'-'||emp_name AS employee_info
FROM employees
WHERE ROWNUM <5;

-- 표현식
-- 조건문, if조건문(PL/SQL)
-- CASE 표현식
SELECT
    employee_id
    ,salary
    ,CASE WHEN salary <=5000 THEN 'C등급'
        WHEN salary >5000 AND salary<=15000 THEN 'B등급'
        ELSE 'A등급'
    END AS salary_grade
FROM employees;

-- 조건식
-- 비교 조건식
-- 분석가 DB 데이터를 추출할 시, 서브쿼리

SELECT 
    employee_id
    ,salary
FROM employees
WHERE salary = ANY(2000,3000,4000)
ORDER BY employee_id;

-- ANY --> OR 변한

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

-- NOT 조건식
SELECT
    employee_id
    ,salary
FROM employees
WHERE NOT(salary>=2500)
ORDER BY employee_id;

--IN 조건식
-- 조건절에 명시한 값이 포함된 건을 반환하는데 앞에서 배웠던 ANY
SELECT 
    employee_id
    ,salary
FROM employees
WHERE salary NOT IN(2000,3000,4000)
ORDER BY employee_id;

-- EXISTS 조건식
-- "서브쿼리"만 올 수 있음

-- Like 조건식
-- 문자열의 패턴을 검색해서 사용하는 조건식

 SELECT 
    emp_name
FROM employees
WHERE emp_name LIKE 'A%'
ORDER BY emp_name;

CREATE TABLE ex3_5(
    name VARCHAR2(30));
    
INSERT INTO ex3_5 VALUES('홍길동');
INSERT INTO ex3_5 VALUES('홍길용');
INSERT INTO ex3_5 VALUES('홍길상');
INSERT INTO ex3_5 VALUES('홍길상동');

SELECT *
    FROM ex3_5
WHERE name LIKE '홍길%';

SELECT *
    FROM ex3_5
WHERE name LIKE '홍길_';

-- 4장 숫자함수
-- p.126

SELECT ABS(10), ABS(-10),ABS(-10.123)
FROM DUAL;

-- 정수 반환
-- 올림
SELECT CEIL(10.123),CEIL(10.5541),CEIL(11.001)
FROM DUAL;

--내림
SELECT FLOOR(10.123),FLOOR(10.5541),FLOOR(11.001)
FROM DUAL;

-- 반올림
SELECT ROUND(10.123,1),ROUND(10.5541,2),ROUND(11.001,3)
FROM DUAL;

-- TRUNC
-- 반올림 안함. 소수점 절삭, 자리수 지정 가능

SELECT TRUNC(115.155),TRUNC(115.155,1),TRUNC(115.155,2),TRUNC(115.155,3)
FROM DUAL;

-- POWER
--POWER 함수, SQRT
SELECT POWER(3,2), POWER(3,3),POWER(3,3.001)
FROM DUAL;
--제곱근 반환
SELECT SQRT(2),SQRT(5),SQRT(9)
FROM DUAL;

-- 문자 함수
SELECT INITCAP('never say goodbye'),INITCAP('never6isay*good가 bye')
FROM DUAL;

-- Lower함수
-- 매개변수로 들어오는 문자를 모두 소문자로, upper 함수는 대문자로 반환
SELECT LOWER('NEVER SAY GOODBYE'),UPPER('never sya goodbye')
FROM DUAL;

-- CONCAT(char1,char2),
SELECT CONCAT('I Have','A Dream'),'I Have'||'A Dream'
FROM DUAL;

--SUBSTR
-- 문자열 자르기
SELECT SUBSTR('ABCDEFG',1,4),SUBSTR('ABCDEFG',-1,4)
FROM DUAL;

SELECT SUBSTRB('ABCDEFG',1,4),SUBSTRB('가나다라마바사',1,4)
FROM DUAL;

-- LTRIM,RTRIM함수
SELECT LTRIM('ABCDEFGABC','ABC')
FROM DUAL;

SELECT RTRIM('ABCDEFGABC','ABC')
FROM DUAL;

--LPAD, RPAD

-- 날짜 함수(p.138)
SELECT SYSDATE,SYSTIMESTAMP
FROM DUAL;
--add_months
--add_months함수, 매개변수로 들어온 날짜, integer만큼 월을 더함

SELECT ADD_MONTHS(SYSDATE,1)
FROM DUAL;

SELECT MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE,1))mon1,
        MONTHS_BETWEEN(ADD_MONTHS(SYSDATE,1),SYSDATE)mon2
FROM DUAL;

SELECT LAST_DAY(SYSDATE)
FROM DUAL;

SELECT SYSDATE, ROUND(SYSDATE,'month'),TRUNC(SYSDATE,'month')
FROM DUAL;

SELECT NEXT_DAY(SYSDATE,'금요일')
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
-- 매개변수로 들어오는 표현식에서 NULL이 아닌 첫 번째 표현식 반환

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