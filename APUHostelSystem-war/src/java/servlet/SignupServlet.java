package servlet;

import db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form inputs
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone_number");
        String gender = request.getParameter("gender");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Ensure all required fields are filled
        if (name == null || email == null || phone == null || gender == null || password == null || confirmPassword == null ||
            name.isEmpty() || email.isEmpty() || phone.isEmpty() || gender.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            request.getSession().setAttribute("signupMessage", "⚠ Please fill in all required fields.");
            request.getSession().setAttribute("signupMessageType", "error");
            response.sendRedirect("Login/Login.jsp");
            return;
        }

        // Check if password and confirm password match
        if (!password.equals(confirmPassword)) {
            request.getSession().setAttribute("signupMessage", "⚠ Passwords do not match. Please try again.");
            request.getSession().setAttribute("signupMessageType", "error");
            response.sendRedirect("Login/Login.jsp");
            return;
        }

        // Hash the password before storing it
        String hashedPassword = hashPassword(password);
        String role = "Resident"; // Default role
        String defaultProfilePicture = "user1.png"; // Default profile picture

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                request.getSession().setAttribute("signupMessage", "❌ Database connection failed. Try again later.");
                request.getSession().setAttribute("signupMessageType", "error");
                response.sendRedirect("Login/Login.jsp");
                return;
            }

            // Check if email already exists
            String checkUserQuery = "SELECT email FROM Users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkUserQuery);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.getSession().setAttribute("signupMessage", "🚫 Account already exists, please login.");
                request.getSession().setAttribute("signupMessageType", "error");
                response.sendRedirect("Login/Login.jsp");
                return;
            }

            // Insert user into Users table with default profile picture
            String insertUserQuery = "INSERT INTO Users (name, email, phone_number, gender, password, role, profile_picture) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement insertUserStmt = conn.prepareStatement(insertUserQuery);
            insertUserStmt.setString(1, name);
            insertUserStmt.setString(2, email);
            insertUserStmt.setString(3, phone);
            insertUserStmt.setString(4, gender);
            insertUserStmt.setString(5, hashedPassword);
            insertUserStmt.setString(6, role);
            insertUserStmt.setString(7, defaultProfilePicture); // Saving default profile picture

            int affectedRows = insertUserStmt.executeUpdate();
            if (affectedRows > 0) {
                request.getSession().setAttribute("signupMessage", "✅ Account created successfully! You can now log in.");
                request.getSession().setAttribute("signupMessageType", "success");
            } else {
                request.getSession().setAttribute("signupMessage", "❌ Signup failed, please try again.");
                request.getSession().setAttribute("signupMessageType", "error");
            }
            response.sendRedirect("Login/Login.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("signupMessage", "❌ Signup failed due to an error.");
            request.getSession().setAttribute("signupMessageType", "error");
            response.sendRedirect("Login/Login.jsp");
        }
    }

    // Hash Password Using SHA-256
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashedBytes) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
}
