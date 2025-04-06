CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(255),
    dob DATE,
    gender VARCHAR(255),
    password VARCHAR(255),
    role VARCHAR(255) CHECK (role IN ('Resident', 'Managing Staff', 'Security Staff'))
);


CREATE TABLE Visitor_Requests (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    visitor_name VARCHAR(255),
    visitor_email VARCHAR(255),
    visitor_phone VARCHAR(255),
    visitor_id VARCHAR(255),
    visitor_gender VARCHAR(255),
    purpose VARCHAR(255),
    visit_date DATE,
    visit_time TIME,
    verification_code VARCHAR(255),
    status VARCHAR(255) CHECK (status IN ('Pending', 'Approved', 'Cancelled')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


CREATE TABLE Requests_Log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT,
    approved_by INT,
    approval_time DATETIME,
    status VARCHAR(255) CHECK (status IN ('Approved', 'Rejected')),
    comments TEXT,
    FOREIGN KEY (request_id) REFERENCES Visitor_Requests(request_id),
    FOREIGN KEY (approved_by) REFERENCES Users(user_id)
);


CREATE TABLE Activity_Logs (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT,
    verified_by INT,
    verification_time DATETIME,
    status VARCHAR(255) CHECK (status IN ('Verified', 'Failed')),
    FOREIGN KEY (request_id) REFERENCES Visitor_Requests(request_id),
    FOREIGN KEY (verified_by) REFERENCES Users(user_id)
);


CREATE TABLE Profiles (
    profile_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    name VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(255),
    dob DATE,
    gender VARCHAR(255),
    password VARCHAR(255),
    role VARCHAR(255) CHECK (role IN ('Resident', 'Managing Staff', 'Security Staff')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


INSERT INTO Users (name, email, phone_number, dob, gender, password, role) VALUES
('Admin User', 'admin@example.com', '0123456789', '1985-07-10', 'Male', 'admin123', 'Managing Staff'),
('Security Staff 1', 'security1@example.com', '01123456781', '1994-03-30', 'Male', 'security123', 'Security Staff'),
('Security Staff 2', 'security2@example.com', '01123456782', '2004-10-18', 'Male', 'security123', 'Security Staff'),
('Security Staff 3', 'security3@example.com', '01123456783', '2004-11-17', 'Male', 'security123', 'Security Staff');


-- 20 Residents
INSERT INTO Users (name, email, phone_number, dob, gender, password, role)
SELECT 'Resident ' + CAST(n AS VARCHAR), 
       'resident' + CAST(n AS VARCHAR) + '@example.com',
       '0101234567' + CAST(n AS VARCHAR),
       DATEADD(YEAR, -20, GETDATE()),
       CASE WHEN n % 2 = 0 THEN 'Male' ELSE 'Female' END,
       'resident123',
       'Resident'
FROM (SELECT TOP 20 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM master.dbo.spt_values) AS T;

INSERT INTO Visitor_Requests 
(user_id, visitor_name, visitor_email, visitor_phone, visitor_id, visitor_gender, purpose, visit_date, visit_time, verification_code, status) 
VALUES
(42, 'Visitor 1', 'visitor1@mail.com', '01987654321', 'VST0001', 'Female', 'Visiting Resident', '2025-02-28', '05:15:08', 'CODE0001', 'Approved'),
(43, 'Visitor 2', 'visitor2@mail.com', '01987654322', 'VST0002', 'Male', 'Meeting Friend', '2025-02-09', '10:30:00', 'CODE0002', 'Pending'),
(44, 'Visitor 3', 'visitor3@mail.com', '01987654323', 'VST0003', 'Female', 'Project Discussion', '2025-02-26', '13:15:08', 'CODE0003', 'Approved'),
(45, 'Visitor 4', 'visitor4@mail.com', '01987654324', 'VST0004', 'Male', 'Event Attendance', '2025-02-15', '18:00:00', 'CODE0004', 'Rejected'),
(46, 'Visitor 5', 'visitor5@mail.com', '01987654325', 'VST0005', 'Female', 'Workshop Participation', '2025-03-03', '14:30:00', 'CODE0005', 'Cancelled');



INSERT INTO Requests_Log (request_id, approved_by, approval_time, status, comments) 
VALUES
(9, 38, '2025-02-27 05:15:08', 'Approved', 'Request approved successfully'),
(10, 38, '2025-02-26 05:15:08', 'Approved', 'Request approved successfully'),
(11, 38, '2025-03-04 05:15:08', 'Approved', 'Request approved successfully'),
(12, 38, '2025-02-15 05:15:08', 'Rejected', 'The visitor details were incomplete'),
(13, 38, '2025-02-23 05:15:08', 'Approved', 'Security cleared the visitor');



INSERT INTO Activity_Logs (request_id, verified_by, verification_time, status) 
VALUES
(9, 39, '2025-02-28 05:15:08', 'Verified'),
(10, 40, '2025-02-24 05:15:08', 'Verified'),
(11, 41, '2025-02-14 05:15:08', 'Verified'),
(12, 39, '2025-03-10 05:15:08', 'Failed'),
(13, 40, '2025-02-24 05:15:08', 'Verified');





