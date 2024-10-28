import streamlit as st



# Initialize session state for managing screens
if "page" not in st.session_state:
    st.session_state["page"] = "login" 

# Initialize session state for keeping track of who has logged in. 
if "username" not in st.session_state:
    st.session_state["username"] = ""  # Initialize username


#------------------------------------------------------------------------------------------------------------#

# Functions to handle different functionalities
def handle_login(username, password, login_type):
    # validate with database 
    '''
    if the "login_type variable is "user" then look in the users table. else look in the admin table. 
    '''
    

    if username == "admin" and password == "admin":
        st.session_state["page"] = "admin_dashboard"  
        st.session_state["username"] = username
        st.rerun()  
    elif username == "user" and password == "user":
        st.session_state["page"] = "user_homepage"  
        st.session_state["username"] = username
        st.rerun()  
    else:
        st.error("Invalid credentials!")

#-------------------------------------------------------------------------------------------------------------#

# Define different "pages" (screens)
def login_page():

    st.markdown("<h1 style='text-align: center;'>IT Infrastructure Management System</h1>", unsafe_allow_html=True)
    st.write("___________")
    st.markdown("<h3 style='text-align: center;'>Please Enter Your Login Details:</h3>", unsafe_allow_html=True)
    login_type = st.radio("Select Login Type:", ["User", "Administrator"])   # this variable is used to determine which database to check for the required credentials. 


    with st.form("login_form"):
        username = st.text_input("Username")
        password = st.text_input("Password", type="password")
        submitted = st.form_submit_button("Login")
        if submitted:
            handle_login(username, password, login_type)

    st.write("_____________")

    st.markdown("<p style='text-align: center;'>Database Management And Software Engineering Project 2024 ©</p>", unsafe_allow_html=True)
#___________________________________________________________________________________________________

#This will be the page design and layout that would be displayed when the administrator logs in successfully.

def admin_dashboard():
    if st.button("Logout"):
        st.session_state["page"] = "login"  # Log out and return to login page
        st.rerun()  # Rerun the script to switch the page
    
    st.markdown(f"<h1 style='text-align: center;'>Welcome, {st.session_state['username']}! You are logged in as an Administrator</h1>", unsafe_allow_html=True)
    st.write("__________")
    st.markdown("<h2 style='text-align: center;'>Admin Dashboard</h2>", unsafe_allow_html=True)
    st.write("the admin should be able to view which resource is allocated to which employee. Also should be able to view the pending requests for resources and to accept/deny that request.")
    
    if st.button("Create An Account"):
        st.session_state["page"] = "create_acc"  
        st.rerun()  
    
    if st.button("Update Resources"):
        st.session_state["page"] = "update_resource"  
        st.rerun()  

    


#___________________________________________________________________________________________________

#This will be the page tht gets displayed when the user logs in successfully. 

def user_homepage():
    if st.button("Logout"):
        st.session_state["page"] = "login"  
        st.rerun() 

    st.markdown(f"<h1 style='text-align: center;'>Welcome, {st.session_state['username']}! You are logged in as a User.</h1>", unsafe_allow_html=True)
    st.write("__________")
    st.markdown("<h2 style='text-align: left;'>Employee Information</h2>", unsafe_allow_html=True)
    st.write(" <data from database in the form of a dshboard> ")

    st.write("__________")
    st.markdown("<h2 style='text-align: left;'>Allocated Resources Information</h2>", unsafe_allow_html=True)
    st.write(" <data from database in the form of a table> ")

    st.write("__________")
    if st.button("Request Resource"):
        st.session_state["page"] = "Request"  
        st.rerun() 
    
#___________________________________________________________________________________________________

def request_resource_page():
    if st.button("Back To Home"):
        st.session_state["page"] = "user_homepage"  
        st.rerun() 

    st.markdown("<h1 style='text-align: center;'>Resource Request</h1>", unsafe_allow_html=True)
    st.write("_______________")
    st.markdown("<h3 style='text-align: center;'>Resource request Dashboard</h3>", unsafe_allow_html=True)


#___________________________________________________________________________________________________

def create_account_page():
    if st.button("Back To Home"):
        st.session_state["page"] = "admin_dashboard"  
        st.rerun() 

    st.markdown("<h1 style='text-align: center;'>Create New Employee Account</h1>", unsafe_allow_html=True)
    st.write("_______________")
    st.markdown("<h3 style='text-align: center;'>Form to create a new employee</h3>", unsafe_allow_html=True)


#__________________________________________________________________________________________________

def update_resources_page() :
    if st.button("Back To Home"):
        st.session_state["page"] = "admin_dashboard"  
        st.rerun() 

    st.markdown("<h1 style='text-align: center;'>Update IT Resources</h1>", unsafe_allow_html=True)
    st.write("_______________")
    st.markdown("<h3 style='text-align: center;'>options to add / delete / update information about the resources available to the employees</h3>", unsafe_allow_html=True)


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
