<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    int activeResidents = 0;
    int pendingRequests = 0;

    try {
        String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=APUHostelSystem;integratedSecurity=true;encrypt=true;trustServerCertificate=true;";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        Connection conn = DriverManager.getConnection(DB_URL);

        // Get the number of active residents
        String residentSQL = "SELECT COUNT(*) FROM Users";
        PreparedStatement pstmtResidents = conn.prepareStatement(residentSQL);
        ResultSet rsResidents = pstmtResidents.executeQuery();
        if (rsResidents.next()) {
            activeResidents = rsResidents.getInt(1);
        }
        rsResidents.close();
        pstmtResidents.close();

        // Get the number of pending visitor requests
        String visitorSQL = "SELECT COUNT(*) FROM Visitor_Requests WHERE status='Pending'";
        PreparedStatement pstmtRequests = conn.prepareStatement(visitorSQL);
        ResultSet rsRequests = pstmtRequests.executeQuery();
        if (rsRequests.next()) {
            pendingRequests = rsRequests.getInt(1);
        }
        rsRequests.close();
        pstmtRequests.close();

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
        <title>Resident Dashboard</title>

        <!-- External Styles & Scripts -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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
                    <button id="editProfileBtn" class="edit-profile" 
                            onclick="location.href = '/APUHostelSystem-war/ManagingStaff/EditProfile.jsp'">
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
                   <a href="LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content: Dashboard -->
            <div class="main-content" id="dashboardSection">
                <h1>Dashboard</h1>
                <p class="overview-text">Overview of the system status</p>

                <div class="stats-container">
                    <div class="stat-box">
                        <h3>Number of Active Residents</h3>
                        <div class="stat-value"><%= activeResidents%></div>
                    </div>

                    <div class="stat-box">
                        <h3>Pending Visitor Requests</h3>
                        <div class="stat-value"><%= pendingRequests%></div>
                    </div>
                </div>

                <div class="activity-overview">
                    <h2>Activity Overview</h2>
                    <div class="chart-container">
                        <canvas id="activityChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Pie chart initialization with dynamic data
            const ctx = document.getElementById('activityChart').getContext('2d');
            new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: ['Pending Visitor Requests', 'Active Residents'],
                    datasets: [{
                            data: [<%= pendingRequests%>, <%= activeResidents%>],
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
        </script>

    </body>
</html>
