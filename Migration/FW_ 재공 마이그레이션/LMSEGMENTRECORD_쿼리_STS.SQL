/*
동관 UMLOT

SELECT * FROM EQUIPMENT
 WHERE SHOPID = 'JCU'

SELECT * FROM UDT_RECEIPT
 WHERE RECEIPTNO = '12862'
   AND PONO = '34368-2-3-1'

SELECT * FROM UDT_SEMIITEM
 WHERE SEMIID = '180904-h001'
*/
SELECT	CONVERT(CHAR(23), A.ACTDTTM, 21)	AS TableSysID,
		A.LOTID			AS LotID,
		A.PROCID		AS SegmentID,
		B.PROCDESC		AS SegmentName,
		'LSM'			AS Site,
		'PB1'			AS FacilityID,
		E.WORKORDER		AS WorkOrderID,
		A.EQPTID		AS EquipmentID,				-- ?설비 UPDATE
		D.EQPTDESC		AS EquipmentName,			-- 설비명
		CASE WHEN A.PROCID = 'P105' THEN 1
		     ELSE CONVERT(INT, RIGHT(A.PROCID, 3)) END		AS Opr_CD,					-- ?공정코드 앞 1자리 제외 후 적용?
		0				AS HoldSeq,
		0				AS RepeatCount,
		'Y'				AS IsCompleted,
		''				AS CarrierID,
		A.PRODID		AS ProductID,
		NULL			AS StandardTime,
		NULL			AS ActualTime,
		1				AS LotCnt,
		NULL			AS RActualTime,
		''				AS BilletNo,
		''			AS JobNo,
		''	AS PalletNo,
		--''				AS PalletNo,
		A.SHIFT			AS ShiftID,
		A.LOTLENGTH		AS PLength,
		C.UNITWEIGHT		AS InputWeight,		-- ?단중
		C.UNITWEIGHT	AS OutputWeight,		-- ?단중
		''				AS InputBasketID,
		''				AS OutputBasketID,
		-- 1번원자재
		(SELECT Z.HEATNO FROM UDT_SEMIITEM Z WHERE Z.SHOPID = F.SHOPID AND Z.SEMIID = F.SEMIID)	AS InputRawMaterial1,
		(SELECT Z.REALTHICKNESS FROM UDT_SEMIITEM Z WHERE Z.SHOPID = F.SHOPID AND Z.SEMIID = F.SEMIID)	AS InputRawMaterial1Thickness,
		(SELECT Z.REALWIDTH FROM UDT_SEMIITEM Z WHERE Z.SHOPID = F.SHOPID AND Z.SEMIID = F.SEMIID)	AS InputRawMaterial1Width,
		(SELECT Z.REALLENGTH FROM UDT_SEMIITEM Z WHERE Z.SHOPID = F.SHOPID AND Z.SEMIID = F.SEMIID)	AS InputRawMaterial1Length,
		F.SEMIID		AS InputRawMaterial1Lot,
		''				AS InputRawMaterial1BPID,
		(SELECT MAX(Z.SUPPLIER) FROM UDT_SEMIITEM Q, UDT_RECEIPT Z
		  WHERE Q.SHOPID = F.SHOPID AND Q.SEMIID = F.SEMIID
		    AND Q.SHOPID = Z.SHOPID AND Q.RECEIPTNO = Z.RECEIPTNO AND Q.PONO = Z.PONO)					AS InputRawMaterial1BPName,
		(SELECT Z.ITEMCODE FROM UDT_SEMIITEM Z WHERE Z.SHOPID = F.SHOPID AND Z.SEMIID = F.SEMIID)		AS InputRawMaterial1MProductID,
		-- 2번원자재
		(SELECT Z.HEATNO FROM UDT_SEMIITEM Z WHERE Z.SHOPID = G.SHOPID AND Z.SEMIID = G.SEMIID)			AS InputRawMaterial2,
		(SELECT Z.REALTHICKNESS FROM UDT_SEMIITEM Z WHERE Z.SHOPID = G.SHOPID AND Z.SEMIID = G.SEMIID)	AS InputRawMaterial2Thickness,
		(SELECT Z.REALWIDTH FROM UDT_SEMIITEM Z WHERE Z.SHOPID = G.SHOPID AND Z.SEMIID = G.SEMIID)		AS InputRawMaterial2Width,
		(SELECT Z.REALLENGTH FROM UDT_SEMIITEM Z WHERE Z.SHOPID = G.SHOPID AND Z.SEMIID = G.SEMIID)		AS InputRawMaterial2Length,
		G.SEMIID		AS InputRawMaterial2Lot,
		''				AS InputRawMaterial2BPID,
		(SELECT MAX(Z.SUPPLIER) FROM UDT_SEMIITEM Q, UDT_RECEIPT Z
		  WHERE Q.SHOPID = G.SHOPID AND Q.SEMIID = G.SEMIID
		    AND Q.SHOPID = Z.SHOPID AND Q.RECEIPTNO = Z.RECEIPTNO AND Q.PONO = Z.PONO)					AS InputRawMaterial2BPName,
		(SELECT Z.ITEMCODE FROM UDT_SEMIITEM Z WHERE Z.SHOPID = G.SHOPID AND Z.SEMIID = G.SEMIID)		AS InputRawMaterial2MProductID,
		-- 3번원자재
		(SELECT Z.HEATNO FROM UDT_SEMIITEM Z WHERE Z.SHOPID = H.SHOPID AND Z.SEMIID = H.SEMIID)			AS InputRawMaterial3,
		(SELECT Z.REALTHICKNESS FROM UDT_SEMIITEM Z WHERE Z.SHOPID = H.SHOPID AND Z.SEMIID = H.SEMIID)	AS InputRawMaterial3Thickness,
		(SELECT Z.REALWIDTH FROM UDT_SEMIITEM Z WHERE Z.SHOPID = H.SHOPID AND Z.SEMIID = H.SEMIID)		AS InputRawMaterial3Width,
		(SELECT Z.REALLENGTH FROM UDT_SEMIITEM Z WHERE Z.SHOPID = H.SHOPID AND Z.SEMIID = H.SEMIID)		AS InputRawMaterial3Length,
		H.SEMIID		AS InputRawMaterial3Lot,
		''				AS InputRawMaterial3BPID,
		(SELECT MAX(Z.SUPPLIER) FROM UDT_SEMIITEM Q, UDT_RECEIPT Z
		  WHERE Q.SHOPID = H.SHOPID AND Q.SEMIID = H.SEMIID
		    AND Q.SHOPID = Z.SHOPID AND Q.RECEIPTNO = Z.RECEIPTNO AND Q.PONO = Z.PONO)					AS InputRawMaterial3BPName,
		(SELECT Z.ITEMCODE FROM UDT_SEMIITEM Z WHERE Z.SHOPID = H.SHOPID AND Z.SEMIID = H.SEMIID)		AS InputRawMaterial3MProductID,
		-- 4번원자재
		(SELECT Z.HEATNO FROM UDT_SEMIITEM Z WHERE Z.SHOPID = I.SHOPID AND Z.SEMIID = I.SEMIID)			AS InputRawMaterial4,
		(SELECT Z.REALTHICKNESS FROM UDT_SEMIITEM Z WHERE Z.SHOPID = I.SHOPID AND Z.SEMIID = I.SEMIID)	AS InputRawMaterial4Thickness,
		(SELECT Z.REALWIDTH FROM UDT_SEMIITEM Z WHERE Z.SHOPID = I.SHOPID AND Z.SEMIID = I.SEMIID)		AS InputRawMaterial4Width,
		(SELECT Z.REALLENGTH FROM UDT_SEMIITEM Z WHERE Z.SHOPID = I.SHOPID AND Z.SEMIID = I.SEMIID)		AS InputRawMaterial4Length,
		I.SEMIID		AS InputRawMaterial4Lot,
		''				AS InputRawMaterial4BPID,
		(SELECT MAX(Z.SUPPLIER) FROM UDT_SEMIITEM Q, UDT_RECEIPT Z
		  WHERE Q.SHOPID = I.SHOPID AND Q.SEMIID = I.SEMIID
		    AND Q.SHOPID = Z.SHOPID AND Q.RECEIPTNO = Z.RECEIPTNO AND Q.PONO = Z.PONO)					AS InputRawMaterial4BPName,
		(SELECT Z.ITEMCODE FROM UDT_SEMIITEM Z WHERE Z.SHOPID = I.SHOPID AND Z.SEMIID = I.SEMIID)		AS InputRawMaterial4MProductID,
		''				AS OutSideWeldingProductID,
		0				AS OutSideWeldingConsumeQty,
		''				AS OutSideFluxID,
		0				AS OutSideFluxConsumeQty,
		''				AS InSideWeldingProductID,
		0				AS InSideWeldingConsumeQty,
		''				AS InSideFluxID,
		0				AS InSideFluxConsumeQty,
		0				AS FullDiameterMax,
		0				AS FullDiameterMin,
		0				AS FullDiameterAvg,
		0				AS ThicknessMax,
		0				AS ThicknessMin,
		0				AS ThicknessAvg,
		0				AS InnerDiameterMax,
		0				AS InnerDiameterMin,
		0				AS InnerDiameterAvg,
		0				AS ThreadMax,
		0				AS ThreadMin,
		0				AS ThreadAvg,
		0				AS BottomThicknessMax,
		0				AS BottomThicknessMin,
		0				AS BottomThicknessAvg,
		0				AS ScrapQty,
		0				AS UseQty,
		0				AS PassQty,
		0				AS DefectQty,
		''				AS DefectCode,
		''				AS DefectSegmentID,
		''				AS DefectDesc,
		''				AS DefectUTQty,
		''				AS Mold,
		0				AS UTQty,
		C.UNITWEIGHT	AS UnitWeight,
		0				AS DrawingUnitWeight,
		0				AS DrawingPassCount,
		0				AS BasketDivide,
		0				AS CoilDivide,
		0				AS ParentPipeSize,
		''				AS ChillTubeNo_A,
		''				AS ChillTubeNo_B,
		''				AS ChillTubeNo_C,
		''				AS Oring,
		''				AS RollNo,
		0				AS RollingSpeed,
		''				AS AppearanceCondition,
		0				AS RollUseQty,
		0				AS MTipUseQty,
		0				AS WorkNo,
		0				AS HeatLotNo,
		''				AS SPurge,
		''				AS HeatTemperature1,
		''				AS HeatTemperature2,
		''				AS CycleTime,
		''				AS Oxygen,
		''				AS Shorter,
		''				AS Combined,
		''				AS STDIns,
		''				AS FilmType,
		0				AS STDFilmQty,
		0				AS FilmQty,
		''				AS PicklingNo,
		0				AS CastingSpeed,
		0				AS CastingTemp,
		NULL			AS Coolant_1st_Temp_A,
		NULL			AS Coolant_1st_Temp_B,
		NULL			AS Coolant_1st_Temp_C,
		NULL			AS Coolant_2nd_Temp_A,
		NULL			AS Coolant_2nd_Temp_B,
		NULL			AS Coolant_2nd_Temp_C,
		NULL			AS Coolant_Entrance_Temp,
		NULL			AS Roll_Coolant_Pressure,
		NULL			AS Roll_Coolant_Temperature,
		NULL			AS Tube_Coolant_Pressure,
		NULL			AS Tube_Coolant_Temperature,
		NULL			AS Main_Drive_RPM,
		NULL			AS Main_Drive_Current,
		NULL			AS Main_Drive_Vibration_1,
		NULL			AS Main_Drive_Vibration_2,
		NULL			AS Superimposed_Drive_RPM,
		NULL			AS Superimposed_Drive_Current,
		NULL			AS Superimposed_Drive_Vibration,
		NULL			AS DrawingSpeed_1st,
		NULL			AS DrawingSpeed_2nd,
		NULL			AS MainMotorCurrent_1st,
		NULL			AS MainMotorCurrent_2nd,
		NULL			AS MainMotorVibration_1st,
		NULL			AS MainMotorVibration_2nd,
		NULL			AS ScadaIFSysID,
		NULL			AS StartTime,				-- ?종료시간 - AT TIME? 
		NULL			AS EndTime,					-- ?종료시간?
		NULL			AS InsResult1,
		NULL			AS InsResult2,
		NULL			AS InsResult3,
		NULL			AS InsResult4,
		NULL			AS InsResult5,				-- ?밀링일 때 작업일보의 개선현상 넣기 코드 UPDATE?
		NULL			AS InsResult6,
		NULL			AS InsResult7,
		NULL			AS InsResult8,
		NULL			AS InsResult9,
		NULL			AS InsResult10,
		NULL			AS InsResult11,
		NULL			AS InsResult12,
		NULL			AS InsResult13,
		NULL			AS InsResult14,
		NULL			AS InsResult15,
		NULL			AS InsResult16,
		NULL			AS InsResult17,
		NULL			AS InsResult18,
		NULL			AS InsResult19,
		NULL			AS InsResult20,
		NULL			AS TubeNo,
		'N'				AS DELETE_FLAG,
		'마이그레이션'	AS Comments,
		''				AS ExecuteService,
		''				AS OriginalExecuteService,
		''				AS ActionCode,
		'Y'				AS IsUsable,
		A.USERID		AS CreateUser,
		A.ACTDTTM		AS CreateTime,
		A.USERID		AS UpdateUser,
		A.ACTDTTM		AS UpdateTime,
		A.ACTDTTM		AS LastEventTime			-- * String Convert 필요 *
  FROM	WIP WIP			INNER JOIN WIPHISTORY A (nolock)	ON	A.SHOPID	= WIP.SHOPID
												AND	A.LOTID		= WIP.LOTID
						INNER JOIN	PROCESS B	ON	B.SHOPID	= A.SHOPID
												AND	B.PROCID	= A.PROCID
						INNER JOIN	PRODUCT C	ON	C.SHOPID	= A.SHOPID
												AND	C.PRODID	= A.PRODID
						--INNER JOIN	PROCESSEQUIPMENT C	ON	C.SHOPID	= A.SHOPID
						--								AND	C.PROCID	= A.PROCID
						INNER JOIN	EQUIPMENT D (nolock)	ON	D.SHOPID	= A.SHOPID
												AND	D.EQPTID	= A.EQPTID
												AND	D.EQPTIUSE	= 'Y'
						INNER JOIN UDT_WORKORDER E (nolock)	ON	E.SHOPID	= A.SHOPID
													AND	E.WORKORDER	= A.ROUTID
						LEFT JOIN UDT_SEMIUSE F (nolock)	ON	F.SHOPID	= A.SHOPID			-- 첫번째 원자재
												AND	F.WORKORDER	= A.WORKORDER
												AND	F.SUBNO		= A.SUBNO
												AND	F.SEQ		= '1'
						LEFT JOIN UDT_SEMIUSE G (nolock)	ON	G.SHOPID	= A.SHOPID			-- 첫번째 원자재
												AND	G.WORKORDER	= A.WORKORDER
												AND	G.SUBNO		= A.SUBNO
												AND	G.SEQ		= '2'
						LEFT JOIN UDT_SEMIUSE H (nolock)	ON	H.SHOPID	= A.SHOPID			-- 첫번째 원자재
												AND	H.WORKORDER	= A.WORKORDER
												AND	H.SUBNO		= A.SUBNO
												AND	H.SEQ		= '3'
						LEFT JOIN UDT_SEMIUSE I (nolock)	ON	I.SHOPID	= A.SHOPID			-- 첫번째 원자재
												AND	I.WORKORDER	= A.WORKORDER
												AND	I.SUBNO		= A.SUBNO
												AND	I.SEQ		= '4'
 WHERE	WIP.DELETEFLAG	= 'N'
   AND	WIP.WIPTERM	= 'N'
   AND  WIP.SHOPID	= 'PSTS'
   AND	A.DELETEFLAG	= 'N'
   --AND	WIP.ROUTID	= '180403-8598'		-- 추후 WHERE에서 제외
   --AND	WIP.LOTID		= '20180823036001'	-- 추후 WHERE에서 제외

