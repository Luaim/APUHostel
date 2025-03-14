<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>

<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("../Login.jsp?error=Session expired. Please login again.");
        return;
    }

    // Fetch user details from session
    String name = (session.getAttribute("name") != null) ? (String) session.getAttribute("name") : "";
    String email = (session.getAttribute("email") != null) ? (String) session.getAttribute("email") : "";
    String phone = (session.getAttribute("phone_number") != null) ? (String) session.getAttribute("phone_number") : "";
    String dob = (session.getAttribute("dob") != null) ? session.getAttribute("dob").toString() : "";
    String gender = (session.getAttribute("gender") != null) ? (String) session.getAttribute("gender") : "Male";
    String profilePicture = (session.getAttribute("profile_picture") != null) ? session.getAttribute("profile_picture").toString() : "default.png";

    // Get success/error messages
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="dashboard.css">
    <title>Edit Profile</title>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="profile-section">
                <div class="profile-image">
                    <img id="sidebarProfileImage" src="<%= request.getContextPath()%>/uploads/<%= profilePicture %>" alt="Profile">
                </div>
                <h3><%= name %></h3>
                <a href="editProfile.jsp" class="edit-profile active">
                    <i class="fas fa-user-edit"></i> Edit Profile
                </a>
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
                <a href="../LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <!-- Main Content: Edit Profile -->
        <div class="main-content">
            <h1>Edit Profile</h1>

            <!-- Display success or error messages -->
            <% if (successMessage != null) { %>
                <div class="alert alert-success">✅ <%= successMessage %></div>
            <% } %>

            <% if (errorMessage != null) { %>
                <div class="alert alert-danger">❌ <%= errorMessage %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/UpdateProfileServlet" method="POST" enctype="multipart/form-data">
                <div class="edit-profile-container">
                    <!-- Profile Picture Upload -->
                    <div class="profile-container">
                        <img id="profileImagePreview" src="<%= request.getContextPath() %>/uploads/<%= profilePicture %>" alt="Profile" onclick="document.getElementById('profileUpload').click();">
                        <input type="file" id="profileUpload" name="profilePicture" style="display: none;" accept="image/*" onchange="updateImagePreview(this);">
                        <div class="edit-icon" onclick="document.getElementById('profileUpload').click();">
                            <i class="fas fa-pen"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Name</label>
                        <div class="input-container">
                            <i class="fas fa-user"></i>
                            <input type="text" name="name" value="<%= name %>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <div class="input-container">
                            <i class="fas fa-envelope"></i>
                            <input type="email" name="email" value="<%= email %>" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Phone Number</label>
                        <div class="input-container">
                            <i class="fas fa-phone"></i>
                            <input type="tel" name="phone_number" value="<%= phone %>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Date of Birth</label>
                        <div class="input-container">
                            <i class="fas fa-calendar-alt"></i>
                            <input type="date" name="dob" value="<%= dob %>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Gender</label>
                        <div class="input-container">
                            <i class="fas fa-venus-mars"></i>
                            <select name="gender" required>
                                <option value="Male" <%= gender.equals("Male") ? "selected" : "" %>>Male</option>
                                <option value="Female" <%= gender.equals("Female") ? "selected" : "" %>>Female</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Password (Leave empty if not changing)</label>
                        <div class="input-container">
                            <i class="fas fa-lock"></i>
                            <input type="password" name="password">
                        </div>
                    </div>

                    <button type="submit" class="save-btn">Save</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function updateImagePreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('profileImagePreview').src = e.target.result;
                    document.getElementById('sidebarProfileImage').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>
