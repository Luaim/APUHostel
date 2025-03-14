<%-- 
    Document   : ActivityLogs
    Created on : Mar 10, 2025, 9:24:30 AM
    Author     : lmoha
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Security Staff - Activity Logs</title>

        <!-- External Styles -->
        <link rel="stylesheet" href="Security.css">
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
                    <a href="Security.jsp" class="edit-profile"><i class="fas fa-user-edit"></i> Edit Profile</a>
                </div>

                <nav class="menu">
                    <ul>
                        <li><a href="VisitorVerification.jsp"><i class="fas fa-id-card"></i> Visitor Verification</a></li>
                        <li class="active"><a href="ActivityLogs.jsp"><i class="fas fa-book"></i> Activity Logs</a></li>
                    </ul>
                </nav>

                <div class="logout-section">
                    <a href="#" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <h1 class="page-title">Activity Logs</h1>

                <!-- Search Bar -->
                <div class="search-container">
                    <input type="text" id="search-input" placeholder="Search by Name, Email, or Code..." onkeyup="searchTable()">
                    <button class="search-btn"><i class="fas fa-search"></i> Search</button>
                </div>

                <div class="activity-logs-container">
                    <!-- Table -->
                    <table class="logs-table">
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
                        <tbody id="logs-table-body">
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
                                <td>Completed</td>
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
                                <td>Completed</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            function searchTable() {
                let input = document.getElementById("search-input").value.toLowerCase();
                let rows = document.querySelectorAll("#logs-table-body tr");

                rows.forEach(row => {
                    let text = row.innerText.toLowerCase();
                    row.style.display = text.includes(input) ? "" : "none";
                });
            }
        </script>
    </body>
</html>

