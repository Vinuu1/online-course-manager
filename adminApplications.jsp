<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
String message = "";
Connection con = (Connection) application.getAttribute("dbConnection");

try {
    PreparedStatement ps = con.prepareStatement(
        "SELECT id, full_name, email, role FROM applications WHERE status = 'pending'"
    );
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Applications</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 40px;
        }
        .container {
            max-width: 900px;
            margin: auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.08);
        }
        h2 {
            margin-bottom: 25px;
            color: #2c3e50;
            font-size: 24px;
            border-bottom: 2px solid #ecf0f1;
            padding-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            padding: 14px 12px;
            border-bottom: 1px solid #e0e0e0;
            text-align: left;
        }
        th {
            background-color: #f0f4f8;
            color: #34495e;
            font-weight: 600;
        }
        tr:hover {
            background-color: #f9fcff;
        }
        .btn {
            padding: 8px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: background-color 0.2s ease;
        }
        .approve {
            background-color: #27ae60;
            color: white;
        }
        .approve:hover {
            background-color: #219150;
        }
        .reject {
            background-color: #c0392b;
            color: white;
        }
        .reject:hover {
            background-color: #a93226;
        }
        .actions {
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Pending Applications</h2>

    <table>
        <tr>
            <th>Full Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Actions</th>
        </tr>

        <%
        while (rs.next()) {
            int appId = rs.getInt("id");
            String name = rs.getString("full_name");
            String email = rs.getString("email");
            String role = rs.getString("role");
        %>
        <tr>
            <td><%= name %></td>
            <td><%= email %></td>
            <td><%= role %></td>
            <td>
                <div class="actions">
                    <form action="processApplication.jsp" method="post">
                        <input type="hidden" name="id" value="<%= appId %>">
                        <input type="hidden" name="action" value="approve">
                        <button type="submit" class="btn approve">Approve</button>
                    </form>
                    <form action="processApplication.jsp" method="post">
                        <input type="hidden" name="id" value="<%= appId %>">
                        <input type="hidden" name="action" value="reject">
                        <button type="submit" class="btn reject">Reject</button>
                    </form>
                </div>
            </td>
        </tr>
        <% } %>
    </table>

    <% rs.close(); ps.close(); %>
</div>

</body>
</html>

<%
} catch (Exception e) {
    out.println("<div style='color:red;'>Error loading applications: " + e.getMessage() + "</div>");
}
%>