<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="db.jsp" %>

<%
    // Retrieve login credentials
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    // Get database connection from application context
    Connection con = (Connection) application.getAttribute("dbConnection");
    
    if (con == null) {
        response.sendRedirect("login.jsp?error=" +
            java.net.URLEncoder.encode("Database connection error. Please try again later.", "UTF-8"));
        return;
    }
    
    try {
        // Prepare SQL query to fetch user details - updated to match your schema
        String query = "SELECT u.id, u.role, " +
                       "i.id AS instructor_id, s.id AS student_id " +
                       "FROM users u " +
                       "LEFT JOIN instructors i ON u.id = i.user_id " +
                       "LEFT JOIN students s ON u.id = s.user_id " +
                       "WHERE u.username = ? AND u.password = ?";
        
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, username);
        ps.setString(2, password);
        
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            // Valid credentials - set session attributes
            String role = rs.getString("role");
            session.setAttribute("user_id", rs.getInt("id"));
            session.setAttribute("username", username);
            session.setAttribute("role", role);
            
            // Redirect based on role
            if ("admin".equals(role)) {
                response.sendRedirect("admin.jsp");
            } else if ("instructor".equals(role)) {
                session.setAttribute("instructor_id", rs.getInt("instructor_id"));
                response.sendRedirect("instructor.jsp");
            } else if ("student".equals(role)) {
                session.setAttribute("student_id", rs.getInt("student_id"));
                response.sendRedirect("student.jsp");
            } else {
                response.sendRedirect("login.jsp?error=" +
                    java.net.URLEncoder.encode("Unauthorized role. Contact administrator.", "UTF-8"));
            }
        } else {
            response.sendRedirect("login.jsp?error=" +
                java.net.URLEncoder.encode("Invalid username or password.", "UTF-8"));
        }
        
        // Clean up resources
        rs.close();
        ps.close();
    } catch (SQLException e) {
        response.sendRedirect("login.jsp?error=" +
            java.net.URLEncoder.encode("Database error: " + e.getMessage(), "UTF-8"));
    }
%>