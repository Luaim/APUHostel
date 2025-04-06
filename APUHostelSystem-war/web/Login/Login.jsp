<%-- 
    Document   : Login
    Created on : Feb 27, 2025, 9:08:13 PM
    Author     : Luai
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>APU Hostel</title>

    <!-- Font Awesome for Eye Icon -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Login/Login.css">

    <script>
        function toggleForms(showSignUp) {
            var loginForm = document.getElementById("login-form");
            var signupForm = document.getElementById("signup-form");
            var loginButton = document.getElementById("log-in");
            var signupButton = document.getElementById("sign-up");

            if (showSignUp) {
                loginForm.style.display = "none";
                signupForm.style.display = "block";
                signupButton.classList.add("active");
                loginButton.classList.remove("active");
            } else {
                loginForm.style.display = "block";
                signupForm.style.display = "none";
                loginButton.classList.add("active");
                signupButton.classList.remove("active");
            }
        }

        function togglePasswordVisibility(passwordId, iconId) {
            var password = document.getElementById(passwordId);
            var icon = document.getElementById(iconId);
            if (password.type === "password") {
                password.type = "text";
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            } else {
                password.type = "password";
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            }
        }

        function validatePhoneNumber(input) {
            input.value = input.value.replace(/[^0-9]/g, '');
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>APU Hostel</h1>
            <p>Explore More. Experience Life.</p>
        </div>

        <div class="auth-buttons">
            <button class="button sign-up" id="sign-up" onclick="toggleForms(true)">Sign Up</button>
            <button class="button log-in" id="log-in" onclick="toggleForms(false)">Log In</button>
        </div>

        <!-- Display Signup Messages (Stored in Session) -->
        <% if (session.getAttribute("signupMessage") != null) { %>
        <div class="error-message">
            <p style="<%= session.getAttribute("signupMessageType").equals("success") ? "color: green;" : "color: red;" %>">
                <%= session.getAttribute("signupMessage") %>
            </p>
        </div>
        <% 
            session.removeAttribute("signupMessage"); 
            session.removeAttribute("signupMessageType");
        } %>

        <!-- Display Login Error Messages -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">
            <% if (request.getAttribute("error").equals("invalid")) { %>
            <p style="color: red;">❌ Invalid email or password. Please try again.</p>

            <% } else if (request.getAttribute("error").equals("timeout")) { 
                int remainingTime = (Integer) request.getAttribute("remainingTime"); %>
            <p style="color: orange;">⚠ Too many failed attempts. Wait <span id="countdown"><%= remainingTime %></span> seconds before trying again.</p>

            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    let timeLeft = <%= remainingTime %>;
                    const countdownElem = document.getElementById("countdown");
                    const emailInput = document.querySelector("input[name='email']");
                    const passwordInput = document.querySelector("input[name='password']");
                    const loginButton = document.querySelector("button[type='submit']");

                    emailInput.disabled = true;
                    passwordInput.disabled = true;
                    loginButton.disabled = true;

                    const countdown = setInterval(() => {
                        if (timeLeft > 0) {
                            timeLeft--;
                            countdownElem.innerText = timeLeft;
                        } else {
                            clearInterval(countdown);
                            emailInput.disabled = false;
                            passwordInput.disabled = false;
                            loginButton.disabled = false;
                            document.querySelector(".error-message").innerHTML = 
                                "<p style='color: green;'>✅ You can now enter your email and password. If you enter it wrong again, you will be permanently blocked.</p>";
                        }
                    }, 1000);
                });
            </script>

            <% } else if (request.getAttribute("error").equals("blocked")) { %>
            <p style="color: red;">🚫 Too many failed attempts. You are permanently blocked.</p>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    document.querySelector("input[name='email']").disabled = true;
                    document.querySelector("input[name='password']").disabled = true;
                    document.querySelector("button[type='submit']").disabled = true;
                });
            </script>

            <% } else if (request.getAttribute("error").equals("exception")) { %>
            <p style="color: red;">❌ An error occurred. Please try again later.</p>
            <% } %>
        </div>
        <% } %>

        <!-- Login Form -->
        <div class="form-container" id="login-form" style="display:none;">
            <h2>Login</h2>
            <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
                <input type="email" name="email" placeholder="Email" required>
                <div class="password-container">
                    <input type="password" id="login-password" name="password" placeholder="Password" required>
                    <span onclick="togglePasswordVisibility('login-password', 'login-icon')" class="toggle-password">
                        <i class="fas fa-eye-slash" id="login-icon"></i>
                    </span>
                </div>
                <button type="submit" class="button submit">Login</button>
            </form>
        </div>

        <!-- Signup Form -->
        <div class="form-container" id="signup-form">
            <h2>Join Us</h2>
            <form action="${pageContext.request.contextPath}/SignupServlet" method="POST">
                <input type="text" name="name" placeholder="Name" required>
                <input type="email" name="email" placeholder="Email" required>
                <input type="tel" name="phone_number" placeholder="Phone Number" required oninput="validatePhoneNumber(this)">

                <select name="gender" required>
                    <option value="">Select Gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                </select>

                <div class="password-container">
                    <input type="password" id="signup-password" name="password" placeholder="Password" required>
                    <span onclick="togglePasswordVisibility('signup-password', 'signup-icon')" class="toggle-password">
                        <i class="fas fa-eye-slash" id="signup-icon"></i>
                    </span>
                </div>

                <div class="password-container">
                    <input type="password" id="confirm-password" name="confirm_password" placeholder="Confirm Password" required>
                    <span onclick="togglePasswordVisibility('confirm-password', 'confirm-icon')" class="toggle-password">
                        <i class="fas fa-eye-slash" id="confirm-icon"></i>
                    </span>
                </div>

                <button type="submit" class="button submit">Sign Up</button>
            </form>
        </div>
    </div>
</body>
</html>
