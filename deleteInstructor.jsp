<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String instructorId = request.getParameter("id");
    if (instructorId == null || instructorId.trim().isEmpty()) {
        response.sendRedirect("manageInstructors.jsp");
        return;
    }

    try {
        PreparedStatement ps = con.prepareStatement(
            "DELETE FROM users WHERE user_id = ? AND LOWER(role) = 'instructor'"
        );
        ps.setInt(1, Integer.parseInt(instructorId));
        ps.executeUpdate();
        ps.close();
    } catch (Exception e) {
        // Optional: Log error or redirect with error flag
        response.sendRedirect("manageInstructors.jsp?error=1");
        return;
    }

    response.sendRedirect("manageInstructors.jsp");
%>