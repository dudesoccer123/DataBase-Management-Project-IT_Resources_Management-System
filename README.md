# DBMS_SE_Project :

# IT Resource Management System

## 📖 Overview
The **IT Resource Management System** is a comprehensive database-backed application built using **MySQL** and **Streamlit python**. It is designed to streamline the allocation, management, and tracking of IT resources (hardware and software) across an organization.

This project provides:
- A relational database schema for efficient data storage and retrieval.
- A fully functional web-based user interface for employees and administrators.

---

## 🛠 Features
### **For Administrators**
- View available and allocated resources.
- Approve or reject resource requests submitted by employees.
- Create new employee accounts with distinct roles (Admin/User).
- Manage resources: Add, update, or delete hardware/software details.

### **For Employees**
- View personal and team details (e.g., role, team, and project).
- Check allocated resources.
- Submit requests for hardware or software resources.
- Monitor the status of their requests (Pending/Approved/Rejected).

### **Database Features**
- Designed with MySQL, following relational database principles.
- Predefined stored procedures for handling operations:
  - Employee and resource management.
  - Request submission and approval workflows.
- Optimized schema for scalability and integrity.

---

## 🏗 Technology Stack
- **Frontend**: [Streamlit](https://streamlit.io/) for building the UI.
- **Backend**: MySQL database with stored procedures and triggers.
- **Language**: Python for logic and database interaction.

---

## 🗂 Database Schema
The database schema includes the following tables:
1. **Employee**: Stores employee details with roles (Admin/User).
2. **Team**: Manages teams and their leaders.
3. **Hardware**: Tracks hardware resources.
4. **Software**: Tracks software resources.
5. **Request**: Logs resource requests and their statuses.
6. **Project**: Tracks team-based project assignments.

Check the schema file (`DBMSxSE_Iter1.sql`) for detailed definitions.

---

## 🚀 Getting Started
### Prerequisites
1. Python 3.8 or above.
2. MySQL Server installed.
3. Dependencies installed:
   ```bash
   pip install streamlit mysql-connector-python
   ```
Installation Steps
Clone the Repository:
```
git clone <repo_url>
cd IT-Resource-Management
```
Set up the Database:

Import the schema into MySQL:
```
mysql -u root -p < DBMSxSE_Iter1.sql
```
Update database credentials in infra_management_updated.py:
```
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'your_db_password',
    'database': 'it_infra_mgmt'
}
```
Run the Application:
```
streamlit run infra_management_updated.py
```
Access the application at http://localhost:8501.

## 🖥 User Guide
Login Page
* Admins and employees can log in using their credentials.
  
Admin Dashboard
* Manage resources and approve/reject requests.
* Create new employee accounts.
* Update or delete existing resources.
  
Employee Homepage
* View personal details, team information, and current projects.
* Check allocated resources.
* Submit new resource requests.
  
## 📂 Project Structure
* infra_management_updated.py: Main Python file for the Streamlit app.
* DBMSxSE_Iter2.sql: Database schema with tables, stored procedures, and views.
  
🧪 Testing and Debugging
Database Connection:
Verify the MySQL server is running.
Check credentials in the DB_CONFIG dictionary.
Resource Requests:
Ensure no duplicate resource allocations in the database.
Debugging Streamlit:
Check error logs in the Streamlit console.
Verify stored procedures in MySQL.

