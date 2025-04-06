<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String message = "";

    try {
        String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=APUHostelSystem;integratedSecurity=true;encrypt=true;trustServerCertificate=true;";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(DB_URL);

        String action = request.getParameter("action");

        if (action != null) {
            response.setContentType("text/html");

            if (action.equals("update")) {
                String[] emails = request.getParameterValues("email");
                String[] names = request.getParameterValues("name");
                String[] phone_numbers = request.getParameterValues("phone_number");
                String[] dobs = request.getParameterValues("dob");
                String[] genders = request.getParameterValues("gender");
                String[] passwords = request.getParameterValues("password");
                String[] roles = request.getParameterValues("role");

                if (emails != null) {
                    for (int i = 0; i < emails.length; i++) {
                        String updateSQL = "UPDATE Users SET name=?, phone_number=?, dob=?, gender=?, password=?, role=? WHERE email=?";
                        pstmt = conn.prepareStatement(updateSQL);
                        pstmt.setString(1, names[i]);
                        pstmt.setString(2, phone_numbers[i]);
                        pstmt.setString(3, dobs[i]);
                        pstmt.setString(4, genders[i]);
                        pstmt.setString(5, passwords[i]);
                        pstmt.setString(6, roles[i]);
                        pstmt.setString(7, emails[i]);
                        pstmt.executeUpdate();
                        pstmt.close();
                    }
                    message = "✅ Users updated successfully!";
                }
            } else if (action.equals("delete")) {
                String[] selectedEmails = request.getParameterValues("emails");
                if (selectedEmails != null) {
                    for (String email : selectedEmails) {
                        String deleteSQL = "DELETE FROM Users WHERE email=?";
                        pstmt = conn.prepareStatement(deleteSQL);
                        pstmt.setString(1, email);
                        pstmt.executeUpdate();
                        pstmt.close();
                    }
                    message = "✅ Selected users deleted successfully!";
                }
            } else if (action.equals("add")) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone_number = request.getParameter("phone_number");
                String dob = request.getParameter("dob");
                String gender = request.getParameter("gender");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                String insertSQL = "INSERT INTO Users (name, email, phone_number, dob, gender, password, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertSQL);
                pstmt.setString(1, name);
                pstmt.setString(2, email);
                pstmt.setString(3, phone_number);
                pstmt.setString(4, dob);
                pstmt.setString(5, gender);
                pstmt.setString(6, password);
                pstmt.setString(7, role);
                pstmt.executeUpdate();
                pstmt.close();

                message = "✅ New user added successfully!";
            }
        }

        String sql = "SELECT * FROM Users ORDER BY name";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
    } catch (Exception e) {
        message = "❌ Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Management</title>
        <link rel="stylesheet" href="dashboard.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <div class="dashboard-container">
            <div class="sidebar">
                <div class="profile-section">
                    <div class="profile-image">
                        <img src="user_profile.jpg" alt="Profile">
                    </div>
                    <h3>Ali Ahmed</h3>
                    <button id="editProfileBtn" class="edit-profile" onclick="redirectToEditProfile()">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                </div>

                <nav class="menu">
                    <ul>
                        <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
                        <li><a href="user_management.jsp" class="active"><i class="fas fa-users-cog"></i> User Management</a></li>
                        <li><a href="approve_request.jsp"><i class="fas fa-check-circle"></i> Approve Request</a></li>
                        <li><a href="report_generation.jsp"><i class="fas fa-file-alt"></i> Report Generation</a></li>
                    </ul>
                </nav>

                <div class="logout-section">
                    <a href="LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <div class="main-content">
                <h1>User Management</h1>

                <div class="user-management-container">
                    <div class="search-bar">
                        <div class="search-input-container">
                            <input type="text" id="search" placeholder="Search..." onkeyup="searchTable()">
                            <i class="fas fa-search search-icon"></i>
                        </div>
                    </div>

                    <div id="messageBox" class="message-box" style="display: <%= message.isEmpty() ? "none" : "block"%>;">
                        <%= message%>
                    </div>

                    <div class="table-container">
                        <table class="user-table">
                            <thead>
                                <tr>
                                    <th>Select</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone Number</th>
                                    <th>Date of Birth</th>
                                    <th>Gender</th>
                                    <th>Password</th>
                                    <th>Role</th>
                                </tr>
                            </thead>
                            <tbody id="userTableBody">
                                <% while (rs.next()) {%>
                                <tr>
                                    <td><input type="checkbox" class="row-select" value="<%= rs.getString("email")%>"></td>
                                    <td contenteditable="true"><%= rs.getString("name")%></td>
                                    <td><%= rs.getString("email")%></td>
                                    <td contenteditable="true"><%= rs.getString("phone_number")%></td>
                                    <td contenteditable="true"><%= rs.getDate("dob")%></td>
                                    <td contenteditable="true"><%= rs.getString("gender")%></td>
                                    <td contenteditable="true"><%= rs.getString("password")%></td>
                                    <td contenteditable="true"><%= rs.getString("role")%></td>
                                </tr>
                                <% }%>
                            </tbody>
                        </table>
                    </div>

                    <div class="buttons-container">
                        <button class="action-btn update-btn" onclick="updateUser()"><i class="fas fa-sync-alt"></i> Update</button>
                        <button class="action-btn add-btn" onclick="handleAddUser()"><i class="fas fa-user-plus"></i> Add</button>
                        <button class="action-btn delete-btn" onclick="deleteUser()"><i class="fas fa-trash"></i> Delete</button>
                    </div>
                </div>
            </div>

            <script>
                let isAdding = false;

                function showMessage(message, isSuccess) {
                    const messageBox = document.getElementById('messageBox');
                    messageBox.textContent = message;
                    messageBox.style.display = 'block';
                    messageBox.style.backgroundColor = isSuccess ? '#d4edda' : '#f8d7da';
                    messageBox.style.color = isSuccess ? '#155724' : '#721c24';
                    setTimeout(() => messageBox.style.display = 'none', 3000);
                }

                function updateUser() {
                    const formData = new FormData();
                    formData.append('action', 'update');

                    document.querySelectorAll('#userTableBody tr').forEach(row => {
                        const cells = row.cells;
                        formData.append('email', cells[2].textContent.trim());
                        formData.append('name', cells[1].textContent.trim());
                        formData.append('phone_number', cells[3].textContent.trim());
                        formData.append('dob', cells[4].textContent.trim());
                        formData.append('gender', cells[5].textContent.trim());
                        formData.append('password', cells[6].textContent.trim());
                        formData.append('role', cells[7].textContent.trim());
                    });

                    fetch(window.location.href, {
                        method: 'POST',
                        body: new URLSearchParams(formData)
                    })
                            .then(response => response.text()) // Get the response as text
                            .then(data => {
                                if (data.includes("✅ Users updated successfully!")) {
                                    showMessage(data, true); // Show success message
                                    setTimeout(() => location.reload(), 2000); // Reload page after showing message
                                } else {
                                    showMessage('❌ Error updating users', false); // Show error if response isn't expected
                                }
                            })
                            .catch(error => showMessage('❌ Error: ' + error.message, false));
                }

                function deleteUser() {
                    const emails = Array.from(document.querySelectorAll('.row-select:checked'))
                            .map(checkbox => checkbox.value);

                    if (!emails.length) {
                        showMessage('❌ Please select users to delete', false);
                        return;
                    }

                    const formData = new FormData();
                    formData.append('action', 'delete');
                    emails.forEach(email => formData.append('emails', email));

                    fetch(window.location.href, {
                        method: 'POST',
                        body: new URLSearchParams(formData)
                    }).then(response => {
                        if (response.ok)
                            location.reload();
                        else
                            showMessage('❌ Error deleting users', false);
                    }).catch(error => showMessage('❌ Error: ' + error.message, false));
                }

                function handleAddUser() {
                    if (!isAdding) {
                        isAdding = true;
                        const btn = document.querySelector('.add-btn');
                        btn.innerHTML = '<i class="fas fa-save"></i> Save';
                        btn.onclick = saveNewUser;

                        const newRow = document.createElement('tr');
                        newRow.innerHTML = `
                            <td></td>
                            <td contenteditable="true"></td>
                            <td contenteditable="true"></td>
                            <td contenteditable="true"></td>
                            <td contenteditable="true"></td>
                            <td contenteditable="true"></td>
                            <td contenteditable="true"></td>
                            <td contenteditable="true"></td>
                        `;
                        document.getElementById('userTableBody').appendChild(newRow);
                    }
                }

                function saveNewUser() {
                    const row = document.querySelector('#userTableBody tr:last-child');
                    const cells = row.cells;
                    const formData = new FormData();

                    formData.append('action', 'add');
                    formData.append('name', cells[1].textContent);
                    formData.append('email', cells[2].textContent);
                    formData.append('phone_number', cells[3].textContent);
                    formData.append('dob', cells[4].textContent);
                    formData.append('gender', cells[5].textContent);
                    formData.append('password', cells[6].textContent);
                    formData.append('role', cells[7].textContent);

                    fetch(window.location.href, {
                        method: 'POST',
                        body: new URLSearchParams(formData)
                    }).then(response => {
                        if (response.ok)
                            location.reload();
                        else
                            showMessage('❌ Error adding user', false);
                    }).catch(error => showMessage('❌ Error: ' + error.message, false));
                }


                function searchTable() {
                    let input = document.getElementById("search").value.toLowerCase().trim();
                    let tableRows = document.querySelectorAll("#userTableBody tr");

                    tableRows.forEach(row => {
                        let name = row.cells[1].innerText.toLowerCase();
                        let email = row.cells[2].innerText.toLowerCase();
                        let role = row.cells[7].innerText.toLowerCase(); // Role column instead of Purpose

                        row.style.display = (name.includes(input) || email.includes(input) || role.includes(input)) ? "" : "none";
                    });
                }
            </script>
    </body>
</html>