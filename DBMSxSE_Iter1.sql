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
    Email VARCHAR(100) UNIQUE NOT NULL,
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
INSERT INTO Employee (Name, Email, Role, Username, Password, Is_Admin, Team_ID)
VALUES
('Alice Johnson', 'alice.johnson@example.com', 'Network Engineer', 'alice.johnson', 'password123!', 0, 1),
('Bob Williams', 'bob.williams@example.com', 'Senior Developer', 'bob.williams', 'password456!', 1, 2), -- Admin user
('Carol Smith', 'carol.smith@example.com', 'Data Analyst', 'carol.smith', 'data@123', 0, 4),
('David Brown', 'david.brown@example.com', 'Support Specialist', 'david.brown', 'support@789', 0, 3),
('Eve Davis', 'eve.davis@example.com', 'Software Engineer', 'eve.davis', 'dev@abc', 0, 2);


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

-- create Roles


-- Create the admin role with full privileges
-- CREATE ROLE 'admin_role';
-- GRANT ALL PRIVILEGES ON it_infra_mgmt.* TO 'admin_role';

-- Create the employee role with limited privileges
-- CREATE ROLE 'employee_role';
-- GRANT SELECT ON it_infra_mgmt.Software TO 'employee_role';
-- GRANT SELECT ON it_infra_mgmt.Hardware TO 'employee_role';
-- GRANT SELECT ON it_infra_mgmt.Team TO 'employee_role';
-- GRANT SELECT ON it_infra_mgmt.Project TO 'employee_role';

-- FLUSH PRIVILEGES;


-- create users for existing data entries. 
-- CREATE USER 'alice.johnson'@'localhost' IDENTIFIED BY 'password123!';
-- CREATE USER 'bob.williams'@'localhost' IDENTIFIED BY 'password456!';
-- CREATE USER 'carol.smith'@'localhost' IDENTIFIED BY 'data@123';
-- CREATE USER 'david.brown'@'localhost' IDENTIFIED BY 'support@789';
-- CREATE USER 'eve.davis'@'localhost' IDENTIFIED BY 'dev@abc';

-- FLUSH PRIVILEGES;


-- Assign roles to existing employees based on their admin status
-- G  RANT 'admin_role' TO 'bob.williams'@'localhost';   -- Admin user
-- GRANT 'employee_role' TO 'alice.johnson'@'localhost';
-- GRANT 'employee_role' TO 'carol.smith'@'localhost';
-- GRANT 'employee_role' TO 'david.brown'@'localhost';
-- GRANT 'employee_role' TO 'eve.davis'@'localhost';

FLUSH PRIVILEGES;




DELIMITER //

CREATE PROCEDURE assign_role_to_employee(
    IN p_username VARCHAR(50),
    IN p_is_admin INT
)
BEGIN
    DECLARE grant_query VARCHAR(255);

    -- Assign role based on admin status
    IF p_is_admin = 1 THEN
        SET grant_query = CONCAT("GRANT admin_role TO '", p_username, "'@'localhost'");
    ELSE
        SET grant_query = CONCAT("GRANT employee_role TO '", p_username, "'@'localhost'");
    END IF;

    -- Execute the dynamic SQL statement for granting the role
    SET @stmt = grant_query;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;


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
        e.Email,
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
    -- Approve or deny the request based on the input
    IF p_approved THEN
        -- Update request status to "Approved"
        UPDATE Request SET Status = 'Approved' WHERE Request_ID = p_request_id;
    ELSE
        -- Deny the request by updating the status
        UPDATE Request SET Status = 'Denied' WHERE Request_ID = p_request_id;
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE create_new_employee(
    IN emp_name VARCHAR(100),
    IN emp_email VARCHAR(100),
    IN emp_role VARCHAR(100),
    IN emp_is_admin BOOLEAN,
    OUT emp_username VARCHAR(50),
    OUT emp_password VARCHAR(50)
)
BEGIN
    -- Generate username and password
    SET emp_username = CONCAT(SUBSTRING(emp_name, 1, 3), FLOOR(RAND() * 1000));
    SET emp_password = CONCAT('P@ss', FLOOR(RAND() * 1000));

    -- Insert the new employee record into the Employee table
    INSERT INTO Employee (Name, Email, Role, Username, Password, Is_Admin)
    VALUES (emp_name, emp_email, emp_role, emp_username, emp_password, emp_is_admin);

    -- Create a MySQL user with the generated username and password
    SET @create_user_query = CONCAT("CREATE USER '", emp_username, "'@'localhost' IDENTIFIED BY '", emp_password, "'");
    PREPARE stmt FROM @create_user_query;
    EXECUTE stmt;
    FLUSH PRIVILEGES;
    DEALLOCATE PREPARE stmt;

    -- Call the assign_role_to_employee procedure to grant permissions
    CALL assign_role_to_employee(emp_username, emp_is_admin);
    
END //

DELIMITER ;



-- add a hardware resource

DELIMITER //

CREATE PROCEDURE handle_addition_of_new_hardware(
    IN h_id INT,
    IN h_name VARCHAR(100),
    IN h_desc TEXT,
    IN h_use TEXT,
    IN h_alloc_status VARCHAR(20)
)
BEGIN
    INSERT INTO Hardware (Hardware_ID, name, description, Usage_Instructions, Allocation_Status)
    VALUES (h_id, h_name, h_desc, h_use, h_alloc_status);
END //

DELIMITER ;

-- add a software resource.
DELIMITER //

CREATE PROCEDURE handle_addition_of_new_software(
    IN s_id INT,
    IN s_name VARCHAR(100),
    IN s_desc TEXT,
    IN s_key VARCHAR(255),
    IN s_docs TEXT,
    IN s_alloc_status VARCHAR(20)
)
BEGIN
    INSERT INTO Software (Software_ID, name, Description, License_Key, Documentation, Allocation_Status)
    VALUES (s_id, s_name, s_desc, s_key, s_docs, s_alloc_status);
END //

DELIMITER ;

-- update a hardware resource
DELIMITER //

CREATE PROCEDURE handle_hardware_updation(
    IN h_id INT,
    IN h_name VARCHAR(100),
    IN h_desc TEXT,
    IN h_use TEXT,
    IN h_alloc_status VARCHAR(20)
)
BEGIN
    UPDATE Hardware
    SET name = h_name,
        Description = h_desc,
        usage_instructions = h_use,
        Allocation_Status = h_alloc_status
    WHERE Hardware_ID = h_id;
END //

DELIMITER ;

-- update a software resource
DELIMITER //

CREATE PROCEDURE handle_software_updation(
    IN s_id INT,
    IN s_name VARCHAR(100),
    IN s_desc TEXT,
    IN s_key VARCHAR(255),
    IN s_docs TEXT,
    IN s_alloc_status VARCHAR(20)
)
BEGIN
    UPDATE Software
    SET name = s_name,
        Description = s_desc,
        License_Key = s_key,
        Documentation = s_docs,
        Allocation_Status = s_alloc_status
    WHERE Software_ID = s_id;
END //

DELIMITER ;

-- delete a resource
DELIMITER //

CREATE PROCEDURE handle_resource_deletion(
    IN resource_type VARCHAR(20),
    IN r_id INT
)
BEGIN
    DECLARE resource_exists INT DEFAULT 0;

    -- Check if resource exists in the specified table
    IF resource_type = 'Hardware' THEN
        SELECT COUNT(*) INTO resource_exists FROM Hardware WHERE Hardware_ID = r_id;
        IF resource_exists = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hardware resource with specified ID does not exist.';
        ELSE
            DELETE FROM Hardware WHERE Hardware_ID = r_id;
        END IF;
    ELSEIF resource_type = 'Software' THEN
        SELECT COUNT(*) INTO resource_exists FROM Software WHERE Software_ID = r_id;
        IF resource_exists = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Software resource with specified ID does not exist.';
        ELSE
            DELETE FROM Software WHERE Software_ID = r_id;
        END IF;
    END IF;
END //

DELIMITER ;


-- display available resources
CREATE VIEW Available_Resources_View AS
SELECT Hardware_ID AS Resource_ID, Name AS Resource_Name, 'Hardware' AS Resource_Type
FROM hardware
WHERE Allocation_Status = 'Available'
UNION ALL
SELECT Software_ID AS Resource_ID, Name AS Resource_Name, 'Software' AS Resource_Type
FROM software
WHERE Allocation_Status = 'Available';

-- display the allocated resources

CREATE VIEW Allocated_Resources_View AS
SELECT 
    h.Hardware_ID AS Resource_ID, 
    h.Name AS Resource_Name, 
    'Hardware' AS Resource_Type, 
    e.Employee_ID, 
    e.Name AS Employee_Name
FROM 
    Hardware h
JOIN 
    Employee e ON h.Allocated_To = e.Employee_ID
WHERE 
    h.Allocation_Status = 'Allocated'

UNION ALL

SELECT 
    s.Software_ID AS Resource_ID, 
    s.Name AS Resource_Name, 
    'Software' AS Resource_Type, 
    e.Employee_ID, 
    e.Name AS Employee_Name
FROM 
    Software s
JOIN 
    Employee e ON s.Allocated_To = e.Employee_ID
WHERE 
    s.Allocation_Status = 'Allocated';


-- create a trigger : 
DELIMITER //

CREATE TRIGGER allocate_resource_on_approval
AFTER UPDATE ON Request
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Approved' THEN
        -- Check if the request is for hardware, then update hardware status
        IF NEW.Resource_Type = 'Hardware' THEN
            UPDATE Hardware
            SET Allocation_Status = 'Allocated', Allocated_To = NEW.Employee_ID
            WHERE Hardware_ID = NEW.Resource_ID;
        END IF;

        -- Check if the request is for software, then update software status
        IF NEW.Resource_Type = 'Software' THEN
            UPDATE Software
            SET Allocation_Status = 'Allocated', Allocated_To = NEW.Employee_ID
            WHERE Software_ID = NEW.Resource_ID;
        END IF;
    END IF;
END //

DELIMITER ;



