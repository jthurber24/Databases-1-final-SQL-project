/* Phase 3 Joshua Thurber, Oliver Shulman*/

DROP TABLE StayIn CASCADE CONSTRAINTS;
DROP TABLE Examine CASCADE CONSTRAINTS;
DROP TABLE Admission CASCADE CONSTRAINTS;
DROP TABLE Patient CASCADE CONSTRAINTS;
DROP TABLE RoomAccess CASCADE CONSTRAINTS;
DROP TABLE RoomService CASCADE CONSTRAINTS;
DROP TABLE Room CASCADE CONSTRAINTS;
DROP TABLE Equipment CASCADE CONSTRAINTS;
DROP TABLE EquipmentType CASCADE CONSTRAINTS;
DROP TABLE CanRepairEquipment CASCADE CONSTRAINTS;
DROP TABLE EquipmentTechnician CASCADE CONSTRAINTS;
DROP TABLE Doctor CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP VIEW CriticalCases;
DROP VIEW DoctorsLoad;

/*Create Table Statements*/

Create TABLE Employee(
ID Number NOT NULL,
FName CHAR(25) NOT NULL,
LName CHAR(25) NOT NULL,
Salary Number NOT NULL,
jobTitle VARCHAR2(50) NOT NULL,
OfficeNum Number NOT NULL,
empRank Number NOT NULL,
supervisorID Number NOT NULL,
AddressStreet VARCHAR2(50) NOT NULL,
AddressCity Char(25) NOT NULL,
PRIMARY KEY(ID),
CONSTRAINT Check_EmpRank CHECK (EmpRank = 0 OR EmpRank = 1 OR EmpRank = 2) /* employee is regular (rank = 0), division manager (rank = 1), or general manager (rank = 2) */
);

Create TABLE Doctor(
EmployeeID Number PRIMARY KEY, 
gender VARCHAR2(50) NOT NULL, 
specialty VARCHAR2(20) NOT NULL,
GraduatedFrom VARCHAR2(50),
FOREIGN KEY (EmployeeID) REFERENCES Employee(ID));

Create TABLE EquipmentTechnician(
EmployeeID Number PRIMARY KEY,
FOREIGN KEY (EmployeeID) REFERENCES Employee(ID));

Create TABLE CanRepairEquipment(
EmployeeID Number NOT NULL, 
EquipmentType VARCHAR2(50),
CONSTRAINT P_CanRepairEquipment PRIMARY KEY (EmployeeID, EquipmentType),
FOREIGN KEY (EmployeeID) REFERENCES Employee(ID));

Create TABLE EquipmentType( 
EquipmentID Number, 
Descriptions VARCHAR2(50), 
ModelNum VARCHAR2(50) NOT NULL, 
Instructions VARCHAR2(50),
PRIMARY KEY(EquipmentID));

Create TABLE Room(
Nums Number, 
occupied Number NOT NULL,
CONSTRAINT P_Room PRIMARY KEY (Nums),
CONSTRAINT Check_occupied CHECK (occupied = 0 OR occupied = 1));

Create TABLE Equipment(
Serial# VARCHAR2(20), 
TypeID Number NOT NULL, 
PurchaseYear Date NOT NULL, 
LastInspection Date, 
roomNum Number NOT NULL,
PRIMARY KEY(Serial#),
FOREIGN KEY (roomNum) REFERENCES Room(Nums),
FOREIGN KEY (TypeID) REFERENCES EquipmentType(EquipmentID),
CONSTRAINT Check_Equipment CHECK (LastInspection >= PurchaseYear));

Create TABLE RoomService(
roomNum Number, 
services VARCHAR2(30),
CONSTRAINT P_RoomServices PRIMARY KEY (roomNum, services),
FOREIGN KEY (roomNum) REFERENCES Room(Nums));

Create TABLE RoomAccess(
roomNum Number NOT NULL, 
EmployeeID Number NOT NULL,
CONSTRAINT P_RoomAccess PRIMARY KEY (roomNum, EmployeeID),
FOREIGN KEY (roomNum) REFERENCES Room(Nums),
FOREIGN KEY (EmployeeID) REFERENCES Employee(ID));

Create TABLE Patient(
SSN VARCHAR2(11) NOT NULL,
FirstName VARCHAR2(25) NOT NULL, 
LastName VARCHAR2(25) NOT NULL, 
Address VARCHAR2(50) NOT NULL, 
TelNum VARCHAR2(15) NOT NULL,
PRIMARY KEY(SSN));

Create TABLE Admission(
Nums Number NOT NULL, 
AdmissionDate date NOT NULL, 
LeaveDate date, 
TotalPayment Number NOT NULL, 
InsurancePayment Number, 
Patient_SSN VARCHAR2(11) NOT NULL, 
FutureVisit date,
PRIMARY KEY(Nums),
FOREIGN KEY(Patient_SSN) REFERENCES Patient(SSN),
CONSTRAINT Check_Payment CHECK (InsurancePayment<=TotalPayment),
CONSTRAINT Check_Admission CHECK (AdmissionDate<=LeaveDate),
CONSTRAINT Check_Future CHECK (LeaveDate<FutureVisit));

Create TABLE Examine(
DoctorID Number, 
AdmissionNum Number, 
Comments VARCHAR2(100),
CONSTRAINT P_Examine PRIMARY KEY (DoctorID, AdmissionNum),
FOREIGN KEY (DoctorID) REFERENCES Doctor(EmployeeID),
FOREIGN KEY (AdmissionNum) REFERENCES Admission(Nums));

Create TABLE StayIn(
AdmissionNum Number NOT NULL, 
RoomNum Number NOT NULL, 
startDate date NOT NULL, 
endDate date,
CONSTRAINT P_StayIn PRIMARY KEY (AdmissionNum, RoomNum, startDate),
FOREIGN KEY (AdmissionNum) REFERENCES Admission(Nums),
FOREIGN KEY (roomNum) REFERENCES Room(Nums));




/*Populating the tables*/




INSERT INTO Patient(SSN,FirstName,LastName,Address,TelNum) 
VALUES('012-34-5678','Dan','Kmemes','12 FarAway ST.','(123)-456-7890');
INSERT INTO Patient(SSN,FirstName,LastName,Address,TelNum) 
VALUES('123-45-6789','Tabal','Prince','100 Institute RD.','(585)-567-5309');
INSERT INTO Patient(SSN,FirstName,LastName,Address,TelNum) 
VALUES('123-45-6780','King','Philip','30 Yes ST.','(012)-345-6789');
INSERT INTO Patient(SSN,FirstName,LastName,Address,TelNum) 
VALUES('036-66-6059','John','Tavis','10 NoWHERE BLV.','(123)-654-7890');
INSERT INTO Patient(SSN,FirstName,LastName,Address,TelNum) 
VALUES('988-77-4328','John','Doe','12 FarAway ST.','(987)-456-0321');
INSERT INTO Patient(SSN,FirstName,LastName,Address,TelNum) 
VALUES('765-89-0254','Sally','Smith','12 FarAway ST.','(010)-101-0101');
INSERT INTO Patient(SSN,FirstName,LastName,Address,TelNum) 
VALUES('678-54-3760','Sarah','Pipsi','12 FarAway ST.','(111)-111-0000');
INSERT INTO Patient(SSN,FirstName,LastName,Address,TelNum) 
VALUES('123-79-6540','Eron','Steel','12 FarAway ST.','(111)-111-1111');
INSERT INTO Patient(SSN,FirstName,LastName,Address,TelNum) 
VALUES('192-847-452','Tabal','Prince','12 FarAway ST.','(333)-666-6999');
INSERT INTO Patient(SSN,FirstName,LastName,Address,TelNum) 
VALUES('111-22-3333','Cave','Johnson','50 Jazz RD','(000)-000-0000');

INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('600','Josh','Pickles','10.00','Regular Employee','101','0','700', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity)
VALUES('601','Surya','Leman','10.00','Regular Employee','102','0','700', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('602','Kistan','Hilbert','10.00','Regular Employee','103','0','700', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('603','Mansa','Yao','10.00','Regular Employee','104','0','701', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('604','Ralph','Jones','10.00','Regular Employee','105','0','701', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('605','Jen','Rulon','10.00','Regular Employee','106','0','701', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('606','Josh','Conte','10.00','Regular Employee','107','0','702', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('607','Anthony','Poreloo','10.00','Regular Employee','108','0','702', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('608','Lily','Coie','10.00','Regular Employee','109','0','703', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('609','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');

INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('1000','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('1001','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('1002','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('1003','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('1004','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');

INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('150','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('151','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('152','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('153','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) VALUES('154','Sam','Smith','10.00','Regular Employee','110','0','703', '555 street', 'worcester');

INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('700','Jona','Smos','12.00','Division Manager','111','1','800', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('701','Kim','Pasta','12.00','Division Manager','112','1','800', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('702','Tom','Brady','12.00','Division Manager','113','1','801', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('703','Rose','Low','12.00','Division Manager','114','1','801', '555 street', 'worcester');

INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('800','Bill','Gates','15.00','General Manager','200','2','801', '555 street', 'worcester');
INSERT INTO Employee(ID,FName,LName,Salary,JobTitle,OfficeNum,emprank,SupervisorID,AddressStreet,AddressCity) 
VALUES('420','William','Gates','15.00','General Manager','120','2','801', '555 street', 'worcester');

INSERT INTO Room(Nums,occupied) VALUES('101','0');
INSERT INTO Room(Nums,occupied) VALUES('102','1');
INSERT INTO Room(Nums,occupied) VALUES('105','0');
INSERT INTO Room(Nums,occupied) VALUES('106','0');
INSERT INTO Room(Nums,occupied) VALUES('103','1');
INSERT INTO Room(Nums,occupied) VALUES('104','1');
INSERT INTO Room(Nums,occupied) VALUES('108','0');
INSERT INTO Room(Nums,occupied) VALUES('109','1');
INSERT INTO Room(Nums,occupied) VALUES('107','0');
INSERT INTO Room(Nums,occupied) VALUES('110','1');



INSERT INTO RoomAccess(roomNum,EmployeeID) VALUES('101','600');
INSERT INTO RoomAccess(roomNum,EmployeeID) VALUES('102','600');
INSERT INTO RoomAccess(roomNum,EmployeeID) VALUES('101','604');

INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit)
VALUES('11',TO_DATE('2003/02/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2003/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','0','111-22-3333',TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));

INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('1',TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2003/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','1000','123-45-6789',TO_DATE('2204/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('2',TO_DATE('2013/09/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2014/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','0','123-45-6789',TO_DATE('2204/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('3',TO_DATE('2007/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2008/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','0','012-34-5678',TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('4',TO_DATE('2006/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2007/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','0','012-34-5678',TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('5',TO_DATE('2005/06/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2006/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','0','036-66-6059',TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('6',TO_DATE('2002/08/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2003/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','0','036-66-6059',TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('7',TO_DATE('2003/03/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2004/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','0','192-847-452',TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('8',TO_DATE('2003/04/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2003/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','0','192-847-452',TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));

INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('9',TO_DATE('2003/04/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2003/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','0','111-22-3333',TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('10',TO_DATE('2003/02/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2003/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','500','111-22-3333',TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Nums,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,Patient_SSN,FutureVisit) VALUES('12',TO_DATE('2003/08/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2004/05/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'1000','500','111-22-3333',TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));

INSERT INTO EquipmentType(EquipmentID,Descriptions,ModelNum,Instructions) VALUES('3000','SUPER COOL','A','DO IT YOURSELF');
INSERT INTO EquipmentType(EquipmentID,Descriptions,ModelNum,Instructions) VALUES('4000','AMAZING','B','CALL IKEA');
INSERT INTO EquipmentType(EquipmentID,Descriptions,ModelNum,Instructions) VALUES('5000','KINDA GOOD','C','');

INSERT INTO Equipment(Serial#,TypeID,PurchaseYear,LastInspection,roomNum) VALUES('ABD123','3000',TO_DATE('2003', 'yyyy'),TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'101');
INSERT INTO Equipment(Serial#,TypeID,PurchaseYear,LastInspection,roomNum) VALUES('ABDC1234','3000',TO_DATE('2003', 'yyyy'),TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'105');
INSERT INTO Equipment(Serial#,TypeID,PurchaseYear,LastInspection,roomNum) VALUES('ABC123','3000',TO_DATE('2011', 'yyyy'),TO_DATE('2018/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'107');
INSERT INTO Equipment(Serial#,TypeID,PurchaseYear,LastInspection,roomNum) VALUES('XYZ789','4000',TO_DATE('2004', 'yyyy'),TO_DATE('2017/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'102');
INSERT INTO Equipment(Serial#,TypeID,PurchaseYear,LastInspection,roomNum) VALUES('XYZ000','4000',TO_DATE('2004', 'yyyy'),TO_DATE('2013/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'103');
INSERT INTO Equipment(Serial#,TypeID,PurchaseYear,LastInspection,roomNum) VALUES('XYZ999','4000',TO_DATE('2004', 'yyyy'),TO_DATE('2017/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'104');
INSERT INTO Equipment(Serial#,TypeID,PurchaseYear,LastInspection,roomNum) VALUES('JKL456','5000',TO_DATE('2010', 'yyyy'),TO_DATE('2017/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'109');
INSERT INTO Equipment(Serial#,TypeID,PurchaseYear,LastInspection,roomNum) VALUES('JKLQRS','5000',TO_DATE('2011', 'yyyy'),TO_DATE('2017/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'101');
INSERT INTO Equipment(Serial#,TypeID,PurchaseYear,LastInspection,roomNum) VALUES('555JKS','5000',TO_DATE('2005', 'yyyy'),TO_DATE('2018/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'109');
INSERT INTO Equipment(Serial#,TypeID,PurchaseYear,LastInspection,roomNum) VALUES('A01-02X','5000',TO_DATE('2005', 'yyyy'),TO_DATE('2018/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),'109');

INSERT INTO RoomService(roomNum,services) VALUES('102','MRI');
INSERT INTO RoomService(roomNum,services) VALUES('102','BloodTesting');
INSERT INTO RoomService(roomNum,services) VALUES('102','CATScan');
INSERT INTO RoomService(roomNum,services) VALUES('103','Cafeteria');
INSERT INTO RoomService(roomNum,services) VALUES('103','Dining');
INSERT INTO RoomService(roomNum,services) VALUES('103','Xray');
INSERT INTO RoomService(roomNum,services) VALUES('104','CPR');
INSERT INTO RoomService(roomNum,services) VALUES('104','MRI');

INSERT INTO Doctor(EmployeeID, gender, specialty, GraduatedFrom) VALUES(1000, 'Male', 'General', 'WPI');
INSERT INTO Doctor(EmployeeID, gender, specialty, GraduatedFrom) VALUES(1001, 'Female', 'Neurosurgery', 'Yale');
INSERT INTO Doctor(EmployeeID, gender, specialty, GraduatedFrom) VALUES(1002, 'Male', 'Dermatology', 'Harvard');
INSERT INTO Doctor(EmployeeID, gender, specialty, GraduatedFrom) VALUES(1003, 'Female', 'Radiology', 'Brown');
INSERT INTO Doctor(EmployeeID, gender, specialty, GraduatedFrom) VALUES(1004, 'Male', 'Rheumatology', 'RPI');



INSERT INTO Examine(DoctorID,AdmissionNum,Comments) VALUES('1000','8','Broken Leg');
INSERT INTO Examine(DoctorID,AdmissionNum,Comments) VALUES('1001','9','Allergic to Meat');
INSERT INTO Examine(DoctorID,AdmissionNum,Comments) VALUES('1001','10','Still Allergic to Meat');
INSERT INTO Examine(DoctorID,AdmissionNum,Comments) VALUES('1001','12','Very Allergic to Meat');


INSERT INTO EquipmentTechnician(EmployeeID) VALUES('150');
INSERT INTO EquipmentTechnician(EmployeeID) VALUES('151');
INSERT INTO EquipmentTechnician(EmployeeID) VALUES('152');
INSERT INTO EquipmentTechnician(EmployeeID) VALUES('153');
INSERT INTO EquipmentTechnician(EmployeeID) VALUES('154');

INSERT INTO CanRepairEquipment(EmployeeID, EquipmentType) VALUES('150','3000');
INSERT INTO CanRepairEquipment(EmployeeID, EquipmentType) VALUES('151','3000');
INSERT INTO CanRepairEquipment(EmployeeID, EquipmentType) VALUES('152','3002');
INSERT INTO CanRepairEquipment(EmployeeID, EquipmentType) VALUES('153','4000');
INSERT INTO CanRepairEquipment(EmployeeID, EquipmentType) VALUES('154','5000');


CREATE VIEW CriticalCases AS 
    Select SSN AS Patient_SSN, firstName, lastName, numberOfAdmissionsToICU 
    From Patient NATURAL JOIN ( 
        Select Patient_SSN AS SSN, Count(*) AS numberOfAdmissionsToICU 
        From Admission NATURAL JOIN ( 
            Select AdmissionNum AS ANum  
            From StayIn NATURAL JOIN ( 
                Select RoomNum 
                From RoomService 
                Where services = 'ICU')) 
        Group By Patient_SSN) 
    Where numberOfAdmissionsToICU >= 2;

CREATE VIEW DoctorsLoad AS    
    Select EmployeeID as DoctorID, gender, 'Overloaded' AS load
    From Doctor NATURAL JOIN(
        Select DoctorID AS EmployeeID, Count(AdmissionNum) AS LoadNum
        From Examine
        Group By DoctorID)
    Where Loadnum > 10
    Union
        (Select EmployeeID as DoctorID, gender, 'Underloaded' AS load
        From Doctor NATURAL JOIN(
            Select DoctorID AS EmployeeID, Count(AdmissionNum) AS LoadNum
            From Examine
            Group By DoctorID)
        Where Loadnum <= 10);
        
        
Select *
From CriticalCases
Where numberOfAdmissionsToICU > 4;

Select EmployeeID, FName, LName
From Doctor D, DoctorsLoad L, Employee E
Where D.EmployeeID = L.DoctorID
    AND
    D.GraduatedFrom = 'WPI'
    AND
    L.load = 'Overloaded';


Select D.DoctorID, C.Patient_SSN, Comments
From CriticalCases C, Admission A, Examine E, DoctorsLoad D
Where C.Patient_SSN = A.Patient_SSN
    AND
    A.Nums = E.AdmissionNum
    AND
    E.DoctorID = D.DoctorID
    AND
    D.load = 'Underloaded'; 
    
    
CREATE OR REPLACE TRIGGER AddComment
AFTER INSERT 
ON Examine
FOR EACH ROW
DECLARE
	RType varchar2(30);
BEGIN
	Select services INTO RType 
    From Patient NATURAL JOIN ( 
        Select Patient_SSN AS SSN, services
        From Admission NATURAL JOIN ( 
            Select AdmissionNum AS Nums,services  
            From StayIn NATURAL JOIN ( 
                Select RoomNum,services 
                From RoomService 
                Where services = 'ICU')) 
        Group By Patient_SSN)
		Where RType='ICU';
IF (:new.comments IS NULL)
    THEN
      RAISE_APPLICATION_ERROR(-20004, 'You must leave a comment.');
    END IF;
END;
/
Show errors;



CREATE OR REPLACE TRIGGER CHECKFutureVisit
BEFORE INSERT 
ON Admission
FOR EACH ROW
DECLARE
	RType varchar2(30);
BEGIN
	Select services INTO RType 
    From Patient NATURAL JOIN ( 
        Select Patient_SSN AS SSN, services
        From Admission NATURAL JOIN ( 
            Select AdmissionNum AS Nums,services  
            From StayIn NATURAL JOIN ( 
                Select RoomNum,services 
                From RoomService 
                Where services = 'ICU')) 
        Group By Patient_SSN)
        Where :old.Patient_SSN = :new.Patient_SSN;
IF (RType='ICU')
    THEN
      :new.FutureVisit:= :new.AdmissionDate + INTERVAL '2' Month;
END IF;
END;
/
Show errors;

-- Should be placed after tables are made and before inserts
CREATE TRIGGER CalcInsurance
BEFORE INSERT OR UPDATE
ON Admission
FOR EACH ROW
BEGIN
:new.InsurancePayment := :new.TotalPayment * 0.65;
END;
/
Show errors;

CREATE OR REPLACE TRIGGER CHECKMANAGERS
BEFORE INSERT OR UPDATE 
ON Employee
FOR EACH ROW
WHEN (new.EmpRank = 0)
DECLARE
   BossRank NUMBER := 1;
BEGIN 
    Select EmpRank INTO BossRank FROM Employee WHERE ID = :new.SupervisorID;
    IF(BossRank != 1) THEN
	RAISE_APPLICATION_ERROR(-20004, 'Employee of Rank 0 must have Supervisor of Rank 1');
	END IF;
END;
/
Show errors;

CREATE OR REPLACE TRIGGER CHECKGENMANAGERS
BEFORE INSERT OR UPDATE 
ON Employee
FOR EACH ROW
WHEN (new.EmpRank = 1)
DECLARE
   BossRank NUMBER := 2;
BEGIN 
    Select EmpRank INTO BossRank FROM Employee WHERE ID = :new.SupervisorID;
    IF(BossRank != 2) THEN
	RAISE_APPLICATION_ERROR(-20004, 'Employee of Rank 1 must have Supervisor of Rank 2');
	END IF;
END;
/
Show errors;

/*
CREATE OR REPLACE TRIGGER EquipInspect
AFTER INSERT 
ON Equipment
FOR EACH ROW
DECLARE
	ins date;
BEGIN
Select LastInspection INTO ins, TypeID From Equipment
    From CanRepairEquipment NATUAL JOIN(
        Select EquipmentType as TypeID, EmployeeID, LastInspection
            Group By EmployeeID)
            WHERE EmployeeID IS NOT NULL;
        IF (ins < DATEADD(month, -1, GETDATE())) THEN
                :new.LastInspection := GETDATE();
END IF;
END;
/
Show errors;
/*