<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    String name = (session.getAttribute("name") != null) ? (String) session.getAttribute("name") : "Unknown User";
    String profilePicture = (session.getAttribute("profile_picture") != null) ? session.getAttribute("profile_picture").toString() : "default.png";
    
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
            response.setContentType("text/plain");
            if (action.equals("update")) {
                String updatedName = request.getParameter("name");
                String email = request.getParameter("email");
                String phone_number = request.getParameter("phone_number");
                String dob = request.getParameter("dob");
                String gender = request.getParameter("gender");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                String updateSQL = "UPDATE Users SET name=?, phone_number=?, dob=?, gender=?, password=?, role=? WHERE email=?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSQL);
                updateStmt.setString(1, name);
                updateStmt.setString(2, phone_number);
                updateStmt.setString(3, dob);
                updateStmt.setString(4, gender);
                updateStmt.setString(5, password);
                updateStmt.setString(6, role);
                updateStmt.setString(7, email);
                updateStmt.executeUpdate();
                updateStmt.close();

                out.print("User updated successfully!");
                return;

            } else if (action.equals("delete")) {
                String email = request.getParameter("email");

                // First, delete records from dependent tables
                String deleteActivityLogsSQL = "DELETE FROM Activity_Logs WHERE verified_by = (SELECT user_id FROM Users WHERE email=?)";
                PreparedStatement deleteActivityLogsStmt = conn.prepareStatement(deleteActivityLogsSQL);
                deleteActivityLogsStmt.setString(1, email);
                deleteActivityLogsStmt.executeUpdate();
                deleteActivityLogsStmt.close();

                // Now, delete from Users table
                String deleteSQL = "DELETE FROM Users WHERE email=?";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSQL);
                deleteStmt.setString(1, email);
                deleteStmt.executeUpdate();
                deleteStmt.close();

                out.print("User deleted successfully!");
                return;

            } else if (action.equals("add")) {
                String updatedName   = request.getParameter("name");
                String email = request.getParameter("email");
                String phone_number = request.getParameter("phone_number");
                String dob = request.getParameter("dob");
                String gender = request.getParameter("gender");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                String insertSQL = "INSERT INTO Users (name, email, phone_number, dob, gender, password, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSQL);
                insertStmt.setString(1, name);
                insertStmt.setString(2, email);
                insertStmt.setString(3, phone_number);
                insertStmt.setString(4, dob);
                insertStmt.setString(5, gender);
                insertStmt.setString(6, password);
                insertStmt.setString(7, role);
                insertStmt.executeUpdate();
                insertStmt.close();

                out.print("User added successfully!");
                return;
            }
        }

        // Fetch user data again after any update
        String sql = "SELECT * FROM Users ORDER BY name";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
        return;
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
                            <img id="sidebarProfileImage" src="<%= request.getContextPath()%>/uploads/<%= profilePicture %>" alt="Profile">
                        </div>
                        <h3><%= name %></h3>
                    <button id="editProfileBtn" class="edit-profile" onclick="redirectToEditProfile()">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                </div>
                <nav class="menu">
                    <ul>
                        <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
                        <li><a href="user_management.jsp"><i class="fas fa-users-cog"></i> User Management</a></li>
                        <li><a href="approve_request.jsp"><i class="fas fa-check-circle"></i> Approve Request</a></li>
                        <li><a href="report_generation.jsp"><i class="fas fa-file-alt"></i> Report Generation</a></li>
                    </ul>
                </nav>
                <div class="logout-section">
                    <a href="#" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <div class="main-content">
                <h1>User Management</h1>

                <div class="search-bar">
                    <div class="search-input-container">
                        <input type="text" id="searchInput" placeholder="🔍 Search by Name, Email, or Gender..." onkeyup="searchTable()">
                        <i class="fas fa-search search-icon"></i>
                    </div>
                </div>


                <div id="messageBox" style="display: none; padding: 10px; background: #dff0d8; color: #3c763d; border: 1px solid #3c763d; border-radius: 5px; margin-bottom: 10px; text-align: center;"></div>
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
                            <%
                                while (rs.next()) {
                            %>
                            <tr onclick="makeRowEditable(this)">
                                <td><input type="checkbox" class="row-select"></td>
                                <td contenteditable="false"><%= rs.getString("name")%></td>
                                <td contenteditable="false"><%= rs.getString("email")%></td>
                                <td contenteditable="false"><%= rs.getString("phone_number")%></td>
                                <td contenteditable="false"><%= rs.getDate("dob")%></td>
                                <td contenteditable="false"><%= rs.getString("gender")%></td>
                                <td contenteditable="false"><%= rs.getString("password")%></td>
                                <td contenteditable="false"><%= rs.getString("role")%></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="buttons-container">
                    <button class="action-btn update-btn" onclick="updateUser()"><i class="fas fa-sync-alt"></i> Update</button>
                    <button class="action-btn add-btn" onclick="addUser()"><i class="fas fa-user-plus"></i> Add</button>
                    <button class="action-btn delete-btn" onclick="deleteUser()"><i class="fas fa-trash"></i> Delete</button>
                </div>

                <% if (!message.isEmpty()) {%>
                <p><strong><%= message%></strong></p>
                <% }%>

            </div>

            <script>
                function makeRowEditable(row) {
                    let cells = row.querySelectorAll("td:not(:first-child)");
                    cells.forEach(cell => cell.contentEditable = "true");
                    row.classList.add("editable");
                }

                function updateUser() {
                    let rows = document.querySelectorAll(".editable");
                    rows.forEach(row => {
                        let cells = row.querySelectorAll("td");
                        let userData = {
                            action: "update",
                            name: cells[1].innerText,
                            email: cells[2].innerText,
                            phone_number: cells[3].innerText,
                            dob: cells[4].innerText,
                            gender: cells[5].innerText,
                            password: cells[6].innerText,
                            role: cells[7].innerText
                        };

                        $.post("user_management.jsp", userData, function (response) {
                            showMessage(response.trim());
                            setTimeout(() => {
                                location.reload();
                            }, 6000);
                        });
                    });
                }

                function addUser() {
                    // Get user input using a prompt
                    let name = prompt("Enter Name:");
                    if (!name)
                        return;

                    let email = prompt("Enter Email:");
                    if (!email)
                        return;

                    let phone_number = prompt("Enter Phone Number:");
                    if (!phone_number)
                        return;

                    let dob = prompt("Enter Date of Birth (YYYY-MM-DD):");
                    if (!dob)
                        return;

                    let gender = prompt("Enter Gender (Male/Female):");
                    if (!gender)
                        return;

                    let password = prompt("Enter Password:");
                    if (!password)
                        return;

                    let role = prompt("Enter Role (Resident/Managing Staff/Security Staff):");
                    if (!role)
                        return;

                    // Prepare user data for insertion
                    let userData = {
                        action: "add",
                        name: name,
                        email: email,
                        phone_number: phone_number,
                        dob: dob,
                        gender: gender,
                        password: password,
                        role: role
                    };

                    // Send data to the server via AJAX
                    $.post("user_management.jsp", userData, function (response) {
                        showMessage(response.trim());
                        setTimeout(() => {
                            location.reload();
                        }, 6000);
                    });
                }

                function deleteUser() {
                    $(".row-select:checked").each(function () {
                        let row = $(this).closest("tr");
                        let email = row.find("td:eq(2)").text();

                        $.post("user_management.jsp", {action: "delete", email: email}, function (response) {
                            showMessage(response.trim());
                            setTimeout(() => {
                                row.remove();
                            }, 6000);
                        });
                    });
                }

                function showMessage(message) {
                    let messageBox = document.getElementById("messageBox");
                    messageBox.innerHTML = message; // Set message text
                    messageBox.style.display = "block"; // Show the message box
                    messageBox.style.opacity = "1";

                    setTimeout(() => {
                        let fadeEffect = setInterval(() => {
                            if (!messageBox.style.opacity) {
                                messageBox.style.opacity = "1";
                            }
                            if (messageBox.style.opacity > "0") {
                                messageBox.style.opacity -= "0.1";
                            } else {
                                clearInterval(fadeEffect);
                                messageBox.style.display = "none"; // Hide after fade-out
                            }
                        }, 100);
                    }, 6000);
                }

                function searchTable() {
                    let input = document.getElementById("searchInput").value.toLowerCase();
                    let tableRows = document.querySelectorAll("#userTableBody tr");

                    tableRows.forEach(row => {
                        let name = row.cells[1].innerText.toLowerCase();
                        let email = row.cells[2].innerText.toLowerCase();
                        let gender = row.cells[5].innerText.toLowerCase().trim();

                        // Show the row if it matches the search input in Name, Email, or Gender
                        if (name.includes(input) || email.includes(input) || gender.includes(input)) {
                            row.style.display = "";
                        } else {
                            row.style.display = "none";
                        }
                    });
                }
            </script>
    </body>
</html>
