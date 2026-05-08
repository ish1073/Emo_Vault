package com.emovault.servlet;

import com.emovault.dao.UserDAO;
import com.emovault.util.DatabaseInitializer;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * LoginServlet - Handles user authentication
 * GET: Handle logout action
 * POST: Process login form
 */
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Initialize database on first access
        DatabaseInitializer.initializeDatabase();
        
        String action = req.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        // Validation
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Email is required");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }
        
        if (password == null || password.isEmpty()) {
            req.setAttribute("error", "Password is required");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }
        
        // Demo mode: Allow demo@emovault.com with password test123
        if ("demo@emovault.com".equals(email.trim()) && "test123".equals(password)) {
            HttpSession session = req.getSession(true);
            session.setAttribute("userId", 1);
            session.setAttribute("userEmail", "demo@emovault.com");
            session.setAttribute("userName", "Demo User");
            session.setMaxInactiveInterval(30 * 60);
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            System.out.println("[EmoVault] Demo user logged in (demo mode)");
            return;
        }
        
        // Try to authenticate using database
        int userId = userDAO.authenticateUser(email.trim(), password);
        
        if (userId > 0) {
            String userName = userDAO.getUserName(userId);
            
            // Create session
            HttpSession session = req.getSession(true);
            session.setAttribute("userId", userId);
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", userName);
            session.setMaxInactiveInterval(30 * 60);  // 30 minutes
            
            // Redirect to dashboard
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            req.setAttribute("error", "Invalid email or password (Demo: demo@emovault.com / test123)");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
