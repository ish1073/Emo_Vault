<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<!DOCTYPE html>
<html>
<head>
    <title>Setup Database</title>
    <style>
        body { font-family: Arial; margin: 20px; max-width: 900px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .box { border: 1px solid #ccc; padding: 15px; margin: 15px 0; border-radius: 5px; background: #f9f9f9; }
        pre { background: #f5f5f5; padding: 10px; border-radius: 5px; overflow-x: auto; }
        input[type="password"] { padding: 5px; width: 200px; }
        input[type="submit"] { padding: 10px 20px; background: #679F9F; color: white; border: none; border-radius: 5px; cursor: pointer; }
    </style>
</head>
<body>
    <h1>EmoVault Database Setup</h1>
    
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
                out.println("<p>Creating database emovault_db...</p>");
                
                Statement stmt = conn.createStatement();
                
                // Create database
                stmt.execute("CREATE DATABASE IF NOT EXISTS emovault_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                out.println("<p>✓ Created database emovault_db</p>");
                
                // Use the database
                stmt.execute("USE emovault_db");
                
                // Create users table
                stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY," +
                    "name VARCHAR(100) NOT NULL," +
                    "email VARCHAR(100) UNIQUE NOT NULL," +
                    "password VARCHAR(255) NOT NULL," +
                    "role VARCHAR(50) DEFAULT 'user'," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                    ")");
                out.println("<p>✓ Created users table</p>");
                
                // Create emotion_entries table
                stmt.execute("CREATE TABLE IF NOT EXISTS emotion_entries (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY," +
                    "user_id INT NOT NULL," +
                    "mood VARCHAR(50)," +
                    "intensity INT," +
                    "`trigger` VARCHAR(500)," +
                    "`response` TEXT," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                    ")");
                out.println("<p>✓ Created emotion_entries table</p>");
                
                // Create diary entries table
                stmt.execute("CREATE TABLE IF NOT EXISTS diary_entries (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY," +
                    "user_id INT NOT NULL," +
                    "title VARCHAR(200)," +
                    "content TEXT," +
                    "mood VARCHAR(50)," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                    ")");
                out.println("<p>✓ Created diary_entries table</p>");
                
                stmt.close();
                conn.close();
                
                out.println("<p class='success'><strong>✓ Database setup complete!</strong></p>");
                out.println("<p><strong>Next steps:</strong></p>");
                out.println("<p><a href='test_mysql.jsp' style='display:inline-block;padding:10px 20px;background:#679F9F;color:white;text-decoration:none;border-radius:5px;'>Test Connection</a> ");
                out.println("<a href='register.jsp' style='display:inline-block;padding:10px 20px;background:#679F9F;color:white;text-decoration:none;border-radius:5px;'>Go to Registration</a></p>");
                out.println("</div>");
            } catch (Exception e) {
                out.println("<div class='box error'>");
                out.println("<h2>✗ Failed to setup database</h2>");
                out.println("<p>Error: " + e.getMessage() + "</p>");
                out.println("</div>");
            }
        } else {
            out.println("<div class='box'>");
            out.println("<h2>Create Database</h2>");
            out.println("<p>The database 'emovault_db' needs to be created. Enter your MySQL root password:</p>");
            out.println("<form method='GET'>");
            out.println("<label>MySQL Root Password:</label><br/>");
            out.println("<input type='password' name='rootPass' placeholder='Enter root password' /><br/><br/>");
            out.println("<input type='submit' value='Create Database' />");
            out.println("</form>");
            out.println("</div>");
        }
    %>
    
    <p><a href="register.jsp">← Back to Registration</a></p>
</body>
</html>
