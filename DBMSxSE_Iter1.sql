CREATE DATABASE IF NOT EXISTS it_infra_mgmt;
USE it_infra_mgmt;

-- Team Table (with foreign key for Headed_By added later)
CREATE TABLE Team (
    Team_ID INT AUTO_INCREMENT PRIMARY KEY,
    Team_Name VARCHAR(100) NOT NULL,
    No_Of_Members INT,
    Headed_By INT -- This will reference Employee_ID but added later as a foreign key
);

-- Employee Table (with Is_Admin as integer and foreign key for Team_ID added later)
CREATE TABLE Employee (
    Employee_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(100),
    Username VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Is_Admin INT DEFAULT 0, -- Changed to integer (1 for admin, 0 for non-admin)
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

ALTER TABLE Hardware ADD COLUMN Allocated_To INT DEFAULT NULL;
ALTER TABLE Software ADD COLUMN Allocated_To INT DEFAULT NULL;


-- Request Table (Foreign keys for Hardware_Allocated and Software_Allocated added later)
CREATE TABLE Request (
    Request_ID INT AUTO_INCREMENT PRIMARY KEY,
    Employee_ID INT NOT NULL,
    Resource_Type VARCHAR(10) NOT NULL,
    Resource_ID INT NOT NULL,
    Status VARCHAR(10) DEFAULT 'Pending',
    Date_Of_Request TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);

-- Project Table (foreign key for Team_ID added later)
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
('Network Security', 5, NULL),      -- Headed by Alice Johnson 1
('Software Development', 8, NULL),  -- Headed by Bob Williams (Admin) 2
('Technical Support', 6, NULL),     -- Headed by David Brown 4
('Data Analysis', 4, NULL);         -- Headed by Carol Smith 3

-- Insert sample data into Employee table
INSERT INTO Employee (Name, Role, Username, Password, Is_Admin, Team_ID)
VALUES
('Alice Johnson', 'Network Engineer', 'alice.johnson', 'password123!', 0, 1),
('Bob Williams', 'Senior Developer', 'bob.williams', 'password456!', 1, 2), -- Admin user
('Carol Smith', 'Data Analyst', 'carol.smith', 'data@123', 0, 4),
('David Brown', 'Support Specialist', 'david.brown', 'support@789', 0, 3),
('Eve Davis', 'Software Engineer', 'eve.davis', 'dev@abc', 0, 2);

UPDATE Team SET Headed_By = (SELECT Employee_ID FROM Employee WHERE Name = 'Alice Johnson') WHERE Team_Name = 'Network Security';
UPDATE Team SET Headed_By = (SELECT Employee_ID FROM Employee WHERE Name = 'Bob Williams') WHERE Team_Name = 'Software Development';
UPDATE Team SET Headed_By = (SELECT Employee_ID FROM Employee WHERE Name = 'David Brown') WHERE Team_Name = 'Technical Support';
UPDATE Team SET Headed_By = (SELECT Employee_ID FROM Employee WHERE Name = 'Carol Smith') WHERE Team_Name = 'Data Analysis';

-- Insert sample data into Hardware table (All unallocated by default)
INSERT INTO Hardware (Name, Description, Usage_Instructions, Allocation_Status)
VALUES
('Dell PowerEdge R540', 'Rack Server with 64GB RAM and 1TB Storage', 'For network infrastructure use only', 'Available'),
('Cisco Catalyst 9200', 'Network switch with 48 ports', 'Setup in secure server rooms', 'Available'),
('HP LaserJet Pro M404', 'Monochrome Laser Printer', 'Use for official document printing', 'Available'),
('Lenovo ThinkPad X1', 'Laptop with Intel i7 and 16GB RAM', 'Assigned to employees as needed', 'Available');

-- Insert sample data into Software table (All unallocated by default)
INSERT INTO Software (Name, Description, License_Key, Documentation, Allocation_Status)
VALUES
('Microsoft Office 365', 'Productivity Suite including Word, Excel, and PowerPoint', 'ABC123-XYZ789', 'User manual available online', 'Available'),
('Adobe Photoshop CC', 'Photo editing software', 'PHOTOSHOP-2024-XYZ', 'Access online tutorials for usage', 'Available'),
('Tableau', 'Data visualization tool for analysis', 'TAB-2024-XYZ987', 'Install guide provided with license', 'Available'),
('AutoCAD', 'Software for 2D and 3D design', 'AUTO-CAD-12345', 'Follow setup documentation carefully', 'Available');

-- Insert sample data into Project table
INSERT INTO Project (Project_Start_Date, Budget, Name, Team_ID)
VALUES
('2024-01-15', 100000.00, 'Network Overhaul 2024', 1),
('2023-09-01', 50000.00, 'Customer Support Automation', 3),
('2023-06-01', 75000.00, 'Market Insights Analysis', 4),
('2024-03-01', 150000.00, 'Mobile App Development', 2);


-- Login function
DELIMITER //
CREATE FUNCTION validate_login(
    p_username VARCHAR(100),
    p_password VARCHAR(100)
) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE login_status INT DEFAULT 0;

    SELECT CASE 
               WHEN Is_Admin = 1 THEN 1 
               ELSE 2 
           END INTO login_status
    FROM Employee
    WHERE Username = p_username AND Password = p_password
    LIMIT 1;

    RETURN login_status; -- 1 for admin login, 2 for regular user login, 0 if login failed
END //
DELIMITER ;

-- Get employee details
DELIMITER //
CREATE PROCEDURE get_employee_details(
    IN p_employee_id INT
)
BEGIN
    SELECT 
        e.Employee_ID,
        e.Name,
        e.Role,
        t.Team_Name,
        p.Name AS Project_Name,
        p.Project_Start_Date,
        p.Budget
    FROM Employee e
    LEFT JOIN Team t ON e.Team_ID = t.Team_ID
    LEFT JOIN Project p ON t.Team_ID = p.Team_ID
    WHERE e.Employee_ID = p_employee_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_allocated_resources(
    IN p_employee_id INT
)
BEGIN
    -- Fetch allocated hardware resources
    SELECT 
        h.Name AS Hardware_Name,
        h.Description AS Hardware_Description,
        NULL AS Software_Name,
        NULL AS Software_Description
    FROM Hardware h
    WHERE h.Allocated_To = p_employee_id AND h.Allocation_Status = 'Allocated'
    
    UNION ALL
    
    -- Fetch allocated software resources
    SELECT 
        NULL AS Hardware_Name,
        NULL AS Hardware_Description,
        s.Name AS Software_Name,
        s.Description AS Software_Description
    FROM Software s
    WHERE s.Allocated_To = p_employee_id AND s.Allocation_Status = 'Allocated';
END //
DELIMITER ;

-- submit resource request
DELIMITER //
CREATE PROCEDURE submit_resource_request(
    IN p_employee_id INT,
    IN p_resource_type VARCHAR(10),
    IN p_resource_id INT
)
BEGIN
    DECLARE resource_allocated INT DEFAULT 0;

    -- Check if the resource is already allocated
    IF p_resource_type = 'Hardware' THEN
        SELECT COUNT(*) INTO resource_allocated
        FROM Hardware
        WHERE Hardware_ID = p_resource_id AND Allocation_Status = 'Allocated';
    ELSEIF p_resource_type = 'Software' THEN
        SELECT COUNT(*) INTO resource_allocated
        FROM Software
        WHERE Software_ID = p_resource_id AND Allocation_Status = 'Allocated';
    END IF;

    -- If the resource is already allocated, signal an error
    IF resource_allocated > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Resource is already allocated.';
    ELSE
        -- Insert the request if the resource is available
        INSERT INTO Request (Employee_ID, Resource_Type, Resource_ID, Status)
        VALUES (p_employee_id, p_resource_type, p_resource_id, 'Pending');
    END IF;
END //
DELIMITER ;


-- Get pending requests
DELIMITER //
CREATE PROCEDURE get_pending_requests()
BEGIN
    SELECT 
        r.Request_ID,
        r.Date_Of_Request,
        r.Employee_ID,
        e.Name AS Employee_Name,
        CASE 
            WHEN r.Resource_Type = 'Hardware' THEN h.Name
            WHEN r.Resource_Type = 'Software' THEN s.Name
        END AS Resource_Name,
        r.Resource_Type
    FROM Request r
    JOIN Employee e ON r.Employee_ID = e.Employee_ID
    LEFT JOIN Hardware h ON r.Resource_Type = 'Hardware' AND r.Resource_ID = h.Hardware_ID
    LEFT JOIN Software s ON r.Resource_Type = 'Software' AND r.Resource_ID = s.Software_ID
    WHERE r.Status = 'Pending' 
      AND (h.Allocation_Status = 'Available' OR s.Allocation_Status = 'Available');
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE handle_request_approval(
    IN p_request_id INT,
    IN p_approved BOOLEAN
)
BEGIN
    -- Retrieve request details
    SELECT Resource_Type, Resource_ID, Employee_ID
    INTO @resource_type, @resource_id, @employee_id
    FROM Request WHERE Request_ID = p_request_id;

    -- Approve and allocate the resource if approved
    IF p_approved THEN
        -- Allocate hardware or software based on resource type
        UPDATE Hardware SET Allocation_Status = 'Allocated', Allocated_To = @employee_id
        WHERE @resource_type = 'Hardware' AND Hardware_ID = @resource_id AND Allocation_Status = 'Available';
        
        UPDATE Software SET Allocation_Status = 'Allocated', Allocated_To = @employee_id
        WHERE @resource_type = 'Software' AND Software_ID = @resource_id AND Allocation_Status = 'Available';

        -- Update request status to "Approved"
        UPDATE Request SET Status = 'Approved' WHERE Request_ID = p_request_id;
    ELSE
        -- Deny the request by updating the status
        UPDATE Request SET Status = 'Denied' WHERE Request_ID = p_request_id;
    END IF;
END //
DELIMITER ;



