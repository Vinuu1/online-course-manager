<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String sessionName = request.getParameter("sessionName");
    String sessionDate = request.getParameter("sessionDate");
    String sessionTime = request.getParameter("sessionTime");

    String message = "";
    boolean isError = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (sessionName == null || sessionDate == null || sessionTime == null ||
            sessionName.trim().isEmpty() || sessionDate.trim().isEmpty() || sessionTime.trim().isEmpty()) {
            message = "Please fill all fields.";
            isError = true;
        } else {
            Connection con = null;
            try {
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "root");
                String sql = "INSERT INTO sessions (name, date, time) VALUES (?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, sessionName);
                ps.setString(2, sessionDate);
                ps.setString(3, sessionTime);
                ps.executeUpdate();
                ps.close();

                message = "Session added successfully!";
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                isError = true;
            } finally {
                if (con != null) try { con.close(); } catch (SQLException e) {}
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Session</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #f8f9fa, #c9d6ff);
            padding: 40px;
        }
        .form-container {
            background: white;
            padding: 30px;
            max-width: 500px;
            margin: auto;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        h2 {
            margin-bottom: 20px;
            color: #2c3e50;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }
        input[type="text"], input[type="date"], input[type="time"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            margin-top: 20px;
            padding: 10px 16px;
            background-color: #2980b9;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover {
            background-color: #1f6391;
        }
        .message {
            margin-top: 15px;
            color: green;
        }
        .error {
            color: red;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #2980b9;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Add Session</h2>

    <form method="post">
        <label>Session Name</label>
        <input type="text" name="sessionName" required>

        <label>Date</label>
        <input type="date" name="sessionDate" required>

        <label>Time</label>
        <input type="time" name="sessionTime" required>

        <button type="submit">Add Session</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="<%= isError ? "error" : "message" %>"><%= message %></div>
    <% } %>

    <a href="manageCourses.jsp" class="back-link">← Back to Session Management</a>
</div>

</body>
</html>
