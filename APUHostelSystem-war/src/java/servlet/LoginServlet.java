package servlet;

import db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final HashMap<String, Integer> loginAttempts = new HashMap<>();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        // Check if user is blocked due to too many failed attempts
        if (loginAttempts.containsKey(email) && loginAttempts.get(email) >= 6) {
            request.setAttribute("error", "blocked");
            request.getRequestDispatcher("Login/Login.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("Database connection successful!");

            // Hash the entered password to match database storage
            String hashedPassword = hashPassword(password);

            String query = "SELECT * FROM Users WHERE LOWER(email) = LOWER(?) AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            stmt.setString(2, hashedPassword);
            ResultSet rs = stmt.executeQuery();

            if (!rs.isBeforeFirst()) {  // No matching user found
                System.out.println("Login failed: Invalid credentials for email: " + email);
                loginAttempts.put(email, loginAttempts.getOrDefault(email, 0) + 1);

                request.setAttribute("error", "invalid");
                request.getRequestDispatcher("Login/Login.jsp").forward(request, response);
                return;
            }

            if (rs.next()) {
                System.out.println("User found: " + rs.getString("name"));
                System.out.println("User role: " + rs.getString("role"));

                // Reset login attempts
                loginAttempts.remove(email);

                // Store user details in session
                session.setAttribute("user", rs.getString("name"));
                session.setAttribute("role", rs.getString("role"));

                // Redirect user based on role
                switch (rs.getString("role")) {
                    case "Managing Staff":
                        response.sendRedirect(request.getContextPath() + "/ManagingStaff/dashboard.jsp");
                        break;
                    case "Resident":
                        response.sendRedirect(request.getContextPath() + "/Residents/Residents.jsp");
                        break;
                    case "Security Staff":
                        response.sendRedirect(request.getContextPath() + "/SecurityStaff/Security.jsp");
                        break;
                    default:
                        request.setAttribute("error", "role");
                        request.getRequestDispatcher("Login/Login.jsp").forward(request, response);
                }
            } else {
                System.out.println("Login failed: No user found in database.");
                request.setAttribute("error", "invalid");
                request.getRequestDispatcher("Login/Login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Database error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "exception");
            request.getRequestDispatcher("Login/Login.jsp").forward(request, response);
        }
    }

    // Hash Password Using SHA-256 (Same as in SignupServlet)
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
