/*
동관 UMLOT

SELECT * FROM EQUIPMENT
 WHERE SHOPID = 'JCU'
*/
SELECT	'LSM'			AS Site,
		A.LOTID			AS LotID,
		''				AS BilletID,
		''				AS JobNo,
		''				AS Mold,
		''				AS WorkNo,
		''				AS Oring,
		''				AS BasketDivide,
		''				AS CoilDivide,
		C.UNITWEIGHT	AS UnitWeight,		-- 제품 단중
		NULL	AS DrawingUnitWeight,
		NULL	AS ParentPipeSize,
		NULL		AS MarkingEqpID,
		NULL		AS DrawingEqpID,
		NULL		AS FinEqpID,
		''		AS HeatLotNo,
		''		AS HeatTrayNo,
		''		AS IsPacking,
		A.LOTLENGTH		AS Length,
		A.WIPQTY		AS Weight,
		0		AS UTQty,
		0				AS RealUTQty,
		0				AS RealWeight,
		''				AS OriginalProductID,
		''				AS OriginalVendorID,
		CASE WHEN A.PROCID = 'P360'	THEN 'N'		-- 열처리면 Y
			 WHEN A.PROCID > 'P360' OR A.PROCID = 'P255' OR A.PROCID = 'P270' THEN 'Y'		-- 이후 공정이나 RT면 Y
			 ELSE 'N' END	AS FlexibleRouiting230,
		CASE WHEN A.PROCID = 'P375'	THEN 'N'		-- 교정이면 Y
			 WHEN A.PROCID > 'P375' OR A.PROCID = 'P255' OR A.PROCID = 'P270' THEN 'Y'		-- 이후 공정이나 RT면 Y
			 ELSE 'N' END	AS FlexibleRouiting260,
		CASE WHEN A.PROCID = 'P255' OR A.PROCID = 'P270' THEN 'N'		-- RT면 Y
			 WHEN A.PROCID >= 'P380' THEN 'Y'		-- 베벨이후 공정이면 Y
			 ELSE 'N' END	AS FlexibleRouiting270,
		CASE WHEN A.PROCID = 'P380' THEN 'N'		-- 베벨공정이면 N
			 WHEN A.PROCID > 'P380' THEN 'Y'		-- 베벨이후 공정이면 Y
			 ELSE 'N' END	AS FlexibleRouiting300,
		'N'				AS IsHydro,
		'N'				AS Pickling1,
		'N'				AS Pickling2,
		''				AS InsideRemoval,
		''				AS OutsideRemoval,
		'마이그레이션'	AS Comments,
		''				AS ExecuteService,
		''				AS OriginalExecuteService,
		''				AS ActionCode,
		'Usable'		AS IsUsable,
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
 WHERE	A.SHOPID	IN ('PSTS', 'JSTS')
   AND	A.DELETEFLAG	= 'N'
   AND	A.WIPTERM	= 'N'			-- 종료되지 않은 공정 (N, Y)
   AND	A.ROUTID	= '180403-8598'		-- 추후 WHERE에서 제외
   AND	A.LOTID		= '20180823036001'	-- 추후 WHERE에서 제외

