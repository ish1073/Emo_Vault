<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String role = request.getParameter("role");
    
    if (name == null || name.trim().isEmpty() ||
        email == null || email.trim().isEmpty() ||
        password == null || password.trim().isEmpty() ||
        confirmPassword == null || confirmPassword.trim().isEmpty() ||
        role == null) {
        session.setAttribute("alertMessage", "All fields are required");
        session.setAttribute("alertType", "error");
        response.sendRedirect(request.getContextPath() + "/register.jsp");
        return;
    }
    
    if (!password.equals(confirmPassword)) {
        session.setAttribute("alertMessage", "Passwords do not match");
        session.setAttribute("alertType", "error");
        response.sendRedirect(request.getContextPath() + "/register.jsp");
        return;
    }
    
    if (password.length() < 6) {
        session.setAttribute("alertMessage", "Password must be at least 6 characters");
        session.setAttribute("alertType", "error");
        response.sendRedirect(request.getContextPath() + "/register.jsp");
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
        
        // Check if email exists
        PreparedStatement checkStmt = conn.prepareStatement("SELECT id FROM users WHERE email = ?");
        checkStmt.setString(1, email.trim());
        ResultSet rs = checkStmt.executeQuery();
        boolean emailExists = rs.next();
        rs.close();
        checkStmt.close();
        
        if (emailExists) {
            conn.close();
            session.setAttribute("alertMessage", "Email already registered");
            session.setAttribute("alertType", "error");
            response.sendRedirect(request.getContextPath() + "/register.jsp");
            return;
        }
        
        // Insert new user
        PreparedStatement insertStmt = conn.prepareStatement(
            "INSERT INTO users (name, email, password, role, created_at) VALUES (?, ?, MD5(?), ?, NOW())"
        );
        insertStmt.setString(1, name.trim());
        insertStmt.setString(2, email.trim());
        insertStmt.setString(3, password);
        insertStmt.setString(4, role.equals("expert") ? "expert" : "user");
        
        int result = insertStmt.executeUpdate();
        insertStmt.close();
        conn.close();
        
        if (result > 0) {
            session.setAttribute("alertMessage", "? Account created successfully! Please login.");
            session.setAttribute("alertType", "success");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            session.setAttribute("alertMessage", "Failed to create account");
            session.setAttribute("alertType", "error");
            response.sendRedirect(request.getContextPath() + "/register.jsp");
        }
        
    } catch (SQLException e) {
        session.setAttribute("alertMessage", "Database error: " + e.getMessage());
        session.setAttribute("alertType", "error");
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    } catch (Exception e) {
        session.setAttribute("alertMessage", "Error: " + e.getMessage());
        session.setAttribute("alertType", "error");
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    } finally {
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {}
    }
%>
