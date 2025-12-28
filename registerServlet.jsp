<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
String fullName = request.getParameter("full_name");
String email = request.getParameter("email");
String role = request.getParameter("role");
String message = "";

Connection con = (Connection) application.getAttribute("dbConnection");

if ("POST".equalsIgnoreCase(request.getMethod())) {
    if (fullName != null && email != null && role != null &&
        !fullName.trim().isEmpty() && !email.trim().isEmpty() && !role.trim().isEmpty()) {

        try {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO applications (full_name, email, role, status) VALUES (?, ?, ?, 'pending')"
            );
            ps.setString(1, fullName.trim());
            ps.setString(2, email.trim());
            ps.setString(3, role.trim());
            ps.executeUpdate();
            ps.close();

            message = "✅ Application submitted successfully. Await admin approval.";
        } catch (Exception e) {
            message = "❌ Error: " + (e.getMessage() != null ? e.getMessage() : "Unknown error");
        }
    } else {
        message = "⚠️ Please fill in all fields.";
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Status</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #f8f9fa, #c9d6ff);
            padding: 60px;
            text-align: center;
        }
        .message-box {
            background: white;
            padding: 30px;
            max-width: 500px;
            margin: auto;
            border-radius: 10px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
            font-size: 16px;
            color: #2c3e50;
        }
        .success { color: green; }
        .error { color: red; }
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

<div class="message-box">
    <div class="<%= message.startsWith("✅") ? "success" : "error" %>"><%= message %></div>
    <a href="register.jsp" class="back-link">← Back to Register</a>
</div>

</body>
</html>