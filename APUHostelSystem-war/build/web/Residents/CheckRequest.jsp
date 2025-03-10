<%-- 
    Document   : CheckRequest
    Created on : Mar 10, 2025, 12:59:01 PM
    Author     : lmoha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Residents - Check Request</title>

        <!-- External Styles & Scripts -->
        <link rel="stylesheet" href="Residents.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
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
                    <button id="editProfileBtn" class="edit-profile" onclick="location.href = 'EditProfile.jsp'">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>

                </div>

                <nav class="menu">
                    <ul>
                        <li><a href="Residents.jsp" class="active"><i class="fas fa-user-check"></i> Visitor Request</a></li>
                        <li><a href="CheckRequest.jsp"><i class="fas fa-list"></i> Check Request</a></li>
                    </ul>
                </nav>


                <div class="logout-section">
                    <a href="#" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <h1 class="page-title">Check Request</h1>

                <div class="check-request-container">
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
                                <th>Status</th>
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
                                <td>Approved</td>
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
                                <td>Pending</td>
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
                                <td>Pending</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="action-buttons">
                        <button class="update-btn"><i class="fas fa-sync-alt"></i> Update</button>
                        <button class="delete-btn"><i class="fas fa-times"></i> Delete</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

