CREATE DATABASE RESORT;
USE RESORT;
CREATE TABLE EMPLOYEE(
    Name VARCHAR(20),
    Address VARCHAR(20),
    AadharNo BIGINT(20) CHECK(aadharno BETWEEN 100000000000 AND 999999999999),
    MobNo BIGINT,
    EmailId VARCHAR(40),
    DateOfJoin DATE,
    Salary INT,
    PRIMARY KEY(AadharNo)
);

INSERT INTO EMPLOYEE VALUES
('Dipesh', 'Vazhapalliparambil', 240150719628, 8078176686, 'dipeshvs100@gmail.com', '2022-12-01', 60000),
('Abhiram', 'Abhiramveed', 250150719622, 8078982889, 'abhiram@gmail.com', '2022-09-01', 50000),
('Prabhav', 'Prabhaveed', 260150719623, 8078176799, 'prabhav@gmail.com', '2022-10-15', 55000),
('Jaseel', 'Jaseelveed', 270150719624, 8078176700, 'jaseel@gmail.com', '2022-11-20', 52000),
('Hari', 'Hariveed', 280150719625, 8078176801, 'hari@gmail.com', '2022-08-25', 58000),
('Febin', 'Febinveed', 290150719626, 8078176902, 'febin@gmail.com', '2022-07-30', 53000);

CREATE TABLE RESIDENTS(
    Name VARCHAR(20),
    Address VARCHAR(20),
    AadharNo BIGINT(20),
    Gender VARCHAR(20),
    Age INT CHECK(Age<>0),
    MobNo BIGINT,
    EmailId VARCHAR(40),
    PRIMARY KEY(AadharNo)
);
INSERT INTO RESIDENTS VALUES
('Anand', 'anandveed', 310150719627, 'Male', 30, 8078177701, 'anand@gmail.com'),
('Sooraj', 'soorajveed', 320150719628, 'Male', 28, 8078177702, 'sooraj@gmail.com'),
('Akhil', 'akhilveed', 330150719629, 'Male', 30, 8078177703, 'akhil@gmail.com'),
('Abhimanue', 'abhimanueveed', 340150719630, 'Male', 35, 8078177704, 'abhimanue@gmail.com');

CREATE TABLE ROOMS(
    roomNo int,
    roomType varchar(20),
    capacity varchar(20),
    PRIMARY KEY(roomNo)
);
INSERT INTO ROOMS VALUES
(101, 'A/C', 'Single Bed'),
(102, 'Non-A/C', 'Double Bed'),
(103, 'A/C', 'Single Bed'),
(104, 'A/C', 'Double Bed'),
(105, 'Non-A/C', 'Single Bed');

CREATE TABLE FOODITEMS(
    ItemName varchar(30),
    FoodType varchar(20),
    price float,
    PRIMARY KEY(ItemName)
);
INSERT INTO FOODITEMS VALUES
('Vegetable Curry', 'Vegetarian', 150.00),
('Chicken Biryani', 'Non-Vegetarian', 250.00),
('Paneer Tikka', 'Vegetarian', 200.00),
('Fish Fry', 'Non-Vegetarian', 300.00),
('Dal Tadka', 'Vegetarian', 120.00);

CREATE TABLE BOOKING(
    BookingID INT,
    ResAadharNo BIGINT,
    RoomNo INT,
    Check_InDATE DATE,
    Check_OutDate DATE,
    BookingDate DATE,
    PRIMARY KEY(BookingID),
    FOREIGN KEY(ResAadharNo) REFERENCES RESIDENTS(AadharNo) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO BOOKING VALUES
(1001, 310150719627, 101, '2023-05-01', '2023-05-07', '2023-04-20'),
(1002, 320150719628, 102, '2023-06-10', '2023-06-15', '2023-06-01'),
(1003, 330150719629, 103, '2023-07-05', '2023-07-10', '2023-06-25'),
(1004, 340150719630, 104, '2023-08-15', '2023-08-20', '2023-08-01'),
(1005, 310150719627, 101, '2023-05-01', '2023-05-07', '2023-04-20'),
(1006, 310150719627, 101, '2023-05-01', '2023-05-07', '2023-04-20'),
(1007, 310150719627, 101, '2023-05-01', '2023-05-07', '2023-04-20');

CREATE TABLE COMPANIONS(
     Name VARCHAR(20),
     Gender VARCHAR(20),
     MobNo BIGINT,
     ResAadharNo BIGINT,
     BookingID INT,
     FOREIGN KEY(ResAadharNo) REFERENCES RESIDENTS(AadharNo) ON DELETE CASCADE ON UPDATE CASCADE,
     PRIMARY KEY(Name,ResAadharNo),
     FOREIGN KEY(BookingID) REFERENCES BOOKING(BookingID) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO COMPANIONS VALUES
('Johaan', 'Male', 8078177801, 310150719627,1001),
('Appu', 'Male', 8078177878, 310150719627,1006),
('Mani', 'Male', 8078177898, 310150719627,1005),
('Kannan', 'Male', 8078177845, 310150719627,1007),
('Aashirvad', 'Male', 8078177802, 320150719628,1002),
('Dhanshyam', 'Male', 8078177803, 330150719629,1003),
('Gokul', 'Male', 8078177804, 340150719630,1004);

CREATE TABLE ORDERS(
    OrderNo INT,
    ItemName VARCHAR(20),
    AadharNo BIGINT,
    BookingID INT,
    FOREIGN KEY(BookingID) REFERENCES BOOKING(BookingID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(ItemName) REFERENCES FOODITEMS(ItemName) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(AadharNo) REFERENCES RESIDENTS(AadharNo) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(OrderNo)
);

INSERT INTO ORDERS VALUES
(1, 'Vegetable Curry', 310150719627, 1001),
(2, 'Chicken Biryani', 320150719628, 1002),
(3, 'Paneer Tikka', 330150719629, 1003),
(4, 'Fish Fry', 340150719630, 1004),
(5, 'Vegetable Curry', 310150719627, 1005);



-- (a)
CREATE VIEW CompanionRes AS
SELECT R.Name,R.Address,R.AadharNo,R.Gender,R.Age,R.MobNo,COUNT(C.BookingID) AS CompanionCount
FROM RESIDENTS R
JOIN COMPANIONS C ON R.Aadharno=C.ResAadharNo
GROUP BY R.Name,R.Address,R.AadharNo,R.Gender,R.Age,R.mobno;

SELECT * FROM CompanionRes
WHERE CompanionCount > 3;

-- (b)
CREATE VIEW CompanionResDate AS
SELECT R.Name, R.Address, R.AadharNo, R.Gender, R.Age, R.MobNo, B.BookingDate, COUNT(DISTINCT C.BookingID) AS CompanionCount
FROM RESIDENTS R
JOIN COMPANIONS C ON R.AadharNo = C.ResAadharNo
JOIN BOOKING B ON R.AadharNo = B.ResAadharNo
GROUP BY R.Name, R.Address, R.AadharNo, R.Gender, R.Age, R.MobNo, B.BookingDate;

SELECT * 
FROM CompanionResDate
WHERE BookingDate BETWEEN '2023-03-01' AND '2023-05-07';

-- (c)
CREATE VIEW ACRoomBookings AS
SELECT R.Name, R.Address, R.AadharNo, COUNT(DISTINCT B.BookingID) AS BookingCount, COUNT(B.RoomNo) AS RoomCount
FROM RESIDENTS R
JOIN BOOKING B ON R.AadharNo = B.ResAadharNo
JOIN ROOMS RM ON B.RoomNo = RM.roomNo
WHERE RM.roomType = 'A/C'
GROUP BY R.Name, R.Address, R.AadharNo;

SELECT * 
FROM ACRoomBookings
WHERE BookingCount >= 2 AND RoomCount > 2;

-- (d)
CREATE VIEW FOOD AS
SELECT F.ItemName,COUNT(O.AadharNo) as FoodCount
FROM FOODITEMS F
JOIN ORDERS O ON O.ItemName=F.ItemName
GROUP BY F.ItemName;
-- (part 2)
SELECT * FROM FOOD 
WHERE FoodCount=( SELECT MAX(FoodCount)FROM FOOD);
-- (part 1)
SELECT * FROM FOOD 
WHERE FoodCount=( SELECT MIN(FoodCount)FROM FOOD);

-- (e)
CREATE VIEW FoodPreference AS
SELECT F.ItemName, F.FoodType, F.Price, COUNT(O.OrderNo) AS OrderCount
FROM FOODITEMS F
JOIN ORDERS O ON F.ItemName = O.ItemName
JOIN BOOKING B ON O.BookingID = B.BookingID
WHERE B.BookingDate BETWEEN '2023-03-01' AND '2023-05-07'
GROUP BY F.ItemName, F.FoodType, F.Price
ORDER BY OrderCount DESC, Price ASC;

SELECT * FROM FoodPreference;



DROP DATABASE RESORT;