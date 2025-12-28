<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String sessionId = request.getParameter("id");
    if (sessionId == null || sessionId.trim().isEmpty()) {
        response.sendRedirect("manageCourses.jsp");
        return;
    }

    try {
        PreparedStatement ps = con.prepareStatement("DELETE FROM sessions WHERE id = ?");
        ps.setInt(1, Integer.parseInt(sessionId));
        int rowsAffected = ps.executeUpdate();
        ps.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error deleting session: " + e.getMessage() + "</p>");
    } finally {
        if (con != null) try { con.close(); } catch (SQLException e) {}
    }

    response.sendRedirect("manageCourses.jsp");
%>