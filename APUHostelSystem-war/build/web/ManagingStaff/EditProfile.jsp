<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>

<%
    HttpSession sessionObj = request.getSession();
    Integer userId = (Integer) sessionObj.getAttribute("user_id");

    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/Login/Login.jsp");
        return;
    }

    String name = "", email = "", phoneNumber = "", dob = "", gender = "", password = "", profileImage = request.getContextPath() + "/uploads/user1.png"; // Default Image

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
                profileImage = request.getContextPath() + "/uploads/" + dbImage; // Corrected image path
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
        <title>Managing Staff - Edit Profile</title>

        <!-- External Styles & Scripts -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ManagingStaff/dashboard.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="profile-section">
                    <div class="profile-image">
                        <!-- Sidebar Profile Image (Fetched from DB) -->
                        <img id="sidebarProfileImage" src="<%= profileImage%>" alt="Profile">
                    </div>
                    <h3><%= name%></h3>

                    <button id="editProfileBtn" class="edit-profile" 
                            onclick="location.href = '${pageContext.request.contextPath}/ManagingStaff/EditProfile.jsp'">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                </div>

                <nav class="menu">
                    <ul>
                        <li class="active"><a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
                        <li><a href="user_management.jsp"><i class="fas fa-users-cog"></i> User Management</a></li>
                        <li><a href="approve_request.jsp"><i class="fas fa-check-circle"></i> Approve Request</a></li>
                        <li><a href="report_generation.jsp"><i class="fas fa-file-alt"></i> Report Generation</a></li>
                    </ul>
                </nav>

                <div class="logout-section">
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-btn">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
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
                    var formData = $(this).serialize(); // Serialize form data

                    $.ajax({
                        url: "${pageContext.request.contextPath}/UpdateProfileServlet",
                        type: "POST",
                        data: formData,
                        success: function (response) {
                            $("#messageBox").html(response).show();
                            setTimeout(() => {
                                $("#messageBox").fadeOut();
                                location.reload(); // Reload page to reflect updates
                            }, 2000);
                        },
                        error: function () {
                            $("#messageBox").html("<p style='color: red;'>Error updating profile!</p>").show();
                        }
                    });
                });
            });
        </script>

    </body>
</html>
