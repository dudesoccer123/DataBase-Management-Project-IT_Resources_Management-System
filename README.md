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
