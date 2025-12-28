<%@ page session="true" import="java.sql.*" %>
<%
    if (session.getAttribute("username") == null || !"instructor".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String instructorUsername = (String) session.getAttribute("username");
    Integer instructorId = (Integer) session.getAttribute("instructor_id");

    int sessionCount = 0;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "root");

        if (instructorId != null) {
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM sessions WHERE instructor_id = ?");
            ps.setInt(1, instructorId);
            ResultSet rs1 = ps.executeQuery();

            if (rs1.next()) {
                sessionCount = rs1.getInt(1);
            }

            rs1.close();
            ps.close();
        }

        conn.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Instructor Dashboard</title>
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
            padding: 20px;
            flex-grow: 1;
        }
        .card {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0px 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .card h2 {
            margin-top: 0;
            font-size: 22px;
            color: #34495e;
        }
        .card p {
            font-size: 16px;
            color: #2c3e50;
            margin: 10px 0;
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
        <h1>Welcome, <%= instructorUsername %></h1>

        <div class="card">
            <h2>Instructor Info</h2>
            <p>Username: <strong><%= instructorUsername %></strong></p>
        </div>

        <div class="card">
            <h2>Your Overview</h2>
            <p>Total Sessions: <strong><%= sessionCount %></strong></p>
        </div>
    </div>
</body>
</html>