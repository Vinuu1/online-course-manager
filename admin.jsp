<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        /* --- Existing styles --- */
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #f8f9fa, #c9d6ff);
            display: flex;
        }
        .sidebar {
            width: 200px;
            background: #2c3e50;
            padding: 20px;
            color: white;
        }
        .sidebar a {
            display: block;
            color: white;
            padding: 10px;
            text-decoration: none;
        }
        .sidebar a:hover {
            background: #34495e;
        }
        .content {
            flex: 1;
            padding: 20px;
        }
        .card-container {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 20px;
            flex: 1;
        }
        .section-title {
            margin-top: 40px;
            font-size: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            background: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            border-radius: 5px;
            overflow: hidden;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th {
            background-color: #3498db;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 10px;
        }
        tr:hover {
            background-color: #f1f8ff;
        }
        /* Button styles */
        .action-btn {
            padding: 6px 12px;
            margin-right: 5px;
            border: none;
            border-radius: 3px;
            font-size: 14px;
            cursor: pointer;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        .view-btn {
            background-color: #2980b9;
        }
        .edit-btn {
            background-color: #27ae60;
        }
        .delete-btn {
            background-color: #c0392b;
        }
        .action-btn:hover {
            opacity: 0.85;
        }
        form.inline {
            display: inline;
        }
        .error-message {
            color: #e74c3c;
            background-color: #fdecea;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
        }
    </style>
</head>
<body>

<%
    if (con == null || con.isClosed()) {
        out.print("<div class='error-message'>Database connection not available</div>");
    } else {
%>

<div class="sidebar">
    <h2>Admin</h2>
    <a href="admin.jsp">Dashboard</a>
    <a href="manageStudents.jsp">Manage Students</a>
    <a href="manageInstructors.jsp">Manage Instructors</a>
    <a href="manageCourses.jsp">Manage Courses</a>
    <a href="logout.jsp">Logout</a>
</div>

<div class="content">
    <h1>Dashboard Overview</h1>
    <div class="card-container">
        <!-- Cards for totals can be here -->
    </div>

    <!-- Recent Students Table -->
    <h2 class="section-title">Recent Students</h2>
    <%
        PreparedStatement psStudents = null;
        ResultSet rsStudents = null;
        try {
            psStudents = con.prepareStatement("SELECT id, username, role FROM users WHERE role='student' ORDER BY id DESC LIMIT 5");
            rsStudents = psStudents.executeQuery();
    %>
    <table>
        <thead>
            <tr>
                <th>ID</th><th>Username</th><th>Role</th><th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% while (rsStudents.next()) { %>
            <tr>
                <td><%= rsStudents.getInt("id") %></td>
                <td><%= rsStudents.getString("username") %></td>
                <td><%= rsStudents.getString("role") %></td>
                <td>
                    <a href="viewUser.jsp?id=<%= rsStudents.getInt("id") %>" class="action-btn view-btn">View</a>
                    <a href="editUser.jsp?id=<%= rsStudents.getInt("id") %>" class="action-btn edit-btn">Edit</a>
                    <form action="deleteUser.jsp" method="post" class="inline" onsubmit="return confirm('Are you sure you want to delete this user?');">
                        <input type="hidden" name="id" value="<%= rsStudents.getInt("id") %>" />
                        <button type="submit" class="action-btn delete-btn">Delete</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <%
        } catch (SQLException e) {
            out.print("<div class='error-message'>Error loading students: " + e.getMessage() + "</div>");
        } finally {
            if (rsStudents != null) try { rsStudents.close(); } catch (SQLException e) {}
            if (psStudents != null) try { psStudents.close(); } catch (SQLException e) {}
        }
    %>

    <!-- Recent Instructors Table -->
    <h2 class="section-title">Recent Instructors</h2>
    <%
        PreparedStatement psInstructors = null;
        ResultSet rsInstructors = null;
        try {
            psInstructors = con.prepareStatement("SELECT id, username, role FROM users WHERE role='instructor' ORDER BY id DESC LIMIT 5");
            rsInstructors = psInstructors.executeQuery();
    %>
    <table>
        <thead>
            <tr>
                <th>ID</th><th>Username</th><th>Role</th><th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% while (rsInstructors.next()) { %>
            <tr>
                <td><%= rsInstructors.getInt("id") %></td>
                <td><%= rsInstructors.getString("username") %></td>
                <td><%= rsInstructors.getString("role") %></td>
                <td>
                    <a href="viewUser.jsp?id=<%= rsInstructors.getInt("id") %>" class="action-btn view-btn">View</a>
                    <a href="editUser.jsp?id=<%= rsInstructors.getInt("id") %>" class="action-btn edit-btn">Edit</a>
                    <form action="deleteUser.jsp" method="post" class="inline" onsubmit="return confirm('Are you sure you want to delete this user?');">
                        <input type="hidden" name="id" value="<%= rsInstructors.getInt("id") %>" />
                        <button type="submit" class="action-btn delete-btn">Delete</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <%
        } catch (SQLException e) {
            out.print("<div class='error-message'>Error loading instructors: " + e.getMessage() + "</div>");
        } finally {
            if (rsInstructors != null) try { rsInstructors.close(); } catch (SQLException e) {}
            if (psInstructors != null) try { psInstructors.close(); } catch (SQLException e) {}
        }
    %>

    <!-- Upcoming Sessions Table -->
    <h2 class="section-title">Upcoming Sessions</h2>
    <%
        PreparedStatement psSessions = null;
        ResultSet rsSessions = null;
        try {
            psSessions = con.prepareStatement("SELECT id, session_name, date, time FROM sessions WHERE CONCAT(date, ' ', time) > NOW() ORDER BY date, time ASC LIMIT 5");
            rsSessions = psSessions.executeQuery();
    %>
    <table>
        <thead>
            <tr>
                <th>Session ID</th><th>Session Name</th><th>Date & Time</th><th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% while (rsSessions.next()) { %>
            <tr>
                <td><%= rsSessions.getInt("id") %></td>
                <td><%= rsSessions.getString("session_name") %></td>
                <td><%= rsSessions.getDate("date") %> <%= rsSessions.getTime("time") %></td>
                <td>
                    <a href="viewSession.jsp?id=<%= rsSessions.getInt("id") %>" class="action-btn view-btn">View</a>
                    <a href="editSession.jsp?id=<%= rsSessions.getInt("id") %>" class="action-btn edit-btn">Edit</a>
                    <form action="deleteSession.jsp" method="post" class="inline" onsubmit="return confirm('Are you sure you want to delete this session?');">
                        <input type="hidden" name="id" value="<%= rsSessions.getInt("id") %>" />
                        <button type="submit" class="action-btn delete-btn">Delete</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <%
        } catch (SQLException e) {
            out.print("<div class='error-message'>Error loading sessions: " + e.getMessage() + "</div>");
        } finally {
            if (rsSessions != null) try { rsSessions.close(); } catch (SQLException e) {}
            if (psSessions != null) try { psSessions.close(); } catch (SQLException e) {}
        }
    %>
</div>

<%
    }
%>

</body>
</html>
