<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="db.jsp" %>
<%
    String sessionIdParam = request.getParameter("id");
    Map<String, String> sessionData = new HashMap<String, String>();

    if (con != null && sessionIdParam != null) {
        try {
            PreparedStatement ps = con.prepareStatement(
                "SELECT title, session_time, link, instructor_username FROM sessions WHERE id = ?"
            );
            ps.setInt(1, Integer.parseInt(sessionIdParam));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                sessionData.put("title", rs.getString("title"));
                sessionData.put("time", rs.getString("session_time"));
                sessionData.put("link", rs.getString("link"));
                sessionData.put("instructor", rs.getString("instructor_username"));
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Session Details</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f8;
            padding: 40px;
        }
        .session-box {
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            max-width: 500px;
            margin: auto;
        }
        h2 {
            color: #2c3e50;
            margin-bottom: 20px;
        }
        p {
            font-size: 16px;
            margin: 8px 0;
        }
        a {
            color: #2980b9;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="session-box">
        <h2>Session Details</h2>
    <%
        if (!sessionData.isEmpty()) {
    %>
        <p><strong>Title:</strong> <%= sessionData.get("title") %></p>
        <p><strong>Time:</strong> <%= sessionData.get("time") %></p>
        <p><strong>Instructor:</strong> <%= sessionData.get("instructor") %></p>
        <p><strong>Link:</strong> <a href="<%= sessionData.get("link") %>">Join Session</a></p>
    <%
        } else {
    %>
        <p>Session not found or invalid ID.</p>
    <%
        }
    %>
    </div>
</body>
</html>