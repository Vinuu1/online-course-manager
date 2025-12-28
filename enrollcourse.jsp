<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String courseId = request.getParameter("course_id");
    String username = request.getParameter("username");

    if (courseId != null && username != null) {
        try {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO enrollments (username, course_id, status) VALUES (?, ?, 'Pending')"
            );
            ps.setString(1, username);
            ps.setInt(2, Integer.parseInt(courseId));

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("student.jsp?msg=Application+sent");
            } else {
                response.sendRedirect("student.jsp?error=Failed+to+send");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("student.jsp?error=Database+error");
        }
    } else {
        response.sendRedirect("student.jsp?error=Invalid+data");
    }
%>
