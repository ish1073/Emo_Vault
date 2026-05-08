package com.emovault.servlet;

import com.emovault.dao.TimeCapsuleDAO;
import com.emovault.model.TimeCapsule;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * TimeCapsuleServlet - Handles time capsule operations
 * GET: Display time capsule page
 * POST: Create capsule, open capsule, add reflection
 */
public class TimeCapsuleServlet extends HttpServlet {
    private TimeCapsuleDAO capsuleDAO = new TimeCapsuleDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = req.getSession(false);
        Integer userId = (Integer) (session != null ? session.getAttribute("userId") : null);
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        // Retrieve all time capsules for this user
        List<TimeCapsule> capsules = capsuleDAO.getUserCapsules(userId);
        req.setAttribute("capsules", capsules);
        
        // Forward to time capsule page
        req.getRequestDispatcher("timecapsule.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = req.getSession(false);
        Integer userId = (Integer) (session != null ? session.getAttribute("userId") : null);
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get action parameter
        String action = req.getParameter("action");
        
        if ("create".equals(action)) {
            handleCreateCapsule(req, resp, userId);
        } else if ("open".equals(action)) {
            handleOpenCapsule(req, resp, userId);
        } else if ("reflect".equals(action)) {
            handleAddReflection(req, resp, userId);
        } else if ("delete".equals(action)) {
            handleDeleteCapsule(req, resp, userId);
        } else {
            doGet(req, resp);
        }
    }
    
    private void handleCreateCapsule(HttpServletRequest req, HttpServletResponse resp, int userId) 
            throws ServletException, IOException {
        
        String message = req.getParameter("message");
        String goal = req.getParameter("goal");
        String mood = req.getParameter("mood");
        String targetDateStr = req.getParameter("targetDate");
        
        // Validation
        if (message == null || message.trim().isEmpty()) {
            req.setAttribute("error", "Please provide a message for your future self");
            doGet(req, resp);
            return;
        }
        
        if (targetDateStr == null || targetDateStr.isEmpty()) {
            req.setAttribute("error", "Please select a target date");
            doGet(req, resp);
            return;
        }
        
        if (mood == null || mood.trim().isEmpty()) {
            req.setAttribute("error", "Please select your current mood");
            doGet(req, resp);
            return;
        }
        
        try {
            // Parse target date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date utilDate = sdf.parse(targetDateStr);
            Timestamp targetDate = new Timestamp(utilDate.getTime());
            
            // Check if target date is in the future
            if (targetDate.before(new Timestamp(System.currentTimeMillis()))) {
                req.setAttribute("error", "Target date must be in the future");
                doGet(req, resp);
                return;
            }
            
            // Create capsule with mood
            int capsuleId = capsuleDAO.saveTimeCapsule(userId, message.trim(), goal, mood.trim(), targetDate);
            
            if (capsuleId > 0) {
                System.out.println("[TimeCapsuleServlet] Capsule #" + capsuleId + " created for user " + userId + " with mood: " + mood);
                req.setAttribute("success", "⏳ Time capsule sealed! It will open on " + targetDateStr);
            } else {
                req.setAttribute("error", "Failed to create time capsule. Please try again.");
            }
        } catch (Exception e) {
            System.err.println("[TimeCapsuleServlet] Error creating capsule: " + e.getMessage());
            req.setAttribute("error", "An error occurred while creating your capsule");
        }
        
        doGet(req, resp);
    }
    
    private void handleOpenCapsule(HttpServletRequest req, HttpServletResponse resp, int userId) 
            throws ServletException, IOException {
        
        String capsuleIdStr = req.getParameter("capsuleId");
        
        if (capsuleIdStr == null || capsuleIdStr.isEmpty()) {
            doGet(req, resp);
            return;
        }
        
        try {
            int capsuleId = Integer.parseInt(capsuleIdStr);
            TimeCapsule capsule = capsuleDAO.getCapsule(capsuleId, userId);
            
            if (capsule == null) {
                req.setAttribute("error", "Capsule not found");
                doGet(req, resp);
                return;
            }
            
            // Check if can be opened
            if (!capsule.canBeOpened()) {
                req.setAttribute("error", "This capsule is not ready to open yet. Opens on " + capsule.getTargetDate());
                doGet(req, resp);
                return;
            }
            
            // Mark as opened
            if (capsuleDAO.openCapsule(capsuleId, userId)) {
                System.out.println("[TimeCapsuleServlet] Capsule #" + capsuleId + " opened by user " + userId);
                req.setAttribute("success", "🌟 Your capsule has been opened! Add your reflection below.");
                req.setAttribute("openedCapsuleId", capsuleId);
            } else {
                req.setAttribute("error", "Failed to open capsule");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid capsule ID");
        }
        
        doGet(req, resp);
    }
    
    private void handleAddReflection(HttpServletRequest req, HttpServletResponse resp, int userId) 
            throws ServletException, IOException {
        
        String capsuleIdStr = req.getParameter("capsuleId");
        String reflection = req.getParameter("reflection");
        String achievementStatus = req.getParameter("achievementStatus");
        String reflectionMood = req.getParameter("reflectionMood");
        
        if (capsuleIdStr == null || capsuleIdStr.isEmpty() || reflection == null || reflection.trim().isEmpty()) {
            req.setAttribute("error", "Please provide a reflection");
            doGet(req, resp);
            return;
        }
        
        try {
            int capsuleId = Integer.parseInt(capsuleIdStr);
            
            if (capsuleDAO.addReflection(capsuleId, userId, reflection.trim(), achievementStatus, reflectionMood)) {
                System.out.println("[TimeCapsuleServlet] Reflection added to capsule #" + capsuleId + " with mood: " + reflectionMood);
                req.setAttribute("success", "✨ Your reflection has been saved!");
            } else {
                req.setAttribute("error", "Failed to save reflection");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid capsule ID");
        }
        
        doGet(req, resp);
    }
    
    private void handleDeleteCapsule(HttpServletRequest req, HttpServletResponse resp, int userId) 
            throws ServletException, IOException {
        
        String capsuleIdStr = req.getParameter("capsuleId");
        
        if (capsuleIdStr == null || capsuleIdStr.isEmpty()) {
            doGet(req, resp);
            return;
        }
        
        try {
            int capsuleId = Integer.parseInt(capsuleIdStr);
            
            if (capsuleDAO.deleteCapsule(capsuleId, userId)) {
                System.out.println("[TimeCapsuleServlet] Capsule #" + capsuleId + " deleted");
                req.setAttribute("success", "Time capsule has been deleted");
            } else {
                req.setAttribute("error", "Failed to delete capsule");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid capsule ID");
        }
        
        doGet(req, resp);
    }
}
