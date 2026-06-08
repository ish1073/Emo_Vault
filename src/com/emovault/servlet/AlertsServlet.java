package com.emovault.servlet;

import com.emovault.service.NotificationEngine;
import com.emovault.service.DataService;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * Alerts and Notifications Servlet
 * Serves real alerts generated from user activity and behavior
 * Replaces hardcoded/demo alert content
 */
@WebServlet("/alerts")
public class AlertsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        
        // Generate real alerts from actual user activity
        List<Map<String, Object>> alerts = NotificationEngine.generateUserAlerts(userId);
        
        // Also fetch saved alerts from database
        List<Map<String, Object>> savedAlerts = NotificationEngine.getSavedAlerts(userId, 10);
        
        // Combine and sort by priority
        List<Map<String, Object>> allAlerts = new ArrayList<>();
        allAlerts.addAll(alerts);
        allAlerts.addAll(savedAlerts);
        
        // Sort by priority (HIGH > MEDIUM > LOW)
        allAlerts.sort((a, b) -> {
            String priorityA = (String) a.getOrDefault("priority", "LOW");
            String priorityB = (String) b.getOrDefault("priority", "LOW");
            return getPriorityValue(priorityB) - getPriorityValue(priorityA);
        });
        
        // Format dates for JSP (convert LocalDateTime to formatted strings)
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy hh:mm a");
        for (Map<String, Object> alert : allAlerts) {
            Object createdAt = alert.get("createdAt");
            if (createdAt != null) {
                if (createdAt instanceof java.time.LocalDateTime) {
                    alert.put("formattedDate", ((java.time.LocalDateTime) createdAt).format(formatter));
                } else if (createdAt instanceof java.util.Date) {
                    alert.put("formattedDate", new java.text.SimpleDateFormat("MMM dd, yyyy hh:mm a").format((java.util.Date) createdAt));
                }
            }
        }
        
        // Set request attributes for JSP
        request.setAttribute("alerts", allAlerts);
        request.setAttribute("alertCount", allAlerts.size());
        request.setAttribute("unreadCount", countUnread(allAlerts));
        
        // Forward to alerts JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/alerts.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("mark_read".equals(action)) {
            int alertId = Integer.parseInt(request.getParameter("alert_id"));
            NotificationEngine.markAlertAsRead(alertId);
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true}");
            return;
        }
        
        // Default: redirect to GET to show alerts
        doGet(request, response);
    }
    
    /**
     * Get numeric priority value for sorting
     */
    private int getPriorityValue(String priority) {
        switch (priority) {
            case "HIGH": return 3;
            case "MEDIUM": return 2;
            case "LOW": return 1;
            default: return 0;
        }
    }
    
    /**
     * Count unread alerts
     */
    private int countUnread(List<Map<String, Object>> alerts) {
        if (alerts == null || alerts.isEmpty()) {
            return 0;
        }
        return (int) alerts.stream()
                .filter(a -> a.containsKey("is_read") && Boolean.FALSE.equals(a.get("is_read")))
                .count();
    }
}
