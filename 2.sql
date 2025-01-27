CREATE DATABASE MEDICALLAB;
USE MEDICALLAB;


CREATE TABLE LABEMPLOYEE(
    empid VARCHAR(20),
    EmployeeName VARCHAR(20),
    address VARCHAR(20),
    aadharno BIGINT CHECK(aadharno BETWEEN 100000000000 AND 999999999999),
    mobno BIGINT,
    emailid VARCHAR(40),
    PRIMARY KEY(empid)
);


INSERT INTO LABEMPLOYEE VALUES(
    'DIP29',
    'Dipesh V Sabu',
    'Vazhapalliparambil',
    250150719628,
    8078176686,
    'dipeshvs100@gmail.com'
);
INSERT INTO LABEMPLOYEE VALUES(
    'PN59',
    'Prabhav Narayanan',
    'SreePrabhavam',
    250150719622,
    8078982889,
    'prabhu100@gmail.com'
);
INSERT INTO LABEMPLOYEE VALUES(
    'HK62',
    'R Harikrishnan',
    'HariVeed',
    250150739628,
    9448176686,
    'hari@gmail.com'
);
INSERT INTO LABEMPLOYEE VALUES(
    'MJ68',
    'Muhammed Jaseel',
    'JaseelBhavanam',
    111122223333,
    9447636686,
    'jaseel@gmail.com'
);
SELECT * FROM LABEMPLOYEE;


CREATE TABLE PATIENT(
    PID VARCHAR(20),
    PatientName VARCHAR(20),
    address VARCHAR(20),
    aadharno BIGINT CHECK(aadharno BETWEEN 100000000000 AND 999999999999),
    mobno BIGINT,
    emailid VARCHAR(40),
    PRIMARY KEY(PID)
);


INSERT INTO PATIENT VALUES(
    'AS6',
    'Abhiram',
    'Abhiramveed',
    123456789012,
    9876543210,
    'abhiram@gmail.com'
);


INSERT INTO PATIENT VALUES(
    'ASV10',
    'Akhil',
    'vazhapalliparambil',
    234567890123,
    8765432109,
    'akhil@gmail.com'
);


INSERT INTO PATIENT VALUES(
    'AJ11',
    'Abhimanue',
    'Vaadamurikkal',
    345678901234,
    7654321098,
    'abhimanue@gmail.com'
);


INSERT INTO PATIENT VALUES(
    'VN21',
    'Vineeth',
    'maadanveed',
    456789012345,
    6543210987,
    'vineeth@gmail.com'
);


SELECT * FROM PATIENT;


CREATE TABLE TESTS(
    TestName VARCHAR(50),
    TestDescription VARCHAR(110),
    PRIMARY KEY(TestName)
);


INSERT INTO TESTS VALUES(
    'Apgar Test',
    'Quickly summarizes the health of newborn children'
);
INSERT INTO TESTS VALUES(
    'Biopsy',
    'Cell or tissue sampling for examination'
);
INSERT INTO TESTS VALUES(
    'Blood Test',
    'Blood sample laboratory test'
);
INSERT INTO TESTS VALUES(
    'DNA TEST',
    'Genetic diagnosis of vulnerabilities to inherited diseases and more'
);
SELECT *FROM TESTS;

CREATE TABLE SCANS(
    ScanName VARCHAR(50),
    ScanDescription VARCHAR(110),
    PRIMARY KEY(ScanName)
);


INSERT INTO SCANS VALUES(
    'CT Scan',
    'A detailed imaging scan using computed tomography'
);
INSERT INTO SCANS VALUES(
    'MRI',
    'Magnetic Resonance Imaging for detailed internal images'
);
INSERT INTO SCANS VALUES(
    'Ultrasound',
    'Imaging using high-frequency sound waves'
);
INSERT INTO SCANS VALUES(
    'X-Ray',
    'Radiographic imaging for viewing bone structures'
);
INSERT INTO SCANS VALUES(
    'Bone SCAN',
    'Scanning of bonbes'
);
SELECT * FROM SCANS;



CREATE TABLE DOCTOR(
    DoctorID VARCHAR(20),
    DoctorName VARCHAR(20),
    adddress VARCHAR(20),
    SPECIALIZATION VARCHAR(20),
    HOSPITALNAME VARCHAR(20),
    PRIMARY KEY(DoctorID,HOSPITALNAME)
);


INSERT INTO DOCTOR VALUES(
    'DR01',
    'Dr. Sudhevan',
    'MG Road, Kochi',
    'Cardiology',
    'Caritas Hospital'
);


INSERT INTO DOCTOR VALUES(
    'DR02',
    'Dr. Radhakrishnan',
    'Ettumanoor',
    'Neurology',
    'Matha Hospital'
);


INSERT INTO DOCTOR VALUES(
    'DR04',
    'Dr. Jayakumar',
    'Thellakom',
    'Orthopedics',
    'KIMS Hospital'
);


INSERT INTO DOCTOR VALUES(
    'DR05',
    'Dr. Sobhana',
    'Kuruppanthara',
    'Dermatology',
    'Divine Hospital'
);


SELECT * FROM DOCTOR;


CREATE TABLE PATIENTTESTS(
    PPID VARCHAR(20),
    TestName VARCHAR(50),
    DoctorID VARCHAR(20),
    HOSPITALNAME VARCHAR(60),
    TestDate DATE,
    pathtoresult VARCHAR(20),
    AmountToBePaid BIGINT,
    FOREIGN KEY(PPID) REFERENCES PATIENT(PID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(TestName) REFERENCES TESTS(TestName) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(DoctorID,HOSPITALNAME) REFERENCES DOCTOR(DoctorID,HOSPITALNAME) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(PPID, DoctorID,HOSPITALNAME, TestName, TestDate)
);
INSERT INTO PATIENTTESTS VALUES(
    'AS6',
    'DNA TEST',
    'DR05',
    'Divine Hospital',
    '2024-01-24',
    './test1',
    20000
);


INSERT INTO PATIENTTESTS VALUES(
    'AS6',
    'Biopsy',
    'DR02',
    'Matha Hospital',
    '2024-02-22',
    './test2',
    30000    
);


INSERT INTO PATIENTTESTS VALUES(
    'AJ11',
    'Blood Test',
    'DR04',
    'KIMS Hospital',
    '2024-03-22',
    './test3',
    60000
);


INSERT INTO PATIENTTESTS VALUES (
    'VN21',
    'DNA TEST',
    'DR05',
    'Divine Hospital',
    '2024-09-11',
    './test4',
    77000
);


INSERT INTO PATIENTTESTS VALUES(
    'AJ11',
    'DNA TEST',
    'DR04',
    'KIMS Hospital',
    '2024-03-22',
    './test6',
    60000
);
INSERT INTO PATIENTTESTS VALUES(
    'AJ11',
    'Blood Test',
    'DR04',
    'KIMS Hospital',
    '2024-03-26',
    './test5',
    60000
);


SELECT *FROM PATIENTTESTS;


CREATE TABLE SCANSCONDUCTED(
    SPID VARCHAR(20),
    ScanName VARCHAR(20),
    DoctorID VARCHAR(20),
    HOSPITALNAME VARCHAR(60),
    PathTOFilePRSC VARCHAR(20 ),
    pathtoresult VARCHAR(20),
    amount int,
    ScanDate Date,
    FOREIGN KEY(SPID) REFERENCES PATIENT(PID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(DoctorID,HOSPITALNAME) REFERENCES DOCTOR(DoctorID,HOSPITALNAME) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(SPID,ScanName,DoctorID,HOSPITALNAME)
);

INSERT INTO SCANSCONDUCTED VALUES(
    'AS6',
    'CT Scan',
    'DR04',
    'KIMS Hospital',
    './scan1',
    './result1',
     10000,
     '2024-10-06'
);

INSERT INTO SCANSCONDUCTED VALUES(
    'AJ11',
    'MRI',
    'DR04',
    'KIMS Hospital',
    './scan2',
    './result2',
    5000,
    '2024-10-03'
);

INSERT INTO SCANSCONDUCTED VALUES(
    'VN21',
    'Ultrasound',
    'DR05',
    'Divine Hospital',
    './scan3',
    './result3',
     2500,
     '2024-12-15'

);

INSERT INTO SCANSCONDUCTED VALUES(
    'AS6',
    'X-Ray',
    'DR02',
    'Matha Hospital',
    './scan4',
    './result4',
      4000,
     '2024-8-18'

);

INSERT INTO SCANSCONDUCTED VALUES(
    'AJ11',
    'CT Scan',
    'DR04',
    'KIMS Hospital',
    './scan5',
    './result5',
     2400,
     '2024-11-29'
);
SELECT * FROM SCANSCONDUCTED;



-- (a)
SELECT *
FROM PATIENT AS p JOIN PATIENTTESTS AS pt 
ON p.PID=pt.PPID
WHERE p.PID='AS6' AND pt.TestDate BETWEEN '2024-01-23' and '2024-01-25';


-- (b)
SELECT P.*,TestName FROM 
PATIENTTESTS PT JOIN PATIENT P 
ON PT.PPID=P.PID
ORDER BY TestName;


-- (c)(1)
SELECT TestName,COUNT(TestName) AS Max_Count
FROM PATIENTTESTS
GROUP BY TestName
HAVING COUNT(TestName) = (
    SELECT MAX(CS)
    FROM (
        SELECT COUNT(TestName) AS CS FROM 
        PATIENTTESTS
        GROUP BY TestName
    ) AS drak
);


SELECT TestName,COUNT(TestName) AS Min_Count
FROM PATIENTTESTS
GROUP BY TestName
HAVING COUNT(TestName) = (
    SELECT MIN(CS)
    FROM (
        SELECT COUNT(TestName) AS CS FROM 
        PATIENTTESTS
        GROUP BY TestName
    ) AS drak
);
-- (d)

SELECT * FROM PATIENT WHERE PID IN (SELECT SC.SPID FROM SCANSCONDUCTED SC GROUP BY SC.SPID,ScanName HAVING COUNT(*) <= 2);


-- (e)(1)
SELECT T.TestName,ifnull(SUM(pt.AmountToBePaid),0) AS CREDIT
FROM TESTS as T LEFT JOIN PATIENTTESTS as pt
ON T.TestName=pt.TestName
GROUP BY T.TestName;
-- (e)(2)
SELECT S.ScanName,ifnull(SUM(sc.Amount),0) AS CREDIT
FROM SCANS as S LEFT JOIN SCANSCONDUCTED as sc
ON S.ScanName=sc.ScanName
GROUP BY S.ScanName;


-- (f)(1)
SELECT S.ScanName,S.ScanDescription
FROM SCANS as S JOIN SCANSCONDUCTED as sc 
ON S.ScanName=sc.ScanName
WHERE sc.ScanDate=(
SELECT MAX(ScanDate)
FROM SCANSCONDUCTED
);

-- (f)(2)
SELECT S.ScanName,S.ScanDescription
FROM SCANS as S JOIN SCANSCONDUCTED as sc 
ON S.ScanName=sc.ScanName
WHERE sc.ScanDate=(
SELECT MIN(ScanDate)
FROM SCANSCONDUCTED
);

-- (g)(1)
SELECT dr.*
FROM PATIENTTESTS as pt JOIN DOCTOR as dr
ON dr.DoctorID=pt.DoctorID
WHERE pt.TestDate BETWEEN '2020-19-03' AND '2025-12-29'
GROUP BY pt.DoctorID,dr.DoctorName,dr.SPECIALIZATION,dr.HOSPITALNAME,dr.adddress
HAVING COUNT(pt.DoctorID) = (
    SELECT MAX(max_count)
    FROM(
        SELECT COUNT(*) AS max_count
        FROM PATIENTTESTS AS pt
        WHERE pt.TestDate BETWEEN '2020-19-03' AND '2025-12-29'
        GROUP BY pt.DoctorID
    )AS subquery
);



-- (g)(2)
SELECT dr.*
FROM PATIENTTESTS as pt JOIN DOCTOR as dr
ON dr.DoctorID=pt.DoctorID
WHERE pt.TestDate BETWEEN '2020-19-03' AND '2025-12-29'
GROUP BY pt.DoctorID,dr.DoctorName,dr.SPECIALIZATION,dr.HOSPITALNAME,dr.adddress
HAVING COUNT(pt.DoctorID) = (
    SELECT MIN(max_count)
    FROM(
        SELECT COUNT(*) AS max_count
        FROM PATIENTTESTS AS pt
        WHERE pt.TestDate BETWEEN '2020-19-03' AND '2025-12-29'
        GROUP BY pt.DoctorID
    )AS subquery
);

-- (h)
SELECT DoctorID, SUM(rev) FROM 
((SELECT pt.DoctorID, SUM(pt.AmountToBePaid) as rev FROM PATIENTTESTS pt JOIN DOCTOR dr ON pt.DoctorID = dr.DoctorID GROUP BY pt.DoctorID)
UNION
(SELECT pt.DoctorID, SUM(pt.amount) as rev FROM SCANSCONDUCTED pt JOIN DOCTOR dr ON pt.DoctorID = dr.DoctorID GROUP BY pt.DoctorID)) A GROUP BY A.DoctorID;



DROP DATABASE MEDICALLAB;