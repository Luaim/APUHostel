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

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("user_id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone_number");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                response.getWriter().write("<p style='color: red;'>Database connection failed!</p>");
                return;
            }

            // Update query
            String sql = "UPDATE Users SET name=?, email=?, phone_number=?, dob=?, gender=?, password=? WHERE user_id=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, phoneNumber);
            pstmt.setString(4, dob);
            pstmt.setString(5, gender);
            pstmt.setString(6, password);
            pstmt.setInt(7, userId);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.getWriter().write("<p style='color: green;'>Profile updated successfully!</p>");
            } else {
                response.getWriter().write("<p style='color: red;'>Profile update failed. Try again!</p>");
            }

            pstmt.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<p style='color: red;'>Error updating profile!</p>");
        }
    }
}
