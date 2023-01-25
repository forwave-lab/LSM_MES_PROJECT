/*
���� UMLOT

SELECT * FROM EQUIPMENT
 WHERE SHOPID = 'JCU'
*/
SELECT	'LSM'			AS Site,
		A.LOTID			AS LotID,
		A.BILLETNO		AS BilletID,
		A.JOBNO			AS JobNo,
		ISNULL((SELECT Z.MOLD FROM UDT_BILLETADDINFO Z WHERE Z.BILLETNO = A.BILLETNO), '')	AS Mold,
		(SELECT LA.LATTVALUE  FROM    LOTATT LA  with (nolock) WHERE LA.SHOPID = A.SHOPID AND LA.LOTID = A.LOTID AND LA.LATTITEM = 'IAWORKNO' )	AS WorkNo,
		ISNULL((SELECT Z.ORING FROM UDT_BILLETADDINFO_C210 Z WHERE Z.BILLETNO = A.BILLETNO), '')	AS Oring,
		A.SUBNO			AS BasketDivide,
		A.COILDIVIDE	AS CoilDivide,
		A.LOTUNITWEIGHT	AS UnitWeight,
		(SELECT convert(float,isnull(LA.LATTVALUE,'0'))  FROM    LOTATT LA  with (nolock)
		  WHERE LA.SHOPID = A.SHOPID AND LA.LOTID = A.LOTID AND LA.LATTITEM = 'UNITWEIGHT_DRAW' ) / 2	AS DrawingUnitWeight,
		(SELECT LA.LATTVALUE  FROM    LOTATT LA  with (nolock)
		  WHERE LA.SHOPID = A.SHOPID AND LA.LOTID = A.LOTID AND LA.LATTITEM = 'PARENT_PIPESIZE' )	AS ParentPipeSize,
		ISNULL((
			SELECT MAX(Z.EQPTID) FROM WIPHISTORY Z
			 WHERE Z.SHOPID	= A.SHOPID
			   AND Z.LOTID	= A.LOTID
			   AND Z.PROCID	IN ('C340','C350')
		), '')	AS MarkingEqpID,			--?������ִ��� Ȯ�� �� �־��ٰ�, ��������
		ISNULL((
			SELECT MAX(Z.EQPTID) FROM WIPHISTORY Z
			 WHERE Z.SHOPID	= A.SHOPID
			   AND Z.LOTID	= A.LOTID
			   AND Z.PROCID	IN ('C310')
		), '')	AS DrawingEqpID,			--?�ι�ȣ��		UPDATE �ʿ�
		ISNULL((
			SELECT MAX(Z.EQPTID) FROM WIPHISTORY Z
			 WHERE Z.SHOPID	= A.SHOPID
			   AND Z.LOTID	= A.LOTID
			   AND Z.PROCID	IN ('C330')
		), '')	AS FinEqpID,				--?FINȣ��		UPDATE �ʿ�
		''		AS HeatLotNo,
		''		AS HeatTrayNo,
		'N'		AS IsPacking,
		A.LOTLENGTH		AS Length,
		A.WIPQTY		AS Weight,
		A.LOTFAULT		AS UTQty,
		0				AS RealUTQty,
		0				AS RealWeight,
		A.PRODID		AS OriginalProductID,
		''				AS OriginalVendorID,		-- UPDATE �ʿ�
		E.CUSTOMER		AS OriginalVendorName,
		''				AS FlexibleRouiting230,
		''				AS FlexibleRouiting260,
		''				AS FlexibleRouiting270,
		''				AS FlexibleRouiting300,
		'N'				AS IsHydro,
		'N'				AS Pickling1,
		'N'				AS Pickling2,
		''				AS InsideRemoval,
		''				AS OutsideRemoval,
		'���̱׷��̼�'	AS Comments,
		''				AS ExecuteService,
		''				AS OriginalExecuteService,
		''				AS ActionCode,
		'Y'				AS IsUsable,
		(SELECT MAX(Z.USERID) FROM WIPACTHISTORY Z WHERE Z.SHOPID = A.SHOPID AND Z.LOTID = A.LOTID)	AS CreateUser,
		A.CREATEDTTM	AS CreateTime,
		ISNULL((SELECT MAX(Z.USERID) FROM WIPACTHISTORY Z WHERE Z.SHOPID = A.SHOPID AND Z.LOTID = A.LOTID AND Z.PROCID = A.PROCID_PREV), '')	AS UpdateUser,
		ISNULL((SELECT MAX(Z.CREATEDTTM) FROM WIPACTHISTORY Z WHERE Z.SHOPID = A.SHOPID AND Z.LOTID = A.LOTID), '')	AS UpdateTime,
		ISNULL((SELECT MAX(Z.CREATEDTTM) FROM WIPACTHISTORY Z WHERE Z.SHOPID = A.SHOPID AND Z.LOTID = A.LOTID), '')	AS LastEventTime,
		*
  FROM	WIP A			INNER JOIN	PROCESS B	ON	B.SHOPID	= A.SHOPID
												AND	B.PROCID	= A.PROCID
						INNER JOIN	PRODUCT C	ON	C.SHOPID	= A.SHOPID
												AND	C.PRODID	= A.PRODID
						INNER JOIN UDT_WORKORDER E	ON	E.SHOPID	= A.SHOPID
													AND	E.WORKORDER	= A.ROUTID
 WHERE	A.SHOPID	= 'JCU'
   AND	A.DELETEFLAG	= 'N'
   AND	A.WIPTERM	= 'N'			-- ������� ���� ���� (N, Y)
   --AND	A.ROUTID	= '180907-9039'		-- ���� WHERE���� ����
   --AND	A.LOTID		= '20211103000101'	-- ���� WHERE���� ����

