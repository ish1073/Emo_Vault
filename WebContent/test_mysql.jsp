<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<!DOCTYPE html>
<html>
<head>
    <title>MySQL Connection Test</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .success { color: green; }
        .error { color: red; }
        pre { background: #f5f5f5; padding: 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>MySQL Connection Test</h1>
    
    <%
        Connection conn = null;
        try {
            // Test: Using dedicated application user
            out.println("<h2>Test: Using Application User (emovault_user)</h2>");
            java.util.Properties props = new java.util.Properties();
            props.setProperty("user", "emovault_user");
            props.setProperty("password", "emovault123");
            props.setProperty("useSSL", "false");
            props.setProperty("allowPublicKeyRetrieval", "true");
            props.setProperty("serverTimezone", "UTC");
            
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/emovault_db",
                props
            );
            out.println("<p class='success'>✓ Connected successfully with emovault_user!</p>");
            
            // Test database
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT VERSION()");
            if (rs.next()) {
                out.println("<p><strong>MySQL Version:</strong> " + rs.getString(1) + "</p>");
            }
            
            // List tables
            out.println("<h3>Tables in emovault_db:</h3><pre>");
            rs = stmt.executeQuery("SHOW TABLES");
            while (rs.next()) {
                out.println(rs.getString(1));
            }
            out.println("</pre>");
            
            rs.close();
            stmt.close();
            conn.close();
            
            out.println("<p class='success'><strong>✓ Database connection is working! Registration should now work.</strong></p>");
            
        } catch (Exception e) {
            out.println("<p class='error'>✗ Connection failed with emovault_user</p>");
            out.println("<p><strong>Error:</strong> " + e.getMessage() + "</p>");
            out.println("<details><summary>Stack trace:</summary><pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre></details>");
            
            out.println("<h3>If user doesn't exist, create with:</h3>");
            out.println("<pre>CREATE USER 'emovault_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'emovault123';<br>");
            out.println("GRANT ALL PRIVILEGES ON emovault_db.* TO 'emovault_user'@'localhost';<br>");
            out.println("FLUSH PRIVILEGES;</pre>");
        }
    %>
    
    <p><a href="register.jsp">Back to Registration</a></p>
</body>
</html>
