/*****************실행 쿼리(시작) ****************************/
--1. 연결되어 있는 링크드 서버 제거
----연결계정 삭제
EXEC sp_droplinkedsrvlogin 
        @rmtsrvname='bizentrosa',  -- 로그인 매핑적용서버이름, 기본값 없음
       @locallogin = NULL; -- 삭제할 로그이 이름, 기본값 없음

-----서버 삭제
EXEC sp_dropserver 
        @server='ERPDB';  -- 삭제할 링크드 서버이름, 기본값 없음

 --2. 신규 링크드 서버 등록
-----링크드 서버 등록-----------------------------
 --서버등록
EXEC sp_addlinkedserver 
        @server='ERPDB',  -- 링크드 서버이름, 기본값 없음
       @srvproduct = '', -- OLEDB 데이터 원본 제품 이름, 기본값 NULL, ODBC 원본 이름
       @provider = 'SQLOLEDB', -- 공급자 고유 식별자
       @datasrc = '127.0.0.1,11433', -- 데이터 원본 이름 또는 아이피 및 포트(ex : 192.168.29.222,14333 )     
        @provstr='',   -- OLEDB 공급자 연결 문자열, 기본값 NULL
        @catalog='lsmDB';   -- 공급자 연결 카다로그, 데이터 베이스 이름

 
--연결계정 등록
EXEC sp_addlinkedsrvlogin
       @rmtsrvname = 'ERPDB',  -- 링크드 서버이름, 기본값 없음
       @useself = 'false',  -- 로그인이름 사용유무, 기본값 true
        @locallogin = NULL,  -- 로컬서버 로그인 여부, 기본값 NULL
       @rmtuser = 'bizentrosa',  -- 사용자이름
       @rmtpassword = 'Bizsqlsa@2022!';  -- 사용자 암호
       
--서버 등록 확인
SELECT * FROM master.dbo.sysservers WHERE srvname = 'ERPDB';
SELECT * FROM master.sys.linked_logins WHERE remote_name = 'bizentrosa';       

 --3. 데이터가 정상적으로 조회 되는지 확인.
-- 정상동작 확인
 select top 10 * from  [linkservername].[dbname].[DBO].TB_TEST ;

/*****************실행 쿼리(끝) ****************************/
SELECT * FROM ERPDB.lsmDB.dbo.Q_WITNESS_START_CKO112V (NOLOCK);

select * from lsmDB.dbo.Q_WITNESS_START_CKO112V WITH (NOLOCK);

SELECT 
	 PLANT_CD	
	,LOT_NO	
	,OPT_START	
FROM OPENQUERY(
	 [ERPDB],
		'SELECT
			 PLANT_CD	
			,LOT_NO	
			,OPT_START	
		
		FROM
			Q_WITNESS_START_CKO112V
') AS ERP ;

   







