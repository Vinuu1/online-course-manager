<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Instructors</title>
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
    <h1>Instructor Management</h1>

    <div class="action-buttons">
        <a href="addInstructor.jsp">➕ Add Instructor</a>
    </div>

    <table>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Actions</th>
        </tr>
        <%
            try {
                Connection con = (Connection) application.getAttribute("dbConnection");
                PreparedStatement ps = con.prepareStatement(
                    "SELECT i.id AS instructor_id, u.username, i.full_name, i.email " +
                    "FROM instructors i JOIN users u ON i.user_id = u.id"
                );
                ResultSet rs = ps.executeQuery();
                boolean hasInstructors = false;
                while (rs.next()) {
                    hasInstructors = true;
        %>
        <tr>
            <td><%= rs.getInt("instructor_id") %></td>
            <td><%= rs.getString("username") %></td>
            <td><%= rs.getString("full_name") %></td>
            <td><%= rs.getString("email") %></td>
            <td class="actions">
                <a href="editInstructor.jsp?id=<%= rs.getInt("instructor_id") %>">Edit</a>
                <a href="deleteInstructor.jsp?id=<%= rs.getInt("instructor_id") %>" onclick="return confirm('Delete this instructor?');">Delete</a>
            </td>
        </tr>
        <%
                }
                if (!hasInstructors) {
        %>
        <tr><td colspan="5">No instructors found.</td></tr>
        <%
                }
                rs.close(); ps.close();
            } catch (Exception e) {
        %>
        <tr><td colspan="5" style="color:red;">Error loading instructors: <%= e.getMessage() %></td></tr>
        <%
            }
        %>
    </table>

    <a href="admin.jsp" class="back-button">← Back to Admin Dashboard</a>
</div>

</body>
</html>