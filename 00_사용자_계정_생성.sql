
--한 줄 주석
/*
 * 범위 주석
 * */


--1. 11G버전 이전의 문법을 사용 가능하도록 함
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- CTRL + ENTER : 선택한 sql 수행

--2. 사용자 계정 생성
CREATE USER kh_ksy IDENTIFIED BY kh1234;

--3. 생성한 사용자에 권한 부여하기
GRANT RESOURCE, CONNECT TO kh_ksy;

--4. 객체가 생성될 수 있는 공간 할당량 지정
ALTER USER kh_ksy DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;



