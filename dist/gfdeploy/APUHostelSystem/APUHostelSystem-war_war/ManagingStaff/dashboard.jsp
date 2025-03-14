<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Force Font Awesome to Load Properly -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <title>Resident Dashboard</title>

        <!-- External Styles & Scripts -->
        <link rel="stylesheet" href="dashboard.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    </head>
    <body>
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="profile-section">
                    <div class="profile-image">
                        <img src="user_profile.jpg" alt="Profile">
                    </div>
                    <h3>Ahmed</h3>
                    <button id="editProfileBtn" class="edit-profile" onclick="redirectToEditProfile()">
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
                    <a href="#" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content: Dashboard -->
            <div class="main-content" id="dashboardSection">
                <h1>Dashboard</h1>
                <p class="overview-text">Overview of the system status</p>

                <div class="stats-container">
                    <div class="stat-box">
                        <h3>Number of Active Residents</h3>
                        <div class="stat-value">350</div>
                    </div>

                    <div class="stat-box">
                        <h3>Pending Visitor Requests</h3>
                        <div class="stat-value">50</div>
                    </div>
                </div>

                <div class="activity-overview">
                    <h2>Activity Overview</h2>
                    <div class="chart-container">
                        <canvas id="activityChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Main Content: Edit Profile -->
            <div class="main-content" id="editProfileSection" style="display: none;">
                <h1>Edit Profile</h1>
                <div class="edit-profile-container">

                    <!-- Updated Profile Image with Edit Option -->
                    <div class="edit-profile-image">
                        <div class="profile-container">
                            <img src="user_profile.jpg" alt="Profile">
                            <button class="edit-icon"><i class="fas fa-pen"></i></button>
                        </div>
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



            <script>
                // Pie chart initialization (Updated for responsiveness)
                const ctx = document.getElementById('activityChart').getContext('2d');
                new Chart(ctx, {
                    type: 'pie',
                    data: {
                        labels: ['Pending Visitor Requests', 'Active Residents'],
                        datasets: [{
                                data: [50, 350],
                                backgroundColor: ['#FF6384', '#36A2EB'],
                                hoverOffset: 4
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false, // Allow it to resize properly
                        plugins: {
                            legend: {position: 'bottom'}
                        }
                    }
                });


                // Toggle between Dashboard and Edit Profile
                document.getElementById('editProfileBtn').addEventListener('click', function () {
                    document.getElementById('dashboardSection').style.display = 'none';
                    document.getElementById('editProfileSection').style.display = 'block';
                });

                document.getElementById('dashboardBtn').addEventListener('click', function () {
                    document.getElementById('dashboardSection').style.display = 'block';
                    document.getElementById('editProfileSection').style.display = 'none';
                });



                // for the password to show and hide the eye taggle

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

            <script>
                // Check if the URL contains #editProfile, then open Edit Profile section
                if (window.location.hash === "#editProfile") {
                    document.getElementById('dashboardSection').style.display = 'none';
                    document.getElementById('editProfileSection').style.display = 'block';
                }

                // Toggle between Dashboard and Edit Profile inside dashboard.jsp
                document.getElementById('editProfileBtn').addEventListener('click', function () {
                    window.location.href = "dashboard.jsp#editProfile";
                });

                document.getElementById('dashboardBtn').addEventListener('click', function () {
                    window.location.href = "dashboard.jsp";
                });
            </script>


    </body>
</html>
