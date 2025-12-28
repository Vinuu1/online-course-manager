<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>  <%-- This will give you the 'con' variable --%>

<%
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");

        if (username != null && password != null && fullName != null && email != null &&
            !username.trim().isEmpty() && !password.trim().isEmpty() &&
            !fullName.trim().isEmpty() && !email.trim().isEmpty()) {

            if (con == null) {
                message = "Error: Database connection not available.";
            } else {
                try {
                    // Insert into users
                    PreparedStatement ps1 = con.prepareStatement(
                        "INSERT INTO users (username, password, role) VALUES (?, ?, 'student')",
                        Statement.RETURN_GENERATED_KEYS
                    );
                    ps1.setString(1, username.trim());
                    ps1.setString(2, password.trim());
                    ps1.executeUpdate();

                    ResultSet rs = ps1.getGeneratedKeys();
                    if (rs.next()) {
                        int userId = rs.getInt(1);

                        // Insert into students
                        PreparedStatement ps2 = con.prepareStatement(
                            "INSERT INTO students (user_id, full_name, email) VALUES (?, ?, ?)"
                        );
                        ps2.setInt(1, userId);
                        ps2.setString(2, fullName.trim());
                        ps2.setString(3, email.trim());
                        ps2.executeUpdate();
                        ps2.close();

                        message = "Student added successfully.";
                    } else {
                        message = "Error: Failed to retrieve user ID.";
                    }

                    rs.close();
                    ps1.close();
                } catch (Exception e) {
                    message = "Error: " + (e.getMessage() != null ? e.getMessage() : "Unknown error");
                }
            }
        } else {
            message = "Please fill in all fields.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Student</title>
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
        input[type="text"], input[type="password"], input[type="email"] {
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
    <h2>Add Student</h2>
    <form method="post">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <label>Full Name</label>
        <input type="text" name="full_name" required>

        <label>Email</label>
        <input type="email" name="email" required>

        <button type="submit">Add Student</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="<%= message.startsWith("Error") ? "error" : "message" %>"><%= message %></div>
    <% } %>

    <a href="manageStudents.jsp" class="back-link">← Back to Student Management</a>
</div>

</body>
</html>
