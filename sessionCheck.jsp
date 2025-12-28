<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect("index.jsp?error=Please+login+first");
        return;
    }
%>
