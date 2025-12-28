<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    // Session check
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String id = request.getParameter("id");

    if (id == null || id.trim().isEmpty()) {
        response.sendRedirect("manageCourses.jsp?error=Missing+course+ID");
        return;
    }

    try {
        PreparedStatement ps = con.prepareStatement("DELETE FROM courses WHERE id=?");
        ps.setInt(1, Integer.parseInt(id));
        int rowsAffected = ps.executeUpdate();
        ps.close();
        con.close();

        if (rowsAffected > 0) {
            response.sendRedirect("manageCourses.jsp?message=Course+deleted+successfully");
        } else {
            response.sendRedirect("manageCourses.jsp?error=Course+not+found");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageCourses.jsp?error=Error+deleting+course");
    }
%>