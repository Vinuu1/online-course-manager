<%@ page session="true" import="java.sql.*" %>
<%
    if (session.getAttribute("username") == null || !"instructor".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String instructorUsername = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Plan Session</title>
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
            padding: 30px;
            flex: 1;
        }
        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0px 6px 12px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            transition: box-shadow 0.3s ease;
        }
        .card:hover {
            box-shadow: 0px 10px 18px rgba(0,0,0,0.15);
        }
        .card h2 {
            margin-top: 0;
            font-size: 24px;
            color: #34495e;
            margin-bottom: 20px;
        }
        form label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            color: #2c3e50;
        }
        input[type="text"],
        input[type="date"],
        input[type="time"],
        input[type="url"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s ease;
        }
        input:focus {
            border-color: #2980b9;
            outline: none;
        }
        button {
            background-color: #2c3e50;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        button:hover {
            background-color: #34495e;
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
            <h2>Plan Live / Online Session</h2>
            <form action="saveSession.jsp" method="post">
                <label for="session_name">Session Name</label>
                <input type="text" id="session_name" name="session_name" required>

                <label for="date">Date</label>
                <input type="date" id="date" name="date" required>

                <label for="time">Time</label>
                <input type="time" id="time" name="time" required>

                <label for="link">Meeting Link</label>
                <input type="url" id="link" name="link" required>

                <button type="submit">Save Session</button>
            </form>
        </div>
    </div>
</body>
</html>
