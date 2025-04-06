<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
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

        if ("update".equals(action)) {
            // Ensure the AJAX response is plain text.
            response.setContentType("text/plain");
            String[] requestIds = request.getParameterValues("request_id");
            if (requestIds != null) {
                int totalUpdated = 0;
                String[] visitorNames = request.getParameterValues("visitor_name");
                String[] visitorEmails = request.getParameterValues("visitor_email");
                String[] visitorPhones = request.getParameterValues("visitor_phone");
                String[] visitorGenders = request.getParameterValues("visitor_gender");
                String[] visitorIds = request.getParameterValues("visitor_id");
                String[] visitDates = request.getParameterValues("visit_date");
                String[] visitTimes = request.getParameterValues("visit_time");
                String[] purposes = request.getParameterValues("purpose");

                for (int i = 0; i < requestIds.length; i++) {
                    String updateSQL = "UPDATE Visitor_Requests SET visitor_name=?, visitor_email=?, visitor_phone=?, visitor_gender=?, visitor_id=?, visit_date=?, visit_time=?, purpose=? WHERE request_id=? AND user_id=? AND status='Pending'";
                    pstmt = conn.prepareStatement(updateSQL);
                    pstmt.setString(1, visitorNames[i]);
                    pstmt.setString(2, visitorEmails[i]);
                    pstmt.setString(3, visitorPhones[i]);
                    pstmt.setString(4, visitorGenders[i]);
                    pstmt.setString(5, visitorIds[i]);
                    pstmt.setString(6, visitDates[i]);
                    pstmt.setString(7, visitTimes[i]);
                    pstmt.setString(8, purposes[i]);
                    pstmt.setInt(9, Integer.parseInt(requestIds[i]));
                    pstmt.setInt(10, loggedInUserId);
                    int rowsAffected = pstmt.executeUpdate();
                    totalUpdated += rowsAffected;
                    pstmt.close();
                }
                message = (totalUpdated > 0) ? "✅ Request updated successfully!" : "❌ No changes were made.";
            } else {
                message = "❌ No pending rows found to update.";
            }
            out.print(message);
            return;
        }

        if ("delete".equals(action)) {
            response.setContentType("text/plain");
            String requestId = request.getParameter("request_id");
            if (requestId != null && !requestId.isEmpty()) {
                String deleteSQL = "DELETE FROM Visitor_Requests WHERE request_id=? AND user_id=? AND status='Pending'";
                pstmt = conn.prepareStatement(deleteSQL);
                pstmt.setInt(1, Integer.parseInt(requestId));
                pstmt.setInt(2, loggedInUserId);
                int rowsAffected = pstmt.executeUpdate();
                pstmt.close();

                message = (rowsAffected > 0) ? "✅ Request deleted successfully!" : "❌ Only pending requests can be deleted.";
            }
            out.print(message);
            return;
        }

        // Normal page load: retrieve all requests for the logged in user.
        String sql = "SELECT request_id, visitor_name, visitor_email, visitor_phone, visitor_id, visitor_gender, visit_date, visit_time, purpose, verification_code, status FROM Visitor_Requests WHERE user_id=? ORDER BY visit_date DESC";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, loggedInUserId);
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
        <title>Residents - Check Request</title>
        <link rel="stylesheet" href="Residents.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
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
                    <a href="LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <div class="main-content">
                <h1 class="page-title">Check Request</h1>

                <div id="messageBox" class="message-box" style="display: <%= message.isEmpty() ? "none" : "block"%>;">
                    <%= message%>
                </div>

                <div class="check-request-container">
                    <table class="request-table">
                        <thead>
                            <tr>
                                <th>Select</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
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
                            <% while (rs.next()) {
                                    boolean isPending = rs.getString("status").equals("Pending");
                            %>
                            <tr data-id="<%= rs.getInt("request_id")%>" data-pending="<%= isPending%>">
                                <td><input type="checkbox" class="row-select"></td>
                                <td contenteditable="<%= isPending%>"><%= rs.getString("visitor_name")%></td>
                                <td contenteditable="<%= isPending%>"><%= rs.getString("visitor_email")%></td>
                                <td contenteditable="<%= isPending%>"><%= rs.getString("visitor_phone")%></td>
                                <td contenteditable="<%= isPending%>"><%= rs.getString("visitor_gender")%></td>
                                <td contenteditable="<%= isPending%>"><%= rs.getString("visitor_id")%></td>
                                <td contenteditable="<%= isPending%>"><%= rs.getDate("visit_date")%></td>
                                <td contenteditable="<%= isPending%>"><%= rs.getTime("visit_time")%></td>
                                <td contenteditable="<%= isPending%>"><%= rs.getString("purpose")%></td>
                                <td><%= rs.getString("verification_code")%></td>
                                <td><%= rs.getString("status")%></td>
                            </tr>
                            <% }%>
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
            // Update: Loop through every pending (editable) row and send the updated data.
            function updateRequest() {
                var requestIds = [];
                var visitorNames = [];
                var visitorEmails = [];
                var visitorPhones = [];
                var visitorGenders = [];
                var visitorIds = [];
                var visitDates = [];
                var visitTimes = [];
                var purposes = [];

                // Select rows with data-pending="true"
                $(".request-table tbody tr[data-pending='true']").each(function () {
                    var requestId = $(this).data("id");
                    requestIds.push(requestId);
                    visitorNames.push($(this).find("td").eq(1).text().trim());
                    visitorEmails.push($(this).find("td").eq(2).text().trim());
                    visitorPhones.push($(this).find("td").eq(3).text().trim());
                    visitorGenders.push($(this).find("td").eq(4).text().trim());
                    visitorIds.push($(this).find("td").eq(5).text().trim());
                    visitDates.push($(this).find("td").eq(6).text().trim());
                    visitTimes.push($(this).find("td").eq(7).text().trim());
                    purposes.push($(this).find("td").eq(8).text().trim());
                });

                if (requestIds.length === 0) {
                    alert("No pending rows available for update.");
                    return;
                }

                console.log("Updating rows:", requestIds, visitorNames);

                // Use traditional parameter serialization to send arrays properly.
                $.ajax({
                    url: "CheckRequest.jsp",
                    type: "POST",
                    data: {
                        action: "update",
                        request_id: requestIds,
                        visitor_name: visitorNames,
                        visitor_email: visitorEmails,
                        visitor_phone: visitorPhones,
                        visitor_gender: visitorGenders,
                        visitor_id: visitorIds,
                        visit_date: visitDates,
                        visit_time: visitTimes,
                        purpose: purposes
                    },
                    traditional: true,
                    success: function (response) {
                        console.log("Response:", response);
                        $("#messageBox").html(response).show();
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.error("Error in update:", textStatus, errorThrown);
                        $("#messageBox").html("❌ Update failed: " + textStatus).show();
                    }
                });
            }

            // Delete: Only works with rows selected via the checkbox.
            function deleteRequest() {
                var selected = $(".request-table tbody tr").filter(function () {
                    return $(this).find(".row-select").is(":checked");
                });
                if (selected.length === 0) {
                    alert("Please select at least one pending row to delete.");
                    return;
                }
                var requestId = selected.first().data("id");
                $.post("CheckRequest.jsp", {action: "delete", request_id: requestId}, function (response) {
                    $("#messageBox").html(response).show();
                    // Remove the deleted row from the table
                    selected.first().remove();
                });
            }
        </script>

    </body>
</html>
