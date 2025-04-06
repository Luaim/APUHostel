<%-- 
    Document   : EditProfile
    Created on : Mar 10, 2025, 12:56:25 PM
    Author     : lmoha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>

<%
    HttpSession sessionObj = request.getSession();
    Integer userId = (Integer) sessionObj.getAttribute("user_id");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = "", email = "", phoneNumber = "", dob = "", gender = "", password = "", profileImage = "uploads/profile_placeholder.png"; // Default Image

    try {
        String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=APUHostelSystem;integratedSecurity=true;encrypt=true;trustServerCertificate=true;";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        Connection conn = DriverManager.getConnection(DB_URL);

        String sql = "SELECT name, email, phone_number, dob, gender, password, profile_picture FROM Users WHERE user_id=?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            phoneNumber = rs.getString("phone_number");
            dob = rs.getString("dob");
            gender = rs.getString("gender");
            password = rs.getString("password");

            String dbImage = rs.getString("profile_picture");
            if (dbImage != null && !dbImage.isEmpty()) {
                profileImage = "uploads/" + dbImage; // Ensure the correct file path
            }
        }
        rs.close();
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Security - Edit Profile</title>

        <!-- External Styles & Scripts -->
        <link rel="stylesheet" href="Security.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
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

                    <button id="editProfileBtn" class="edit-profile" 
                            onclick="location.href = '/APUHostelSystem-war/SecurityStaff/Security.jsp'">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                </div>

                <nav class="menu">
                    <ul>
                        <li><a href="VisitorVerification.jsp"><i class="fas fa-id-card"></i> Visitor Verification</a></li>
                        <li><a href="ActivityLogs.jsp"><i class="fas fa-book"></i> Activity Logs</a></li>
                    </ul>
                </nav>

                <div class="logout-section">
                    <a href="LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <h1 class="page-title">Edit Profile</h1>

                <div class="edit-profile-container">
                    <!-- Profile Image Section -->
                    <div class="profile-container">
                        <img id="profileImagePreview" src="<%= profileImage%>" alt="Profile">
                        <input type="file" id="profileImageInput" name="profile_picture" accept="image/*">
                    </div>

                    <form class="edit-profile-form" id="editProfileForm" enctype="multipart/form-data">
                        <input type="hidden" name="user_id" value="<%= userId%>">

                        <div class="form-group">
                            <label>Name</label>
                            <div class="input-container">
                                <i class="fas fa-user"></i>
                                <input type="text" name="name" value="<%= name%>" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <div class="input-container">
                                <i class="fas fa-envelope"></i>
                                <input type="email" name="email" value="<%= email%>" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Phone Number</label>
                            <div class="input-container">
                                <i class="fas fa-phone"></i>
                                <input type="text" name="phone_number" value="<%= phoneNumber%>" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Date of Birth</label>
                            <div class="input-container">
                                <i class="fas fa-calendar-alt"></i>
                                <input type="date" name="dob" value="<%= dob%>" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Gender</label>
                            <div class="input-container">
                                <i class="fas fa-venus-mars"></i>
                                <select name="gender" required>
                                    <option value="Male" <%= gender.equals("Male") ? "selected" : ""%>>Male</option>
                                    <option value="Female" <%= gender.equals("Female") ? "selected" : ""%>>Female</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <div class="input-container">
                                <i class="fas fa-lock"></i>
                                <input type="password" name="password" value="<%= password%>" required>
                            </div>
                        </div>

                        <button type="submit" class="save-btn">Save</button>
                    </form>
                    <div id="messageBox" style="display: none;"></div>
                </div>
            </div>
        </div>

        <script>
            $(document).ready(function () {
                $("#editProfileForm").submit(function (event) {
                    event.preventDefault();
                    var formData = new FormData(this);

                    $.ajax({
                        url: "UpdateProfileServlet",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (response) {
                            $("#messageBox").html(response).show();
                            setTimeout(() => {
                                $("#messageBox").fadeOut();
                                location.reload(); // Reload page to reflect updates
                            }, 2000);
                        }
                    });
                });

                // Handle profile image preview
                $("#profileImageInput").change(function () {
                    let reader = new FileReader();
                    reader.onload = function (e) {
                        $("#profileImagePreview").attr("src", e.target.result);
                        $("#sidebarProfileImage").attr("src", e.target.result);
                    };
                    reader.readAsDataURL(this.files[0]);
                });
            });
        </script>
    </body>
</html>
