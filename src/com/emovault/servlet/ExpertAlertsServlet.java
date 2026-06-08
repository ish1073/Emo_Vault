package com.emovault.servlet;

import com.emovault.service.ExpertAnalyticsService;
import com.emovault.dao.AlertDAO;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * ExpertAlertsServlet - Real-time emotional risk alerts for experts
 * Shows dynamically generated alerts from actual user activity
 */
@WebServlet("/expert/alerts")
public class ExpertAlertsServlet extends HttpServlet {
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
        
        String filter = request.getParameter("filter");
        if (filter == null) {
            filter = "all";
        }
        
        // Get recent alerts from actual user activity
        List<Map<String, Object>> recentAlerts = analyticsService.getRecentAlerts(50);
        
        // Filter alerts based on severity
        List<Map<String, Object>> filteredAlerts = new ArrayList<>();
        for (Map<String, Object> alert : recentAlerts) {
            if ("all".equals(filter) || filter.equals(alert.get("severity"))) {
                filteredAlerts.add(alert);
            }
        }
        
        // Get alert statistics
        Map<String, Integer> alertStats = new HashMap<>();
        int highCount = 0, mediumCount = 0, lowCount = 0, resolvedCount = 0;
        
        for (Map<String, Object> alert : recentAlerts) {
            String severity = (String) alert.get("severity");
            boolean isResolved = (Boolean) alert.get("isResolved");
            
            if ("high".equals(severity)) highCount++;
            else if ("medium".equals(severity)) mediumCount++;
            else if ("low".equals(severity)) lowCount++;
            
            if (isResolved) resolvedCount++;
        }
        
        alertStats.put("high", highCount);
        alertStats.put("medium", mediumCount);
        alertStats.put("low", lowCount);
        alertStats.put("resolved", resolvedCount);
        alertStats.put("total", recentAlerts.size());
        
        // Get users with emotional spikes (potential alert triggers)
        List<Map<String, Object>> emotionalSpikes = analyticsService.getRecentEmotionalSpikes(20);
        
        // Get high risk users (may need proactive alerts)
        List<Map<String, Object>> highRiskUsers = analyticsService.getHighRiskUsers(10);
        
        request.setAttribute("alerts", filteredAlerts);
        request.setAttribute("alertStats", alertStats);
        request.setAttribute("currentFilter", filter);
        request.setAttribute("emotionalSpikes", emotionalSpikes);
        request.setAttribute("highRiskUsers", highRiskUsers);
        
        request.getRequestDispatcher("expert_alerts.jsp").forward(request, response);
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
        
        String action = request.getParameter("action");
        
        if ("resolve".equals(action)) {
            handleResolveAlert(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/expert/alerts");
        }
    }
    
    /**
     * Mark an alert as resolved
     */
    private void handleResolveAlert(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int alertId = Integer.parseInt(request.getParameter("alertId"));
        
        AlertDAO alertDAO = new AlertDAO();
        boolean success = alertDAO.markAlertAsResolved(alertId);
        
        if (success) {
            System.out.println("✓ Alert " + alertId + " marked as resolved");
        }
        
        response.sendRedirect(request.getContextPath() + "/expert/alerts");
    }
}