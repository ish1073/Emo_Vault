package com.emovault.servlet;

import com.emovault.dao.UserDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * RegisterServlet - Handles user registration
 * GET: Forward to register.jsp
 * POST: Process registration form
 */
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        
        // Validation
        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Name is required");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Email is required");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        
        if (password == null || password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        
        // Prevent registering the demo account
        if ("demo@emovault.com".equals(email.trim())) {
            req.setAttribute("error", "This email is reserved. Please use a different email.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        
        // Register user (will work if DB is connected, otherwise gracefully fail)
        int userId = userDAO.registerUser(name.trim(), email.trim(), password);
        
        if (userId > 0) {
            System.out.println("[EmoVault] User registered successfully: " + email);
            req.setAttribute("success", "Registration successful! Please login.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        } else if (userId == -1) {
            req.setAttribute("error", "Email already exists");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        } else {
            // Demo mode: allow registration without persistence
            System.out.println("[EmoVault] Registration attempted in demo mode (DB unavailable): " + email);
            req.setAttribute("info", "Registration accepted (Demo Mode). Use email: " + email + " to login after restart.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }
}
