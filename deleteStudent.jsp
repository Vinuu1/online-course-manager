<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ include file="db.jsp" %>

<%
    // 1. Security check: Only admin can delete
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp?msg=AccessDenied");
        return;
    }

    // 2. Get the student ID from URL
    String studentId = request.getParameter("id");
    if (studentId == null || studentId.trim().isEmpty()) {
        response.sendRedirect("manageStudents.jsp?msg=NoID");
        return;
    }

    // 3. Try deleting the student
    boolean deleteSuccess = false;
    String errorMessage = "Unknown error"; // default to avoid NullPointerException

    try {
        PreparedStatement ps = con.prepareStatement(
            "DELETE FROM users WHERE id = ? AND role = 'student'"
        );
        ps.setInt(1, Integer.parseInt(studentId));
        int rowsAffected = ps.executeUpdate();
        deleteSuccess = (rowsAffected > 0);

        if (!deleteSuccess) {
            errorMessage = "No student found with the given ID.";
        }

        ps.close();
    } catch (Exception e) {
        errorMessage = e.getMessage();
    } finally {
        if (con != null) try { con.close(); } catch (SQLException e) {}
    }

    // 4. Redirect with status
    if (deleteSuccess) {
        response.sendRedirect("manageStudents.jsp?msg=Deleted");
    } else {
        response.sendRedirect("manageStudents.jsp?msg=Error&error=" + URLEncoder.encode(errorMessage, "UTF-8"));
    }
%>
