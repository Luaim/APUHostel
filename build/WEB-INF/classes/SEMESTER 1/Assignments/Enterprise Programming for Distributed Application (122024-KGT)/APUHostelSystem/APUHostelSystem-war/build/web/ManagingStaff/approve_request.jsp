<%-- 
    Document   : approve_request
    Created on : Mar 9, 2025, 3:14:26 PM
    Author     : lmoha
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Approve Request</title>

        <!-- External Styles & Scripts -->
        <link rel="stylesheet" href="dashboard.css">
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

            <!-- Main Content: Approve Request -->
            <div class="main-content">
                <h1>Approve Request</h1>

                <div class="approve-request-container">
                    <div class="search-bar">
                        <label for="search"><b>Search</b></label>
                        <div class="search-input-container">
                            <input type="text" id="search" placeholder="Search...">
                            <i class="fas fa-search search-icon"></i>
                        </div>
                    </div>

                    <div class="table-container">
                        <table class="request-table">
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
                                <tr>
                                    <td>2.</td>
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
                                <tr>
                                    <td>3.</td>
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

                    <div class="buttons-container">
                        <button class="approve-btn"><i class="fas fa-user-check"></i> Approve</button>
                        <button class="reject-btn"><i class="fas fa-user-times"></i> Reject</button>
                    </div>

                    <script>
                        function redirectToEditProfile() {
                            window.location.href = "dashboard.jsp#editProfile";
                        }
                    </script>
                </div>
            </div>
        </div>
    </body>
</html>

