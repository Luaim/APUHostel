package servlet;

import db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/SignupServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10, 
    maxRequestSize = 1024 * 1024 * 50 
)
public class SignupServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads";

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
            request.setAttribute("signupMessage", "⚠ Please fill in all required fields.");
            request.setAttribute("signupMessageType", "error");
            request.getRequestDispatcher("/Login/Login.jsp").forward(request, response);
            return;
        }

        // Check if password and confirm password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("signupMessage", "⚠ Passwords do not match. Please try again.");
            request.setAttribute("signupMessageType", "error");
            request.getRequestDispatcher("/Login/Login.jsp").forward(request, response);
            return;
        }

        // Hash the password before storing it
        String hashedPassword = hashPassword(password);
        String role = "Resident"; // Default role

        // Handle profile image upload (Optional)
        Part filePart = request.getPart("profile_picture");
        String fileName = (filePart != null && filePart.getSize() > 0) ? Paths.get(filePart.getSubmittedFileName()).getFileName().toString() : "default.png";

        // File upload path
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        // Save file only if a file was uploaded
        if (filePart != null && filePart.getSize() > 0) {
            filePart.write(uploadPath + File.separator + fileName);
        }

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                request.setAttribute("signupMessage", "❌ Database connection failed. Try again later.");
                request.setAttribute("signupMessageType", "error");
                request.getRequestDispatcher("/Login/Login.jsp").forward(request, response);
                return;
            }

            // Check if email already exists
            String checkUserQuery = "SELECT email FROM Users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkUserQuery);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("signupMessage", "🚫 Account already exists, please login.");
                request.setAttribute("signupMessageType", "error");
                request.getRequestDispatcher("/Login/Login.jsp").forward(request, response);
                return;
            }

            // Insert user into Users table
            String insertUserQuery = "INSERT INTO Users (name, email, phone_number, gender, password, role, profile_picture) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement insertUserStmt = conn.prepareStatement(insertUserQuery);
            insertUserStmt.setString(1, name);
            insertUserStmt.setString(2, email);
            insertUserStmt.setString(3, phone);
            insertUserStmt.setString(4, gender);
            insertUserStmt.setString(5, hashedPassword);
            insertUserStmt.setString(6, role);
            insertUserStmt.setString(7, fileName);

            int affectedRows = insertUserStmt.executeUpdate();
            if (affectedRows > 0) {
                request.setAttribute("signupMessage", "✅ Account created successfully! You can now log in.");
                request.setAttribute("signupMessageType", "success");
            } else {
                request.setAttribute("signupMessage", "❌ Signup failed, please try again.");
                request.setAttribute("signupMessageType", "error");
            }
            request.getRequestDispatcher("/Login/Login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("signupMessage", "❌ Signup failed due to an error.");
            request.setAttribute("signupMessageType", "error");
            request.getRequestDispatcher("/Login/Login.jsp").forward(request, response);
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
