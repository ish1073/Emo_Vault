package com.emovault.servlet;

import com.emovault.dao.EmotionDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * EmotionServlet - Handles emotion logging
 * GET: Forward to emotion.jsp (requires login)
 * POST: Process emotion form submission
 */
public class EmotionServlet extends HttpServlet {
    private EmotionDAO emotionDAO = new EmotionDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Prevent caching to always show fresh data
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        
        HttpSession session = req.getSession(false);
        Integer userId = (Integer) (session != null ? session.getAttribute("userId") : null);
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        req.getRequestDispatcher("emotion.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Prevent caching
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        
        // Check session
        HttpSession session = req.getSession(false);
        Integer userId = (Integer) (session != null ? session.getAttribute("userId") : null);
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get form parameters
        String trigger = req.getParameter("trigger");
        String mood = req.getParameter("mood");
        String intensityStr = req.getParameter("intensity");
        String response = req.getParameter("response");
        
        // Validation
        if (trigger == null || trigger.trim().length() < 3) {
            req.setAttribute("error", "Please provide a trigger (minimum 3 characters)");
            req.getRequestDispatcher("emotion.jsp").forward(req, resp);
            return;
        }
        
        if (mood == null || mood.trim().isEmpty()) {
            req.setAttribute("error", "Please select a mood");
            req.getRequestDispatcher("emotion.jsp").forward(req, resp);
            return;
        }
        
        if (response == null || response.trim().length() < 10) {
            req.setAttribute("error", "Please describe your response (minimum 10 characters)");
            req.getRequestDispatcher("emotion.jsp").forward(req, resp);
            return;
        }
        
        try {
            int intensity = Integer.parseInt(intensityStr);
            if (intensity < 1 || intensity > 10) {
                req.setAttribute("error", "Intensity must be between 1 and 10");
                req.getRequestDispatcher("emotion.jsp").forward(req, resp);
                return;
            }
            
            // Save emotion
            boolean saved = emotionDAO.saveEmotion(userId, trigger.trim(), mood, intensity, response.trim());
            
            if (saved) {
                // Redirect to dashboard to see updated mood
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            } else {
                req.setAttribute("error", "Failed to save emotion. Please try again.");
                req.getRequestDispatcher("emotion.jsp").forward(req, resp);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid intensity value");
            req.getRequestDispatcher("emotion.jsp").forward(req, resp);
        }
    }
}
