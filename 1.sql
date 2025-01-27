CREATE DATABASE DIPESHBANK;
USE DIPESHBANK;

CREATE TABLE CUSTOMER(
    name varchar(20),
    aadharno BIGINT CHECK(aadharno BETWEEN 100000000000 AND 999999999999),
    panno varchar(20),
    mob BIGINT,
    address varchar(30),
    emailid varchar(30),
    PRIMARY KEY(aadharno)
);
INSERT INTO CUSTOMER VALUES('Dipesh',250150719628,1234567,8078176686,'Vazhapalliparambil','dipeshvs100@gmail.com');
INSERT INTO CUSTOMER VALUES('Prabhav',250150719622,1234564,8078982889,'Sreeprabhavam','prabhu100@gmail.com');
INSERT INTO CUSTOMER VALUES('Hari',250150739628,100000,9448176686,'Hariveed','hari@gmail.com');
INSERT INTO CUSTOMER VALUES('Jaseel',111122223333,1000000000,9447636686,'JaseelVeed','jaseel@gmail.com');



CREATE TABLE CHITTY(
    Chittyno INT,
    Branch varchar(20),
    ChittyAmount BIGINT,
    StartDate Date,
    No_Installment int,
    Statuss varchar(20) CHECK(Statuss IN('OPEN', 'CLOSED')),
    PRIMARY KEY(Chittyno,Branch)
);
INSERT INTO CHITTY VALUES(231,'Ottapalam',10000.1,'2005-01-24',12,'OPEN');
INSERT INTO CHITTY VALUES(123,'Manjoor',90000.1,'2004-01-24',12,'CLOSED');
INSERT INTO CHITTY VALUES(456,'Manjoor',80000.1,'2007-01-12',12,'OPEN');
INSERT INTO CHITTY VALUES(777,'Manjoor',60000.1,'2007-02-24',12,'CLOSED');




CREATE TABLE LOAN (
    LoanNo INT,
    LoanType VARCHAR(20) CHECK(LoanType IN ('Homeloan', 'Personalloan', 'Carloan', 'Businessloan')),
    Branch varchar(20),
    aadharno BIGINT,
    Chittyno INT,  
    Amount FLOAT,
    PeriodS VARCHAR(20),
    EMI FLOAT,
    FOREIGN KEY (aadharno) REFERENCES CUSTOMER(aadharno) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Chittyno,Branch) REFERENCES CHITTY(Chittyno,Branch) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (aadharno,Branch,LoanNo)
);
INSERT INTO LOAN VALUES(121,'Homeloan','Ottapalam',250150719628,231,250001,'12 Months',1500);
INSERT INTO LOAN VALUES(122,'Personalloan','Manjoor',250150719622,123,350001,'12 Months',1200);
INSERT INTO LOAN VALUES(123,'Carloan','Manjoor',250150739628,456,450001,'12 Months',2200);
INSERT INTO LOAN VALUES(124,'Businessloan','Manjoor',111122223333,777,270001,'12 Months',3200);



CREATE TABLE CUSTOMERCHITTY(
    aadharno BIGINT,
    Branch varchar(20),
    Chittyno int,
    ChittalNo VARCHAR(20),
    FOREIGN KEY (aadharno) REFERENCES CUSTOMER(aadharno) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ( Chittyno,Branch) REFERENCES CHITTY(Chittyno,Branch) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (aadharno, Branch,ChittalNo,Chittyno)
);
INSERT INTO CUSTOMERCHITTY VALUES(250150719628,'Ottapalam',231,'DVS29');
INSERT INTO CUSTOMERCHITTY VALUES(250150739628,'Manjoor',456,'HN29');
INSERT INTO CUSTOMERCHITTY VALUES(111122223333,'Manjoor',777,'JS29');

CREATE TABLE CHITTYPAYMENT(
    Chittyno INT,
    ChittalNo VARCHAR(20),
    Branch VARCHAR(20),
    aadharno BIGINT,  
    Statuss VARCHAR(20),
    PaidAmount INT,
    PayDate Date,
    ModeofPay VARCHAR(20),
    PaidBranch VARCHAR(20),
   FOREIGN KEY (aadharno, Branch, ChittalNo, Chittyno) 
       REFERENCES CUSTOMERCHITTY(aadharno, Branch, ChittalNo, Chittyno) 
       ON DELETE CASCADE ON UPDATE CASCADE,
   PRIMARY KEY(Chittyno, ChittalNo, Branch, PaidBranch)
);

INSERT INTO CHITTYPAYMENT VALUES(456,'HN29','Manjoor',250150739628,'Ongoing',2000,'2006-10-24','Online','Ottapalam');



CREATE TABLE CHITTYAUC(
    aadharno BIGINT,
    Branch VARCHAR(20),
    Chittyno INT,
    ChittalNo VARCHAR(20),
    AucAmount BIGINT,
    FOREIGN KEY(aadharno, Branch,ChittalNo,Chittyno) REFERENCES CUSTOMERCHITTY(aadharno, Branch,ChittalNo,Chittyno) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (aadharno,Branch,ChittalNo,Chittyno)
);
INSERT INTO CHITTYAUC VALUES(250150719628,'Ottapalam',231,'DVS29',8000);
INSERT INTO CHITTYAUC VALUES(250150739628,'Manjoor',456,'HN29',82000);
INSERT INTO CHITTYAUC VALUES(111122223333,'Manjoor',777,'JS29',50000);

CREATE TABLE LOANPAYMENT(
    PaymentId VARCHAR(10),
    aadharno BIGINT,
    LoanNo INT,
    Branch varchar(20),
    Amount FLOAT,
    LoanBranch VARCHAR(20),
    DateofPay DATE,
    FOREIGN KEY(aadharno,Branch,LoanNo) REFERENCES LOAN(aadharno,Branch,LoanNo) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(PaymentId,aadharno,LoanNo,LoanBranch)
);

-- (a)
SELECT * FROM CUSTOMER c JOIN ((SELECT aadharno FROM LOAN) INTERSECT (SELECT aadharno FROM CUSTOMERCHITTY)) a on c.aadharno=a.aadharno; 
SELECT * FROM CUSTOMER c JOIN ((SELECT aadharno FROM LOAN) EXCEPT (SELECT aadharno FROM CUSTOMERCHITTY)) a on c.aadharno=a.aadharno;

-- (b)
SELECT * FROM CUSTOMER c JOIN LOAN l 
ON l.aadharno=c.aadharno
ORDER BY l.amount desc;
 
-- (c)
SELECT LoanType,COUNT(*) FROM LOAN
GROUP BY LoanType;

-- (d)
SELECT c.* FROM CUSTOMER c JOIN CUSTOMERCHITTY cc JOIN CHITTYPAYMENT cp ON
c.aadharno=cc.aadharno AND cc.Chittyno=cp.Chittyno AND cc.branch<>cp.PaidBranch;

-- (e)

SELECT * FROM CHITTYAUC ac JOIN CHITTY c ON ac.Chittyno = c.Chittyno
WHERE 
    c.Statuss = 'CLOSED' AND 
    ac.AucAmount = (
        SELECT MAX(ac1.AucAmount) FROM CHITTYAUC ac1 JOIN CHITTY c1 ON ac1.Chittyno = c1.Chittyno
        WHERE c1.Statuss='CLOSED' AND c1.branch = c.branch
    );

SELECT * FROM CHITTYAUC ac JOIN CHITTY c ON ac.Chittyno = c.Chittyno
WHERE 
    c.Statuss = 'CLOSED' AND 
    ac.AucAmount = (
        SELECT MIN(ac1.AucAmount) FROM CHITTYAUC ac1 JOIN CHITTY c1 ON ac1.Chittyno = c1.Chittyno
        WHERE c1.Statuss='CLOSED' AND c1.branch = c.branch
    );



DROP DATABASE DIPESHBANK;
