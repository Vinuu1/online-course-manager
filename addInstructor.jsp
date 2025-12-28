<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");

        try {
            Connection con = (Connection) application.getAttribute("dbConnection");

            // Insert into users table
            PreparedStatement psUser = con.prepareStatement(
                "INSERT INTO users (username, password, role) VALUES (?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            psUser.setString(1, username);
            psUser.setString(2, password);
            psUser.setString(3, "instructor");
            psUser.executeUpdate();

            ResultSet rs = psUser.getGeneratedKeys();
            int userId = -1;
            if (rs.next()) {
                userId = rs.getInt(1);
            }
            rs.close();
            psUser.close();

            // Insert into instructors table
            PreparedStatement psInstructor = con.prepareStatement(
                "INSERT INTO instructors (user_id, full_name, email) VALUES (?, ?, ?)"
            );
            psInstructor.setInt(1, userId);
            psInstructor.setString(2, fullName);
            psInstructor.setString(3, email);
            psInstructor.executeUpdate();
            psInstructor.close();

            response.sendRedirect("manageInstructors.jsp");
            return;
        } catch (Exception e) {
            message = "Error adding instructor: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Instructor</title>
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
        form {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            max-width: 500px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }
        input[type="text"], input[type="password"], input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        input[type="submit"] {
            background-color: #2980b9;
            color: white;
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        input[type="submit"]:hover {
            background-color: #1f6391;
        }
        .message {
            color: red;
            margin-bottom: 16px;
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
    <h1>Add Instructor</h1>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <form method="post">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <label>Full Name</label>
        <input type="text" name="full_name" required>

        <label>Email</label>
        <input type="email" name="email" required>

        <input type="submit" value="Add Instructor">
    </form>

    <a href="manageInstructors.jsp" class="back-button">← Back to Instructor Management</a>
</div>

</body>
</html>