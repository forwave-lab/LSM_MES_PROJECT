/*
동관 UMLOT

SELECT * FROM EQUIPMENT
 WHERE SHOPID = 'JCU'

SELECT * FROM WIPHISTORY
 WHERE RECEIPTNO = '12862'
   AND PONO = '34368-2-3-1'

SELECT * FROM UDT_SEMIITEM
 WHERE SEMIID = '180904-h001'
*/
SELECT	CONVERT(CHAR(23), A.ACTDTTM, 21)	AS TableSysID,			-- ?STRING STS도
		A.LOTID			AS LotID,
		A.PROCID		AS SegmentID,
		B.PROCDESC		AS SegmentName,			-- ?공정명
		'LSM'			AS Site,
		'PA1'			AS FacilityID,
		E.WORKORDER		AS WorkOrderID,
		A.EQPTID		AS EquipmentID,			-- 설비
		D.EQPTDESC		AS EquipmentName,		-- 설비명
		CONVERT(INT, RIGHT(A.PROCID, 3))	AS Opr_CD,
		0				AS HoldSeq,
		0				AS RepeatCount,
		'Y'				AS IsCompleted,
		A.BASKETID		AS CarrierID,
		A.PRODID		AS ProductID,			-- ?매칭해야됨
		NULL			AS StandardTime,		-- ?UPDATE 필요
		NULL			AS ActualTime,
		1				AS LotCnt,
		0				AS RActualTime,
		A.BILLETNO		AS BilletNo,
		A.JOBNO			AS JobNo,
		(SELECT ISNULL(MAX(Z.PALLETID), '') FROM UDT_PALLETLOT Z, UDT_PALLET Q WHERE Z.SHOPID = WIP.SHOPID AND Z.SHOPID = Q.SHOPID
		    AND Z.JOBNO = WIP.JOBNO AND Z.WORKORDER = WIP.ROUTID AND Z.PALLETID = Q.PALLETID AND Q.DELETEFLAG = 'N')	AS PalletNo,
		--''				AS PalletNo,
		A.SHIFT			AS ShiftID,
		A.LOTLENGTH		AS PLength,
		A.WIPQTY_IN		AS InputWeight,
		A.WIPQTY_ED		AS OutputWeight,
		''				AS InputBasketID,
		A.BASKETID		AS OutputBasketID,		-- 산출바스켓
		-- 1번원자재
		''				AS InputRawMaterial1,
		''				AS InputRawMaterial1Thickness,
		''				AS InputRawMaterial1Width,
		''				AS InputRawMaterial1Length,
		(SELECT MAX(Q.BILLETNO) FROM UDT_SEMIUSE Z, WIP Q WHERE Z.SHOPID = WIP.SHOPID AND Z.LOTID = WIP.LOTID
		    AND Z.PROCID = A.PROCID AND Z.SHOPID = Q.SHOPID AND Z.SEMIID = Q.LOTID)		AS InputRawMaterial1Lot,
		''				AS InputRawMaterial1BPID,
		''				AS InputRawMaterial1BPName,
		(SELECT MAX(Z.SPRODID) FROM UDT_SEMIUSE Z WHERE Z.SHOPID = WIP.SHOPID AND Z.LOTID = WIP.LOTID
		    AND Z.PROCID = A.PROCID)		AS InputRawMaterial1MProductID,
		-- 2번원자재
		''				AS InputRawMaterial2,
		''				AS InputRawMaterial2Thickness,
		''				AS InputRawMaterial2Width,
		''				AS InputRawMaterial2Length,
		''				AS InputRawMaterial2Lot,
		''				AS InputRawMaterial2BPID,
		''				AS InputRawMaterial2BPName,
		''				AS InputRawMaterial2MProductID,
		-- 3번원자재
		''				AS InputRawMaterial3,
		''				AS InputRawMaterial3Thickness,
		''				AS InputRawMaterial3Width,
		''				AS InputRawMaterial3Length,
		''				AS InputRawMaterial3Lot,
		''				AS InputRawMaterial3BPID,
		''				AS InputRawMaterial3BPName,
		''				AS InputRawMaterial3MProductID,
		-- 4번원자재
		''				AS InputRawMaterial4,
		''				AS InputRawMaterial4Thickness,
		''				AS InputRawMaterial4Width,
		''				AS InputRawMaterial4Length,
		''				AS InputRawMaterial4Lot,
		''				AS InputRawMaterial4BPID,
		''				AS InputRawMaterial4BPName,
		''				AS InputRawMaterial4MProductID,
		----------------------------------------------
		''				AS OutSideWeldingProductID,
		0				AS OutSideWeldingConsumeQty,
		''				AS OutSideFluxID,
		0				AS OutSideFluxConsumeQty,
		''				AS InSideWeldingProductID,
		0				AS InSideWeldingConsumeQty,
		''				AS InSideFluxID,
		0				AS InSideFluxConsumeQty,
		CASE WHEN A.PROCID IN ('C210','C220','C310') THEN F.CLCTVAL1		-- 외경
			 WHEN A.PROCID IN ('C110')				 THEN F.CLCTVAL4
			 WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL5
			 WHEN A.PROCID IN ('C350')				 THEN F.CLCTVAL2
		END		AS FullDiameterMax,
		CASE WHEN A.PROCID IN ('C210','C220','C310') THEN F.CLCTVAL2
			 WHEN A.PROCID IN ('C110')				 THEN F.CLCTVAL5
			 WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL6
			 WHEN A.PROCID IN ('C350')				 THEN F.CLCTVAL3
		END		AS FullDiameterMin,
		CASE WHEN A.PROCID IN ('C210','C220','C310') THEN F.CLCTVAL5
			 WHEN A.PROCID IN ('C110')				 THEN F.CLCTVAL6
			 WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL1
			 WHEN A.PROCID IN ('C350')				 THEN F.CLCTVAL1
		END		AS FullDiameterAvg,
		CASE WHEN A.PROCID IN ('C210','C220','C310') THEN F.CLCTVAL3		-- 두께
			 WHEN A.PROCID IN ('C110')				 THEN F.CLCTVAL10
			 WHEN A.PROCID IN ('C350')				 THEN F.CLCTVAL5
		END		AS ThicknessMax,
		CASE WHEN A.PROCID IN ('C210','C220','C310') THEN F.CLCTVAL4
			 WHEN A.PROCID IN ('C110')				 THEN F.CLCTVAL11
			 WHEN A.PROCID IN ('C350')				 THEN F.CLCTVAL6
		END		AS ThicknessMin,
		CASE WHEN A.PROCID IN ('C210','C220','C310') THEN F.CLCTVAL6
			 WHEN A.PROCID IN ('C110')				 THEN F.CLCTVAL12
			 WHEN A.PROCID IN ('C350')				 THEN F.CLCTVAL4
		END		AS ThicknessAvg,
		CASE WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL7
		END		AS InnerDiameterMax,
		CASE WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL8
		END		AS InnerDiameterMin,
		CASE WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL2
		END		AS InnerDiameterAvg,
		CASE WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL9
		END		AS ThreadMax,
		CASE WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL10
		END		AS ThreadMin,
		CASE WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL3
		END		AS ThreadAvg,
		CASE WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL11
		END		AS BottomThicknessMax,
		CASE WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL12
		END		AS BottomThicknessMin,
		CASE WHEN A.PROCID IN ('C330','C340')		 THEN F.CLCTVAL4
		END		AS BottomThicknessAvg,
		A.WIPQTY_SCRAP	AS ScrapQty,
		A.WIPQTY_IN		AS UseQty,
		A.WIPQTY_ED		AS PassQty,
		A.WIPQTY_SCRAP	AS DefectQty,
		A.SCRAPREASON	AS DefectCode,			-- ?UPDATE 필요
		A.PROCID		AS DefectSegmentID,		-- ?디펙트공정, 현재공정?
		''				AS DefectDesc,
		''				AS DefectUTQty,
		ISNULL((SELECT Z.MOLD FROM UDT_BILLETADDINFO Z WHERE Z.BILLETNO = A.BILLETNO), '')	AS Mold,
		A.LOTFAULT		AS UTQty,
		A.LOTUNITWEIGHT	AS UnitWeight,
		(SELECT Z.LATTVALUE FROM LOTATT Z (nolock) WHERE Z.LATTITEM ='UNITWEIGHT_DRAW'
		    AND Z.SHOPID = WIP.SHOPID  AND Z.LOTID = WIP.LOTID)	AS DrawingUnitWeight,
		(SELECT MAX(Z.SEQ) FROM UDT_PASSSTOP Z (nolock) WHERE Z.SHOPID = WIP.SHOPID  AND Z.LOTID = WIP.LOTID)	AS DrawingPassCount,
		A.SUBNO			AS BasketDivide,
		A.COILDIVIDE	AS CoilDivide,
		(SELECT Z.LATTVALUE FROM LOTATT Z (nolock) WHERE Z.LATTITEM ='PARENT_PIPESIZE'
		    AND Z.SHOPID = WIP.SHOPID  AND Z.LOTID = WIP.LOTID)	AS ParentPipeSize,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL20
		END				AS ChillTubeNo_A,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL22
		END				AS ChillTubeNo_B,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL21
		END				AS ChillTubeNo_C,
		ISNULL((SELECT Z.ORING FROM UDT_BILLETADDINFO_C210 Z WHERE Z.BILLETNO = A.BILLETNO), '')	AS Oring,
		(SELECT Z.LATTVALUE FROM LOTATT Z (nolock) WHERE Z.LATTITEM ='ROLLNO'
		    AND Z.SHOPID = WIP.SHOPID  AND Z.LOTID = WIP.LOTID)				AS RollNo,
		''				AS RollingSpeed,
		''				AS AppearanceCondition,
		(SELECT Z.LATTVALUE FROM LOTATT Z (nolock) WHERE Z.LATTITEM ='ROLLWEIGHT'
		    AND Z.SHOPID = WIP.SHOPID  AND Z.LOTID = WIP.LOTID)				AS RollUseQty,
		(SELECT Z.LATTVALUE FROM LOTATT Z (nolock) WHERE Z.LATTITEM ='MTIPWEIGHT'
		    AND Z.SHOPID = WIP.SHOPID  AND Z.LOTID = WIP.LOTID)				AS MTipUseQty,
		(SELECT LA.LATTVALUE  FROM    LOTATT LA  with (nolock) WHERE LA.SHOPID = WIP.SHOPID AND LA.LOTID = WIP.LOTID AND LA.LATTITEM = 'IAWORKNO') AS WorkNo,				--?숫자형?
		(SELECT Z.LATTVALUE FROM LOTATT Z (nolock) WHERE Z.LATTITEM ='CUHEATLOTNO'
		    AND Z.SHOPID = WIP.SHOPID  AND Z.LOTID = WIP.LOTID)				AS HeatLotNo,
		CASE WHEN A.PROCID IN ('C360')		 THEN F.CLCTVAL5
		END				AS SPurge,
		CASE WHEN A.PROCID IN ('C360')		 THEN F.CLCTVAL1
		END				AS HeatTemperature1,
		CASE WHEN A.PROCID IN ('C360')		 THEN F.CLCTVAL2
		END				AS HeatTemperature2,
		CASE WHEN A.PROCID IN ('C360')		 THEN F.CLCTVAL3
		END				AS CycleTime,
		CASE WHEN A.PROCID IN ('C360')		 THEN F.CLCTVAL4
		END				AS Oxygen,
		CASE WHEN LEN(A.CUTTERTYPE) = 1 THEN
			  CASE WHEN SUBSTRING(A.CUTTERTYPE,1,1) = 'C' THEN 'O'
				   WHEN SUBSTRING(A.CUTTERTYPE,1,1) = 'F' THEN 'X'
				   WHEN SUBSTRING(A.CUTTERTYPE,1,1) <> 'C' THEN 'X'
			  END
		  WHEN LEN(A.CUTTERTYPE) = 2 THEN
			  CASE WHEN SUBSTRING(A.CUTTERTYPE,1,1) = 'C' THEN 'O'
				  WHEN SUBSTRING(A.CUTTERTYPE,1,1) = 'F' THEN 'X'
				 WHEN SUBSTRING(A.CUTTERTYPE,1,1) <> 'C' THEN 'X'
			  END		
		  ELSE 'X'  END				AS Shorter,
		CASE WHEN LEN(A.CUTTERTYPE) = 1 THEN
			CASE WHEN SUBSTRING(A.CUTTERTYPE,1,1) = 'B' THEN 'O'
				WHEN SUBSTRING(A.CUTTERTYPE,1,1) = 'F' THEN 'X'
				WHEN SUBSTRING(A.CUTTERTYPE,1,1) <> 'B' THEN 'X'
			END
			WHEN LEN(A.CUTTERTYPE) = 2 THEN
			CASE 
				WHEN SUBSTRING(A.CUTTERTYPE,2,1) = 'B' THEN 'O'
				WHEN SUBSTRING(A.CUTTERTYPE,2,1) = 'F' THEN 'X'
				WHEN SUBSTRING(A.CUTTERTYPE,2,1) <> 'B' THEN 'X'
			END  			
		ELSE 'X' 	END				AS Combined,
		''				AS STDIns,
		''				AS FilmType,
		0				AS STDFilmQty,
		0				AS FilmQty,
		''				AS PicklingNo,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL1
		END				AS CastingSpeed,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL2
		END				AS CastingTemp,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL16
		END			AS Coolant_1st_Temp_A,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL23
		END			AS Coolant_1st_Temp_B,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL17
		END			AS Coolant_1st_Temp_C,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL18
		END			AS Coolant_2nd_Temp_A,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL24
		END			AS Coolant_2nd_Temp_B,
		CASE WHEN A.PROCID IN ('C110')		 THEN F.CLCTVAL19
		END			AS Coolant_2nd_Temp_C,
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
		NULL			AS StartTime,				-- ?종료시간 - ST TIME UPDATE
		NULL			AS EndTime,					-- ?종료시간?
		NULL			AS InsResult1,
		NULL			AS InsResult2,
		NULL			AS InsResult3,
		NULL			AS InsResult4,
		NULL			AS InsResult5,
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
		'Usable'			AS IsUsable,
		A.USERID		AS CreateUser,
		A.ACTDTTM		AS CreateTime,
		A.USERID		AS UpdateUser,
		A.ACTDTTM		AS UpdateTime,
		A.ACTDTTM		AS LastEventTime
  FROM	WIP WIP			INNER JOIN WIPHISTORY A	ON	A.SHOPID	= WIP.SHOPID
												AND	A.LOTID		= WIP.LOTID
						INNER JOIN	PROCESS B	ON	B.SHOPID	= A.SHOPID
												AND	B.PROCID	= A.PROCID
						INNER JOIN	PRODUCT C	ON	C.SHOPID	= A.SHOPID
												AND	C.PRODID	= A.PRODID
						--INNER JOIN	PROCESSEQUIPMENT C	ON	C.SHOPID	= A.SHOPID
						--								AND	C.PROCID	= A.PROCID
						INNER JOIN	EQUIPMENT D	ON	D.SHOPID	= A.SHOPID
												AND	D.EQPTID	= A.EQPTID
												AND	D.EQPTIUSE	= 'Y'
						INNER JOIN UDT_WORKORDER E	ON	E.SHOPID	= A.SHOPID
													AND	E.WORKORDER	= A.ROUTID
						LEFT OUTER JOIN WIPDATACOLLECT F (nolock)	ON	F.SHOPID	= A.SHOPID
																	AND	F.LOTID		= A.LOTID
																	AND F.WIPSEQ	= A.WIPSEQ
 WHERE	WIP.DELETEFLAG	= 'N'
   AND	WIP.WIPTERM	= 'N'
   AND  WIP.SHOPID	= 'JCU'
   AND	A.DELETEFLAG	= 'N'
   AND	WIP.LOTID > '20210114030403'
   --AND	WIP.ROUTID	= '180907-9039'		-- 추후 WHERE에서 제외
   --AND	WIP.LOTID		= '20211103000101'
   	-- 추후 WHERE에서 제외

