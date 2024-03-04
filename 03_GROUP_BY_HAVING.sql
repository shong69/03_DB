--EMPLOYEE 테이블에서 부서 코드가 D5,D6인 부서의 평균 급여, 인원 수 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE e 
WHERE DEPT_CODE IN ('D5', 'D6')
GROUP BY DEPT_CODE;





--EMPLOYEE 테이블에서 직급 별 2000년도 이후 입사자들의 급여 합을 조회하기(직급코드 오름차순)
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE e 
WHERE SUBSTR(TO_CHAR(HIRE_DATE,'YYYY'),1,4) >=2000 --SUBSTR은 1부터 센다 
--OR EXTRACT(YEAR FROM HIRE_DATE) >= '2000'\
--OR HIRE_DATE >= TO_DATE('2000-01-01')
GROUP BY JOB_CODE
ORDER BY 1; --데이터 정렬 순서 JOB_CODE로 설정


----------------------------------------------------------------------------------
-- * 여러 컬럼을 묶어서 그룹으로 지정 가능 --> 그룹 내 그룹이 가능함

-- * GROUP BY 사용 시 주의사항
--> SELECT문에 GOUP BY절을 사용할 경우
--  SELECT 절에 명시한 조회하려는 컬럼 중 그룹함수가 적용되지 않은 컬럼을
--  모두 GROUP BY절에 작성해야 함


--EMPLOYEE테이블에서 부서별로 같은 직급인 사원의 수를 조회
--부서코드 오름차순, 직급코드 내림차순 정렬
SELECT DEPT_CODE, JOB_CODE , COUNT(*) 
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE --DEPT_CODE로 그룹을 나누고, 나눠진 그룹 내에서 JOB_CODE로 분류(세분화)
--ORA-00979:GROUP BY 표현식이 아닙니다.
ORDER BY DEPT_CODE, JOB_CODE DESC;


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

-- * HAVING 절 : 그룹함수로 구해 올 그룹에 대한 조건을 설정할 때 사용
-- HAVING 컬럼명 | 함수식 비교연산자 비교값

/* 5:SELECT 컬럼명 AS 별칭, 계산식, 함수실
 * 1:FROM 테이블명
 * 2:WHERE 컬럼명, | 함수식 비교연산자 비교값
 * 3:GROUP BY 그룹을 묶을 컬럼명
 * 4:HAVING 그룹함수식 비교연산자 비교값
 * 6:ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식 (ASC/DESC) [NULLS FIRST | LAST]
 * */

--부서 별 평균 급여가 300만원 이상인 부서를 조회(부서코드 오름차순)
SELECT DEPT_CODE , AVG(SALARY)
FROM EMPLOYEE e 
--WHERE SALARY >=3000000
GROUP BY DEPT_CODE 
HAVING AVG(SALARY) > = 3000000 -->DEPT_CODE 그룹 중 급여 평균이 300만 이상인 그룹만 조회
ORDER BY DEPT_CODE;


--EMPLOYEE 테이블에서 직급별 인원 수가 5명 이하인 직급코드, 인원수 조회하기(직급코드 오름차순)
SELECT JOB_CODE , COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING COUNT(*) <= 5 -- HAVING 절에서는 그룹 함수가 반드시 작성된다
ORDER BY JOB_CODE; 



---------------------------------------------------------------------------------

--집계함수(ROLLUP, CUBE)
-- 그룹 별 산출 결과값의 집계를 계산하는 함수
-- (그룹 별로 중간 집계 결과를 추가함)
--GROUP BY 절에서만 사용할 수 있는 함수임

-- ROLLUP : GROUP BY 절에서 가장 먼저 작성된 컬럼의 중간 집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE e 
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;


-- CUBE : GROUP BY 절에 작성된 모든 컬럼의 중간 집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE e 
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;



---------------------------------------------------------------------------------

/*SET OPERATOR (집합 연산자) 

-- 여러 SELECT의 결과(RESULT SET)를 하나의 결과로 만드는 연산자

- UNION (합집합) : 두 SELECT 결과를 하나로 합침. 단, 중복은 한 번만 작성

- INTERSECT (교집합) : 두 SELECT 결과 중 중복되는 부분만 조회

- UNION ALL : UNION + INTERSECT
							합집합에서 중복 부분 제거 X

- MINUS (차집합) : A에서 A, B 교집합 부분을 제거하고 조회

*/

--EMPLOYEE 테이블에서 부서코드가 'D5'인 사원의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE e 
WHERE DEPT_CODE = 'D5' 
--UNION
--INTERSECT 
--UNION ALL
MINUS
--급여가 300만원 초과인 사원의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE e 
WHERE SALARY > 3000000;

--(주의사항!) 집합 연산자를 사용하기 위한 SELECT 문들은 조회하는 컬럼의 타입, 개수가 모두 동일해야함
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, 1
FROM EMPLOYEE e 
WHERE SALARY >= 3000000;

--서로 다른 테이블이지만, 컬럼의 타입과 개수만 일치하면 집합연산자 사용 가능
SELECT EMP_ID, EMP_NAME 
FROM EMPLOYEE e 
UNION
SELECT DEPT_ID, DEPT_TITLE 
FROM DEPARTMENT d ;














