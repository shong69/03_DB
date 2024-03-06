--TCL(TRANSACTION CONTROL LANGUAGE) : 트랜젝션 제어 언어
-- COMMIT(트랜젝션 종료 후 저장), ROLLBACK(트랜젝션 취소), SAVEPOINTN(임시저장)


--DML = 데이터 조작 언어로, 데이터의 삽입, 수정, 삭제를 함
--> 트랜젝션은 DML과 관련됨

/* TRANSACTION이란?
 * - 데이터베이스의 논리적 연산 단위
 * 
 * - 데이터의 변경 사항을 묶어서 하나의 트랜젝션에 담아 처리함
 * - 트랜젝션의 관리 대상이 되는 데이터 변경사항 : INSERT, UPDATE, DELETE, MERGE
 * 
 * 
 * INSERT 수행 --------------------------------------------------> DB 반영 (X)
 * 
 * INSERT 수행-------------> 트랜젝션에 추가--->COMMIT-----------> DB 반영 (O)
 * 
 * INSERT 10번 수행-> 1개 트랜젝션에 10개 추가되어있음 ->ROLLBACK->DB 반영 (X)
 * 
 * 
 * 1) COMMIT : 메모리 버퍼(트랜젝션)에 임시 저장된 데이터 변경사항을 실제로 DB에 반영하는 역할
 * 
 * 2) ROLLBACK : 메모리 버퍼(트랜젝션)에 임시 저장된 데이터 변경사항을 삭제하고
 * 							마지막 COMMIT 상태로 돌아감( DB에 변경내용 반영되지 않음)
 * 3) SAVEPOINT : 메모리 버퍼(트랜젝션)에 저장 지점을 정의하여 ROLLBACK 수행 시 전체 작업을
 * 							삭제하는 것이 아니고, 저장지점까지만 일부 ROLLBACK할 수 있다
 * 		
 * 	[SAVEPOINT 사용방법]
 * 
 * 			...
 * 	SAVEPOINT "포인트명1"; --포인트 명으로 저장됨
 * 			...
 * 	SAVEPOINT "포인트명2"; 
 * 			...
 * 	ROLLBACK TO "포인트명1";  -->포인트1 지점 이후의 데이터 변경사항이 삭제됨
 * 
 * ** SAVEPOINT 지정 및 호출 시 이름에 ""(쌍따옴표) 붙여야 함 **
 * 
 * 
 * 
 * */




-- 새로운 데이터 INSERT
SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');



--INSERT 확인
SELECT * FROM DEPARTMENT2;

-->DB에 반영된 것처럼 보이지만 실제로는 아님
-->SQL수행 시 트랜젝션 내용도 포함해서 수행되기 때문임

--ROLLBACK으로 DB반영여부 확인하기
ROLLBACK; --개발팀 없삼

--COMMIT 후 ROLLBACK 되는지 확인
INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');

SELECT * FROM DEPARTMENT2;

COMMIT;

ROLLBACK;  --개발팀 데이터 안날라감 COMMIT하면서 DB 반영됨



------------------------------------------------------------------------
--SAVEPOINT 확인

INSERT INTO DEPARTMENT2 VALUES('T4', '개발4팀', 'L2');
SAVEPOINT "SP1";  --SAVEPOINT 지정

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP2";  --SAVEPOINT 지정

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP3";  --SAVEPOINT 지정


ROLLBACK TO "SP1";

SELECT * FROM DEPARTMENT2;  --개발4팀까지만 나와있음

ROLLBACK TO "SP3"; --ROLLBACK 후엔 이후 SAVEPOINT는 적용 불가
--ORA-01086: 'SP3' 저장점이 이 세션에 설정되지 않았거나 부적합합니다.
-->ROLLBACK TO "SP1" 구문 실행 시 SP2, SP3도 삭제됨






INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP2"; 
INSERT INTO DEPARTMENT2 VALUES('T5', '개발6팀', 'L2');
SAVEPOINT "SP3"; 

SELECT * FROM DEPARTMENT2;

--개발팀 전체 삭제해보기
DELETE FROM DEPARTMENT2
WHERE DEPT_ID LIKE 'T%';

SELECT * FROM DEPARTMENT2;

--SP2지점까지 ROLLBACK
ROLLBACK TO "SP2"; --개발 6팀만 ROLLBACK
SELECT * FROM DEPARTMENT2;
--SP1지점까지 ROLLBACK
ROLLBACK TO "SP1"; --개발 5팀만 ROLLBACK
SELECT * FROM DEPARTMENT2; 

--ROLLBACK 수행

ROLLBACK;
SELECT * FROM DEPARTMENT2; 
--개발 1,2,3팀만 남음
































