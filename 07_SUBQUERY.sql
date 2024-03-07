/*
 *  * SUBQUERY (서브쿼리)
 * - 하나의 SQL문 안에 포함된 또다른 SQL문
 * - 메인쿼리(기존 쿼리)를 위해 보조 역할을 하는 쿼리문
 * - SELECT, FROM, WHERE, HAVING 절에서 사용 가능하다
 * */

-- 서브쿼리 예시 1. 
-- 부서코드가 노옹철 사원과 같은 소속의 직원의 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE = (
									SELECT DEPT_CODE
									FROM EMPLOYEE
									WHERE EMP_NAME = '노옹철');

-- 서브쿼리 예시 2.
--전직원의 평균 급여보다 많은 급여를 받고 있는 직원의
--사번, 이름, 직급코드, 급여 조회

--1)전직원의 평균 급여 조회하기 -> 서브쿼리
--2)직원 중 급여가 평균급여 이상인 사원의 (사번, 이름, 직급코드, 급여) 조회 -> 메인쿼리
--3)위의 두 단계를 하나의 쿼리로 만들기
SELECT EMP_ID , EMP_NAME , JOB_CODE , SALARY 
FROM EMPLOYEE
WHERE SALARY >= (
								SELECT CEIL(AVG(SALARY))
								FROM EMPLOYEE);
----------------------------------------------------------------------------------------
							
/* 서브쿼리 유형
 * 
 * - 단일 행(, 단일 열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때
 * - 다중 행(, 단일 열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
 * - 다중 열 서브쿼리 : 서브쿼리의 SELECT 절에 나열된 항목 수가 여러개일 때 
 * - 다중 행, 다중 열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때
 * - 상(호연)관 서브쿼리 : 서브쿼리가 만든 결과값을 메인쿼리가 비교연산 할 때 
 * 												메인쿼리 테이블의 값이 바뀌면 서브쿼리의 결과값도 바뀌는 서브쿼리
 * - 스칼라 서브쿼리 : 상관 쿼리면서 결과값이 하나인 서브쿼리
 * 
 * ** !서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 다르다! **
 * 
 * 
 * 
 * */

-- 1. 단일행 서브쿼리(SINGEL ROW SUBQUERY)
--    서브쿼리의 조회 결과값의 개수가 1개인 서브쿼리
--    단일행 서브쿼리 앞에는 비교연산자를 사용한다
	 -- <,>,<=,>=,=,!=,<>,^=

							
--전직원의 급여 평균보다 많은(초과) 급여를 받는 직원의
--이름, 직급, 부서명, 급여를 직급순으로 정렬하여 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY 
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT d ON(DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT AVG(SALARY)
								FROM EMPLOYEE)
ORDER BY JOB_CODE;
--SELECT절에서 명시한 컬럼이 아니더라도 JOIN한 테이블의 컬럼이라면 정렬 가능하다


--가장 적은 급여를 받는 직원의 
--사번, 이름, 직급명, 부서코드, 급여, 입사일을 조회하기
SELECT EMP_ID , EMP_NAME , JOB_NAME, DEPT_CODE , SALARY , HIRE_DATE 
FROM EMPLOYEE e 
JOIN JOB j USING(JOB_CODE)
WHERE SALARY = (
								SELECT MIN(SALARY)
								FROM EMPLOYEE);
							
--노옹철 사원의 급여보다 많이 받는 직원의 
--사번, 이름, 부서명, 직급명, 급여 조회
SELECT EMP_ID , EMP_NAME , DEPT_TITLE, JOB_NAME, SALARY 
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
WHERE SALARY > (
						SELECT SALARY
						FROM EMPLOYEE e2
						WHERE EMP_NAME = '노옹철');




--부서별(부서가 없는 사람 포함) 급여의 합계가 
--가장 큰 부서의 부서명, 급여 합계를 조회
SELECT DEPT_TITLE , SUM(SALARY) 
FROM EMPLOYEE e 
LEFT JOIN DEPARTMENT d ON(DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = (
										SELECT MAX(SUM(SALARY))
										FROM EMPLOYEE e2 
										GROUP BY DEPT_CODE); --17700000원
--GROUP BY의 조건으로 지정해야 하니까 HAVING에 서브쿼리 삽입

-------------------------------------------------------------------------------
-- 2. 다중행 서브쿼리 ( MULTI ROW SUBQUERY)
-- 서브쿼리의 조회 결과값의 개수가 여러행일 때

										
/*
 * >>다중행 서브쿼리 앞에는 일반 비교연산자를 사용할 수 없음
 * 
 * - IN, NOT IN : 여러개의 결과값 중에서 한 개라도 일치하는 값이 있다면(/없다면) =>가장 많이 사용함
 * 
 * -  > ANY,  < ANY : 여러개의 결과값 중에서 한개라도 큰/작은 경우
 * 										가장 작은 값보다 큰가?/가장 큰 값보다 작은가?
 * 
 * -  > ALL,  < ALL : 여러개의 결과값의 모든 값보다 큰/작은 경우
 * 										가장 큰 값보다 큰가? / 가장 작은값보다 작은가?
 * 
 * - EXISTS / NOT EXISTS : 값이 존재하는지/존재하지 않는지
 * 
 * */


--부서별 최고 급여를 받는 직원의
--이름, 직급, 부서, 급여를 부서 순으로 정렬해 조회하기
SELECT EMP_NAME, JOB_CODE, DEPT_CODE,SALARY
FROM EMPLOYEE 
WHERE SALARY IN (
								SELECT MAX(SALARY)
								FROM EMPLOYEE e
								GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

-- 사수에 해당하는 직원에 대해 조회
--사번, 이름, 부서명, 직급명, 구분(사수/직원)

-- * 사수 == MANAGER_ID 컬럼에 작성된 사번

--1) 사수에 해당하는 사원번호 조회
SELECT DISTINCT MANAGER_ID 
FROM EMPLOYEE e 
WHERE MANAGER_ID IS NOT NULL;

--2) 직원의 사번, 이름, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE= DEPT_ID);

--3) 사수에 해당하는 직원에 대한 정보 추출 조회( 구분은 '사수'로)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME , '사수' 구분
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE= DEPT_ID)
WHERE e.EMP_ID IN (
									SELECT DISTINCT MANAGER_ID 
									FROM EMPLOYEE e 
									WHERE MANAGER_ID IS NOT NULL);

--4) 일반 직원에 해당하는 사원들 정보 조회 (구분은 사원으로)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME , '사원' 구분
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE= DEPT_ID)
WHERE e.EMP_ID NOT IN (
									SELECT DISTINCT MANAGER_ID 
									FROM EMPLOYEE e 
									WHERE MANAGER_ID IS NOT NULL);

--5) 3,4 번의 조회결과 합치기 -> SELECT절 SUBQUERY
-- * SELECT절에서도 서브쿼리 사용 가능함
				
--선택함수 사용 !
--DECODE(컬럼명, 값1, 1인경우, 값2, 2인경우,...일치하지 않는 경우)
--CASE WHEN 조건1 THEN 값1
--		 WHEN 조건2 THEN 값2
--     ELSE 값
--END 별칭
								
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME,
CASE WHEN EMP_ID IN (
									SELECT DISTINCT MANAGER_ID 
									FROM EMPLOYEE e 
									WHERE MANAGER_ID IS NOT NULL)
									THEN '사수'
									ELSE '사원'
		END 구분
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE= DEPT_ID)
ORDER BY EMP_ID;

-- * 집합 연산자(UNION 합집합) 사용방법
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME , '사수' 구분
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE= DEPT_ID)
WHERE e.EMP_ID IN (
									SELECT DISTINCT MANAGER_ID 
									FROM EMPLOYEE e 
									WHERE MANAGER_ID IS NOT NULL)
UNION
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME , '사원' 구분
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE= DEPT_ID)
WHERE e.EMP_ID NOT IN (
									SELECT DISTINCT MANAGER_ID 
									FROM EMPLOYEE e 
									WHERE MANAGER_ID IS NOT NULL);




--대리 직급의 직원들 중에서 과장 직급의 최소 급여보다
-- 많이 받는 직원의 사번, 이름, 직급, 급여를 조회
--> ANY : 가장 작은 값보다 큰가
--1)직급이 대리인 직원의 사번, 이름, 직급, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';

--2) 직급이 과장인 직원들 급여 조회
SELECT SALARY
FROM EMPLOYEE e 
NATURAL JOIN JOB 
WHERE JOB_NAME = '과장';

--3) 대리직급의 직원들 중 과장 직급의 최소 급여보다 많이 받는 직원 조회
--3-1)MIN을 이용해 단일행 서브쿼리로 해결

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > (
							SELECT MIN(SALARY)
							FROM EMPLOYEE e 
							NATURAL JOIN JOB 
							WHERE JOB_NAME = '과장');	


--3-2)ANY를 이용해 과장 중 가장 급여가 적은 과장 초과하는 대리 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ANY(
							SELECT SALARY
							FROM EMPLOYEE e 
							NATURAL JOIN JOB 
							WHERE JOB_NAME = '과장');


--차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급의 직원
--사번, 이름, 직급, 급여		
-- > ALL , < ALL : 가장 큰 값보다 크냐/ 가장 작은 값보다 작냐					
SELECT EMP_ID , EMP_NAME , JOB_NAME, SALARY 
FROM EMPLOYEE e2 
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY > ALL (SELECT SALARY
									FROM EMPLOYEE e
									JOIN JOB USING(JOB_CODE)
									WHERE JOB_NAME = '차장');
								
--서브쿼리 중첩 사용(응용편)
--LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
--DEPARTMENT 테이블의 LOCATION_ID가 동일하고 또 DEPT_ID가
--EMPLOYEE 테이블의 DEPT_CODE와 동일한 사원을 고르시오
								
--1) LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE 조회
SELECT LOCAL_CODE
FROM LOCATION 
WHERE NATIONAL_CODE = 'KO';

--2) DEPARTMENT 테이블에서 위의 결과와 동일한 LOCATION_ID를 가지고 있는 DEPT_ID조회
SELECT DEPT_ID
FROM DEPARTMENT
WHERE LOCATION_ID = (
										SELECT LOCAL_CODE
										FROM LOCATION 
										WHERE NATIONAL_CODE = 'KO');

--3) 최종적으로 EMPLOYEE 테이블에서 위의 결과들과 동일한 DEPT_CODE를 가진 사원을 조회
SELECT EMP_NAME , DEPT_CODE 
FROM EMPLOYEE e 
WHERE DEPT_CODE IN (SELECT DEPT_ID -- 다중행
										FROM DEPARTMENT
										WHERE LOCATION_ID = (
																				SELECT LOCAL_CODE -- 단일행
																				FROM LOCATION 
																				WHERE NATIONAL_CODE = 'KO'));



-------------------------------------------------------------------------------
--3. (단일행) 다중열 서브쿼리
-- 서브쿼리 SELECT 절에 나열된 컬럼 수가 여러개 일 때
																			
--퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 
--사원의 이름, 직급, 부서, 입사일을 조회
																			
--1) 퇴사한 여직원 조회
																
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN ='Y'
AND SUBSTR(EMP_NO,8,1)='2'; --이태림, D8, J6

--2) 퇴사한 여직원과 같은 부서, 같은 직급 조회하기
-- 단일행 서브쿼리 2개를 사용해서 조회하기
--> 서브쿼리가 같은 테이블, 같은 조건인데 다른 컬럼을 조회하도록 한다
SELECT EMP_NAME, JOB_CODE , DEPT_CODE , HIRE_DATE  
FROM EMPLOYEE 
WHERE DEPT_CODE =(
									SELECT DEPT_CODE
									FROM EMPLOYEE
									WHERE ENT_YN ='Y'
									AND SUBSTR(EMP_NO,8,1)='2')
AND JOB_CODE = (
								SELECT JOB_CODE
								FROM EMPLOYEE
								WHERE ENT_YN ='Y'
								AND SUBSTR(EMP_NO,8,1)='2');									
					

-- 다중열 서브쿼리 사용
-->WHERE절에 작성된 컬럼 순서에 맞게 서브쿼리에 조회된 컬럼과 비교하여 일치하는 행만 조회
--(컬럼 나열 순서가 중요함)
SELECT EMP_NAME, JOB_CODE , DEPT_CODE , HIRE_DATE  
FROM EMPLOYEE 
WHERE (DEPT_CODE , JOB_CODE) =  (
															SELECT DEPT_CODE, JOB_CODE
															FROM EMPLOYEE
															WHERE ENT_YN ='Y'
															AND SUBSTR(EMP_NO,8,1)='2');


-------------------------------연습문제-------------------------------------
--1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회(단, 노옹철 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명
														
SELECT EMP_NAME, DEPT_CODE , JOB_CODE , DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE (DEPT_ID, JOB_CODE) = (
														SELECT DEPT_ID, JOB_CODE
														FROM EMPLOYEE
														WHERE EMP_NAME = '노옹철')
AND EMP_NAME <> '노옹철';

--2. 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회
--사번, 이름, 부서코드, 입사일
SELECT EMP_ID , EMP_NAME , DEPT_CODE , HIRE_DATE 
FROM EMPLOYEE e 
WHERE (DEPT_CODE, JOB_CODE) =(SELECT DEPT_CODE , JOB_CODE 
															FROM EMPLOYEE 
															WHERE SUBSTR(EXTRACT(YEAR FROM HIRE_DATE),1,4)  = '2000' );			


--3. 77년생 여자 사원과 동일한 부서이면서 동일 사수를 가지고 있는 사원 조회
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 입사일


SELECT EMP_ID , EMP_NAME , DEPT_CODE , MANAGER_ID , EMP_NO , HIRE_DATE 
FROM EMPLOYEE 
WHERE (DEPT_CODE, MANAGER_ID) = (
																SELECT DEPT_CODE, MANAGER_ID
																FROM EMPLOYEE 
																WHERE SUBSTR(EMP_NO,1,2)='77' 
																AND SUBSTR(EMP_NO,8,1)='2');



-------------------------------------------------------------------------------
--4. 다중행 다중열 서브쿼리
-- 서브쿼리 조회 결과 행 수와 열 수가 여러개일때
														
--본인 직급의 평균 급여를 받고 있는 직원의
--사번, 이름, 직급, 급여를 조회 (단, 급여와 급여 평균은 만원 단위로 계산 TRUNC(컬럼명, -4))

-- 1) 직급 별 평균 급여									
SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
FROM EMPLOYEE
GROUP BY JOB_CODE;
																																					
SELECT EMP_ID , EMP_NAME , JOB_CODE, SALARY 
FROM EMPLOYEE 
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
														FROM EMPLOYEE
														GROUP BY JOB_CODE);







































