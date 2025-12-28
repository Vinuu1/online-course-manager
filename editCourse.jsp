<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String id = request.getParameter("id");
    String courseName = "";
    String description = "";

    if (request.getMethod().equalsIgnoreCase("POST")) {
        courseName = request.getParameter("course_name");
        description = request.getParameter("description");

        try {
            PreparedStatement ps = con.prepareStatement("UPDATE courses SET course_name=?, description=? WHERE id=?");
            ps.setString(1, courseName);
            ps.setString(2, description);
            ps.setInt(3, Integer.parseInt(id));
            ps.executeUpdate();
            ps.close();
            con.close();
            response.sendRedirect("manageCourses.jsp");
            return;
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error updating course: " + e.getMessage() + "</p>");
        }
    } else {
        try {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM courses WHERE id=?");
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                courseName = rs.getString("course_name");
                description = rs.getString("description");
            }
            rs.close(); ps.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error loading course: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Course</title>
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
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
        }
        form {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 100%;
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        textarea {
            resize: vertical;
            height: 100px;
        }
        input[type="submit"] {
            margin-top: 20px;
            padding: 10px 16px;
            background-color: #2980b9;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #1f6391;
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
    <h1>Edit Course</h1>
    <form method="post">
        <label>Course Name:</label>
        <input type="text" name="course_name" value="<%= courseName %>" required>

        <label>Description:</label>
        <textarea name="description" required><%= description %></textarea>

        <input type="submit" value="Update Course">
    </form>

    <a href="manageCourses.jsp" class="back-button">← Back to Course List</a>
</div>

</body>
</html>