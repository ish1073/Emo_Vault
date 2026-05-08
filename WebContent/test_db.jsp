<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Connection Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; }
        .error { color: red; }
        pre { background: #f0f0f0; padding: 10px; }
    </style>
</head>
<body>
    <h1>Database Connection Diagnostic</h1>
    
    <%
        try {
            // Test 1: Try to load MySQL drivers
            String[] drivers = {
                "com.mysql.cj.jdbc.Driver",
                "com.mysql.jdbc.Driver",
                "org.mariadb.jdbc.Driver"
            };
            
            String loadedDriver = null;
            for (String driver : drivers) {
                try {
                    Class.forName(driver);
                    loadedDriver = driver;
                    out.println("<p class='success'>✓ Loaded driver: " + driver + "</p>");
                    break;
                } catch (ClassNotFoundException e) {
                    out.println("<p class='error'>✗ Could not load: " + driver + "</p>");
                }
            }
            
            if (loadedDriver == null) {
                out.println("<p class='error'>✗ No MySQL driver found in classpath!</p>");
            }
            
            // Test 2: Try to connect
            out.println("<h2>Connection Test</h2>");
            try {
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/emovault_db?useSSL=false&serverTimezone=UTC&user=root&password="
                );
                
                out.println("<p class='success'>✓ Database connection successful!</p>");
                
                // Test 3: Check if users table exists
                DatabaseMetaData meta = conn.getMetaData();
                ResultSet tables = meta.getTables(null, null, "users", null);
                if (tables.next()) {
                    out.println("<p class='success'>✓ users table found</p>");
                } else {
                    out.println("<p class='error'>✗ users table NOT found</p>");
                }
                
                conn.close();
            } catch (SQLException e) {
                out.println("<p class='error'>✗ Connection failed: " + e.getMessage() + "</p>");
                out.println("<pre>" + e.toString() + "</pre>");
            }
            
        } catch (Exception e) {
            out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            out.println("<pre>" + e.toString() + "</pre>");
        }
    %>
    
    <h2>Info</h2>
    <p>Java Version: <%= System.getProperty("java.version") %></p>
    <p>Tomcat Home: <%= System.getenv("CATALINA_HOME") %></p>
</body>
</html>
