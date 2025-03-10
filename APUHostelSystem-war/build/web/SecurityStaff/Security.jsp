<%-- 
    Document   : Security
    Created on : Mar 9, 2025, 9:01:02 PM
    Author     : lmoha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Security Staff - Edit Profile</title>

        <!-- External Styles & Scripts -->
        <link rel="stylesheet" href="Security.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <!-- Font Awesome for Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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
                    <button id="editProfileBtn" class="edit-profile"><i class="fas fa-user-edit"></i> Edit Profile</button>
                </div>

                <nav class="menu">
                    <ul>
                        <li><a href="VisitorVerification.jsp"><i class="fas fa-id-card"></i> Visitor Verification</a></li>
                        <li><a href="ActivityLogs.jsp"><i class="fas fa-book"></i> Activity Logs</a></li>
                    </ul>
                </nav>

                <div class="logout-section">
                    <a href="#" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content: Edit Profile -->
            <div class="main-content">
                <h1 class="page-title">Edit Profile</h1>
                <div class="edit-profile-container">

                    <!-- Profile Image Section -->
                    <div class="profile-container">
                        <img src="profile_placeholder.png" alt="Profile">
                        <button class="edit-icon"><i class="fas fa-pen"></i></button>
                    </div>

                    <form class="edit-profile-form">
                        <div class="form-group">
                            <label>Name</label>
                            <div class="input-container">
                                <i class="fas fa-user"></i>
                                <input type="text" placeholder="Enter your name">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <div class="input-container">
                                <i class="fas fa-envelope"></i>
                                <input type="email" placeholder="Enter your email">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Phone Number</label>
                            <div class="input-container">
                                <i class="fas fa-phone"></i>
                                <input type="text" placeholder="Enter phone number">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Date of Birth</label>
                            <div class="input-container">
                                <i class="fas fa-calendar-alt"></i>
                                <input type="date">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Gender</label>
                            <div class="input-container">
                                <i class="fas fa-venus-mars"></i>
                                <select>
                                    <option>Male</option>
                                    <option>Female</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <div class="input-container">
                                <i class="fas fa-lock"></i>
                                <input type="password" id="password-field" placeholder="Enter new password">
                                <i class="fas fa-eye toggle-password" id="toggle-password"></i>
                            </div>
                        </div>

                        <button class="save-btn">Save</button>
                    </form>
                </div>
            </div>
        </div>

        <script>
            // Password show/hide toggle
            document.getElementById('toggle-password').addEventListener('click', function () {
                var passwordField = document.getElementById('password-field');
                var icon = this;

                if (passwordField.type === "password") {
                    passwordField.type = "text";
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    passwordField.type = "password";
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            });
        </script>
    </body>
</html>
