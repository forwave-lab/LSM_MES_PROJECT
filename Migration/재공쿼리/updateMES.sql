/*
UMWORKORDER
*/

/*
 * 작업
 * 1. 품목코드 변경
 *  UPDATE UMLOT 
	SET ProductID = E.Item_CD
	FROM UMLOT L 
	JOIN erpdb.lsmdb.dbo.ERP_IF_ITEM E
	ON E.Plant_CD = L.FacilityID
	AND E.SPEC = L.ProductID;
 * 2. StateID 변경 - Release
 */
/*
LMWORKORDERINFO
*/


/*
UMLOT
*/
SELECT 
Site,
LOTID,
LotName,
ProductID,
ProductVersion,
ProcessNodeSYSID,
ProcessID,
ProcessVersion,
SegmentID,
SegmentVersion,
RepeatCount,
NextSegmentID,
OriginalQty,
InputQty,
WorkInputQty,
CurrentQty,
DefectQty,
LossQty,
SegmentRuleID,
RuleSequence,
ProcessingStateID,
StateID,
TransferStateID,
Priority,
EquipmentID,
EquipmentVersion,
FacilityID,
CarrierID,
TrackInTime,
TrackOutTime,
LotGrade,
HoldCode,
IsHold,
IsReservedAction,
IsDivide,
IsRework,
ReworkType,
ReworkCompleteSegmentID,
ReworkCompleteProcessVersion,
ReworkCompleteProcessID,
LineID,
ProductType,
LotCreationType,
ParentLotID,
RepeatLotID,
OriginalLotID,
OutSourceLotID,
DestLotID,
PlantID,
ProcessSpeed,
ReceivedTime,
ReservedEquipmentID,
ReservedTime,
StepID,
StepStartTime,
StepEndTime,
UnitID,
VendorID,
DestSite,
DueDate,
LabelPrintCount,
OwnSite,
WorkOrderID,
PoNo,
PoConfirmNo,
PrevStateTime,
CustomerID,
PrevStateID,
PrevActivity,
PrevEquipemntID,
PrevFaciltyID,
PrevProcessID,
PrevProcessVersion,
PrevProductID,
PrevCurrentQTY,
PrevSegmentID,
PrevTrackOutTime,
Comments,
ExecuteService,
OriginalExecuteService,
ActionCode,
IsUsable,
CreateUser,
CreateTime,
UpdateUser,
UpdateTime,
LastEventTime
FROM UMLOT WHERE FacilityID = 'PB1';

SELECT * FROM UMLOT WHERE FacilityID = 'PB1';



/*
 * 작업
 * 1. 품목코드 변경
 * begin tran
 *  UPDATE UMLOT 
	SET ProductID = E.Item_CD, ProcessID = E.Item_CD
	FROM UMLOT L 
	JOIN erpdb.lsmdb.dbo.ERP_IF_ITEM E
	ON E.Plant_CD = L.FacilityID
	AND E.SPEC = L.ProductID
	WHERE FACILITYID = 'PB1';
	
	ROLLBACK
	
	commit
	
	Wait
 * 2. SEGMENTID 변경
 *  UPDATE UMLOT SET SegmentID = '110' WHERE SegmentID = 'P105' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '120' WHERE SegmentID = 'P115' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '130' WHERE SegmentID = 'P110' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '140' WHERE SegmentID = 'P120' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '150' WHERE SegmentID = 'P230' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '170' WHERE SegmentID = 'P235' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '170' WHERE SegmentID = 'P250' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '200' WHERE SegmentID = 'P240' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '200' WHERE SegmentID = 'P245' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '230' WHERE SegmentID = 'P360' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '260' WHERE SegmentID = 'P375' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '270' WHERE SegmentID = 'P270' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '270' WHERE SegmentID = 'P255' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '300' WHERE SegmentID = 'P380' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '310' WHERE SegmentID = 'P390' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '320' WHERE SegmentID = 'P495' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '340' WHERE SegmentID = 'P225' AND FacilityID = 'PB1';
	UPDATE UMLOT SET SegmentID = '400' WHERE SegmentID = 'P385' AND FacilityID = 'PB1';
 */

/*
LMLOTINFO
*/
SELECT
Site,
LOTID,
BilletID,
JobNo,
Mold,
WorkNo,
Oring,
BasketDivide,
CoilDivide,
UnitWeight,
DrawingUnitWeight,
ParentPipeSize,
MarkingEqpID,
DrawingEqpID,
FinEqpID,
HeatLotNo,
HeatTrayNo,
IsPacking,
Length,
Weight,
UTQty,
RealUTQty,
RealWeight,
OriginalProductID,
OriginalVendorID,
FlexibleRouiting230,
FlexibleRouiting260,
FlexibleRouiting270,
FlexibleRouiting300,
IsHydro,
Pickling1,
Pickling2,
InsideRemoval,
OutsideRemoval,
Comments,
ExecuteService,
OriginalExecuteService,
ActionCode,
IsUsable,
CreateUser,
CreateTime,
UpdateUser,
UpdateTime,
LastEventTime
FROM LMLOTINFO
WHERE Comments = '마이그레이션';

SELECT * FROM LMLOTINFO
WHERE Comments = '마이그레이션';

--Length,Weight 데이타 안들어옴

/*
LMSEGMENTRECORD
*/
SELECT 
TableSysID,
LOTID,
SegmentID,
Site,
FacilityID,
WorkOrderID,
EquipmentID,
Opr_CD,
HoldSeq,
RepeatCount,
IsCompleted,
CarrierID,
ProductID,
StandardTime,
ActualTime,
LotCnt,
RActualTime,
BilletNo,
JobNo,
ShiftID,
PLength,
InputWeight,
OutputWeight,
InputBasketID,
OutputBasketID,
InputRawMaterial1,
InputRawMaterial1Thickness,
InputRawMaterial1Width,
InputRawMaterial1Length,
InputRawMaterial1Lot,
InputRawMaterial1BPID,
InputRawMaterial1MProductID,
InputRawMaterial2,
InputRawMaterial2Thickness,
InputRawMaterial2Width,
InputRawMaterial2Length,
InputRawMaterial2Lot,
InputRawMaterial2BPID,
InputRawMaterial2MProductID,
InputRawMaterial3,
InputRawMaterial3Thickness,
InputRawMaterial3Width,
InputRawMaterial3Length,
InputRawMaterial3Lot,
InputRawMaterial3BPID,
InputRawMaterial3MProductID,
InputRawMaterial4,
InputRawMaterial4Thickness,
InputRawMaterial4Width,
InputRawMaterial4Length,
InputRawMaterial4Lot,
InputRawMaterial4BPID,
InputRawMaterial4MProductID,
OutSideWeldingProductID,
OutSideWeldingConsumeQty,
OutSideFluxID,
OutSideFluxConsumeQty,
InSideWeldingProductID,
InSideWeldingConsumeQty,
InSideFluxID,
InSideFluxConsumeQty,
FullDiameterMax,
FullDiameterMin,
FullDiameterAvg,
ThicknessMax,
ThicknessMin,
ThicknessAvg,
InnerDiameterMax,
InnerDiameterMin,
InnerDiameterAvg,
ThreadMax,
ThreadMin,
ThreadAvg,
BottomThicknessMax,
BottomThicknessMin,
BottomThicknessAvg,
ScrapQty,
UseQty,
PassQty,
DefectQty,
DefectCode,
DefectSegmentID,
DefectDesc,
DefectUTQty,
Mold,
UTQty,
UnitWeight,
DrawingUnitWeight,
DrawingPassCount,
BasketDivide,
CoilDivide,
ParentPipeSize,
ChillTubeNo_A,
ChillTubeNo_B,
ChillTubeNo_C,
Oring,
RollNo,
RollingSpeed,
AppearanceCondition,
RollUseQty,
MTipUseQty,
WorkNo,
HeatLotNo,
SPurge,
HeatTemperature1,
HeatTemperature2,
CycleTime,
Oxygen,
Shorter,
Combined,
STDIns,
FilmType,
STDFilmQty,
FilmQty,
PicklingNo,
CastingSpeed,
CastingTemp,
Coolant_1st_Temp_A,
Coolant_1st_Temp_B,
Coolant_1st_Temp_C,
Coolant_2nd_Temp_A,
Coolant_2nd_Temp_B,
Coolant_2nd_Temp_C,
Coolant_Entrance_Temp,
Roll_Coolant_Pressure,
Roll_Coolant_Temperature,
Tube_Coolant_Pressure,
Tube_Coolant_Temperature,
Main_Drive_RPM,
Main_Drive_Current,
Main_Drive_Vibration_1,
Main_Drive_Vibration_2,
Superimposed_Drive_RPM,
Superimposed_Drive_Current,
Superimposed_Drive_Vibration,
DrawingSpeed_1st,
DrawingSpeed_2nd,
MainMotorCurrent_1st,
MainMotorCurrent_2nd,
MainMotorVibration_1st,
MainMotorVibration_2nd,
ScadaIFSysID,
StartTime,
EndTime,
InsResult1,
InsResult2,
InsResult3,
InsResult4,
InsResult5,
InsResult6,
InsResult7,
InsResult8,
InsResult9,
InsResult10,
InsResult11,
InsResult12,
InsResult13,
InsResult14,
InsResult15,
InsResult16,
InsResult17,
InsResult18,
InsResult19,
InsResult20,
TubeNo,
DELETE_FLAG,
Comments,
ExecuteService,
OriginalExecuteService,
ActionCode,
IsUsable,
CreateUser,
CreateTime,
UpdateUser,
UpdateTime,
LastEventTime
FROM LMSEGMENTRECORD
WHERE FacilityID = 'PB1';

SELECT * FROM LMSEGMENTRECORD
WHERE FacilityID = 'PB1';


/*
 * 작업
 * 1. SEGMENTID 변경
 *  UPDATE LMSEGMENTRECORD SET SegmentID = '110' WHERE SegmentID = 'P105' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '120' WHERE SegmentID = 'P115' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '130' WHERE SegmentID = 'P110' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '140' WHERE SegmentID = 'P120' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '150' WHERE SegmentID = 'P230' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '170' WHERE SegmentID = 'P235' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '170' WHERE SegmentID = 'P250' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '200' WHERE SegmentID = 'P240' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '200' WHERE SegmentID = 'P245' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '230' WHERE SegmentID = 'P360' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '260' WHERE SegmentID = 'P375' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '270' WHERE SegmentID = 'P270' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '270' WHERE SegmentID = 'P255' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '300' WHERE SegmentID = 'P380' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '310' WHERE SegmentID = 'P390' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '320' WHERE SegmentID = 'P495' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '340' WHERE SegmentID = 'P225' AND FacilityID = 'PB1';
	UPDATE LMSEGMENTRECORD SET SegmentID = '400' WHERE SegmentID = 'P385' AND FacilityID = 'PB1';
 * 2. EQUIPMENTID 변경	
 * 3. PRODUCTID 변경
 * begin tran
 * UPDATE LMSEGMENTRECORD 
	SET ProductID = E.Item_CD
	FROM LMSEGMENTRECORD L 
	JOIN erpdb.lsmdb.dbo.ERP_IF_ITEM E
	ON E.Plant_CD = L.FacilityID
	AND E.SPEC = L.ProductID;
	
	commit
	
	rollback
 * 4. SHIFTID
 *  UPDATE LMSEGMENTRECORD SET SHIFTID = 'A' WHERE SHIFTID = 'P001' AND FacilityID = 'PB1';
    UPDATE LMSEGMENTRECORD SET SHIFTID = 'B' WHERE SHIFTID = 'P002' AND FacilityID = 'PB1';
    UPDATE LMSEGMENTRECORD SET SHIFTID = 'C' WHERE SHIFTID = 'P003' AND FacilityID = 'PB1';
    P001	1근
	P002	2근
	P003	3근
 * 5. 원자재 품목코드 변경
 * 6. 원자재 bpid 변경
 */

--ROWNUM으로 OPR_CD UPDATE
SELECT  ROW_NUMBER() OVER(PARTITION BY WorkOrderID,LotID ORDER BY LOTID,CreateTime ASC) AS rownum ,CreateTime, *  FROM LMSEGMENTRECORD;


/*
ERP WO전송
*/
SELECT
 LS.LotID,'N','PB1',LS.ProductID,LS.UnitWeight,'KG','1','EA',CONVERT(CHAR(20), LS.CreateTime, 23),CONVERT(CHAR(20), LS.CreateTime, 23),
 'ST',LW.SL_CD,'PB110','','UNIMES',CONVERT(DATETIME, '2021-12-31 07:00:00'),'C','N','','','',LW.Tracking_NO
FROM 
LMSEGMENTRECORD LS
LEFT JOIN LMWORKORDERINFO LW ON LS.Site = LW.Site AND LS.FacilityID = LW.FacilityID AND LS.WorkOrderID = LW.WorkOrderID
WHERE LS.SegmentID = '110'
AND LS.FacilityID = 'PB1'
AND LS.IsCompleted = 'Y'
;


/*Dev to Real
 * UMLOT
 * LMLOTINFO
 * LMSEGMENTRECORD
 */

INSERT INTO MES_TEST.LSMMES.DBO.UMLOT
SELECT * FROM UMLOT;

INSERT INTO MES_TEST.LSMMES.DBO.LMLOTINFO
SELECT * FROM LMLOTINFO;

INSERT INTO MES_TEST.LSMMES.DBO.LMSEGMENTRECORD
SELECT * FROM LMSEGMENTRECORD;



SELECT * FROM LMNOTICE;
SELECT * FROM LMNOTICEUSER;
SELECT * FROM LMNOTICESEGMENT;




