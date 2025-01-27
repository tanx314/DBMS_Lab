CREATE DATABASE ThesisRepository;
USE ThesisRepository;

CREATE TABLE Students (
    Name VARCHAR(100),
    RollNumber VARCHAR(50),
    Address VARCHAR(255),
    UniversityEmailID VARCHAR(100),
    MobileNumber BIGINT,
    DepartmentName VARCHAR(100),
    Course CHAR(1),
    PRIMARY KEY(RollNumber)
);

INSERT INTO Students VALUES
('Raghavan','CS22MS01','RaghavanVeed','cs22ms01@ktu.in',1111111111,'Computer Science', 'M'),
('Shaji', 'ME22PD02', 'Shajiveed', 'me22pd02@ktu.in', 2222222222, 'Mechanical Engineering', 'P'),
('Shobhana','CS22MS03', 'Shobhanaveed','cs22ms03@ktu.in', 3333333333, 'Computer Science', 'M'),
('Siby', 'ME22PD04', 'Sibyveed', 'me22pd04@ktu.in', 4444444444, 'Mechanical Engineering', 'P'),
('Mini', 'CS22MS05', 'Miniveed', 'cs22ms05@ktu.in', 5555555555, 'Computer Science', 'M'),
('Anjali', 'CS22PHD01', 'AnjaliVeed', 'cs22phd01@ktu.in', 6666666666, 'Computer Science', 'P'),
('Vikram', 'CS22PHD02', 'VikramVeed', 'cs22phd02@ktu.in', 7777777777, 'Computer Science', 'P');

CREATE TABLE Guide (
    Name VARCHAR(30),
    EmployeeID VARCHAR(20),
    ResearchArea VARCHAR(40),
    Department VARCHAR(40),
    Designation VARCHAR(20),
    UniversityEmailID VARCHAR(100),
    MobileNumber BIGINT,
    PRIMARY KEY(EmployeeID)
);

INSERT INTO Guide VALUES
('Dr. Ravi Kumar', 'EMP001', 'Artificial Intelligence', 'Computer Science', 'Professor', 'ravi.kumar@university.edu', 9876543210),
('Dr. Meena Sharma', 'EMP002', 'Thermodynamics', 'Mechanical Engineering', 'Associate Professor', 'meena.sharma@university.edu', 9876543211),
('Dr. Arjun Patel', 'EMP003', 'Data Mining', 'Information Technology', 'Professor', 'arjun.patel@university.edu', 9876543212),
('Dr. Priya Iyer', 'EMP004', 'Structural Engineering', 'Civil Engineering', 'Assistant Professor', 'priya.iyer@university.edu', 9876543213),
('Rajesh Nair', 'EMP005', 'Instrumentation','Electronics Engineering','Lab Staff','rajesh.nair@university.edu',9876543214);

CREATE TABLE Thesis (
    Title VARCHAR(50),
    Area VARCHAR(30),
    PRIMARY KEY(Title)
);

INSERT INTO Thesis VALUES
('AI in Healthcare', 'Artificial Intelligence'),
('Thermal Efficiency', 'Mechanical Engineering'),
('Data Privacy', 'Information Security'),
('Bridge Design', 'Civil Engineering'),
('Approximation Algorithms', 'Computer Science'),
('Machine Learning Models', 'Artificial Intelligence'),
('Neural Networks in AI', 'Artificial Intelligence');

CREATE TABLE ThesisRecord (
    RollNumber VARCHAR(50),
    Title VARCHAR(50),
    GuideID VARCHAR(20),
    DateOfSubm DATE,
    FOREIGN KEY (RollNumber) REFERENCES Students(RollNumber) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (GuideID) REFERENCES Guide(EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Title) REFERENCES Thesis(Title) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO ThesisRecord VALUES 
('CS22MS01', 'AI in Healthcare', 'EMP001', '2024-09-01'),
('ME22PD02', 'Thermal Efficiency', 'EMP002', '2024-09-10'),
('CS22MS05', 'Data Privacy', 'EMP003', '2024-09-15'),
('ME22PD04', 'Bridge Design', 'EMP004', '2024-09-20'),
('CS22MS05', 'AI in Healthcare', 'EMP001', '2024-09-25'),
('CS22MS03', 'Bridge Design', 'EMP004', '2024-09-30'),
('CS22MS03', 'Approximation Algorithms', 'EMP001', '2024-09-01'),
('CS22PHD01', 'Machine Learning Models', 'EMP001', '2024-10-01'), 
('CS22PHD01', 'Neural Networks in AI', 'EMP003', '2024-10-10'), 
('CS22PHD02', 'Machine Learning Models', 'EMP002', '2024-10-05'),
('CS22PHD02', 'Neural Networks in AI', 'EMP001', '2024-10-15');

CREATE TABLE IndexTable (
    IndexID INT AUTO_INCREMENT PRIMARY KEY,
    ThesisID VARCHAR(50),
    Keyword VARCHAR(50),
    FOREIGN KEY (ThesisID) REFERENCES Thesis(Title) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO IndexTable (ThesisID, Keyword) VALUES
('AI in Healthcare', 'Healthcare'),
('AI in Healthcare', 'Artificial Intelligence'),
('Approximation Algorithms', 'Algorithms'),
('Approximation Algorithms', 'Approximation');

-- (a) Find details of guides for the thesis titled "Approximation Algorithms"
SELECT g.*
FROM Guide g
JOIN ThesisRecord tr ON g.EmployeeID = tr.GuideID
JOIN Thesis t ON tr.Title = t.Title
WHERE t.Title = 'Approximation Algorithms';

-- (b)(1) Guide with maximum number of thesis supervised
SELECT g.*, COUNT(tr.Title) AS ThesisCount
FROM Guide g
JOIN ThesisRecord tr ON g.EmployeeID = tr.GuideID
GROUP BY g.EmployeeID
ORDER BY ThesisCount DESC
LIMIT 1;

-- (b)(2) Guide with minimum number of thesis supervised
SELECT g.*, COUNT(tr.Title) AS ThesisCount
FROM Guide g
JOIN ThesisRecord tr ON g.EmployeeID = tr.GuideID
GROUP BY g.EmployeeID
ORDER BY ThesisCount ASC
LIMIT 1;

-- (c) Students who submitted multiple theses in the same area but with different guides
SELECT s.*
FROM Students s
JOIN ThesisRecord tr ON s.RollNumber = tr.RollNumber
JOIN Thesis t ON tr.Title = t.Title
GROUP BY s.RollNumber, t.Area
HAVING COUNT(DISTINCT tr.GuideID) > 1;

-- (d) Guides with PhD students in multiple areas
SELECT g.*
FROM Guide g
JOIN ThesisRecord tr ON g.EmployeeID = tr.GuideID
JOIN Thesis t ON tr.Title = t.Title
JOIN Students s ON tr.RollNumber = s.RollNumber
WHERE s.Course = 'P'
GROUP BY g.EmployeeID
HAVING COUNT(DISTINCT t.Area) > 1;

-- (e)
SELECT 
    i.Keyword,
    SUM(CASE WHEN s.Course = 'P' THEN 1 ELSE 0 END) AS PhD_Thesis_Count,
    SUM(CASE WHEN s.Course = 'M' THEN 1 ELSE 0 END) AS MS_Thesis_Count
FROM 
    IndexTable i
JOIN 
    Thesis t ON i.ThesisID = t.Title
JOIN 
    ThesisRecord tr ON t.Title = tr.Title
JOIN 
    Students s ON tr.RollNumber = s.RollNumber
GROUP BY 
    i.Keyword;

    -- (f)
    SELECT 
    g.*
FROM 
    Guide g
LEFT JOIN 
    ThesisRecord tr ON g.EmployeeID = tr.GuideID 
    AND tr.DateOfSubm BETWEEN '2024-01-01' AND '2024-12-31' 
WHERE 
    tr.GuideID IS NULL;


-- (g)Maximum
SELECT Area, COUNT(*) AS ThesisCount
FROM Thesis
GROUP BY Area
HAVING COUNT(*) = (SELECT MAX(ThesisCount) 
                   FROM (SELECT COUNT(*) AS ThesisCount 
                         FROM Thesis 
                         GROUP BY Area) AS SubQuery);
-- (g)Minimum
SELECT Area, COUNT(*) AS ThesisCount
FROM Thesis
GROUP BY Area
HAVING COUNT(*) = (SELECT MIN(ThesisCount) 
                   FROM (SELECT COUNT(*) AS ThesisCount 
                         FROM Thesis 
                         GROUP BY Area) AS SubQuery);

-- (h) Guides with MS theses only from one central area
SELECT g.*
FROM Guide g
JOIN ThesisRecord tr ON g.EmployeeID = tr.GuideID
JOIN Thesis t ON tr.Title = t.Title
JOIN Students s ON tr.RollNumber = s.RollNumber
WHERE s.Course = 'M'
GROUP BY g.EmployeeID
HAVING COUNT(DISTINCT t.Area) = 1;

-- (i) Students with multiple theses, each with unique keywords
SELECT s.*
FROM Students s
JOIN ThesisRecord tr ON s.RollNumber = tr.RollNumber
JOIN IndexTable i ON tr.Title = i.ThesisID
GROUP BY s.RollNumber
HAVING COUNT(DISTINCT i.Keyword) = COUNT(i.Keyword);


DROP DATABASE ThesisRepository;
