<%-- 
    Document   : report_generation
    Created on : Mar 9, 2025, 3:22:00 PM
    Author     : lmoha
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    int maleCount = 0, femaleCount = 0;
    int pendingCount = 0, approvedCount = 0, rejectedCount = 0;

    try {
        String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=APUHostelSystem;integratedSecurity=true;encrypt=true;trustServerCertificate=true;";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(DB_URL);

        // Get Gender Data (Users Table)
        String genderQuery = "SELECT gender, COUNT(*) as count FROM Users GROUP BY gender";
        pstmt = conn.prepareStatement(genderQuery);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            if (rs.getString("gender").equalsIgnoreCase("Male")) {
                maleCount = rs.getInt("count");
            } else if (rs.getString("gender").equalsIgnoreCase("Female")) {
                femaleCount = rs.getInt("count");
            }
        }
        rs.close();
        pstmt.close();

        // Get Request Status Data (Visitor_Requests Table)
        String statusQuery = "SELECT status, COUNT(*) as count FROM Visitor_Requests GROUP BY status";
        pstmt = conn.prepareStatement(statusQuery);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            String status = rs.getString("status");
            if (status.equalsIgnoreCase("Pending")) {
                pendingCount = rs.getInt("count");
            } else if (status.equalsIgnoreCase("Approved")) {
                approvedCount = rs.getInt("count");
            } else if (status.equalsIgnoreCase("Rejected")) {
                rejectedCount = rs.getInt("count");
            }
        }
        rs.close();
        pstmt.close();

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (conn != null) conn.close(); } catch (SQLException e) { }
    }
%>

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
                    <a href="LogoutServlet" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content: Report Generation -->
            <div class="main-content">
                <h1>Report Generation</h1>

                <div class="report-container">
                    <div class="generate-section">
                        <label><b>Generate</b></label>
                        <button class="report-btn" onclick="generateGenderChart()"><i class="fas fa-chart-pie"></i> Gender </button>
                        <button class="report-btn" onclick="generateRequestChart()"><i class="fas fa-file-alt"></i> Requests</button>
                    </div>

                    <div class="chart-container">
                        <canvas id="reportChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript for Chart -->
        <script>
            let chartInstance;
            const ctx = document.getElementById('reportChart').getContext('2d');

            function generateGenderChart() {
                const data = {
                    labels: ["Male", "Female"],
                    datasets: [{
                        data: [<%= maleCount %>, <%= femaleCount %>],
                        backgroundColor: ['#007bff', '#ff6384'],
                        hoverOffset: 4
                    }]
                };
                updateChart(data, "Users Gender Distribution");
            }

            function generateRequestChart() {
                const data = {
                    labels: ["Pending", "Approved", "Rejected"],
                    datasets: [{
                        data: [<%= pendingCount %>, <%= approvedCount %>, <%= rejectedCount %>],
                        backgroundColor: ['#ffc107', '#28a745', '#dc3545'],
                        hoverOffset: 4
                    }]
                };
                updateChart(data, "Visitor Requests Status");
            }

            function updateChart(data, title) {
                if (chartInstance) {
                    chartInstance.destroy();
                }
                chartInstance = new Chart(ctx, {
                    type: 'pie',
                    data: data,
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { position: 'bottom' },
                            title: {
                                display: true,
                                text: title
                            }
                        }
                    }
                });
            }

            function redirectToEditProfile() {
                window.location.href = "dashboard.jsp#editProfile";
            }
        </script>
    </body>
</html>
