<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Course Planner - Home</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #f8faff, #d6e6ff);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
       }
        .container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            text-align: center;
            width: 350px;
            animation: fade 
            color: #004080;
            margin-bottom: 15px;
        }
        p {
            font-size: 15px;
            color: #555;
            margin-bottom: 25px;
        }
        a {
            display: inline-block;
            text-decoration: none;
            background: linear-gradient(90deg, #004080, #2575fc);
            color: white;
            padding: 12px 20px;
            border-radius: 6px;
            font-size: 15px;
            font-weight: bold;
            transition: transform 0.2s ease, background 0.3s ease;
        }
        a:hover {
            transform: translateY(-2px);
            background: linear-gradient(90deg, #003366, #1e66e0);
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Welcome to Course Planner</h1>
    <p>Manage courses, instructors, and students with ease.</p>
    <a href="login.jsp">Login</a>
</div>

</body>
</html>
