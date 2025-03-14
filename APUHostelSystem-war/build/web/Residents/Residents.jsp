<%-- 
    Document   : Residents
    Created on : Mar 10, 2025
    Author     : lmoha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Residents - Visitor Request</title>

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

            <!-- Visitor Request Section -->
            <div class="main-content">
                <h1 class="page-title">Visitor Request</h1>

                <div class="visitor-request-container">
                    <form class="visitor-request-form">
                        <div class="form-group">
                            <label>Name</label>
                            <div class="input-container">
                                <i class="fas fa-user"></i>
                                <input type="text" placeholder="Enter visitor's name">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <div class="input-container">
                                <i class="fas fa-envelope"></i>
                                <input type="email" placeholder="Enter visitor's email">
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
                            <label>ID Passport</label>
                            <div class="input-container">
                                <i class="fas fa-id-card"></i>
                                <input type="text" placeholder="Enter ID/Passport">
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
                            <label>Visitor’s Purpose of Visit</label>
                            <div class="input-container">
                                <i class="fas fa-clipboard-list"></i>
                                <select>
                                    <option>Friend Visit</option>
                                    <option>Family</option>
                                    <option>Official</option>
                                    <option>Delivery</option>
                                    <option>Others</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group-row">
                            <div class="form-group">
                                <label>Visit Date</label>
                                <div class="input-container">
                                    <i class="fas fa-calendar-alt"></i>
                                    <input type="date">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Time</label>
                                <div class="input-container">
                                    <i class="fas fa-clock"></i>
                                    <input type="time">
                                </div>
                            </div>
                        </div>

                        <div class="verification-container">
                            <label>Auto Verification Code</label>
                            <div class="input-container">
                                <i class="fas fa-key"></i>
                                <input type="text" placeholder="Enter code" class="verification-input">
                            </div>
                        </div>

                        <button class="submit-btn">Send</button>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
