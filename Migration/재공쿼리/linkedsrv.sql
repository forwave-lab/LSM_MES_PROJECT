/*****************���� ����(����) ****************************/
--1. ����Ǿ� �ִ� ��ũ�� ���� ����
----������� ����
EXEC sp_droplinkedsrvlogin 
        @rmtsrvname='bizentrosa',  -- �α��� �������뼭���̸�, �⺻�� ����
       @locallogin = NULL; -- ������ �α��� �̸�, �⺻�� ����

-----���� ����
EXEC sp_dropserver 
        @server='ERPDB';  -- ������ ��ũ�� �����̸�, �⺻�� ����

 --2. �ű� ��ũ�� ���� ���
-----��ũ�� ���� ���-----------------------------
 --�������
EXEC sp_addlinkedserver 
        @server='ERPDB',  -- ��ũ�� �����̸�, �⺻�� ����
       @srvproduct = '', -- OLEDB ������ ���� ��ǰ �̸�, �⺻�� NULL, ODBC ���� �̸�
       @provider = 'SQLOLEDB', -- ������ ���� �ĺ���
       @datasrc = '127.0.0.1,11433', -- ������ ���� �̸� �Ǵ� ������ �� ��Ʈ(ex : 192.168.29.222,14333 )     
        @provstr='',   -- OLEDB ������ ���� ���ڿ�, �⺻�� NULL
        @catalog='lsmDB';   -- ������ ���� ī�ٷα�, ������ ���̽� �̸�

 
--������� ���
EXEC sp_addlinkedsrvlogin
       @rmtsrvname = 'ERPDB',  -- ��ũ�� �����̸�, �⺻�� ����
       @useself = 'false',  -- �α����̸� �������, �⺻�� true
        @locallogin = NULL,  -- ���ü��� �α��� ����, �⺻�� NULL
       @rmtuser = 'bizentrosa',  -- ������̸�
       @rmtpassword = 'Bizsqlsa@2022!';  -- ����� ��ȣ
       
--���� ��� Ȯ��
SELECT * FROM master.dbo.sysservers WHERE srvname = 'ERPDB';
SELECT * FROM master.sys.linked_logins WHERE remote_name = 'bizentrosa';       

 --3. �����Ͱ� ���������� ��ȸ �Ǵ��� Ȯ��.
-- ������ Ȯ��
 select top 10 * from  [linkservername].[dbname].[DBO].TB_TEST ;

/*****************���� ����(��) ****************************/
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

   







