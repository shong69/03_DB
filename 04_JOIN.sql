/* 
[JOIN 용어 정리]
  오라클       	  	                                SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
등가 조인		                            내부 조인(INNER JOIN), JOIN USING / ON
                                            + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
포괄 조인 		                        왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                            + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인   	                		    JOIN ON
----------------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱		              			 교차 조인(CROSS JOIN)
CARTESIAN PRODUCT

- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 수행 결과는 하나의 Result Set으로 나옴.

-- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에
--       시간이 오래 걸리는 단점이 있다!

/* 
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.

- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서 
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.   
*/


--기존에 서로 다른 테이블의 데이터를 조회할 경우 아래와 같이 따로 조회함

--직원번호, 직원명, 부서코드, 부서명을 조회하고자 할 때
SELECT EMP_ID , EMP_NAME , DEPT_CODE 
FROM EMPLOYEE e ;

--부서명은 DEPARTMENT 테이블에서 조회 가능
SELECT DEPT_ID , DEPT_TITLE 
FROM DEPARTMENT d ;


SELECT e.EMP_ID, e.EMP_NAME , d.DEPT_ID, d.DEPT_TITLE  
FROM EMPLOYEE 
JOIN DEPARTMENT d ON(DEPT CODE = DEPT_ID);



--1. 내부 조인(INNER JOIN) (==등가조인(EQUAL JOIN))

-->연결되는 컬럼의 값이 일치하는 행들만 조인됨
--(==일치하는 값이 없는 행은 조인에서 제외됨)

--작성방법은 크게 ANSI구문과 오라클 구문으로 나뉘고, 
--ANSI에서 USING과 ON을 쓰는 방법으로 나뉜다

--1) 연결에 사용할 두 컬럼명이 다른 경우
--연결에 사용할 컬럼명이 다른 경우 ON()을 사용
SELECT e.EMP_ID, e.EMP_NAME , d.DEPT_ID, d.DEPT_TITLE  
FROM EMPLOYEE 
JOIN DEPARTMENT d ON (DEPT CODE = DEPT_ID);

--오라클
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE e , DEPARTMENT d 
WHERE DEPT_CODE = DEPT_ID ;

/*

 * DEPT_ID|DEPT_TITLE|LOCATION_ID|
-------+----------+-----------+
D1     |인사관리부     |L1         |
D2     |회계관리부     |L1         |
D3     |마케팅부       |L1         |
D4     |국내영업부     |L1         |
D5     |해외영업1부    |L2         |
D6     |해외영업2부    |L3         |
D7     |해외영업3부    |L4         |
D8     |기술지원부     |L5         |
D9     |총무부         |L1         |
 * 
 * 
 * 
 * 
 * LOCAL_CODE|NATIONAL_CODE|LOCAL_NAME|
----------+-------------+----------+
L1        |KO           |ASIA1     |
L2        |JP           |ASIA2     |
L3        |CH           |ASIA3     |
L4        |US           |AMERICA   |
L5        |RU           |EU        |

 * */

--DEPARTMENT테이블, LOCATION 테이블을 참조하여 부서명, 지역명 조회
--ANSI 방식
SELECT DEPT_TITLE , LOCAL_NAME
FROM LOCATION l 
JOIN DEPARTMENT d ON(LOCATION_ID = LOCAL_CODE);

--ORACLE 방식
SELECT DEPT_TITLE , LOCAL_NAME
FROM DEPARTMENT d , LOCATION l 
WHERE LOCATION_ID = LOCAL_CODE;



--2)연결에 사용할 두 컬럼명이 같은 경우

--EMPLOYEE 테이블, JOB 테이블을 참조해 사번, 이름, 직급코드, 직급명 조회

--ANSI 연결에 사용할 컬럼명이 같은 경우 USING(컬럼명)을 사용함
SELECT EMP_ID , EMP_NAME , JOB_CODE , JOB_NAME
FROM EMPLOYEE e  
JOIN JOB USING (JOB_CODE);

--ORACLE -> 별칭 사용
--테이블 별로 별칭을 등록할 수 있음
SELECT EMP_ID , EMP_NAME , j.JOB_CODE , JOB_NAME
FROM EMPLOYEE e , JOB j 
WHERE e.JOB_CODE = j.JOB_CODE ;





/*
 * INNER JOIN의 문제점
 * -> 연결에 사용된 컬럼의 값이 일치하지 않으면
 *    조회 결과에 포함되지 않는다
 * */
------------------------------------------------------------------------------
--2. 외부 조인
--두 테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함시킴
--> *반드시 OUTER JOIN임을 명시해야함*
-- OUTER 조인과 비교할 INNER JOIN 쿼리문
SELECT e.EMP_ID, e.EMP_NAME , d.DEPT_ID, d.DEPT_TITLE  
FROM EMPLOYEE 
INNER JOIN DEPARTMENT d ON (DEPT CODE = DEPT_ID);

-- 1)LEFT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 왼 편에 기술된 테이블의 컬럼 수를 기준으로 JOIN
-->왼편에 작성된 테이블의 모든 행이 결과에 포함되어야 함(JOIN 안되는 행도 결과에 포함)

--ANSI 표준
SELECT  EMP_NAME, DEPT_TITLE 
FROM EMPLOYEE e LEFT JOIN DEPARTMENT d 
ON(DEPT_ID = DEPT_CODE); --23개 행(하동운, 이오리 포함됨)


--ORACLE 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE e , DEPARTMENT d 
WHERE DEPT_CODE= DEPT_ID(+); 
--반대쪽 테이블의 컬럼에 (+) 기호를 작성해야 함


-- 2)RIGTH [OUTER] JOIN : 합치기에 사용한 두 테이블 중 
-- 오른편에 기술된 테이블의 컬럼 수를 기준으로 JOIN

--ANSI 표준
SELECT  EMP_NAME, DEPT_TITLE 
FROM EMPLOYEE e RIGHT JOIN DEPARTMENT d 
ON(DEPT_ID = DEPT_CODE);

--ORACLE 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE e , DEPARTMENT d 
WHERE DEPT_CODE(+)= DEPT_ID; 



-- 3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함함
--오라클 구문에서는 FULL OUTER JOIN을 사용 못한다
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE e , DEPARTMENT d 
WHERE DEPT_CODE(+)= DEPT_ID(+);  --ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다

--ANSI 표준
SELECT  EMP_NAME, DEPT_TITLE 
FROM EMPLOYEE e FULL JOIN DEPARTMENT d 
ON(DEPT_ID = DEPT_CODE);


--------------------------------------------------------------------------------------------------
--3. 교차 조인(CROSS JOIN == CARTESIAN PRODUCT)
--   조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법(곱집합)
--> JOIN 구문을 잘못 작성하는 경우 CROSS JOIN의 결과가 조회됨

SELECT EMP_NAME , DEPT_TITLE
FROM EMPLOYEE 
CROSS JOIN DEPARTMENT; --207행 == (EMPLOYEE)23*(DEPARTMENT)9 = 207




--------------------------------------------------------------------------------------------------
-- 4. 비등가 조인(NONE EQUAL JOIN)
-- '='(등호)를 사용하지 않는 조인문
-- 지정한 컬럼 값이 일치하는 경우가 아니라 값의 범위에 포함되는 행들을 연결하는 방식


SELECT * FROM SAL_GRADE sg ;

SELECT EMP_NAME, SAL_LEVEL FROM EMPLOYEE e ;

-- 사원의 급여에 따른 급여 등급 파악하기
SELECT EMP_NAME , SALARY , sg.SAL_LEVEL 
FROM EMPLOYEE 
JOIN SAL_GRADE sg ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);



--------------------------------------------------------------------------------------------------
-- 5. 자체 조인(SELF JOIN)
--    같은 테이블을 조인함 -> 자기 자신과 조인을 맺음
-- TIP ! 같은 테이블 2개가 있다고 생각하고 JOIN 진행

--사번, 이름, 사수의 사번, 사수 이름 조회

--ANSI 표준
SELECT e.EMP_ID , e.EMP_NAME ,
	NVL(e.MANAGER_ID , '없음') ,
	NVL(l.EMP_NAME, '-')
FROM EMPLOYEE e
LEFT JOIN EMPLOYEE l ON(e.MANAGER_ID = l.EMP_ID);


--오라클 구문
SELECT e.EMP_ID , e.EMP_NAME ,
	NVL(e.MANAGER_ID , '없음') ,
	NVL(l.EMP_NAME, '-')
FROM EMPLOYEE e, EMPLOYEE l
WHERE e.MANAGER_ID = l.EMP_ID(+);



--------------------------------------------------------------------------------------------------
-- 6. 자연 조인(NATURAL JOIN)
--    동일한 타입과 이름을 가진 컬럼이 있는 테이블 간의 조인을 간단히 표현하는 방법

-- 반드시 두 테이블 간의 동일한 컬럼명, 타입을 가진 컬럼이 필요함
--> 없을 경우 교차 조인됨

SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE 
--JOIN JOB USING(JOB_CODE);
NATURAL JOIN JOB;

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE 
NATURAL JOIN DEPARTMENT;
--> 잘못 조인하면 CROSS JOIN의 결과가 조회됨




--------------------------------------------------------------------------------------------------
-- 7. 다중 조인
--    N개의 테이블을 조회할 때 사용 ( 순서 중요! )

-- 사원 이름, 부서명, 지역명 조회

--ANSI 표준
SELECT EMP_NAME , DEPT_TITLE , LOCAL_NAME 
FROM EMPLOYEE 
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE); --순서 중요!
--줄바꿈 CTRL+SHITFT + 방향키
--한 줄 복사 CTRL+ALT + 방향키


--오라클 전용
SELECT EMP_NAME , DEPT_TITLE , LOCAL_NAME 
FROM EMPLOYEE  , DEPARTMENT  , LOCATION  
WHERE(DEPT_CODE = DEPT_ID AND LOCATION_ID = LOCAL_CODE);
--조인 순서를 지키지 않은 경우( 에러 발생 )


--[다중 조인 연습 문제]
--직급이 대리면서 아시아 지역에 근무하는 직원 조회. 사번, 이름, 직급명, 부서명, 근무지역명, 급여 조회

--ANSI
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE , LOCAL_NAME, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%';

--ORACLE
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE , LOCAL_NAME, SALARY
FROM EMPLOYEE e , DEPARTMENT d , LOCATION l , JOB j 
WHERE (DEPT_CODE = DEPT_ID)
AND(e.JOB_CODE = j.JOB_CODE)
AND(LOCATION_ID = LOCAL_CODE)
AND JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%';





--------------------------------------------------------------------------------------------------
--JOIN 연습문제

--1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의
--사원명, 주민번호, 부서명, 직급명을 조회하시오.

SELECT EMP_NAME , EMP_NO , DEPT_TITLE, JOB_NAME
FROM EMPLOYEE e  
JOIN DEPARTMENT d ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_NO LIKE '7%'
AND SUBSTR(EMP_NO, 8,1) = '2'
AND EMP_NAME LIKE '전%';


--2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 직급명, 부서명을 조회하시오.

SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE 
FROM EMPLOYEE e 
JOIN DEPARTMENT ON( DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '%형%';


--3. 해외영업 1부, 2부에 근무하는 사원의 사원명, 직급명, 부서코드, 부서명을 조회하시오.

SELECT EMP_NAME , JOB_NAME, DEPT_CODE , DEPT_TITLE
FROM EMPLOYEE e 
JOIN DEPARTMENT d ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE DEPT_TITLE LIKE '해외영업%';


--4. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT EMP_NAME , BONUS, DEPT_TITLE , LOCAL_NAME
FROM EMPLOYEE e 
LEFT JOIN DEPARTMENT d ON(DEPT_ID = DEPT_CODE)
LEFT JOIN LOCATION l  ON(LOCATION_ID = LOCAL_CODE) 
--보너스 받지만 부서 없는 하동운도 포함하기 위해 LEFT JOIN
WHERE BONUS IS NOT NULL;


--5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE , LOCAL_NAME
FROM EMPLOYEE e 
JOIN DEPARTMENT d ON(DEPT_CODE= DEPT_ID)
JOIN LOCATION l  ON (LOCATION_ID = LOCAL_CODE)
JOIN JOB USING(JOB_CODE)
WHERE DEPT_CODE IS NOT NULL;


--6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의 사원명, 직급명,
--급여, 연봉(보너스포함)을 조회하시오. (연봉에 보너스포인트를 적용하시오.)
SELECT EMP_NAME , DEPT_TITLE , SALARY, 
DECODE(BONUS, NULL, SALARY*12, SALARY*12*(1+BONUS))
FROM EMPLOYEE e 
JOIN DEPARTMENT d ON(DEPT_CODE = DEPT_ID)
JOIN SAL_GRADE sg USING(SAL_LEVEL)
WHERE MIN_SAL < SALARY;



--7.한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT EMP_NAME, DEPT_TITLE , NATIONAL_CODE ,LOCAL_NAME
FROM EMPLOYEE e 
JOIN DEPARTMENT d ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION l ON(LOCATION_ID = LOCAL_CODE)
WHERE NATIONAL_CODE IN ('KR', 'JP');


--8. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을
--조회하시오.(SELF JOIN 사용)

SELECT e.EMP_NAME, e.DEPT_CODE , e2.EMP_NAME
FROM EMPLOYEE e 
JOIN EMPLOYEE e2 ON(e.DEPT_CODE = e2.DEPT_CODE)
WHERE e.EMP_NAME <> e2.EMP_NAME;

--9. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명,
-- 직급명, 급여를 조회하시오. (단, JOIN, IN 사용할 것)
SELECT EMP_NAME, JOB_NAME, SALARY 
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
WHERE BONUS IS NULL 
AND JOB_CODE IN ('J4', 'J7');













