import streamlit as st
import time
import mysql.connector
from mysql.connector import Error


# Database connection configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'your db password',
    'database': 'it_infra_mgmt'
}

# Initialize session state for managing screens
if "page" not in st.session_state:
    st.session_state["page"] = "login" 

# Initialize session state for keeping track of who has logged in. 
if "username" not in st.session_state:
    st.session_state["username"] = ""  # Initialize username


if "userID" not in st.session_state:
    st.session_state["userID"] = ""  # Initialize username


#------------------------------------------------------------------------------------------------------------#

def get_db_connection():
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        st.error(f"Error connecting to database: {e}")
        return None

def handle_login(username, password):
    conn = get_db_connection()
    if conn is not None:
        try:
            cursor = conn.cursor()
            cursor.execute("SELECT validate_login(%s, %s)", (username, password))
            result = cursor.fetchone()[0]
            
            if result == 0:
                st.error("Invalid credentials!")
            elif result == 1:
                st.session_state["page"] = "admin_dashboard"
                st.session_state["username"] = username
                cursor.execute("SELECT Employee_ID FROM Employee WHERE Username = %s", (username,))
                st.session_state["userID"] = cursor.fetchone()[0]
                st.rerun()
            else:
                st.session_state["page"] = "user_homepage"
                st.session_state["username"] = username
                cursor.execute("SELECT Employee_ID FROM Employee WHERE Username = %s", (username,))
                st.session_state["userID"] = cursor.fetchone()[0]
                st.rerun()
        finally:
            conn.close()

def get_employee_information(userID):
    conn = get_db_connection()
    if conn is not None:
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.callproc('get_employee_details', [userID])
            result = next(cursor.stored_results()).fetchone()
            
            if result:
                st.write(f"**Name:** {result['Name']}")
                st.write(f"**Role:** {result['Role']}")
                st.write(f"**Team:** {result['Team_Name']}")
                st.write(f"**Current Project:** {result['Project_Name']}")
                st.write(f"**Project Start Date:** {result['Project_Start_Date']}")
        finally:
            conn.close()

def get_allocated_resources_information(userID):
    conn = get_db_connection()
    if conn is not None:
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.callproc('get_allocated_resources', [userID])
            results = next(cursor.stored_results()).fetchall()

            if results:
                for resource in results:
                    st.write("---")
                    if resource['Hardware_Name']:
                        st.write(f"**Hardware:** {resource['Hardware_Name']}")
                        st.write(f"**Description:** {resource['Hardware_Description']}")
                    if resource['Software_Name']:
                        st.write(f"**Software:** {resource['Software_Name']}")
                        st.write(f"**Description:** {resource['Software_Description']}")
            else:
                st.write("No resources currently allocated.")
        finally:
            conn.close()




def handle_resource_request(resource_type, resource_id, userID):
    conn = get_db_connection()
    if conn is not None:
        try:
            cursor = conn.cursor()
            cursor.callproc('submit_resource_request', [userID, resource_type, resource_id])
            conn.commit()
            st.success("Request submitted successfully! Waiting for admin approval.")
        except Error as e:
            if "Resource is already allocated" in str(e):
                st.error("The resource cannot be requested because it is already allocated.")
            else:
                st.error(f"Error submitting request: {e}")
        finally:
            conn.close()


def handle_new_employee_creation(emp_name, emp_email, emp_role, emp_is_admin):
    conn = get_db_connection()
    if conn is not None:
        try:
            cursor = conn.cursor(dictionary=True)
            is_admin = emp_is_admin.lower() == 'yes'
            cursor.callproc('create_new_employee', [emp_name, emp_email, emp_role, is_admin])
            credentials = next(cursor.stored_results()).fetchone()
            conn.commit()
            
            st.success("Employee created successfully!")
            st.write("Generated credentials:")
            st.write(f"Username: {credentials['username']}")
            st.write(f"Password: {credentials['password']}")
        except Error as e:
            st.error(f"Error creating employee: {e}")
        finally:
            conn.close()

# Add this to admin_dashboard function
def get_pending_requests():
    conn = get_db_connection()
    if conn is not None:
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.callproc('get_pending_requests')
            return next(cursor.stored_results()).fetchall()
        finally:
            conn.close()
    return []

def handle_request_response(request_id, approved):
    conn = get_db_connection()
    if conn is not None:
        try:
            cursor = conn.cursor()
            cursor.callproc('handle_request_approval', [request_id, approved])
            conn.commit()
            if approved:
                st.success("Request approved and resource allocated!")
            else:
                st.error("Request denied.")
        except Error as e:
            st.error(f"Error processing request: {e}")
        finally:
            conn.close()


def handle_addition_of_new_hardware(h_id, h_name , h_desc , h_use , h_alloc_status):
    pass 

def handle_addition_of_new_software(s_id, s_name , s_desc , s_key , s_docs , s_alloc_status):
    pass

def handle_hardware_updation(h_id, h_name , h_desc , h_use , h_alloc_status):
    pass

def handle_software_updation(s_id, s_name , s_desc , s_key , s_docs , s_alloc_status):
    pass

def handle_resource_deletion(resource_t_2,r_id):
    pass 


#-------------------------------------------------------------------------------------------------------------#

# Define different "pages" (screens)
def login_page():

    st.markdown("<h1 style='text-align: center;'>IT Infrastructure Management System</h1>", unsafe_allow_html=True)
    st.write("___________")
    st.markdown("<h3 style='text-align: center;'>Please Enter Your Login Details:</h3>", unsafe_allow_html=True)
    


    with st.form("login_form"):
        username = st.text_input("Username")
        password = st.text_input("Password", type="password")
        submitted = st.form_submit_button("Login")
        if submitted:
            handle_login(username, password)

    st.write("_____________")

    st.markdown("<p style='text-align: center;'>Database Management And Software Engineering Project 2024 ©</p>", unsafe_allow_html=True)
#___________________________________________________________________________________________________

#This will be the page design and layout that would be displayed when the administrator logs in successfully.

def admin_dashboard():

    col1, col2 , col3 , col4 , col5 , col6 , col7 , col8 = st.columns(8)

    with col1:
        if st.button("Logout"):
            st.session_state["page"] = "login"  
            st.rerun() 
    
    with col8:
        if st.button("🔄"):  
            st.session_state["page"] = "admin_dashboard"
            st.rerun()
    
    st.markdown(f"<h1 style='text-align: center;'>Welcome, {st.session_state['username']}! You are logged in as an Administrator</h1>", unsafe_allow_html=True)
    st.write("__________")
    st.markdown("<h2 style='text-align: center;'>Admin Dashboard</h2>", unsafe_allow_html=True)
    st.write("__________")
    

    # Get the list of pending requests
    requests_data = get_pending_requests()
    
    for request in requests_data:
        st.markdown(
            f"""
            <div style='background-color: #306778; padding: 15px; border-radius: 10px; margin-bottom: 15px;'>
                <strong>Request ID:</strong> {request['Request_ID']}<br>
                <strong>Employee:</strong> {request['Employee_Name']}<br>
                <strong>Resource:</strong> {request['Resource_Name']} ({request['Resource_Type']})
            </div>
            """,
            unsafe_allow_html=True
        )
        
        col1, col2 = st.columns([1, 1])
        with col1:
            if st.button("Accept", key=f"accept_{request['Request_ID']}"):
                handle_request_response(request['Request_ID'], True)
                time.sleep(1)
                st.rerun()

        with col2:
            if st.button("Reject", key=f"reject_{request['Request_ID']}"):
                handle_request_response(request['Request_ID'], False)
                time.sleep(1)
                st.rerun()
        st.write("---")
    
    if st.button("Create An Account"):
        st.session_state["page"] = "create_acc"  
        st.rerun()  
    
    if st.button("Update Resources"):
        st.session_state["page"] = "update_resource"  
        st.rerun()  

#___________________________________________________________________________________________________

#This will be the page tht gets displayed when the user logs in successfully. 

def user_homepage():
    col1, col2 , col3 , col4 , col5 , col6 , col7 , col8 = st.columns(8)

    with col1:
        if st.button("Logout"):
            st.session_state["page"] = "login"  
            st.rerun() 
    
    with col8:
        if st.button("🔄"):  
            st.session_state["page"] = "user_homepage"
            st.rerun()


    st.markdown(f"<h1 style='text-align: center;'>Welcome, {st.session_state['username']}! You are logged in as a User.</h1>", unsafe_allow_html=True)
    st.write("__________")
    st.markdown("<h2 style='text-align: left;'>Employee Information</h2>", unsafe_allow_html=True)
    get_employee_information(st.session_state['userID'])
    

    st.write("__________")
    st.markdown("<h2 style='text-align: left;'>Allocated Resources Information</h2>", unsafe_allow_html=True)
    get_allocated_resources_information(st.session_state['userID'])
    

    st.write("__________")
    if st.button("Request Resource"):
        st.session_state["page"] = "Request"  
        st.rerun() 
    
#___________________________________________________________________________________________________

def request_resource_page():
    if st.button("Back To Home"):
        st.session_state["page"] = "user_homepage"  
        st.rerun() 

    user = st.session_state['username']

    st.markdown("<h1 style='text-align: center;'>Resource Request</h1>", unsafe_allow_html=True)
    st.write("_______________")
    st.markdown("<h3 style='text-align: center;'>Resource request Dashboard</h3>", unsafe_allow_html=True)

    st.write("_______________")

    with st.form("resource_request_form"):
        resource_type = st.selectbox("Select Resource Type:", ["Hardware", "Software"])

        resource_id = st.text_input("Enter Resource ID (Unique to each resource)")

        submitted = st.form_submit_button("Submit Request")
        if submitted:
            handle_resource_request(resource_type,resource_id,st.session_state['userID'])
            time.sleep(2)
            st.session_state["page"] = "user_homepage"
            st.rerun() 


#___________________________________________________________________________________________________

def create_account_page():
    if st.button("Back To Home"):
        st.session_state["page"] = "admin_dashboard"  
        st.rerun() 

    st.markdown("<h1 style='text-align: center;'>Create New Employee Account</h1>", unsafe_allow_html=True)
    st.write("_______________")
    st.markdown("<h3 style='text-align: center;'>Please Enter the details below.</h3>", unsafe_allow_html=True)

    with st.form("create_acc_form"):
        emp_name = st.text_input("Enter the employee name: ")
        emp_email = st.text_input("Enter the employee Email-ID: ")
        emp_role = st.text_input("Entr the employee role: ")
        is_admin = st.radio("Is the new employee an administrator?:", ["Yes", "No"])
        submitted = st.form_submit_button("Submit Request")
        if submitted:
            handle_new_employee_creation(emp_name,emp_email,emp_role,is_admin)

            st.success(f"New Employee Created Successfully!")
            time.sleep(2)
            st.session_state["page"] = "create_acc"
            st.rerun() 

    


#__________________________________________________________________________________________________

def update_resources_page() :
    if st.button("Back To Home"):
        st.session_state["page"] = "admin_dashboard"  
        st.rerun() 

    st.markdown("<h1 style='text-align: center;'>Resource Management</h1>", unsafe_allow_html=True)
    st.write("_______________")
    st.markdown("<h2 style='text-align: center;'>Add A New Resource</h2>", unsafe_allow_html=True)
    resource_t_1 = st.radio("Select Resource Type:", ["Hardware", "Software"])
    update_choice = st.radio("Are you Updating an existing resource? :", ["Yes", "No"])
    with st.form("add_resource_form"):
        if (resource_t_1 == "Hardware") :
            h_id = st.text_input("Enter the Hardware ID: ")
            h_name = st.text_input("Enter the name of the Hardware: ")
            h_desc = st.text_input("Enter the Hardware description: ")
            h_use = st.text_input("Enter the Hardware usage instructions: ")
            h_alloc_status = "Available"
            
        elif (resource_t_1 == "Software"):
            s_id = st.text_input("Enter the Software ID: ")
            s_name = st.text_input("Enter the name of the Software: ")
            s_desc = st.text_input("Enter the Software description: ")
            s_key = st.text_input("Enter the Software license key: ")
            s_docs = st.text_input("Enter the Software documentation information: ")
            s_alloc_status = "Available"

        submitted = st.form_submit_button("Submit Request")


        if submitted:
           # handle_addition_of_new_resource()
            if (resource_t_1 == "Hardware" and update_choice=="No"):
                handle_addition_of_new_hardware(h_id, h_name , h_desc , h_use , h_alloc_status)
                st.success(f"New Resource Created Successfully!")
                time.sleep(2)
                st.rerun() 
            elif (resource_t_1 == "Software" and update_choice=="No"):
                handle_addition_of_new_software(s_id, s_name , s_desc , s_key , s_docs , s_alloc_status)
                st.success(f"New Resource Created Successfully!")
                time.sleep(2)
                st.rerun()
            elif (resource_t_1 == "Hardware" and update_choice=="Yes") :
                handle_hardware_updation(h_id, h_name , h_desc , h_use , h_alloc_status)
                st.success(f"Resource Updated Successfully!")
                time.sleep(2)
                st.rerun() 
            elif (resource_t_1 == "Software" and update_choice=="Yes"):
                handle_software_updation(s_id, s_name , s_desc , s_key , s_docs , s_alloc_status)
                st.success(f"Resource Updated Successfully!")
                time.sleep(2)
                st.rerun()
                
            

    st.write("---")
    st.markdown("<h2 style='text-align: center;'>Delete A Resource</h2>", unsafe_allow_html=True)
    resource_t_2 = st.selectbox("Select Resource Type:", ["Hardware", "Software"])
    with st.form("delete_a_resource_form") :
        r_id = st.text_input("Enter the Resource ID: ")
        submitted = st.form_submit_button("Delete Resource")

        if submitted : 
            handle_resource_deletion(resource_t_2,r_id)
            st.success(f"New Resource Created Successfully!")
            time.sleep(2)
            st.rerun() 
    st.write("---")

#--------------------------------------------------------------------------------------------------------------------#

# Conditionally render the page based on session state
if st.session_state["page"] == "login":
    login_page()
elif st.session_state["page"] == "admin_dashboard":
    admin_dashboard()
elif st.session_state["page"] == "user_homepage":
    user_homepage()
elif st.session_state["page"] == "Request" :
    request_resource_page()
elif st.session_state["page"] == "create_acc":
    create_account_page()
elif st.session_state["page"] == "update_resource":
    update_resources_page()
