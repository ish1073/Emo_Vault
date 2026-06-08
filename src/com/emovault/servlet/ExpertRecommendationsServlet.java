package com.emovault.servlet;

import com.emovault.dao.RecommendationDAO;
import com.emovault.service.ExpertAnalyticsService;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * ExpertRecommendationsServlet - Handles expert recommendation management
 * Allows experts to create, view, and manage recommendations for users
 */
@WebServlet("/expert/recommendations")
public class ExpertRecommendationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ExpertAnalyticsService analyticsService = new ExpertAnalyticsService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if expert is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("expertId") == null) {
            response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
            return;
        }
        
        int expertId = (Integer) session.getAttribute("expertId");
        String action = request.getParameter("action");
        
        // Ensure recommendations table exists
        RecommendationDAO.createRecommendationsTable();
        
        if ("view".equals(action)) {
            // View recommendations for a specific user
            int userId = Integer.parseInt(request.getParameter("userId"));
            List<Map<String, Object>> userRecommendations = 
                new RecommendationDAO().getRecommendationsForUser(userId, 20);
            request.setAttribute("userRecommendations", userRecommendations);
            request.setAttribute("selectedUserId", userId);
        } else if ("history".equals(action)) {
            // View expert's recommendation history
            List<Map<String, Object>> expertRecommendations = 
                new RecommendationDAO().getRecommendationsByExpert(expertId, 50);
            Map<String, Object> stats = new RecommendationDAO().getRecommendationStats(expertId);
            List<Map<String, Object>> categories = new RecommendationDAO().getRecommendationsByCategory(expertId);
            
            request.setAttribute("expertRecommendations", expertRecommendations);
            request.setAttribute("recommendationStats", stats);
            request.setAttribute("recommendationCategories", categories);
        } else {
            // Default: show recommendation dashboard
            List<Map<String, Object>> expertRecommendations = 
                new RecommendationDAO().getRecommendationsByExpert(expertId, 20);
            Map<String, Object> stats = new RecommendationDAO().getRecommendationStats(expertId);
            List<Map<String, Object>> categories = new RecommendationDAO().getRecommendationsByCategory(expertId);
            
            // Get users who might need recommendations
            List<Map<String, Object>> highRiskUsers = analyticsService.getHighRiskUsers(10);
            List<Map<String, Object>> attentionUsers = analyticsService.getUsersNeedingAttention(10);
            
            request.setAttribute("expertRecommendations", expertRecommendations);
            request.setAttribute("recommendationStats", stats);
            request.setAttribute("recommendationCategories", categories);
            request.setAttribute("highRiskUsers", highRiskUsers);
            request.setAttribute("attentionUsers", attentionUsers);
        }
        
        request.getRequestDispatcher("expert_recommendations.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if expert is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("expertId") == null) {
            response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
            return;
        }
        
        int expertId = (Integer) session.getAttribute("expertId");
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                handleCreateRecommendation(request, response, expertId);
            } else if ("deactivate".equals(action)) {
                handleDeactivateRecommendation(request, response, expertId);
            } else {
                response.sendRedirect(request.getContextPath() + "/expert/recommendations");
            }
        } catch (Exception e) {
            System.err.println("Error in ExpertRecommendationsServlet: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/expert/recommendations");
        }
    }
    
    /**
     * Handle creating a new recommendation
     */
    private void handleCreateRecommendation(HttpServletRequest request, HttpServletResponse response,
                                           int expertId) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String type = request.getParameter("type");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        int priority = Integer.parseInt(request.getParameter("priority"));
        
        RecommendationDAO dao = new RecommendationDAO();
        int recommendationId = dao.createRecommendation(expertId, userId, type, title, content, category, priority);
        
        if (recommendationId > 0) {
            System.out.println("✓ Recommendation created with ID: " + recommendationId);
        }
        
        response.sendRedirect(request.getContextPath() + "/expert/recommendations");
    }
    
    /**
     * Handle deactivating a recommendation
     */
    private void handleDeactivateRecommendation(HttpServletRequest request, HttpServletResponse response,
                                               int expertId) throws IOException {
        int recommendationId = Integer.parseInt(request.getParameter("recommendationId"));
        
        RecommendationDAO dao = new RecommendationDAO();
        boolean success = dao.deactivateRecommendation(recommendationId, expertId);
        
        if (success) {
            System.out.println("✓ Recommendation " + recommendationId + " deactivated");
        }
        
        response.sendRedirect(request.getContextPath() + "/expert/recommendations");
    }
}