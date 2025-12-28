<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("username") == null || !"instructor".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer instructorId = (Integer) session.getAttribute("instructor_id");
    if (instructorId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String sessionName = request.getParameter("session_name");
    String date = request.getParameter("date");
    String time = request.getParameter("time");

    boolean valid = sessionName != null && date != null && time != null &&
                    !sessionName.trim().isEmpty() && !date.trim().isEmpty() && !time.trim().isEmpty();

    if (!valid) {
        response.sendRedirect("planSession.jsp?error=missing_fields");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    boolean success = false;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "root");

        ps = con.prepareStatement(
            "INSERT INTO sessions (session_name, date, time, instructor_id) VALUES (?, ?, ?, ?), link"
        );
        ps.setString(1, sessionName);
        ps.setString(2, date);
        ps.setString(3, time);
        ps.setInt(4, instructorId);

        int rows = ps.executeUpdate();
        success = rows > 0;

    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
%>
<%
    if (success) {
        response.sendRedirect("planSession.jsp?status=success");
    } else {
        response.sendRedirect("planSession.jsp?status=failed");
    }
%>

