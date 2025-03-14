<%-- 
    Document   : report_generation
    Created on : Mar 9, 2025, 3:22:00 PM
    Author     : lmoha
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Report Generation</title>

        <!-- External Styles & Scripts -->
        <link rel="stylesheet" href="dashboard.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
        <!-- Font Awesome (Ensure Proper Loading) -->
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
                    <button id="editProfileBtn" class="edit-profile" onclick="redirectToEditProfile()">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                </div>

                <nav class="menu">
                    <ul>
                        <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
                        <li><a href="./user_management.jsp"><i class="fas fa-users-cog"></i> User Management</a></li>
                        <li><a href="./approve_request.jsp"><i class="fas fa-check-circle"></i> Approve Request</a></li>
                        <li><a href="./report_generation.jsp"><i class="fas fa-file-alt"></i> Report Generation</a></li>
                    </ul>
                </nav>

                <div class="logout-section">
                    <a href="#" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content: Report Generation -->
            <div class="main-content">
                <h1>Report Generation</h1>

                <div class="report-container">
                    <div class="generate-section">
                        <label><b>Generate</b></label>
                        <button class="report-btn"><i class="fas fa-chart-pie"></i> Visitor Statistics</button>
                        <button class="report-btn"><i class="fas fa-file-alt"></i> Requests</button>
                    </div>

                    <div class="chart-container">
                        <canvas id="reportChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript for Chart -->
        <script>
            const ctx = document.getElementById('reportChart').getContext('2d');
            new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: ['Visitor Requests', 'Approved Requests'],
                    datasets: [{
                            data: [18.6, 81.4],
                            backgroundColor: ['#28a745', '#007bff'],
                            hoverOffset: 4
                        }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {position: 'bottom'}
                    }
                }
            });


            function redirectToEditProfile() {
                window.location.href = "dashboard.jsp#editProfile";
            }
        </script>
    </body>
</html>
