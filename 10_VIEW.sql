/*
 * VIEW
 * - SELECT문의 실행 결과(RESULT SET)를 화면에 저장하는 객체
 * - 논리적 가상 테이블
 * --> 테이블 모양을 하고는 있지만 실제로 값을 저장하는 테이블은 아님
 * 
 * ** VIEW 사용 목적 **
 * 1) 복잡한 SELECT문을 쉽게 재사용하기 위해 사용함
 * 2) 테이블의 진짜 모습을 감출 수 있어서 보안상 유리함
 * 
 * **** VIEW 사용 시 주의사항 ****
 * 1) 가상 테이블(실제 테이블X) --> ALTER 구문 사용 불가
 * 2) VIEW를 이용한 DML(INSERT/UPDATE/DELETE)이 가능한 경우도 있지만
 *    많은 제약이 따르기 때문에 SELECT 용도로 사용하는 것을 권장함
 *  
 * [VIEW 생성 방법]
 * 
 * CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 
 * AS 서브쿼리(만들고 싶은 뷰 모양의 서브쿼리) [WITH CHECK OPTION] [WITH READ ONLY];
 * 
 * -- 1) OR REPLACE : 기존에 동일한 뷰이름이 존재하는 경우 덮어쓰고,
 * 										존재하지 않으면 새로 생성해줌
 * 
 * -- 2) FORCE | NOFORCE :
 * 				- FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성하기
 * 				- NO FORCE : 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성해줌(기본값) 
 * 
 * -- 3) WITH CHECK OPTION : 옵션을 설정한 컬럼의 값을 수정 불가능하게 함
 * 
 * -- 4) WITH READ ONLY : 뷰에 대해 조회만 가능(DML 수행 불가)
 * 
 * */

--사번, 이름, 부서명, 직급명 조회 결과를 저장하는 VIEW 생성하기
CREATE VIEW V_EMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE= DEPT_ID)
JOIN JOB USING(JOB_CODE);
--ORA-01031: 권한이 불충분합니다
-- 1) SYS 관리자 계정에 접속하기
-- 2) ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; -> 예전 버전 사용 가능하도록 하는 구문
-- 3) GRANT CREATE VIEW TO kh_ksy; -> CREATE VIEW 권한 부여
-- 4) 권한부여받은 kh계정으로 다시 접속해서 위 VIEW 생성 구문 다시 실행하기




ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
GRANT CREATE VIEW TO kh_ksy; 



-- 생성된 VIEW를 이용해 조회해보기
SELECT * FROM V_EMP;




--------------------------------------------------------------------------------------
--OR REPLACE 확인 + 별칭 등록
CREATE VIEW V_EMP
AS SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_TITLE 부서명, JOB_NAME 직급명 
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE= DEPT_ID)
JOIN JOB USING(JOB_CODE);
--ORA-00955: 기존의 객체가 이름을 사용하고 있습니다.


CREATE OR REPLACE VIEW V_EMP 
AS SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_TITLE 부서명, JOB_NAME 직급명 
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE= DEPT_ID)
JOIN JOB USING(JOB_CODE);
--> 기존 V_EMP를 새로운 VIEW로 덮어씌움 OR REPLACE를 사용해서

--------------------------------------------------------------------------------------
-- * VIEW를 이용한 DML 확인 **

-- 테이블 복사
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPARTMENT;

--복사한 테이블을 이용해 VIEW 생성하기
CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2;

--뷰 생성 확인
SELECT * FROM V_DCOPY2;


--VIEW를 이용한 INSERT
INSERT INTO V_DCOPY2 VALUES('D0', 'L3');
--오류 없음

SELECT * FROM V_DCOPY2;
--'DO'랑 'L3'가 삽입 됨
-- > 가상 테이블인 VIEW가 아니라 진짜 테이블(DEPT_COPY2)에 삽입되버림

--원본 테이블 확인
SELECT * FROM DEPT_COPY2;
--> VIEW에 삽입한 내용이 원본 테이블에 존재함
--> VIEW를 이용한 DML구문이 원본에 영향을 미친다!


--VIEW의 원래 목적인 "조회"에 맞게 사용해야 한다.
--> WITH READ ONLY 옵션 사용하기


CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2
WITH READ ONLY; --읽기 전용 뷰가 됨(SELECT만 가능함)

--VIEW를 이용한 INSERT
INSERT INTO V_DCOPY2 VALUES('D0', 'L3');
--ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.

SELECT * FROM V_DCOPY2;
--조회는 가능함




-------------------------------------------------------------------------
--SEQUENCE

CREATE TABLE EMP_TEMP
AS SELECT EMP_ID, EMP_NAME FROM EMPLOYEE; 

SELECT * FROM EMP_TEMP;

CREATE SEQUENCE SEQ_TEMP
START WITH 223    --223에서 시작
INCREMENT BY 10   --10씩 증가
NOCYCLE           --반복X(기본값)
NOCACHE;          --캐시X(CACHE 기본값 20 적용됨)


--EMP_TEMP 테이블에 사원 정보 삽입
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '홍길동'); --223
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '고길동'); --233
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '김길동'); --243


SELECT * FROM EMP_TEMP 
ORDER BY EMP_ID DESC;




---------------------------------------------------------------------------
--SEQUENCE 수정
/*
 * 
 * ALTER SEQUENCE 시퀀스이름
 * [INCREMENT BY숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
 * [MAXVALUE | NOMAXVALUE] -- 발생시킬 최대값 지정(10의 27승 -1)
 * [MINVALUE | NOMINVALUE] --최소값 지정(-10의 26승)
 * [CYCLE | NOCYCLE] --값 순환 여부 지정
 * [CACHE 바이트 크기| NOCACHE] --캐시 메모리 기본값은 20바이트, 최소값은 2바이트
 * 
 * */

--SEQ_TEMP를 1씩 증가하는 형태로 변경
ALTER SEQUENCE SEQ_TEMP
INCREMENT BY 1;

INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '이길동');
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '박길동');
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '최길동');

SELECT * FROM EMP_TEMP ORDER BY 1 DESC;


-- 테이블, 뷰, 시퀀스 삭제
DROP TABLE EMP_TEMP;

DROP VIEW V_DCOPY2;

DROP SEQUENCE SEQ_TEMP;




















