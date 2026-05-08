<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<!DOCTYPE html>
<html>
<head>
    <title>EmoVault Setup Helper</title>
    <style>
        body { font-family: Arial; margin: 20px; max-width: 900px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .info { color: blue; }
        .box { border: 1px solid #ccc; padding: 15px; margin: 15px 0; border-radius: 5px; background: #f9f9f9; }
        pre { background: #f5f5f5; padding: 10px; border-radius: 5px; overflow-x: auto; }
        a.button { display: inline-block; padding: 10px 20px; background: #679F9F; color: white; text-decoration: none; border-radius: 5px; margin: 10px 5px 10px 0; }
        a.button:hover { background: #556b6b; }
        input[type="password"] { padding: 5px; width: 200px; }
        input[type="submit"] { padding: 10px 20px; background: #679F9F; color: white; border: none; border-radius: 5px; cursor: pointer; }
        input[type="submit"]:hover { background: #556b6b; }
    </style>
</head>
<body>
    <h1>EmoVault Setup Helper</h1>
    
    <div class="box">
        <h2>Step 1: Create MySQL User</h2>
        <p>We couldn't auto-detect the MySQL root password. You have two options:</p>
        
        <h3>Option A: Use PhpMyAdmin (Recommended)</h3>
        <ol>
            <li>Open PhpMyAdmin: <a class="button" href="http://localhost/phpmyadmin/" target="_blank">→ PhpMyAdmin Console</a></li>
            <li>You should be automatically logged in as root</li>
            <li>Go to the <strong>"User accounts"</strong> tab</li>
            <li>Click <strong>"Add user account"</strong></li>
            <li>Fill in these details:
                <ul>
                    <li><strong>User name:</strong> <code>emovault_user</code></li>
                    <li><strong>Host:</strong> <code>localhost</code></li>
                    <li><strong>Password:</strong> <code>emovault123</code></li>
                    <li><strong>Repeat password:</strong> <code>emovault123</code></li>
                </ul>
            </li>
            <li>Check the checkbox: <strong>"Create database with same name and grant all privileges"</strong></li>
            <li>Click <strong>"Go"</strong></li>
        </ol>
        <p>Then refresh this page or go to <a href="test_mysql.jsp">test_mysql.jsp</a></p>
        
        <h3>Option B: Enter the MySQL root password below</h3>
        <form method="GET">
            <label>MySQL Root Password:</label><br/>
            <input type="password" name="rootPass" placeholder="Enter root password" /><br/><br/>
            <input type="submit" value="Create User" />
        </form>
    </div>
    
    <%
        String manualPassword = request.getParameter("rootPass");
        if (manualPassword != null && !manualPassword.isEmpty()) {
            Connection conn = null;
            try {
                java.util.Properties props = new java.util.Properties();
                props.setProperty("user", "root");
                props.setProperty("password", manualPassword);
                props.setProperty("useSSL", "false");
                props.setProperty("allowPublicKeyRetrieval", "true");
                props.setProperty("serverTimezone", "UTC");
                
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", props);
                
                out.println("<div class='box success'>");
                out.println("<h2>✓ Connected as root!</h2>");
                out.println("<p>Creating user emovault_user...</p>");
                
                Statement stmt = conn.createStatement();
                stmt.execute("CREATE USER IF NOT EXISTS 'emovault_user'@'localhost' IDENTIFIED BY 'emovault123'");
                stmt.execute("GRANT ALL PRIVILEGES ON emovault_db.* TO 'emovault_user'@'localhost'");
                stmt.execute("GRANT ALL PRIVILEGES ON emovault.* TO 'emovault_user'@'localhost'");
                stmt.execute("FLUSH PRIVILEGES");
                stmt.close();
                conn.close();
                
                out.println("<p class='success'>✓ User created successfully!</p>");
                out.println("<p><strong>Next steps:</strong></p>");
                out.println("<p><a class='button' href='test_mysql.jsp'>Test Connection</a>");
                out.println("<a class='button' href='register.jsp'>Go to Registration</a></p>");
                out.println("</div>");
            } catch (Exception e) {
                out.println("<div class='box error'>");
                out.println("<h2>✗ Failed to create user</h2>");
                out.println("<p>Error: " + e.getMessage() + "</p>");
                out.println("<p>Please verify the password is correct and try again.</p>");
                out.println("</div>");
            }
        }
    %>
    
    <p><a href="register.jsp">← Back to Registration</a></p>
</body>
</html>
