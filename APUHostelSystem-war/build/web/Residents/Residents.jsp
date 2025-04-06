<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.Random"%>

<%
    // Ensure user is logged in
    Integer userId = (session.getAttribute("user_id") != null) ? (Integer) session.getAttribute("user_id") : -1;
    if (userId == -1) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Generate unique 5-digit verification code only if not already in session
    if (session.getAttribute("verification_code") == null) {
        Random random = new Random();
        int verificationCode;
        boolean codeExists;
        int attempts = 0;
        int maxAttempts = 10;

        do {
            verificationCode = 10000 + random.nextInt(90000); // Generate 5-digit number
            attempts++;

            try (Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=APUHostelSystem;integratedSecurity=true;encrypt=true;trustServerCertificate=true;");
                 PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM Visitor_Requests WHERE verification_code = ?")) {

                pstmt.setInt(1, verificationCode);
                ResultSet rs = pstmt.executeQuery();
                rs.next();
                codeExists = rs.getInt(1) > 0;
            } catch (Exception e) {
                codeExists = false; // Assume unique if error occurs
            }
        } while (codeExists && attempts < maxAttempts);

        session.setAttribute("verification_code", verificationCode); // Store code in session
    }

    int verificationCode = (int) session.getAttribute("verification_code");

    // Handle form submission
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String visitorName = request.getParameter("name");
        String visitorEmail = request.getParameter("email");
        String visitorPhone = request.getParameter("phone");
        String visitorID = request.getParameter("id_passport");
        String visitorGender = request.getParameter("gender");
        String visitorPurpose = request.getParameter("purpose");
        String visitDate = request.getParameter("visit_date");
        String visitTime = request.getParameter("visit_time");

        try (Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=APUHostelSystem;integratedSecurity=true;encrypt=true;trustServerCertificate=true;");
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Visitor_Requests (user_id, visitor_name, visitor_email, visitor_phone, visitor_id, visitor_gender, purpose, visit_date, visit_time, verification_code, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending')")) {

            pstmt.setInt(1, userId);
            pstmt.setString(2, visitorName);
            pstmt.setString(3, visitorEmail);
            pstmt.setString(4, visitorPhone);
            pstmt.setString(5, visitorID);
            pstmt.setString(6, visitorGender);
            pstmt.setString(7, visitorPurpose);
            pstmt.setString(8, visitDate);
            pstmt.setString(9, visitTime);
            pstmt.setInt(10, verificationCode);

            pstmt.executeUpdate();
            message = "Request submitted successfully!";
            session.removeAttribute("verification_code"); // Remove code after successful submission
            response.sendRedirect("Residents.jsp"); // Refresh to generate a new code
            return;
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Residents - Visitor Request</title>

    <!-- External Styles & Scripts -->
    <link rel="stylesheet" href="Residents.css">
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
                <h3><%= session.getAttribute("name") %></h3>
                <button id="editProfileBtn" class="edit-profile" onclick="location.href = 'EditProfile.jsp'">
                    <i class="fas fa-user-edit"></i> Edit Profile
                </button>
            </div>

            <nav class="menu">
                <ul>
                    <li><a href="Residents.jsp" class="active"><i class="fas fa-user-check"></i> Visitor Request</a></li>
                    <li><a href="CheckRequest.jsp"><i class="fas fa-list"></i> Check Request</a></li>
                </ul>
            </nav>

            <div class="logout-section">
                <a href="LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <!-- Visitor Request Section -->
        <div class="main-content">
            <h1 class="page-title">Visitor Request</h1>

            <!-- Message Box -->
            <% if (!message.isEmpty()) { %>
                <div id="messageBox" style="padding: 10px; background: #dff0d8; color: #3c763d; border: 1px solid #3c763d; border-radius: 5px; margin-bottom: 10px; text-align: center;">
                    <%= message %>
                </div>
            <% } %>

            <div class="visitor-request-container">
                <form method="POST">
                    <div class="form-group">
                        <label>Name</label>
                        <div class="input-container">
                            <i class="fas fa-user"></i>
                            <input type="text" name="name" placeholder="Enter visitor's name" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <div class="input-container">
                            <i class="fas fa-envelope"></i>
                            <input type="email" name="email" placeholder="Enter visitor's email" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Phone Number</label>
                        <div class="input-container">
                            <i class="fas fa-phone"></i>
                            <input type="text" name="phone" placeholder="Enter phone number" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>ID Passport</label>
                        <div class="input-container">
                            <i class="fas fa-id-card"></i>
                            <input type="text" name="id_passport" placeholder="Enter ID/Passport" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Gender</label>
                        <div class="input-container">
                            <i class="fas fa-venus-mars"></i>
                            <select name="gender">
                                <option>Male</option>
                                <option>Female</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Visitor’s Purpose of Visit</label>
                        <div class="input-container">
                            <i class="fas fa-clipboard-list"></i>
                            <select name="purpose">
                                <option>Friend Visit</option>
                                <option>Family</option>
                                <option>Official</option>
                                <option>Delivery</option>
                                <option>Others</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group-row">
                        <div class="form-group">
                            <label>Visit Date</label>
                            <div class="input-container">
                                <i class="fas fa-calendar-alt"></i>
                                <input type="date" name="visit_date" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Time</label>
                            <div class="input-container">
                                <i class="fas fa-clock"></i>
                                <input type="time" name="visit_time" required>
                            </div>
                        </div>
                    </div>

                    <div class="verification-container">
                        <label>Auto Verification Code</label>
                        <div class="input-container">
                            <i class="fas fa-key"></i>
                            <input type="text" name="verification_code" value="<%= verificationCode %>" readonly>
                        </div>
                    </div>

                    <button type="submit" class="submit-btn">Send</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
