package com.emovault.servlet;

import com.emovault.model.Alert;
import com.emovault.dao.AlertDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * AlertServlet - HTTP handler for alert operations
 * Handles GET (retrieve alerts) and POST (dismiss alerts)
 */
public class AlertServlet extends HttpServlet {
    private AlertDAO alertDAO;
    
    @Override
    public void init() {
        this.alertDAO = new AlertDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Prevent caching to always show fresh data
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get unread alerts
            List<Alert> alerts = alertDAO.getUnreadAlerts(userId);
            
            request.setAttribute("alerts", alerts);
            request.setAttribute("unreadCount", alertDAO.getUnreadAlertCount(userId));
            
            System.out.println("[AlertServlet] Loaded " + alerts.size() + " alerts for user: " + userId);
            
            request.getRequestDispatcher("alerts.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("[AlertServlet] Error loading alerts: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading alerts");
            request.getRequestDispatcher("alerts.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("dismiss".equals(action)) {
            String alertId = request.getParameter("alert_id");
            
            try {
                alertDAO.dismissAlert(alertId);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"success\": true}");
                System.out.println("[AlertServlet] Dismissed alert: " + alertId);
            } catch (Exception e) {
                System.err.println("[AlertServlet] Error dismissing alert: " + e.getMessage());
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            }
        }
    }
}
