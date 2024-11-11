CREATE DATABASE IF NOT EXISTS it_infra_mgmt;
USE it_infra_mgmt;

-- Team Table (without foreign key)
CREATE TABLE Team (
    Team_ID INT AUTO_INCREMENT PRIMARY KEY,
    Team_Name VARCHAR(100) NOT NULL,
    No_Of_Members INT,
    Headed_By INT -- This will reference Employee_ID but added later as a foreign key
);

-- Employee Table (without foreign key)
CREATE TABLE Employee (
    Employee_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(100),
    Username VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Is_Admin BOOLEAN DEFAULT FALSE,
    Team_ID INT -- This will reference Team_ID but added later as a foreign key
);

-- Hardware Table
CREATE TABLE Hardware (
    Hardware_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Usage_Instructions TEXT,
    Allocation_Status VARCHAR(50) NOT NULL
);

-- Software Table
CREATE TABLE Software (
    Software_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    License_Key VARCHAR(100),
    Documentation TEXT,
    Allocation_Status VARCHAR(50) NOT NULL
);

-- Request Table
CREATE TABLE Request (
    Request_ID INT AUTO_INCREMENT PRIMARY KEY,
    Date_Of_Request DATE NOT NULL,
    Employee_ID VARCHAR(100) NOT NULL,
    Hardware_Allocated INT,
    Software_Allocated INT
);

-- Project Table (without foreign key)
CREATE TABLE Project (
    Project_ID INT AUTO_INCREMENT PRIMARY KEY,
    Project_Start_Date DATE,
    Budget DECIMAL(15, 2),
    Name VARCHAR(100) NOT NULL,
    Team_ID INT -- This will reference Team_ID but added later as a foreign key
);

-- Add foreign key for Employee.Team_ID referencing Team.Team_ID
ALTER TABLE Employee
ADD CONSTRAINT fk_team
FOREIGN KEY (Team_ID) REFERENCES Team(Team_ID);

-- Add foreign key for Team.Headed_By referencing Employee.Employee_ID
ALTER TABLE Team
ADD CONSTRAINT fk_headed_by
FOREIGN KEY (Headed_By) REFERENCES Employee(Employee_ID);

-- Add foreign key for Request.Hardware_Allocated and Request.Software_Allocated
ALTER TABLE Request
ADD CONSTRAINT fk_hardware_allocated
FOREIGN KEY (Hardware_Allocated) REFERENCES Hardware(Hardware_ID);

ALTER TABLE Request
ADD CONSTRAINT fk_software_allocated
FOREIGN KEY (Software_Allocated) REFERENCES Software(Software_ID);

-- Add foreign key for Project.Team_ID referencing Team.Team_ID
ALTER TABLE Project
ADD CONSTRAINT fk_project_team
FOREIGN KEY (Team_ID) REFERENCES Team(Team_ID);

-- Insert sample data into Team table
INSERT INTO Team (Team_Name, No_Of_Members, Headed_By)
VALUES
('Network Operations', 8, NULL),  -- The Headed_By will be updated later
('Cybersecurity', 5, NULL);

-- Insert sample data into Employee table
INSERT INTO Employee (Name, Role, Username, Password, Is_Admin, Team_ID)
VALUES
('Alice Green', 'Network Engineer', 'alice_green', 'securePass123!', TRUE, 1),
('Bob Smith', 'Security Analyst', 'bob_smith', 'safeSystem1', FALSE, 2),
('Charlie Baker', 'Systems Administrator', 'charlie_baker', 'sysAdmin#45', FALSE, 1),
('Eve Turner', 'Technical Support', 'eve_turner', 'supportHelp', FALSE, NULL),
('David Cole', 'Network Lead', 'david_cole', 'leadNet2023', TRUE, 1);

-- Update Headed_By in Team table (now referencing Employee)
UPDATE Team SET Headed_By = (SELECT Employee_ID FROM Employee WHERE Name = 'David Cole') WHERE Team_Name = 'Network Operations';
UPDATE Team SET Headed_By = (SELECT Employee_ID FROM Employee WHERE Name = 'Bob Smith') WHERE Team_Name = 'Cybersecurity';

-- Insert sample data into Hardware table
INSERT INTO Hardware (Name, Description, Usage_Instructions, Allocation_Status)
VALUES
('High-Speed Router', 'Router with enhanced data processing speed', 'Ensure it is properly grounded.', 'Allocated'),
('Secure Server Unit', 'High-security server with advanced encryption', 'Keep in a controlled access room.', 'Available'),
('Firewall Protection Device', 'Advanced firewall for network security', 'Configure according to network protocol.', 'Allocated');

-- Insert sample data into Software table
INSERT INTO Software (Name, Description, License_Key, Documentation, Allocation_Status)
VALUES
('Windows Server 2022', 'Server OS with high performance', 'WIN-SVR-2022-LIC', 'Refer to Microsoft Docs.', 'Allocated'),
('VPN Security Suite', 'VPN with encryption and privacy controls', 'VPN-SUI-3042', 'Refer to privacy setup guide.', 'Available'),
('Malware Defender Pro', 'Malware protection software', 'DEF-443-MLW', 'Consult setup manual for configurations.', 'Allocated');

-- Insert sample data into Request table
INSERT INTO Request (Date_Of_Request, Email_ID, Hardware_Allocated, Software_Allocated)
VALUES
('2024-10-01', 'alice_green@networkops.com', 1, 1),  -- High-Speed Router and Windows Server 2022
('2024-10-02', 'charlie_baker@networkops.com', 3, 3); -- Firewall Protection Device and Malware Defender Pro

-- Insert sample data into Project table
INSERT INTO Project (Project_Start_Date, Budget, Name, Team_ID)
VALUES
('2024-09-15', 25000.00, 'Infrastructure Upgrade', 1),
('2024-09-20', 12000.00, 'Cyber Defense Initiative', 2);

-- Insert additional data into Team table
INSERT INTO Team (Team_Name, No_Of_Members, Headed_By)
VALUES
('Data Analytics', 6, NULL),  -- The Headed_By will be updated later
('Cloud Solutions', 4, NULL);

-- Insert additional data into Employee table
INSERT INTO Employee (Name, Role, Username, Password, Is_Admin, Team_ID)
VALUES
('Grace Hopper', 'Lead Data Scientist', 'grace_hopper', 'analyzeData42', TRUE, 3),
('Elon Clarke', 'Cloud Architect', 'elon_clarke', 'cloudBuild', FALSE, 4),
('Isaac Newton', 'Data Engineer', 'isaac_newton', 'dataPipe#2024', FALSE, 3),
('Marie Curie', 'Admin Support', 'marie_curie', 'radiantAdmin', FALSE, NULL),
('John Doe', 'Cloud Engineer', 'john_doe', 'cloudSys2023', TRUE, 4);

-- Update Headed_By in Team table (now referencing Employee)
UPDATE Team SET Headed_By = (SELECT Employee_ID FROM Employee WHERE Name = 'Grace Hopper') WHERE Team_Name = 'Data Analytics';
UPDATE Team SET Headed_By = (SELECT Employee_ID FROM Employee WHERE Name = 'John Doe') WHERE Team_Name = 'Cloud Solutions';

-- Insert additional data into Hardware table
INSERT INTO Hardware (Name, Description, Usage_Instructions, Allocation_Status)
VALUES
('Big Data Server', 'Server optimized for data storage and processing', 'Ensure data compliance.', 'Allocated'),
('Cloud Server X3000', 'Scalable cloud server for enterprise applications', 'Set up access controls.', 'Available'),
('Data Firewall', 'Firewall with data-centric security', 'Configure data flow protocols.', 'Allocated');

-- Insert additional data into Software table
INSERT INTO Software (Name, Description, License_Key, Documentation, Allocation_Status)
VALUES
('Apache Spark', 'Big data processing framework', 'SPRK-2024-ENG', 'Refer to official documentation.', 'Allocated'),
('AWS Toolkit', 'Cloud management and security tools', 'AWS-CLD-PRT', 'Check AWS setup guide.', 'Available'),
('Tableau Pro', 'Data visualization and analytics software', 'TAB-2024-VIS', 'Follow visualization guide.', 'Allocated');

-- Insert additional data into Request table
INSERT INTO Request (Date_Of_Request, Email_ID, Hardware_Allocated, Software_Allocated)
VALUES
('2024-10-03', 'grace_hopper@dataanalytics.com', 5, 5),  -- Big Data Server and Apache Spark
('2024-10-04', 'elon_clarke@cloudsolutions.com', 6, 6); -- Cloud Server X3000 and AWS Toolkit

-- Insert additional data into Project table
INSERT INTO Project (Project_Start_Date, Budget, Name, Team_ID)
VALUES
('2024-10-05', 18000.00, 'Data Lake Implementation', 3),
('2024-10-10', 15000.00, 'Cloud Infrastructure Setup', 4);


-- Login function
DELIMITER //
CREATE FUNCTION validate_login(
    p_username VARCHAR(100),
    p_password VARCHAR(100)
) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE user_id INT;
    DECLARE is_admin BOOLEAN;
    
    SELECT Employee_ID, Is_Admin INTO user_id, is_admin
    FROM Employee
    WHERE Username = p_username AND Password = p_password
    LIMIT 1;
    
    IF user_id IS NULL THEN
        RETURN 0; -- Login failed
    ELSEIF is_admin THEN
        RETURN 1; -- Admin login
    ELSE
        RETURN 2; -- Regular user login
    END IF;
END //
DELIMITER ;