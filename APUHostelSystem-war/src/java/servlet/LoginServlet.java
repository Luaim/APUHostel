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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        Integer failedAttempts = (Integer) session.getAttribute("failedAttempts");
        Long lockEndTime = (Long) session.getAttribute("lockEndTime");

        // Initialize attempt count
        if (failedAttempts == null) {
            failedAttempts = 0;
        }

        // Check if user is blocked
        if (failedAttempts >= 4) {
            request.setAttribute("error", "blocked");
            request.getRequestDispatcher("Login/Login.jsp").forward(request, response);
            return;
        }

        // Check if countdown is active
        if (lockEndTime != null && System.currentTimeMillis() < lockEndTime) {
            int remainingTime = (int) ((lockEndTime - System.currentTimeMillis()) / 1000);
            request.setAttribute("error", "timeout");
            request.setAttribute("remainingTime", remainingTime);
            request.getRequestDispatcher("Login/Login.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT user_id, name, role, password FROM Users WHERE LOWER(email) = LOWER(?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                boolean isAuthenticated = storedPassword.equals(password) || storedPassword.equals(hashPassword(password));

                if (isAuthenticated) {
                    // Reset failed attempts on success
                    session.removeAttribute("failedAttempts");
                    session.removeAttribute("lockEndTime");

                    session.setAttribute("user_id", rs.getInt("user_id"));
                    session.setAttribute("user_name", rs.getString("name"));
                    session.setAttribute("role", rs.getString("role"));

                    // Redirect based on role
                    String redirectUrl = request.getContextPath();
                    switch (rs.getString("role")) {
                        case "Managing Staff":
                            redirectUrl += "/ManagingStaff/dashboard.jsp";
                            break;
                        case "Resident":
                            redirectUrl += "/Residents/Residents.jsp";
                            break;
                        case "Security Staff":
                            redirectUrl += "/SecurityStaff/Security.jsp";
                            break;
                        default:
                            request.setAttribute("error", "role");
                            request.getRequestDispatcher("Login/Login.jsp").forward(request, response);
                            return;
                    }
                    response.sendRedirect(redirectUrl);
                    return;
                }
            }

            // Login failed
            failedAttempts++;
            session.setAttribute("failedAttempts", failedAttempts);

            if (failedAttempts == 3) {
                // Start 40-second countdown on the 3rd failure
                long lockEndTimeMillis = System.currentTimeMillis() + (40 * 1000);
                session.setAttribute("lockEndTime", lockEndTimeMillis);
                request.setAttribute("error", "timeout");
                request.setAttribute("remainingTime", 40);
            } else if (failedAttempts >= 4) {
                // Block user permanently on the 4th failure
                request.setAttribute("error", "blocked");
            } else {
                // Just show normal invalid message
                request.setAttribute("error", "invalid");
            }

            request.getRequestDispatcher("Login/Login.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "exception");
            request.getRequestDispatcher("Login/Login.jsp").forward(request, response);
        }
    }

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

