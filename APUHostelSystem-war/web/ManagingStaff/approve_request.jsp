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

        String action = request.getParameter("action");
        if (action != null) {
            response.setContentType("text/plain");

            String requestId = request.getParameter("request_id");
            if (requestId != null) {
                String updateSQL = "UPDATE Visitor_Requests SET status=? WHERE request_id=?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSQL);
                updateStmt.setString(1, action.equals("approve") ? "Approved" : "Rejected");
                updateStmt.setInt(2, Integer.parseInt(requestId));
                updateStmt.executeUpdate();
                updateStmt.close();
                out.print("Request " + (action.equals("approve") ? "Approved" : "Rejected") + " Successfully!");
                return;
            }
        }

        // Fetch only pending requests
        String sql = "SELECT request_id, visitor_name, visitor_email, visitor_phone, visitor_id, visitor_gender, visit_date, visit_time, purpose, verification_code FROM Visitor_Requests WHERE status='Pending' ORDER BY visit_date DESC";
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
    <title>Approve Request</title>

    <!-- External Styles & Scripts -->
    <link rel="stylesheet" href="dashboard.css">
    <link rel="stylesheet" href="approve_request.css"> <!-- ✅ Your Updated CSS file -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
                <a href="LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <h1>Approve Request</h1>

            <div class="approve-request-container">
                <!-- Search Bar -->
                <div class="search-bar">
                    <div class="search-input-container">
                        <input type="text" id="search" placeholder="Search by Name, Email, or Purpose..." onkeyup="searchTable()">
                        <i class="fas fa-search search-icon"></i>
                    </div>
                </div>

                <!-- Success Message Box -->
                <div id="messageBox" class="message-box" style="display: none;"></div>

                <!-- Table -->
                <div class="table-container">
                    <table class="request-table">
                        <thead>
                            <tr>
                                <th>Select</th>
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
                        <tbody id="requestTableBody">
                            <% int count = 1; while (rs.next()) { %>
                            <tr data-id="<%= rs.getInt("request_id") %>" onclick="selectRow(this)">
                                <td><input type="radio" name="selectRequest"></td>
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

                <!-- Buttons -->
                <div class="buttons-container">
                    <button class="approve-btn" onclick="updateRequest('approve')"><i class="fas fa-user-check"></i> Approve</button>
                    <button class="reject-btn" onclick="updateRequest('reject')"><i class="fas fa-user-times"></i> Reject</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        let selectedRow = null;

        function selectRow(row) {
            document.querySelectorAll("#requestTableBody tr").forEach(tr => {
                tr.classList.remove("selected");
                tr.querySelector("input[type='radio']").checked = false;
            });

            row.classList.add("selected");
            row.querySelector("input[type='radio']").checked = true;
            selectedRow = row;
        }

        function updateRequest(status) {
            if (!selectedRow) {
                showMessage("⚠ Please select a request first!");
                return;
            }

            let requestId = selectedRow.getAttribute("data-id");

            $.post("approve_request.jsp", { action: status, request_id: requestId }, function(response) {
                showMessage(response.trim());
                setTimeout(() => { location.reload(); }, 2000);
            });
        }

        function showMessage(message) {
            let messageBox = document.getElementById("messageBox");
            messageBox.innerHTML = message;
            messageBox.style.display = "block";
            setTimeout(() => { messageBox.style.display = "none"; }, 3000);
        }

        function searchTable() {
            let input = document.getElementById("search").value.toLowerCase().trim();
            let tableRows = document.querySelectorAll("#requestTableBody tr");

            tableRows.forEach(row => {
                let name = row.cells[2].innerText.toLowerCase();
                let email = row.cells[3].innerText.toLowerCase();
                let purpose = row.cells[9].innerText.toLowerCase();

                row.style.display = (name.includes(input) || email.includes(input) || purpose.includes(input)) ? "" : "none";
            });
        }
    </script>
</body>
</html>
