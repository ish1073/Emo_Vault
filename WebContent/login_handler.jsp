<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
        session.setAttribute("alertMessage", "Email and password are required");
        session.setAttribute("alertType", "error");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Check for demo account first
    if ("demo@emovault.com".equals(email.trim()) && "test123".equals(password)) {
        session.setAttribute("userId", 1);
        session.setAttribute("userName", "Demo User");
        session.setAttribute("userEmail", "demo@emovault.com");
        session.setAttribute("alertMessage", "✓ Login successful! Welcome Demo User");
        session.setAttribute("alertType", "success");
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    
    Connection conn = null;
    try {
        // Use dedicated application user with MySQL 8.0 compatibility flags
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
        
        String query = "SELECT id, name FROM users WHERE email = ? AND password = MD5(?)";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, email.trim());
        stmt.setString(2, password);
        
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            Integer userId = rs.getInt("id");
            String userName = rs.getString("name");
            
            session.setAttribute("userId", userId);
            session.setAttribute("userName", userName);
            session.setAttribute("userEmail", email);
            session.setAttribute("alertMessage", "✓ Login successful! Welcome " + userName);
            session.setAttribute("alertType", "success");
            
            rs.close();
            stmt.close();
            conn.close();
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            rs.close();
            stmt.close();
            conn.close();
            session.setAttribute("alertMessage", "Invalid email or password");
            session.setAttribute("alertType", "error");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
        
    } catch (SQLException e) {
        session.setAttribute("alertMessage", "Database error: " + e.getMessage());
        session.setAttribute("alertType", "error");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    } catch (Exception e) {
        session.setAttribute("alertMessage", "Error: " + e.getMessage());
        session.setAttribute("alertType", "error");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    } finally {
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {}
    }
%>
        } else {
            rs.close();
            stmt.close();
            conn.close();
            session.setAttribute("alertMessage", "Invalid email or password");
            session.setAttribute("alertType", "error");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
        
    } catch (SQLException e) {
        session.setAttribute("alertMessage", "Database error: " + e.getMessage());
        session.setAttribute("alertType", "error");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    } catch (Exception e) {
        session.setAttribute("alertMessage", "Error: " + e.getMessage());
        session.setAttribute("alertType", "error");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    } finally {
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {}
    }
%>
