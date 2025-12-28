<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
String message = "";
Connection con = (Connection) application.getAttribute("dbConnection");

String sessionId = request.getParameter("id");
String courseIdStr = request.getParameter("course_id");
String sessionName = "";
String date = "";
String time = "";
String instructorIdStr = request.getParameter("instructor_id");
String link = "";

if (sessionId == null || sessionId.trim().isEmpty()) {
    response.sendRedirect("manageCourses.jsp?error=missing_id");
    return;
}

if ("POST".equalsIgnoreCase(request.getMethod())) {
    courseIdStr = request.getParameter("course_id");
    sessionName = request.getParameter("session_name");
    date = request.getParameter("date");
    time = request.getParameter("time");
    instructorIdStr = request.getParameter("instructor_id");
    link = request.getParameter("link");

    if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
        message = "Course ID is required.";
    } else if (sessionName == null || sessionName.trim().isEmpty() ||
               date == null || date.trim().isEmpty() ||
               time == null || time.trim().isEmpty()) {
        message = "Please fill in all required fields.";
    } else {
        try {
            int courseId = Integer.parseInt(courseIdStr);
            int instructorId = (instructorIdStr != null && !instructorIdStr.trim().isEmpty()) ? Integer.parseInt(instructorIdStr) : 0;

            PreparedStatement ps = con.prepareStatement(
                "UPDATE sessions SET course_id = ?, session_name = ?, date = ?, time = ?, instructor_id = ?, link = ? WHERE id = ?"
            );
            ps.setInt(1, courseId);
            ps.setString(2, sessionName.trim());
            ps.setDate(3, Date.valueOf(date));
            ps.setTime(4, Time.valueOf(time));
            if(instructorId > 0) {
                ps.setInt(5, instructorId);
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.setString(6, link != null ? link.trim() : null);
            ps.setInt(7, Integer.parseInt(sessionId));

            int updated = ps.executeUpdate();
            if(updated > 0) {
                message = "Session updated successfully.";
            } else {
                message = "Session update failed. Please check the session ID.";
            }
            ps.close();
        } catch (Exception e) {
            message = "Error updating session: " + e.getMessage();
        }
    }
} else {
    try {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM sessions WHERE id = ?");
        ps.setInt(1, Integer.parseInt(sessionId));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            courseIdStr = String.valueOf(rs.getInt("course_id"));
            sessionName = rs.getString("session_name");
            date = rs.getDate("date").toString();
            time = rs.getTime("time").toString();
            int instId = rs.getInt("instructor_id");
            instructorIdStr = (instId == 0) ? "" : String.valueOf(instId);
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
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Edit Session</title>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #e3f2fd;
        padding: 40px;
    }
    .form-container {
        background: white;
        padding: 25px;
        max-width: 600px;
        margin: auto;
        border-radius: 8px;
        box-shadow: 0 6px 12px rgba(0,0,0,0.1);
    }
    h2 {
        margin-bottom: 20px;
        color: #1565c0;
    }
    label {
        display: block;
        margin-top: 15px;
        font-weight: 600;
        color: #0d47a1;
    }
    input[type="text"], input[type="date"], input[type="time"], input[type="number"], input[type="url"] {
        width: 100%;
        padding: 10px;
        margin-top: 6px;
        border: 1px solid #90caf9;
        border-radius: 6px;
        font-size: 1rem;
        color: #0d47a1;
    }
    button {
        margin-top: 25px;
        padding: 12px 20px;
        background-color: #1976d2;
        color: white;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: 600;
        font-size: 1.1rem;
    }
    button:hover {
        background-color: #0d47a1;
    }
    .message {
        margin-top: 20px;
        font-weight: 600;
        color: green;
    }
    .error {
        color: red;
        font-weight: 600;
    }
    .back-link {
        display: inline-block;
        margin-top: 25px;
        text-decoration: none;
        color: #1976d2;
        font-weight: 600;
    }
    .back-link:hover {
        text-decoration: underline;
    }
</style>
</head>
<body>

<div class="form-container">
    <h2>Edit Session</h2>
    <form method="post">
        <input type="hidden" name="id" value="<%= sessionId %>">

        <label for="course_id">Course ID *</label>
        <input type="number" id="course_id" name="course_id" value="<%= courseIdStr %>" required>

        <label for="session_name">Session Name *</label>
        <input type="text" id="session_name" name="session_name" value="<%= sessionName %>" required>

        <label for="date">Date *</label>
        <input type="date" id="date" name="date" value="<%= date %>" required>

        <label for="time">Time *</label>
        <input type="time" id="time" name="time" value="<%= time %>" required>

        <label for="instructor_id">Instructor ID</label>
        <input type="number" id="instructor_id" name="instructor_id" value="<%= instructorIdStr %>">

        <label for="link">Link</label>
        <input type="url" id="link" name="link" value="<%= link != null ? link : "" %>">

        <button type="submit">Update Session</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="<%= message.startsWith("Error") || message.contains("failed") ? "error" : "message" %>">
            <%= message %>
        </div>
    <% } %>

    <a href="manageCourses.jsp" class="back-link">← Back to Courses</a>
</div>

</body>
</html>
