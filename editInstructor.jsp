<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String instructorId = request.getParameter("id");
    if (instructorId == null || instructorId.trim().isEmpty()) {
        response.sendRedirect("manageInstructors.jsp");
        return;
    }

    String username = "", password = "", name = "", email = "", message = "";
    Connection con = (Connection) application.getAttribute("dbConnection");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        username = request.getParameter("username");
        password = request.getParameter("password");
        name = request.getParameter("name");
        email = request.getParameter("email");

        if (username != null && password != null && name != null && email != null &&
            !username.trim().isEmpty() && !password.trim().isEmpty() &&
            !name.trim().isEmpty() && !email.trim().isEmpty()) {

            try {
                // Update users table
                PreparedStatement ps1 = con.prepareStatement(
                    "UPDATE users SET username = ?, password = ? WHERE id = ? AND role = 'instructor'"
                );
                ps1.setString(1, username.trim());
                ps1.setString(2, password.trim());
                ps1.setInt(3, Integer.parseInt(instructorId));
                ps1.executeUpdate();
                ps1.close();

                // Update instructors table
                PreparedStatement ps2 = con.prepareStatement(
                    "UPDATE instructors SET name = ?, email = ? WHERE user_id = ?"
                );
                ps2.setString(1, name.trim());
                ps2.setString(2, email.trim());
                ps2.setInt(3, Integer.parseInt(instructorId));
                ps2.executeUpdate();
                ps2.close();

                message = "Instructor updated successfully.";
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            }
        } else {
            message = "Please fill in all fields.";
        }
    } else {
        try {
            // Load from users
            PreparedStatement ps1 = con.prepareStatement(
                "SELECT username, password FROM users WHERE id = ? AND role = 'instructor'"
            );
            ps1.setInt(1, Integer.parseInt(instructorId));
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                username = rs1.getString("username");
                password = rs1.getString("password");
            }
            rs1.close(); ps1.close();

            // Load from instructors
            PreparedStatement ps2 = con.prepareStatement(
                "SELECT full_name, email FROM instructors WHERE user_id = ?"
            );
            ps2.setInt(1, Integer.parseInt(instructorId));
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                name = rs2.getString("full_name");
                email = rs2.getString("email");
            }
            rs2.close(); ps2.close();

        } catch (Exception e) {
            message = "Error loading instructor: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Instructor</title>
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
    <h2>Edit Instructor</h2>
    <form method="post">
        <input type="hidden" name="id" value="<%= instructorId %>">

        <label>Full Name</label>
        <input type="text" name="name" value="<%= name %>" required>

        <label>Email</label>
        <input type="email" name="email" value="<%= email %>" required>

        <label>Username</label>
        <input type="text" name="username" value="<%= username %>" required>

        <label>Password</label>
        <input type="password" name="password" value="<%= password %>" required>

        <button type="submit">Update Instructor</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="<%= message.startsWith("Error") ? "error" : "message" %>"><%= message %></div>
    <% } %>

    <a href="manageInstructors.jsp" class="back-link">← Back to Instructor Management</a>
</div>

</body>
</html>