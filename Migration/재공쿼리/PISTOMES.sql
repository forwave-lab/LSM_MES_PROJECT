/*
UMWORKORDER
*/


/*
LMWORKORDERINFO
*/

/*
UMLOT
*/
SELECT	'LSM'			AS Site,
		A.WORKORDER + '-' + CONVERT(VARCHAR(3),A.SUBNO) AS LOTID,
		A.LOTID			AS LotName,
		A.PRODID		AS ProductID,
		1				AS ProductVersion,
		''				AS ProcessNodeSYSID,
		A.PRODID		AS ProcessID,
		--C.PRODDESC		AS ProcessName,
		1				AS ProcessVersion,
		A.PROCID		AS SegmentID,			-- 공정코드
		--B.PROCDESC		AS SegmentName,			-- 공정명
		1				AS SegmentVersion,
		0				AS RepeatCount,
		''				AS NextSegmentID,
		A.WIPQTY_IN		AS OriginalQty,				-- 투입수량
		A.WIPQTY_IN		AS InputQty,				-- 투입수량
		A.WIPQTY_IN		AS WorkInputQty,			-- 투입수량
		A.WIPQTY		AS CurrentQty,
		0				AS DefectQty,
		0				AS LossQty,
		''				AS SegmentRuleID,
		0				AS RuleSequence,
		CASE WHEN A.WIPTERM	= 'N' THEN 'Wait'
		     ELSE 'Run' END			AS ProcessingStateID,		-- ?작업진행 상태  Wait
		CASE WHEN A.WIPTERM	= 'N' THEN 'Release'
		     ELSE 'Complete' END	AS StateID,					-- ?재공이면 Release or Complete
		''				AS TransferStateID,
		1				AS Priority,
		''				AS EquipmentID,				-- 현재설비
		''				AS EquipmentVersion,
		'PB1'			AS FacilityID,
		''				AS CarrierID,
		A.WIPDTTM_IN	AS TrackInTime,
		A.WIPDTTM_IN	AS TrackOutTime,
		''				AS LotGrade,
		''				AS HoldCode,
		'N'				AS IsHold,
		''				AS IsReservedAction,
		'N'				AS IsDivide,
		'N'				AS IsRework,
		''				AS ReworkType,
		''				AS ReworkCompleteSegmentID,
		''				AS ReworkCompleteProcessVersion,
		''				AS ReworkCompleteProcessID,
		''				AS LineID,
		''				AS ProductType,
		''				AS LotCreationType,
		''				AS ParentLotID,
		''				AS RepeatLotID,
		''				AS OriginalLotID,
		''				AS OutSourceLotID,
		''				AS DestLotID,
		''				AS PlantID,
		''				AS ProcessSpeed,
		''				AS ReceivedTime,
		''				AS ReservedEquipmentID,
		''				AS ReservedTime,
		''				AS StepID,
		''				AS StepStartTime,
		''				AS StepEndTime,
		''				AS UnitID,
		E.CUSTOMER		AS VendorID,				-- ?Vendor ID 나중에 UPDATE
		--E.CUSTOMER		AS VendorName,				-- Vendor명
		''				AS DestSite,
		NULL			AS DueDate,
		0				AS LabelPrintCount,
		''				AS OwnSite,
		E.WORKORDER		AS WorkOrderID,
		''				AS PoNo,
		''				AS PoConfirmNo,
		''				AS PrevStateTime,
		E.CUSTOMER		AS CustomerID,				-- ?추후 UPDATE
		--E.CUSTOMER		AS CustomerName,			-- Vendor명
		''				AS PrevStateID,
		''				AS PrevActivity,
		''				AS PrevEquipemntID,			-- 이전설비코드
		''				AS PrevFaciltyID,
		A.PRODID		AS PrevProcessID,
		1				AS PrevProcessVersion,
		A.PRODID		AS PrevProductID,
		A.WIPQTY		AS PrevCurrentQTY,
		A.PROCID_PREV	AS PrevSegmentID,			-- ?추후 UPDATE
		--B.PROCDESC		AS PrevSegmentName,			-- ?이전공정명
		''				AS PrevTrackOutTime,
		'마이그레이션'	AS Comments,
		''				AS ExecuteService,
		''				AS OriginalExecuteService,
		''				AS ActionCode,
		'Usable'		AS IsUsable,
		(SELECT MAX(Z.USERID) FROM WIPACTHISTORY Z WHERE Z.SHOPID = A.SHOPID AND Z.LOTID = A.LOTID)	AS CreateUser,
		A.CREATEDTTM	AS CreateTime,
		ISNULL((SELECT MAX(Z.USERID) FROM WIPACTHISTORY Z WHERE Z.SHOPID = A.SHOPID AND Z.LOTID = A.LOTID AND Z.PROCID = A.PROCID_PREV), '')	AS UpdateUser,
		ISNULL((SELECT MAX(Z.CREATEDTTM) FROM WIPACTHISTORY Z WHERE Z.SHOPID = A.SHOPID AND Z.LOTID = A.LOTID), '')	AS UpdateTime,
		FORMAT(cast((ISNULL((SELECT MAX(Z.CREATEDTTM) FROM WIPACTHISTORY Z WHERE Z.SHOPID = A.SHOPID AND Z.LOTID = A.LOTID), '')) as datetime), 'yyyyMMddHHmmssffff') AS LastEventTime
  FROM	WIP A			INNER JOIN	PROCESS B	ON	B.SHOPID	= A.SHOPID
												AND	B.PROCID	= A.PROCID
						INNER JOIN	PRODUCT C	ON	C.SHOPID	= A.SHOPID
												AND	C.PRODID	= A.PRODID
						--INNER JOIN	PROCESSEQUIPMENT C	ON	C.SHOPID	= A.SHOPID
						--								AND	C.PROCID	= A.PROCID
						--- JOIN	EQUIPMENT D	ON	D.SHOPID	= A.SHOPID
						---						AND	D.EQPTID	= A.EQPTID_PREV
						---						AND	D.EQPTIUSE	= 'Y'
						INNER JOIN UDT_WORKORDER E	ON	E.SHOPID	= A.SHOPID
													AND	E.WORKORDER	= A.ROUTID
 WHERE	A.SHOPID	IN ('PSTS')
   AND	A.DELETEFLAG	= 'N'
   AND	A.WIPTERM	= 'N'	-- 종료되지 않은 공정 (N, Y)
   --AND	A.ROUTID	= '180403-8598'		-- 추후 WHERE에서 제외  
   --AND A.WORKORDER = '210530-7885';
   ;
  
/*
LMLOTINFO
*/
SELECT	'LSM'			AS Site,
		A.WORKORDER + '-' + CONVERT(VARCHAR(3),A.SUBNO) AS LOTID,
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
		C.LENGTH		AS Length,
		--A.WIPQTY		AS Weight,
		C.UNITWEIGHT	AS Weight,
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
		FORMAT(cast((ISNULL((SELECT MAX(Z.CREATEDTTM) FROM WIPACTHISTORY Z WHERE Z.SHOPID = A.SHOPID AND Z.LOTID = A.LOTID), '')) as datetime), 'yyyyMMddHHmmssffff') AS LastEventTime
  FROM	WIP A			INNER JOIN	PROCESS B	ON	B.SHOPID	= A.SHOPID
												AND	B.PROCID	= A.PROCID
						INNER JOIN	PRODUCT C	ON	C.SHOPID	= A.SHOPID
												AND	C.PRODID	= A.PRODID
						INNER JOIN UDT_WORKORDER E	ON	E.SHOPID	= A.SHOPID
													AND	E.WORKORDER	= A.ROUTID
 WHERE	A.SHOPID	IN ('PSTS')
   AND	A.DELETEFLAG	= 'N'
   --AND	A.WIPTERM	= 'N'			-- 종료되지 않은 공정 (N, Y)
   --AND	A.ROUTID	= '180403-8598'		-- 추후 WHERE에서 제외
   --AND	A.LOTID		= '2021122102650'	-- 추후 WHERE에서 제외
   ;
  
  
/*
LMSEGMENTRECORD
*/
SELECT	'SYS' + FORMAT(cast(A.ACTDTTM as datetime), 'yyyyMMddHHmmssffff') AS TableSysID,
		A.WORKORDER + '-' + CONVERT(VARCHAR(3),A.SUBNO) AS LOTID,
		A.PROCID		AS SegmentID,
		--B.PROCDESC		AS SegmentName,
		'LSM'			AS Site,
		'PB1'			AS FacilityID,
		E.WORKORDER		AS WorkOrderID,
		A.EQPTID		AS EquipmentID,				-- ?설비 UPDATE
		--D.EQPTDESC		AS EquipmentName,			-- 설비명
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
		''				AS JobNo,
		--''				AS PalletNo,
		--''				AS PalletNo,
		--A.SHIFT			AS ShiftID,
		CASE WHEN A.SHIFT = 'P001' THEN 'A' WHEN A.SHIFT = 'P002' THEN 'B' ELSE 'C' END ShiftID,
		A.LOTLENGTH		AS PLength,
		C.UNITWEIGHT	AS InputWeight,		-- ?단중
		C.UNITWEIGHT	AS OutputWeight,		-- ?단중
		''				AS InputBasketID,
		''				AS OutputBasketID,		
		-- 1번원자재
		(SELECT Z.HEATNO FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = F.SHOPID AND Z.SEMIID = F.SEMIID)	AS InputRawMaterial1,
		(SELECT Z.REALTHICKNESS FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = F.SHOPID AND Z.SEMIID = F.SEMIID)	AS InputRawMaterial1Thickness,
		(SELECT Z.REALWIDTH FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = F.SHOPID AND Z.SEMIID = F.SEMIID)	AS InputRawMaterial1Width,
		(SELECT Z.REALLENGTH FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = F.SHOPID AND Z.SEMIID = F.SEMIID)	AS InputRawMaterial1Length,
		F.SEMIID		AS InputRawMaterial1Lot,
		--''				AS InputRawMaterial1BPID,
		(SELECT MAX(Z.SUPPLIER) FROM DBO.UDT_SEMIITEM Q, DBO.UDT_RECEIPT Z
		  WHERE Q.SHOPID = F.SHOPID AND Q.SEMIID = F.SEMIID
		    AND Q.SHOPID = Z.SHOPID AND Q.RECEIPTNO = Z.RECEIPTNO AND Q.PONO = Z.PONO)					AS InputRawMaterial1BPID,
		(SELECT Z.ITEMCODE FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = F.SHOPID AND Z.SEMIID = F.SEMIID)		AS InputRawMaterial1MProductID,
		-- 2번원자재
		(SELECT Z.HEATNO FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = G.SHOPID AND Z.SEMIID = G.SEMIID)			AS InputRawMaterial2,
		(SELECT Z.REALTHICKNESS FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = G.SHOPID AND Z.SEMIID = G.SEMIID)	AS InputRawMaterial2Thickness,
		(SELECT Z.REALWIDTH FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = G.SHOPID AND Z.SEMIID = G.SEMIID)		AS InputRawMaterial2Width,
		(SELECT Z.REALLENGTH FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = G.SHOPID AND Z.SEMIID = G.SEMIID)		AS InputRawMaterial2Length,
		G.SEMIID		AS InputRawMaterial2Lot,
		--''				AS InputRawMaterial2BPID,
		(SELECT MAX(Z.SUPPLIER) FROM DBO.UDT_SEMIITEM Q, DBO.UDT_RECEIPT Z
		  WHERE Q.SHOPID = G.SHOPID AND Q.SEMIID = G.SEMIID
		    AND Q.SHOPID = Z.SHOPID AND Q.RECEIPTNO = Z.RECEIPTNO AND Q.PONO = Z.PONO)					AS InputRawMaterial2BPID,
		(SELECT Z.ITEMCODE FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = G.SHOPID AND Z.SEMIID = G.SEMIID)		AS InputRawMaterial2MProductID,
		-- 3번원자재
		(SELECT Z.HEATNO FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = H.SHOPID AND Z.SEMIID = H.SEMIID)			AS InputRawMaterial3,
		(SELECT Z.REALTHICKNESS FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = H.SHOPID AND Z.SEMIID = H.SEMIID)	AS InputRawMaterial3Thickness,
		(SELECT Z.REALWIDTH FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = H.SHOPID AND Z.SEMIID = H.SEMIID)		AS InputRawMaterial3Width,
		(SELECT Z.REALLENGTH FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = H.SHOPID AND Z.SEMIID = H.SEMIID)		AS InputRawMaterial3Length,
		H.SEMIID		AS InputRawMaterial3Lot,
		--''				AS InputRawMaterial3BPID,
		(SELECT MAX(Z.SUPPLIER) FROM DBO.UDT_SEMIITEM Q, DBO.UDT_RECEIPT Z
		  WHERE Q.SHOPID = H.SHOPID AND Q.SEMIID = H.SEMIID
		    AND Q.SHOPID = Z.SHOPID AND Q.RECEIPTNO = Z.RECEIPTNO AND Q.PONO = Z.PONO)					AS InputRawMaterial3BPID,
		(SELECT Z.ITEMCODE FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = H.SHOPID AND Z.SEMIID = H.SEMIID)		AS InputRawMaterial3MProductID,
		-- 4번원자재
		(SELECT Z.HEATNO FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = I.SHOPID AND Z.SEMIID = I.SEMIID)			AS InputRawMaterial4,
		(SELECT Z.REALTHICKNESS FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = I.SHOPID AND Z.SEMIID = I.SEMIID)	AS InputRawMaterial4Thickness,
		(SELECT Z.REALWIDTH FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = I.SHOPID AND Z.SEMIID = I.SEMIID)		AS InputRawMaterial4Width,
		(SELECT Z.REALLENGTH FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = I.SHOPID AND Z.SEMIID = I.SEMIID)		AS InputRawMaterial4Length,
		I.SEMIID		AS InputRawMaterial4Lot,
		--''				AS InputRawMaterial4BPID,
		(SELECT MAX(Z.SUPPLIER) FROM DBO.UDT_SEMIITEM Q, DBO.UDT_RECEIPT Z
		  WHERE Q.SHOPID = I.SHOPID AND Q.SEMIID = I.SEMIID
		    AND Q.SHOPID = Z.SHOPID AND Q.RECEIPTNO = Z.RECEIPTNO AND Q.PONO = Z.PONO)					AS InputRawMaterial4BPID,
		(SELECT Z.ITEMCODE FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = I.SHOPID AND Z.SEMIID = I.SEMIID)		AS InputRawMaterial4MProductID,		
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
		WIP.WIPDTTM_ED	AS StartTime,				-- ?종료시간 - AT TIME? 
		WIP.WIPDTTM_ED	AS EndTime,					-- ?종료시간?
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
		'마이그레이션'	    AS Comments,
		''				AS ExecuteService,
		''				AS OriginalExecuteService,
		''				AS ActionCode,
		'Usable'		AS IsUsable,
		A.USERID		AS CreateUser,
		A.ACTDTTM		AS CreateTime,
		A.USERID		AS UpdateUser,
		A.ACTDTTM		AS UpdateTime,
		FORMAT(cast(A.ACTDTTM as datetime), 'yyyyMMddHHmmssffff') AS LastEventTime			-- * String Convert 필요 *
  FROM	DBO.WIP WIP			
  						INNER JOIN DBO.WIPHISTORY A (nolock)	ON	A.SHOPID	= WIP.SHOPID
												AND	A.LOTID		= WIP.LOTID
						INNER JOIN	DBO.PROCESS B	ON	B.SHOPID	= A.SHOPID
												AND	B.PROCID	= A.PROCID
						INNER JOIN	DBO.PRODUCT C	ON	C.SHOPID	= A.SHOPID
												AND	C.PRODID	= A.PRODID
						--INNER JOIN	PROCESSEQUIPMENT C	ON	C.SHOPID	= A.SHOPID
						--								AND	C.PROCID	= A.PROCID
						INNER JOIN	DBO.EQUIPMENT D (nolock)	ON	D.SHOPID	= A.SHOPID
												AND	D.EQPTID	= A.EQPTID
												AND	D.EQPTIUSE	= 'Y'
						INNER JOIN DBO.UDT_WORKORDER E (nolock)	ON	E.SHOPID	= A.SHOPID
													AND	E.WORKORDER	= A.ROUTID
						LEFT JOIN DBO.UDT_SEMIUSE F (nolock)	ON	F.SHOPID	= A.SHOPID			-- 첫번째 원자재
												AND	F.WORKORDER	= A.WORKORDER
												AND	F.SUBNO		= A.SUBNO
												AND	F.SEQ		= '1'
						LEFT JOIN DBO.UDT_SEMIUSE G (nolock)	ON	G.SHOPID	= A.SHOPID			-- 첫번째 원자재
												AND	G.WORKORDER	= A.WORKORDER
												AND	G.SUBNO		= A.SUBNO
												AND	G.SEQ		= '2'
						LEFT JOIN DBO.UDT_SEMIUSE H (nolock)	ON	H.SHOPID	= A.SHOPID			-- 첫번째 원자재
												AND	H.WORKORDER	= A.WORKORDER
												AND	H.SUBNO		= A.SUBNO
												AND	H.SEQ		= '3'
						LEFT JOIN DBO.UDT_SEMIUSE I (nolock)	ON	I.SHOPID	= A.SHOPID			-- 첫번째 원자재
												AND	I.WORKORDER	= A.WORKORDER
												AND	I.SUBNO		= A.SUBNO
												AND	I.SEQ		= '4'
 WHERE	WIP.DELETEFLAG	= 'N'
   AND	WIP.WIPTERM	= 'N'
   AND  WIP.SHOPID	= 'PSTS'
   AND	A.DELETEFLAG	= 'N';
   --AND	WIP.ROUTID	= '180403-8598'		-- 추후 WHERE에서 제외
   --AND	WIP.LOTID		= '20180823036001'	-- 추후 WHERE에서 제외
;


SELECT Z.HEATNO FROM DBO.UDT_SEMIITEM Z WHERE Z.SHOPID = 'PSTS' AND Z.SEMIID = '210929-h001';

220110-6863
210929-h001
210929-h002

SELECT * FROM UDT_SEMIUSE I (nolock)	WHERE I.SHOPID	= 'PSTS'			-- 첫번째 원자재
												AND	I.WORKORDER	= '220110-6863'
												AND	I.SUBNO		= A.SUBNO
												AND	I.SEQ		= '4'



												
												

      
