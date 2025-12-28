<%@ page import="java.sql.*" %>
<%! 
    // Declare connection as a page-level variable
    Connection con = null; 
%>
<%
    try {
        Class.forName("com.mysql.jdbc.Driver"); // For MySQL 5.x (your version)
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/project", "root", "root");
           application.setAttribute("dbConnection", con);
    } catch (Exception e) {
        out.println("<div class='error-message'>Database connection failed: " + e.getMessage() + "</div>");
    }
%>
