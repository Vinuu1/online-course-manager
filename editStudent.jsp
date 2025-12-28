<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%!
    // Escape HTML to avoid XSS
    public String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }
%>

<%
    String message = "";
    Connection con = (Connection) application.getAttribute("dbConnection");

    String studentId = request.getParameter("id");
    String username = "", password = "", fullName = "", email = "";

    if (studentId == null || studentId.trim().isEmpty()) {
        response.sendRedirect("manageStudents.jsp?error=missing_id");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        username = request.getParameter("username");
        password = request.getParameter("password");
        fullName = request.getParameter("full_name");
        email = request.getParameter("email");

        if (username != null && password != null && fullName != null && email != null &&
            !username.trim().isEmpty() && !password.trim().isEmpty() &&
            !fullName.trim().isEmpty() && !email.trim().isEmpty()) {

            PreparedStatement ps1 = null, psCheck = null, ps2 = null, psInsert = null;
            ResultSet rsCheck = null;
            try {
                ps1 = con.prepareStatement(
                    "UPDATE users SET username = ?, password = ? WHERE id = ? AND role = 'student'"
                );
                ps1.setString(1, username.trim());
                ps1.setString(2, password.trim());
                ps1.setInt(3, Integer.parseInt(studentId));
                ps1.executeUpdate();

                psCheck = con.prepareStatement(
                    "SELECT COUNT(*) FROM students WHERE user_id = ?"
                );
                psCheck.setInt(1, Integer.parseInt(studentId));
                rsCheck = psCheck.executeQuery();
                boolean studentExists = false;
                if (rsCheck.next()) {
                    studentExists = rsCheck.getInt(1) > 0;
                }

                if (studentExists) {
                    ps2 = con.prepareStatement(
                        "UPDATE students SET full_name = ?, email = ? WHERE user_id = ?"
                    );
                    ps2.setString(1, fullName.trim());
                    ps2.setString(2, email.trim());
                    ps2.setInt(3, Integer.parseInt(studentId));
                    ps2.executeUpdate();
                } else {
                    psInsert = con.prepareStatement(
                        "INSERT INTO students (user_id, full_name, email) VALUES (?, ?, ?)"
                    );
                    psInsert.setInt(1, Integer.parseInt(studentId));
                    psInsert.setString(2, fullName.trim());
                    psInsert.setString(3, email.trim());
                    psInsert.executeUpdate();
                }

                message = "Student updated successfully.";

            } catch (Exception e) {
                message = "Error: " + (e.getMessage() != null ? e.getMessage() : "Unknown error");
            } finally {
                try { if (rsCheck != null) rsCheck.close(); } catch (Exception e) {}
                try { if (ps1 != null) ps1.close(); } catch (Exception e) {}
                try { if (psCheck != null) psCheck.close(); } catch (Exception e) {}
                try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
                try { if (psInsert != null) psInsert.close(); } catch (Exception e) {}
            }
        } else {
            message = "Please fill in all fields.";
        }
    } else {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(
                "SELECT u.username, u.password, s.full_name, s.email " +
                "FROM users u LEFT JOIN students s ON u.id = s.user_id WHERE u.id = ?"
            );
            ps.setInt(1, Integer.parseInt(studentId));
            rs = ps.executeQuery();
            if (rs.next()) {
                username = rs.getString("username");
                password = rs.getString("password");
                fullName = rs.getString("full_name") != null ? rs.getString("full_name") : "";
                email = rs.getString("email") != null ? rs.getString("email") : "";
            } else {
                message = "Error: Student not found.";
            }
        } catch (Exception e) {
            message = "Error loading student: " + (e.getMessage() != null ? e.getMessage() : "Unknown error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
        }
    }

    // Escape data for HTML output
    String escUsername = escapeHtml(username);
    String escPassword = escapeHtml(password);
    String escFullName = escapeHtml(fullName);
    String escEmail = escapeHtml(email);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Student</title>
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
    <h2>Edit Student</h2>
    <form method="post" action="editStudent.jsp?id=<%= studentId %>">
        <input type="hidden" name="id" value="<%= studentId %>">

        <label>Username</label>
        <input type="text" name="username" value="<%= escUsername %>" required>

        <label>Password</label>
        <input type="password" name="password" value="<%= escPassword %>" required>

        <label>Full Name</label>
        <input type="text" name="full_name" value="<%= escFullName %>" required>

        <label>Email</label>
        <input type="email" name="email" value="<%= escEmail %>" required>

        <button type="submit">Update Student</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="<%= message.startsWith("Error") ? "error" : "message" %>"><%= message %></div>
    <% } %>

    <a href="manageStudents.jsp" class="back-link">← Back to Student Management</a>
</div>

</body>
</html>
