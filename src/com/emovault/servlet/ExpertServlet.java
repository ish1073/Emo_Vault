package com.emovault.servlet;

import com.emovault.dao.ExpertDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * ExpertServlet - Handles Expert System authentication and access
 */
public class ExpertServlet extends HttpServlet {
    
    private ExpertDAO expertDAO = new ExpertDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            handleExpertLogin(request, response);
        } else if ("logout".equals(action)) {
            handleExpertLogout(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
        }
    }
    
    /**
     * Handle Expert login using email
     */
    private void handleExpertLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        
        // Validate input
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/expert_login.jsp?error=invalid");
            return;
        }
        
        // Trim and normalize email
        email = email.trim().toLowerCase();
        
        // Verify credentials using email
        int id = expertDAO.verifyExpertCredentialsByEmail(email, password);
        
        if (id > 0) {
            // Credentials valid - create session
            HttpSession session = request.getSession();
            session.setAttribute("expertId", id);
            session.setAttribute("expertEmail", email);
            
            // Get expert info
            String[] expertInfo = expertDAO.getExpertInfo(id);
            if (expertInfo != null) {
                session.setAttribute("expertName", expertInfo[0]);
                session.setAttribute("expertRole", expertInfo[1]);
            } else {
                // Fallback if info not found
                session.setAttribute("expertName", "Expert");
                session.setAttribute("expertRole", "EXPERT");
            }
            
            // Set session timeout (30 minutes)
            session.setMaxInactiveInterval(30 * 60);
            
            // Remember me - set persistent cookie (store email, not expert ID)
            if ("true".equals(rememberMe)) {
                Cookie cookie = new Cookie("expertRemember", email);
                cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                cookie.setPath(request.getContextPath());
                cookie.setHttpOnly(true);
                cookie.setSecure(request.isSecure());
                response.addCookie(cookie);
            }
            
            // Log activity
            expertDAO.logExpertActivity(id, "LOGIN", request.getRemoteAddr());
            expertDAO.updateLastLogin(id);
            
            System.out.println("[ExpertServlet] Expert " + email + " logged in successfully");
            response.sendRedirect(request.getContextPath() + "/expert_dashboard");
        } else {
            // Invalid credentials
            System.out.println("[ExpertServlet] Failed login attempt for: " + email);
            response.sendRedirect(request.getContextPath() + "/expert_login.jsp?error=invalid");
        }
    }
    
    /**
     * Handle Expert logout
     */
    private void handleExpertLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        String expertEmail = null;
        Integer expertIdNum = null;
        
        if (session != null) {
            expertEmail = (String) session.getAttribute("expertEmail");
            expertIdNum = (Integer) session.getAttribute("expertId");
            
            if (expertIdNum != null) {
                expertDAO.logExpertActivity(expertIdNum, "LOGOUT", request.getRemoteAddr());
            }
            
            session.invalidate();
        }
        
        // Clear remember-me cookie
        Cookie cookie = new Cookie("expertRemember", "");
        cookie.setMaxAge(0);
        cookie.setPath(request.getContextPath());
        response.addCookie(cookie);
        
        System.out.println("[ExpertServlet] Expert logged out: " + (expertEmail != null ? expertEmail : "unknown"));
        response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            handleExpertLogout(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
        }
    }
}
