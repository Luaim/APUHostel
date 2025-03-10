<%-- 
    Document   : VisitorVerification
    Created on : Mar 9, 2025, 9:58:31 PM
    Author     : lmoha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Visitor Verification</title>

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
                    <button onclick="location.href='Security.jsp'" class="edit-profile">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                </div>

                <nav class="menu">
                    <ul>
                        <li class="active"><a href="VisitorVerification.jsp"><i class="fas fa-id-card"></i> Visitor Verification</a></li>
                        <li><a href="ActivityLogs.jsp"><i class="fas fa-book"></i> Activity Logs</a></li>
                    </ul>
                </nav>

                <div class="logout-section">
                    <a href="#" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Moved the title OUT of the card -->
                <h1 class="page-title">Visitor Verification</h1>

                <div class="visitor-verification-container">
                    <div class="search-bar">
                        <label>Visitor Verification Code</label>
                        <input type="text" placeholder="Enter Code">
                        <button class="find-btn">Find</button>
                        <button class="complete-btn">Mark as Completed</button>
                    </div>

                    <div class="table-container">
                        <table class="verification-table">
                            <thead>
                                <tr>
                                    <th>NO.</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone Number</th>
                                    <th>Gender</th>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Purpose</th>
                                    <th>Code</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1.</td>
                                    <td>Ali Ahammed</td>
                                    <td>ali@gmail.com</td>
                                    <td>0115985621</td>
                                    <td>M</td>
                                    <td>01156847</td>
                                    <td>12/06/2025</td>
                                    <td>03:30 PM</td>
                                    <td>Friend Visit</td>
                                    <td>4535</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
