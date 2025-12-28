<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ include file="db.jsp" %>

<%
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = (Connection) application.getAttribute("dbConnection");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Sessions as Courses</title>
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
            transition: background 0.3s ease;
        }
        .sidebar a:hover {
            background: #34495e;
        }
        .content {
            margin-left: 220px;
            padding: 20px;
            flex: 1;
        }
        h1 {
            margin-bottom: 20px;
            color: #2c3e50;
        }
        .action-buttons {
            margin-bottom: 20px;
        }
        .action-buttons a {
            display: inline-block;
            margin-right: 10px;
            padding: 10px 16px;
            background-color: #2980b9;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: background 0.3s ease;
        }
        .action-buttons a:hover {
            background-color: #1f6391;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 12px 16px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }
        th {
            background: #2980b9;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .actions a {
            margin-right: 10px;
            color: #2980b9;
            text-decoration: none;
        }
        .actions a:hover {
            text-decoration: underline;
        }
        .back-button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 16px;
            background-color: #2980b9;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: background 0.3s ease;
        }
        .back-button:hover {
            background-color: #1f6391;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Admin</h2>
    <a href="admin.jsp">Dashboard</a>
    <a href="manageStudents.jsp">Manage Students</a>
    <a href="manageInstructors.jsp">Manage Instructors</a>
    <a href="manageCourses.jsp">Manage Courses</a>
    <a href="logout.jsp">Logout</a>
</div>

<div class="content">
    <h1>Session Management</h1>

    <div class="action-buttons">
        <a href="addSession.jsp">➕ Add Session</a>
    </div>

    <table>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Date & Time</th>
            <th>Instructor</th>
            <th>Link</th>
            <th>Actions</th>
        </tr>
        <%
            if (con == null) {
                out.println("<tr><td colspan='6' style='color:red;'>Database connection failed.</td></tr>");
            } else {
                try {
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM sessions ORDER BY time DESC");
                    ResultSet rs = ps.executeQuery();
                    boolean hasSessions = false;

                    while (rs.next()) {
                        hasSessions = true;
                        Timestamp ts = rs.getTimestamp("time");
                        String formattedTime = new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(ts);
        %>
                        <tr>
                            <td><%= rs.getInt("id") %></td>
                            <td><%= rs.getString("session_name") %></td>
                            <td><%= formattedTime %></td>
                            <td><%= rs.getString("instructor_id") %></td>
                            <td><a href="<%= rs.getString("link") %>" target="_blank">Join</a></td>
                            <td class="actions">
                                <a href="editSession.jsp?id=<%= rs.getInt("id") %>">Edit</a>
                                <a href="deleteSession.jsp?id=<%= rs.getInt("id") %>"
                                   onclick="return confirm('Delete this session?');">Delete</a>
                            </td>
                        </tr>
        <%
                    }
                    if (!hasSessions) {
                        out.println("<tr><td colspan='6'>No sessions found.</td></tr>");
                    }
                    rs.close();
                    ps.close();
                } catch (Exception e) {
                    String errMsg = (e.getMessage() != null && !e.getMessage().trim().isEmpty())
                                    ? e.getMessage()
                                    : "An unexpected error occurred while loading sessions.";
                    out.println("<tr><td colspan='6' style='color:red;'>Error loading sessions: " + errMsg + "</td></tr>");
                }
            }
        %>
    </table>

    <a href="admin.jsp" class="back-button">← Back to Admin Dashboard</a>
</div>

</body>
</html>