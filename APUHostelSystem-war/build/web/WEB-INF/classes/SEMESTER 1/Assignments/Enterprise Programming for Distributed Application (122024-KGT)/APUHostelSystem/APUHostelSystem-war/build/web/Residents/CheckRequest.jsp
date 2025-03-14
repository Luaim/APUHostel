<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    
    String name = (session.getAttribute("name") != null) ? (String) session.getAttribute("name") : "Unknown User";
    String profilePicture = (session.getAttribute("profile_picture") != null) ? session.getAttribute("profile_picture").toString() : "default.png";

    
    // Simulating logged-in user (Replace with session user_id)
    int loggedInUserId = (session.getAttribute("user_id") != null) ? (Integer) session.getAttribute("user_id") : -1;
    if (loggedInUserId == -1) {
        response.sendRedirect("login.jsp"); 
        return;
    }

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
                String requestId = request.getParameter("request_id");
                String status = request.getParameter("status");

                if (requestId != null && !requestId.isEmpty() && status != null) {
                    String updateSQL = "UPDATE Visitor_Requests SET status=? WHERE request_id=? AND user_id=? AND status='Pending'";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSQL);
                    updateStmt.setString(1, status);
                    updateStmt.setInt(2, Integer.parseInt(requestId));
                    updateStmt.setInt(3, loggedInUserId);
                    int rowsAffected = updateStmt.executeUpdate();
                    updateStmt.close();

                    if (rowsAffected > 0) {
                        out.print("Request updated successfully!");
                    } else {
                        out.print("Only pending requests can be updated.");
                    }
                    return;
                }
            } 
            else if (action.equals("delete")) {
                String requestId = request.getParameter("request_id");

                if (requestId != null && !requestId.isEmpty()) {
                    String deleteSQL = "DELETE FROM Visitor_Requests WHERE request_id=? AND user_id=? AND status='Pending'";
                    PreparedStatement deleteStmt = conn.prepareStatement(deleteSQL);
                    deleteStmt.setInt(1, Integer.parseInt(requestId));
                    deleteStmt.setInt(2, loggedInUserId);
                    int rowsAffected = deleteStmt.executeUpdate();
                    deleteStmt.close();

                    if (rowsAffected > 0) {
                        out.print("Request deleted successfully!");
                    } else {
                        out.print("Only pending requests can be deleted.");
                    }
                    return;
                }
            }
        }

        // Fetch Requests for Logged-in User
        String sql = "SELECT request_id, visitor_name, visitor_email, visitor_phone, visitor_id, visitor_gender, visit_date, visit_time, purpose, verification_code, status FROM Visitor_Requests WHERE user_id=? ORDER BY visit_date DESC";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, loggedInUserId);
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
        <title>Residents - Check Request</title>

        <!-- External Styles & Scripts -->
        <link rel="stylesheet" href="Residents.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="profile-section">
                    <div class="profile-image">
                        <img id="sidebarProfileImage" src="<%= request.getContextPath()%>/uploads/<%= profilePicture%>" alt="Profile">
                    </div>
                    <h3><%= name%></h3>
                    <button id="editProfileBtn" class="edit-profile" onclick="location.href = 'EditProfile.jsp'">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                </div>

                <nav class="menu">
                    <ul>
                        <li><a href="Residents.jsp"><i class="fas fa-user-check"></i> Visitor Request</a></li>
                        <li><a href="CheckRequest.jsp" class="active"><i class="fas fa-list"></i> Check Request</a></li>
                    </ul>
                </nav>

                <div class="logout-section">
                    <a href="#" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <h1 class="page-title">Check Request</h1>

                <div id="messageBox" class="message-box" style="display: none;"></div>

                <div class="check-request-container">
                    <table class="request-table">
                        <thead>
                            <tr>
                                <th>Select</th>
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
                        <tbody>
                            <% while (rs.next()) { %>
                            <tr data-id="<%= rs.getInt("request_id") %>" onclick="selectRow(this)">
                                <td><input type="checkbox" class="row-select"></td>
                                <td><%= rs.getString("visitor_name") %></td>
                                <td><%= rs.getString("visitor_email") %></td>
                                <td><%= rs.getString("visitor_phone") %></td>
                                <td><%= rs.getString("visitor_gender") %></td>
                                <td><%= rs.getString("visitor_id") %></td>
                                <td><%= rs.getDate("visit_date") %></td>
                                <td><%= rs.getTime("visit_time") %></td>
                                <td><%= rs.getString("purpose") %></td>
                                <td><%= rs.getString("verification_code") %></td>
                                <td contenteditable="<%= rs.getString("status").equals("Pending") ? "true" : "false" %>">
                                    <%= rs.getString("status") %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>

                    <div class="action-buttons">
                        <button class="update-btn" onclick="updateRequest()"><i class="fas fa-sync-alt"></i> Update</button>
                        <button class="delete-btn" onclick="deleteRequest()"><i class="fas fa-times"></i> Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            let selectedRow = null;

            function selectRow(row) {
                document.querySelectorAll("tbody tr").forEach(tr => tr.classList.remove("selected"));
                row.classList.add("selected");
                selectedRow = row;
            }

            function updateRequest() {
                if (!selectedRow) {
                    showMessage("Please select a request first.");
                    return;
                }

                let requestId = selectedRow.getAttribute("data-id");
                let newStatus = selectedRow.cells[10].innerText.trim();

                $.post("CheckRequest.jsp", { action: "update", request_id: requestId, status: newStatus }, function(response) {
                    showMessage(response.trim());
                    setTimeout(() => { location.reload(); }, 2000);
                });
            }

            function deleteRequest() {
                if (!selectedRow) {
                    showMessage("Please select a pending request to delete.");
                    return;
                }

                let requestId = selectedRow.getAttribute("data-id");

                $.post("CheckRequest.jsp", { action: "delete", request_id: requestId }, function(response) {
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
        </script>
    </body>
</html>