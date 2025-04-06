<%-- 
    Document   : ActivityLogs
    Created on : Mar 10, 2025, 9:24:30 AM
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

        // Fetch only verified resident requests
        String sql = "SELECT VR.visitor_name, VR.visitor_email, VR.visitor_phone, VR.visitor_id, VR.visitor_gender, " +
                     "VR.visit_date, VR.visit_time, VR.purpose, VR.verification_code, AL.status " +
                     "FROM Activity_Logs AL " +
                     "JOIN Visitor_Requests VR ON AL.request_id = VR.request_id " +
                     "WHERE AL.status = 'Verified' " +
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
        <title>Security Staff - Activity Logs</title>

        <!-- External Styles -->
        <link rel="stylesheet" href="Security.css">
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
                    <a href="Security.jsp" class="edit-profile"><i class="fas fa-user-edit"></i> Edit Profile</a>
                </div>

                <nav class="menu">
                    <ul>
                        <li><a href="VisitorVerification.jsp"><i class="fas fa-id-card"></i> Visitor Verification</a></li>
                        <li class="active"><a href="ActivityLogs.jsp"><i class="fas fa-book"></i> Activity Logs</a></li>
                    </ul>
                </nav>

                <div class="logout-section">
                    <a href="LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <h1 class="page-title">Activity Logs</h1>

                <!-- Search Bar -->
                <div class="search-container">
                    <input type="text" id="search-input" placeholder="Search by Name, Email, or Code..." onkeyup="searchTable()">
                    <button class="search-btn"><i class="fas fa-search"></i> Search</button>
                </div>

                <div class="activity-logs-container">
                    <!-- Table -->
                    <table class="logs-table" id="activityTable">
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
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody id="logs-table-body">
                            <% int count = 1; while (rs.next()) { %>
                            <tr>
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
                                <td><%= rs.getString("status") %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            function searchTable() {
                let input = document.getElementById("search-input").value.toLowerCase();
                let rows = document.querySelectorAll("#logs-table-body tr");

                rows.forEach(row => {
                    let name = row.cells[1].innerText.toLowerCase();
                    let email = row.cells[2].innerText.toLowerCase();
                    let code = row.cells[9].innerText.toLowerCase();

                    if (name.includes(input) || email.includes(input) || code.includes(input)) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            }
        </script>
    </body>
</html>
