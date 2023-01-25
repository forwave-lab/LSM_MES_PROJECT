/*
���� UMLOT

SELECT * FROM EQUIPMENT
 WHERE SHOPID = 'JCU'
*/
SELECT	'LSM'			AS Site,
		A.LOTID			AS LotID,
		A.LOTID			AS LotName,
		A.PRODID		AS ProductID,
		1				AS ProductVersion,
		''				AS ProcessNodeSYSID,
		A.PRODID		AS ProcessID,
		C.PRODDESC		AS ProcessName,
		1				AS ProcessVersion,
		A.PROCID		AS SegmentID,			-- �����ڵ�
		B.PROCDESC		AS SegmentName,			-- ������
		1				AS SegmentVersion,
		0				AS RepeatCount,
		''				AS NextSegmentID,
		A.WIPQTY_IN		AS OriginalQty,				-- �����߷�
		A.WIPQTY_IN		AS InputQty,				-- �����߷�
		A.WIPQTY_IN		AS WorkInputQty,			-- �����߷�
		A.WIPQTY		AS CurrentQty,
		0				AS DefectQty,
		0				AS LossQty,
		''				AS SegmentRuleID,
		0				AS RuleSequence,
		CASE WHEN A.WIPTERM	= 'N' THEN 'Wait'
		     ELSE 'Run' END			AS ProcessingStateID,		-- ?�۾����� ����  Wait
		CASE WHEN A.WIPTERM	= 'N' THEN 'Release'
		     ELSE 'Complete' END	AS StateID,					-- ?����̸� Release or Complete
		''				AS TransferStateID,
		1				AS Priority,
		''				AS EquipmentID,				-- ���缳��
		''				AS EquipmentVersion,
		'PA1'			AS FacilityID,
		A.BASKETID		AS CarrierID,				-- ����ٽ���ID
		A.WIPDTTM_IN	AS TrackInTime,
		A.WIPDTTM_IN	AS TrackOutTime,
		''				AS LotGrade,
		''				AS HoldCode,
		''				AS IsHold,
		''				AS IsReservedAction,
		'N'				AS IsDivide,				-- ?FIN, ���� ����ó�� ���� Y,N
		'N'				AS IsRework,
		''				AS ReworkType,
		''				AS ReworkCompleteSegmentID,
		''				AS ReworkCompleteProcessVersion,
		''				AS ReworkCompleteProcessID,
		''				AS LineID,
		CASE WHEN A.PROCID IN ('C210','C220') THEN '20'
		     ELSE '' END	AS ProductType,				-- CASCADE ���̸� 20����
		''				AS LotCreationType,
		A.LOTID_PR		AS ParentLotID,				-- �θ�LOTID
		''				AS RepeatLotID,
		A.LOTID			AS OriginalLotID,
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
		'KG'			AS UnitID,
		''				AS VendorID,				-- ?Vendor ID ���߿� UPDATE
		E.CUSTOMER		AS VendorName,				-- Vendor��
		''				AS DestSite,
		NULL			AS DueDate,
		0				AS LabelPrintCount,
		''				AS OwnSite,
		E.WORKORDER		AS WorkOrderID,				-- ?���� UPDATE
		''				AS PoNo,
		''				AS PoConfirmNo,
		''				AS PrevStateTime,
		''				AS CustomerID,				-- ?���� UPDATE
		E.CUSTOMER		AS CustomerName,			-- Vendor��
		''				AS PrevStateID,
		''				AS PrevActivity,
		''				AS PrevEquipemntID,			-- ���������ڵ�
		''				AS PrevFaciltyID,
		A.PRODID		AS PrevProcessID,
		1				AS PrevProcessVersion,
		A.PRODID		AS PrevProductID,
		A.WIPQTY		AS PrevCurrentQTY,
		A.PROCID_PREV	AS PrevSegmentID,			-- ?���� UPDATE
		B.PROCDESC		AS PrevSegmentName,			-- ?����������
		''				AS PrevTrackOutTime,
		'���̱׷��̼�'	AS Comments,
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
						--INNER JOIN	PROCESSEQUIPMENT C	ON	C.SHOPID	= A.SHOPID
						--								AND	C.PROCID	= A.PROCID
						INNER JOIN	EQUIPMENT D	ON	D.SHOPID	= A.SHOPID
												AND	D.EQPTID	= A.EQPTID_PREV
												AND	D.EQPTIUSE	= 'Y'
						INNER JOIN UDT_WORKORDER E	ON	E.SHOPID	= A.SHOPID
													AND	E.WORKORDER	= A.ROUTID
 WHERE	A.SHOPID	= 'JCU'
   AND	A.DELETEFLAG	= 'N'
   AND	A.WIPTERM	= 'N'			-- ������� ���� ���� (N, Y)
   --AND	A.ROUTID	= '180907-9039'		-- ���� WHERE���� ����
   --AND	A.LOTID		= '20211103000101'	-- ���� WHERE���� ����

