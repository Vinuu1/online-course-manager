<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    if (session.getAttribute("username") == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Statement stmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #dfe9f3, #ffffff);
            display: flex;
        }
        .sidebar {
            width: 220px;
            background: #2c3e50;
            color: white;
            height: 100vh;
            padding-top: 20px;
            position: fixed;
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .sidebar a {
            display: block;
            color: white;
            padding: 12px;
            text-decoration: none;
        }
        .sidebar a:hover {
            background: #34495e;
        }
        .content {
            margin-left: 220px;
            padding: 20px;
            width: 100%;
        }
        .card {
            background: white;
            padding: 20px;
            margin-bottom: 25px;
            border-radius: 8px;
            box-shadow: 0px 2px 5px rgba(0,0,0,0.1);
        }
        h1 {
            margin-bottom: 20px;
        }
        ul {
            list-style: none;
            padding-left: 0;
        }
        li {
            padding: 10px;
            margin-bottom: 10px;
            background: #f9f9f9;
            border-left: 5px solid #3498db;
            border-radius: 4px;
        }
        .session-title {
            font-weight: bold;
            color: #2c3e50;
        }
        .session-time {
            font-size: 0.9em;
            color: #555;
        }
        .session-link {
            display: block;
            margin-top: 5px;
            color: #2980b9;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>Student</h2>
        <a href="student.jsp">Dashboard</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <div class="content">
        <h1>Welcome, <%= session.getAttribute("username") %></h1>

        <!-- Enrolled Courses -->
        <div class="card">
            <h2>Enrolled Courses</h2>
            <ul>
            <%
                try {
                    DatabaseMetaData dbm = con.getMetaData();
                    rs = dbm.getTables(null, null, "enrolled_courses", null);
                    if (!rs.next()) {
                        out.println("<li>No enrolled_courses table found in database.</li>");
                    } else {
                        stmt = con.createStatement();
                        rs = stmt.executeQuery(
                            "SELECT c.course_name FROM enrolled_courses ec " +
                            "JOIN courses c ON ec.course_id = c.id " +
                            "JOIN students s ON ec.student_id = s.id " +
                            "WHERE s.username = '" + session.getAttribute("username") + "'"
                        );

                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                            out.println("<li>" + rs.getString("course_name") + "</li>");
                        }
                        if (!hasData) {
                            out.println("<li>You are not enrolled in any courses.</li>");
                        }
                    }
                } catch (Exception e) {
                    out.println("<li>Error: " + e.getMessage() + "</li>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                }
            %>
            </ul>
        </div>

        <!-- Upcoming Classes -->
        <div class="card">
            <h2>Upcoming Classes</h2>
            <ul>
            <%
                PreparedStatement pst = null;
                ResultSet sessionsRs = null;
                try {
                    String sql = "SELECT session_name, date, time, link FROM sessions WHERE date > CURDATE() OR (date = CURDATE() AND time > CURTIME()) ORDER BY date, time";
                    pst = con.prepareStatement(sql);
                    sessionsRs = pst.executeQuery();

                    boolean hasSessions = false;
                    while (sessionsRs.next()) {
                        hasSessions = true;
                        String sessionName = sessionsRs.getString("session_name");
                        Date sessionDate = sessionsRs.getDate("date");
                        Time sessionTime = sessionsRs.getTime("time");
                        String sessionLink = sessionsRs.getString("link");

                        String formattedDate = new java.text.SimpleDateFormat("dd MMM yyyy").format(sessionDate);
                        String formattedTime = new java.text.SimpleDateFormat("HH:mm").format(sessionTime);
                        String displayLink = (sessionLink != null && !sessionLink.trim().isEmpty())
                                ? "<a class='session-link' href='" + sessionLink + "' target='_blank'>Join Link</a>"
                                : "<span class='session-link'>No link available</span>";

                        out.println("<li><span class='session-title'>" + sessionName + "</span><br>");
                        out.println("<span class='session-time'>" + formattedDate + " @ " + formattedTime + "</span><br>");
                        out.println(displayLink + "</li>");
                    }
                    if (!hasSessions) {
                        out.println("<li>No upcoming sessions available.</li>");
                    }
                } catch (Exception e) {
                    out.println("<li>Error loading sessions: " + e.getMessage() + "</li>");
                } finally {
                    try { if (sessionsRs != null) sessionsRs.close(); } catch (Exception e) {}
                    try { if (pst != null) pst.close(); } catch (Exception e) {}
                    try { if (con != null) con.close(); } catch (Exception e) {}
                }
            %>
            </ul>
        </div>
    </div>
</body>
</html>
