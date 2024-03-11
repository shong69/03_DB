--DDL (DATA DEFINITION LANGUAGE)
--객체를 만들고(CREATE), 바꾸고(ALTER), 삭제(DROP)하는 데이터 정의 언어

/*
 * ALTER (바꾸다, 수정하다, 변조하다)
 * 
 * -- 테이블에서 수정할 수 있는 것
 * 1) 제약 조건(추가/삭제) * 제약조건명은 바꿀 수 있음
 * 2) 컬럼(추가/수정/삭제)
 * 3) 이름 변경(테이블명, 컬럼명,...)
 * 4) 
 * 
 * */

-- 1) 제약조건(추가/삭제)

--[작성법]
-- 1) 추가 : ALTER TABLE 테이블명 
--					ADD [CONSTRAINT 제약조건명] 제약조건 (지정할컬럼명)
--				 [REFERENCES 테이블명[(컬럼명)]; <--FK인 경우 추가
--2) 삭제 : ALTER TBALE 테이블명
--          DROP CONSTRAINT 제약조건명

-- * 제약조건 자체를 수정하는 구문은 별도 존재하지 않음
--> 삭제 후 추가해야 함


--DEPARTMENT 테이블 복사 (컬럼명, 데이터타입, NOT NULL 제약조건만 복사됨)
CREATE TABLE DEPT_COPY 
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;
--DEPT_COPY의 DEPT_TITTLE 컬럼에 UNIQUE 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);



--DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 삭제
ALTER TABLE DEPT_COPY 
DROP CONSTRAINT DEPT_COPY_TITLE_U;




-- *** DEPT_COPY의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가/삭제
ALTER TABLE DEPT_COPY 
ADD CONSTRAINT DEPT_COPY_TITLE_NN NOT NULL(DEPT_TITLE);
--ORA-00904: : 부적합한 식별자
--> 구문이 아예 틀렸다는 의미

--NOT NULL 제약조건은 새로운 조건을 추가하는 것이 아니고, 컬럼 자체에 NULL을 허용할 것인지 아닌지 
--제어하는 성질 변경의 형태로 인식함

--> MODIFY구문을 사용해 NULL 제어 가능함

ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE NOT NULL;

ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE NULL;





---------------------------------------------------------------------------------------------------
-- 2. 컬럼(추가/수정/삭제)

--컬럼 추가
--ALTER TABLE 테이블명 ADD( 추가할컬럼명 데이터 타입[DEFAULT '값']);

--컬럼 수정
--ALTER TABLE TBALE 테이블명 MODIFY 컬럼명 데이터 타입; --> 데이터 타입 변경

--ALTER TABLE MODIFY 컬럼명 DEFAULT '값' -->DEFAULT RKQT QUSRUD

--컬럼 삭제 
--ALTER TABLE 테이블명 DROP (삭제할컬럼명)
--A;TER TABLE 테이블명 DROP COLUMN 삭제할 컬럼명'


--CNAME 컬럼 추가

ALTER TABLE DEPT_COPY ADD(CNAME VARCHAR2(30));

--LNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD(LNAME VARCHAR2(30) DEFAULT '한국');
--> 컬럼이 생성되며 DEFAULT값이 자동 삽입됨


--D10개발1팀 추가
INSERT INTO DEPT_COPY 
VALUES('D10', '개발1팀', 'L1', DEFAULT, DEFAULT);
--ORA-12899: "KH_KSY"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2)

--DEPT_ID 컬럼 데이터 타입 수정
ALTER TABLE DEPT_COPY  MODIFY DEPT_ID VARCHAR2(3);


--LNAME의 기본값을 'KOREA' 로 수정하기
ALTER TABLE DEPT_COPY
MODIFY LNAME DEFAULT 'KOREA';

SELECT * FROM DEPT_COPY;
--기존에 있던 행들이 변경되지는 않는다


--LNAME '한국' -> 'KOREA'로 변경
UPDATE DEPT_COPY SET LNAME = DEFAULT WHERE LNAME = '한국';

SELECT * FROM DEPT_COPY;




COMMIT;



--모든 컬럼 삭제
ALTER TABLE DEPT_COPY DROP(LNAME);
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP (LOCATION_ID);
ALTER TABLE DEPT_COPY DROP (DEPT_TITLE);
ALTER TABLE DEPT_COPY DROP (DEPT_ID);  --ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다

--컬럼 삭제 시 유의사항
--테이블이란? 행과 열로 이뤄진 DB의 가장 기본적인 객체
--						테이블에 데이터가 저장됨
--테이블은 최소 1개 이상의 컬럼이 존재해야 하기 때문에 모든 컬럼을 다 삭제할 수 없다

--테이블 삭제
DROP TABLE DEPT_COPY;



--DEPARTMENT 테이블 복사해서 DEPT_COPY 생성
--DPET_COPY 테이블에 PK 추가(컬럼명 DEPT_ID, 제약조건명 : D_CPPU_PK);

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;
--> 컬럼명, 데이터타입, NOT NULL 여부만 복사
ALTER TABLE DEPT_COPY ADD CONSTRAINT D_COPY_PK PRIMARY KEY(DEPT_ID);




-- 3.  이름 변경(컬럼, 테이블, 제약조건)
-- 1) 컬럼명 변경 (DEPT_TITLE -> DEPT_NAME)
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;
SELECT * FROM DEPT_COPY;

-- 2) 제약조건명 변경( D_COPY_PK -> DEPT_COPY_PK)
ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;
SELECT * FROM DEPT_COPY;

-- 2) 테이블명 변경(DEPT_COPY -> D_COPY)
ALTER TABLE DEPT_COPY RENAME TO D_COPY;

SELECT * FROM D_COPY;



--------------------------------------------------------------------------------------------------

--4. 테이블 삭제

--DROP TABLE 테이블명 [CASCADE CONSTRAINTS];



-- 1) 관계가 형성되지 않은 테이블 삭제하기
DROP TABLE D_COPY;




-- 2) 관계가 형성된 테이블 삭제하기
CREATE TABLE TB1(
	TB1_PK NUMBER PRIMARY KEY,
	TB1_COL NUMBER
);

CREATE TABLE TB2(
	TB2_PK NUMBER PRIMARY KEY,
	TB2_COL NUMBER REFERENCES TB1 --TB1의 PK를 참조한다
);


--TB1에 샘플데이터 삽입하기
INSERT INTO TB1 VALUES(1, 100);
INSERT INTO TB1 VALUES(2, 200);
INSERT INTO TB1 VALUES(3, 300);

COMMIT;
--TB2에 샘플데이터 삽입
INSERT INTO TB2 VALUES(11, 1);
INSERT INTO TB2 VALUES(22, 2);
INSERT INTO TB2 VALUES(33, 3);


--TB1 삭제
DROP TABLE TB1;
--ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
-->해결방법
-- 1) 자식, 부모테이블 순서로 삭제
-- 2) ALTER를 이용해 FK 제약조건 삭제 후 TB1 삭제
-- 3) DROP TABLE 삭제 옵션 CASECASE CONSTRAINT  사용
		--> CASCADE CONSTRAINTS : 삭제하려는 테이블과 연결된 FK 제약조건을 모두 삭제하기

DROP TABLE TB1 CASCADE CONSTRAINTS;
--> 삭제 성공

SELECT * FROM TB1; -- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

SELECT * FROM TB2;




-----------------------------------------------------------------------------------------------






/*DDL 주의사항*/
-- 1) DDL은 COMMIT/ROLLBACK이 되지 않는다
-->  ALTER, DROP, CREATE 신중하게 진행하기

-- 2) DDL 과 DML을 섞어서 수행하면 안된다
-->  DDL은 수행 시 존재하고 있는 트랜젝션을 모두 DB에 강제 COMMIT시킨다
-->  DDL이 종료된 후 DML 구문 수행을 권장함



SELECT * FROM TB2;
COMMIT;

--DML
INSERT INTO TB2 VALUES(44,4); 
INSERT INTO TB2 VALUES(55,5); 


ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLCOL;


ROLLBACK;
SELECT * FROM TB2; --ROLLBACK 해도 ALTER했기 때문에 이전에 추가했던 데이터가 강제로 COMMIT되버림




