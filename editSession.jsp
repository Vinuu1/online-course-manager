<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    Connection con = (Connection) application.getAttribute("dbConnection");
    String message = "";
    
    String sessionId = request.getParameter("id");
    String sessionName = "", date = "", time = "", link = "";
    String courseId = "", instructorId = "";

    if (sessionId == null || sessionId.trim().isEmpty()) {
        response.sendRedirect("manageCourses.jsp?error=missing_id");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Get form data
        sessionName = request.getParameter("session_name");
        date = request.getParameter("date");
        time = request.getParameter("time");
        courseId = request.getParameter("course_id");
        instructorId = request.getParameter("instructor_id");
        link = request.getParameter("link");

        if (sessionName != null && date != null && time != null && courseId != null) {
            try {
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE sessions SET session_name=?, date=?, time=?, course_id=?, instructor_id=?, link=? WHERE id=?"
                );
                ps.setString(1, sessionName.trim());
                ps.setString(2, date.trim());
                ps.setString(3, time.trim());
                ps.setInt(4, Integer.parseInt(courseId.trim()));
                if (instructorId != null && !instructorId.trim().isEmpty()) {
                    ps.setInt(5, Integer.parseInt(instructorId.trim()));
                } else {
                    ps.setNull(5, java.sql.Types.INTEGER);
                }
                ps.setString(6, link != null ? link.trim() : "");
                ps.setInt(7, Integer.parseInt(sessionId));
                ps.executeUpdate();
                ps.close();

                message = "Session updated successfully!";
            } catch (Exception e) {
                message = "Error updating session: " + e.getMessage();
            }
        } else {
            message = "Please fill in all required fields.";
        }
    } else {
        // Load session details to populate form
        try {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM sessions WHERE id=?"
            );
            ps.setInt(1, Integer.parseInt(sessionId));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                sessionName = rs.getString("session_name");
                date = rs.getString("date");
                time = rs.getString("time");
                courseId = String.valueOf(rs.getInt("course_id"));
                int instId = rs.getInt("instructor_id");
                if (!rs.wasNull()) {
                    instructorId = String.valueOf(instId);
                }
                link = rs.getString("link");
            } else {
                message = "Session not found.";
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            message = "Error loading session: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Session</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f6fc;
            padding: 20px;
        }
        .container {
            max-width: 500px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }
        input[type=text], input[type=date], input[type=time], input[type=url], select {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        button {
            margin-top: 20px;
            padding: 10px 18px;
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

<div class="container">
    <h2>Edit Session</h2>

    <form method="post" action="updateSession.jsp?id=<%= sessionId %>">
        <label>Session Name *</label>
        <input type="text" name="session_name" value="<%= sessionName %>" required>

        <label>Date *</label>
        <input type="date" name="date" value="<%= date %>" required>

        <label>Time *</label>
        <input type="time" name="time" value="<%= time %>" required>

        <label>Course ID *</label>
        <input type="text" name="course_id" value="<%= courseId %>" required>

        <label>Instructor ID</label>
        <input type="text" name="instructor_id" value="<%= instructorId %>">

        <label>Link</label>
        <input type="url" name="link" value="<%= link != null ? link : "" %>">

        <button type="submit">Update Session</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="<%= message.startsWith("Error") ? "error" : "message" %>"><%= message %></div>
    <% } %>

    <a href="manageCourses.jsp" class="back-link">← Back to Sessions</a>
</div>

</body>
</html>
