<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("username") == null || !"instructor".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer instructorId = (Integer) session.getAttribute("instructor_id");
    if (instructorId == null) {
        out.println("<p class='error'>Instructor ID not found in session.</p>");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "root");

        ps = con.prepareStatement("SELECT id, session_name, date, time FROM sessions WHERE instructor_id = ?");
        ps.setInt(1, instructorId);
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Sessions</title>
    <meta charset="UTF-8">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #f8f9fa, #c9d6ff);
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
            font-size: 16px;
        }
        .sidebar a:hover {
            background: #34495e;
        }
        .content {
            margin-left: 220px;
            padding: 30px;
            flex: 1;
        }
        h1 {
            font-size: 24px;
            color: #2c3e50;
            margin-bottom: 20px;
        }
        .session-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .session-table th, .session-table td {
            padding: 14px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .session-table th {
            background-color: #f0f0f0;
            color: #555;
            text-transform: uppercase;
            font-size: 14px;
        }
        .session-table tr:hover {
            background-color: #f9f9f9;
        }
        .error {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Instructor</h2>
    <a href="instructor.jsp">Dashboard</a>
    <a href="planSession.jsp">Plan Live Session</a>
    <a href="mySessions.jsp">My Sessions</a>
    <a href="logout.jsp">Logout</a>
</div>

<div class="content">
    <h1>My Scheduled Sessions</h1>
    <table class="session-table">
        <tr>
            <th>ID</th>
            <th>Session Name</th>
            <th>Date</th>
            <th>Time</th>
        </tr>
        <%
            boolean hasSessions = false;
            while (rs.next()) {
                hasSessions = true;
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("session_name") %></td>
            <td><%= rs.getDate("date") %></td>
            <td><%= rs.getTime("time") %></td>
        </tr>
        <%
            }
            if (!hasSessions) {
        %>
        <tr>
            <td colspan="4" style="text-align:center; color:#888;">No sessions scheduled yet.</td>
        </tr>
        <%
            }
        %>
    </table>
</div>

</body>
</html>

<%
    } catch (Exception e) {
        out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>