<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Course Planner - Login</title>
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
        .login-box {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            width: 320px;
            text-align: center;
            animation: fadeIn 0.8s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        h2 {
            margin-bottom: 25px;
            color: #004080;
            font-size: 24px;
        }
        label {
            display: block;
            text-align: left;
            font-size: 14px;
            margin-bottom: 5px;
            color: #333;
        }
        input {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            outline: none;
        }
        input:focus {
            border-color: #2575fc;
            box-shadow: 0 0 8px rgba(37,117,252,0.3);
        }
        button {
            background: linear-gradient(90deg, #004080, #2575fc);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
            font-size: 15px;
            font-weight: bold;
            transition: transform 0.2s ease, background 0.3s ease;
        }
        button:hover {
            transform: translateY(-2px);
            background: linear-gradient(90deg, #003366, #1e66e0);
        }
        .error {
            color: red;
            font-size: 13px;
            margin-bottom: 10px;
        }
        a {
            display: inline-block;
            margin-top: 15px;
            font-size: 14px;
            color: #004080;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>Login</h2>

    <% String error = request.getParameter("error");
       if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <form action="validateLogin.jsp" method="post">
        <label>Username</label>
        <input type="text" name="username" placeholder="Enter your username" required>

        <label>Password</label>
        <input type="password" name="password" placeholder="Enter your password" required>

        <button type="submit">Login</button>
    </form>

    <a href="index.jsp">Back to Home</a>
</div>

</body>
</html>
