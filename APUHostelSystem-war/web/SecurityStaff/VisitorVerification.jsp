<%-- 
    Document   : VisitorVerification
    Created on : Mar 9, 2025, 9:58:31 PM
    Author     : lmoha
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=APUHostelSystem;integratedSecurity=true;encrypt=true;trustServerCertificate=true;";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(DB_URL);

        // Fetch approved visitor requests
        String sql = "SELECT VR.request_id, VR.visitor_name, VR.visitor_email, VR.visitor_phone, VR.visitor_id, VR.visitor_gender, " +
                     "VR.visit_date, VR.visit_time, VR.purpose, VR.verification_code " +
                     "FROM Requests_Log RL " +
                     "JOIN Visitor_Requests VR ON RL.request_id = VR.request_id " +
                     "WHERE RL.status = 'Approved' " +
                     "ORDER BY VR.visit_date DESC";

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
        <title>Visitor Verification</title>

        <!-- External Styles & Scripts -->
        <link rel="stylesheet" href="Security.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    </head>
    <body>
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="profile-section">
                    <div class="profile-image">
                        <img src="user_profile.jpg" alt="Profile">
                    </div>
                    <h3>Ali Ahmed</h3>
                    <button onclick="location.href='Security.jsp'" class="edit-profile">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                </div>

                <nav class="menu">
                    <ul>
                        <li class="active"><a href="VisitorVerification.jsp"><i class="fas fa-id-card"></i> Visitor Verification</a></li>
                        <li><a href="ActivityLogs.jsp"><i class="fas fa-book"></i> Activity Logs</a></li>
                    </ul>
                </nav>

                <div class="logout-section">
                   <a href="LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <h1 class="page-title">Visitor Verification</h1>

                <!-- Search Bar -->
                <div class="visitor-verification-container">
                    <div class="search-bar">
                        <label>Visitor Verification Code</label>
                        <input type="text" id="verificationCodeInput" placeholder="Enter Code">
                        <button class="find-btn" onclick="findVisitor()">Find</button>
                        <button class="complete-btn" onclick="markCompleted()" disabled>Mark as Completed</button>
                    </div>

                    <!-- Success Message -->
                    <div id="messageBox" class="message-box" style="display: none;"></div>

                    <div class="table-container">
                        <table class="verification-table">
                            <thead>
                                <tr>
                                    <th>NO.</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone Number</th>
                                    <th>Gender</th>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Purpose</th>
                                    <th>Code</th>
                                </tr>
                            </thead>
                            <tbody id="verificationTableBody">
                                <% int count = 1; while (rs.next()) { %>
                                <tr data-id="<%= rs.getInt("request_id") %>" data-code="<%= rs.getString("verification_code") %>" style="display: none;">
                                    <td><%= count++ %>.</td>
                                    <td><%= rs.getString("visitor_name") %></td>
                                    <td><%= rs.getString("visitor_email") %></td>
                                    <td><%= rs.getString("visitor_phone") %></td>
                                    <td><%= rs.getString("visitor_gender") %></td>
                                    <td><%= rs.getString("visitor_id") %></td>
                                    <td><%= rs.getDate("visit_date") %></td>
                                    <td><%= rs.getTime("visit_time") %></td>
                                    <td><%= rs.getString("purpose") %></td>
                                    <td><%= rs.getString("verification_code") %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function findVisitor() {
                let codeInput = document.getElementById("verificationCodeInput").value.trim().toLowerCase();
                let rows = document.querySelectorAll("#verificationTableBody tr");
                let found = false;

                rows.forEach(row => {
                    let code = row.getAttribute("data-code").trim().toLowerCase();
                    if (code === codeInput) {
                        row.style.display = "";
                        row.classList.add("selected");
                        found = true;
                        document.querySelector(".complete-btn").disabled = false;
                    } else {
                        row.style.display = "none";
                        row.classList.remove("selected");
                    }
                });

                if (!found) {
                    showMessage("No matching visitor found!", "error");
                    document.querySelector(".complete-btn").disabled = true;
                }
            }

            function markCompleted() {
                let selectedRow = document.querySelector("#verificationTableBody tr.selected");
                if (!selectedRow) {
                    showMessage("Please find a visitor before marking as completed.", "error");
                    return;
                }

                let requestId = selectedRow.getAttribute("data-id");

                $.post("VisitorVerification.jsp", { action: "complete", request_id: requestId }, function(response) {
                    showMessage(response.trim(), "success");
                    selectedRow.remove();
                    document.querySelector(".complete-btn").disabled = true;
                });
            }

            function showMessage(message, type) {
                let messageBox = document.getElementById("messageBox");
                messageBox.innerHTML = message;
                messageBox.style.display = "block";
                messageBox.style.backgroundColor = type === "success" ? "#dff0d8" : "#f8d7da";
                messageBox.style.color = type === "success" ? "#3c763d" : "#721c24";

                setTimeout(() => { messageBox.style.display = "none"; }, 3000);
            }
        </script>

        <%
            String action = request.getParameter("action");

            if (action != null && action.equals("complete")) {
                String requestId = request.getParameter("request_id");

                if (requestId != null && !requestId.isEmpty()) {
                    try {
                        String insertSQL = "INSERT INTO Activity_Logs (request_id, verified_by, verification_time, status) VALUES (?, ?, GETDATE(), 'Completed')";
                        PreparedStatement insertStmt = conn.prepareStatement(insertSQL);
                        insertStmt.setInt(1, Integer.parseInt(requestId));
                        insertStmt.setInt(2, 39); // Replace with logged-in security staff ID
                        insertStmt.executeUpdate();
                        insertStmt.close();

                        out.print("Visitor request marked as completed!");
                    } catch (Exception e) {
                        out.print("Error: " + e.getMessage());
                    }
                }
                return;
            }
        %>
    </body>
</html>
