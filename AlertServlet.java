package com.emovault.servlet;

import com.emovault.dao.*;
import com.emovault.model.*;
import com.emovault.util.RiskAnalyzer;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class AlertServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String view = request.getParameter("view");
        if (view == null) view = "unread";

        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            request.setAttribute("error", "Database connection failed");
            request.getRequestDispatcher("alert.jsp").forward(request, response);
            return;
        }

        AlertDAO alertDAO = new AlertDAO(connection);
        RiskAnalyzer analyzer = new RiskAnalyzer(connection);

        try {
            List<Alert> alerts;

            if ("all".equals(view)) {
                alerts = alertDAO.getAllAlertsByUserId(userId);
            } else {
                alerts = alertDAO.getUnreadAlertsByUserId(userId);
            }

            // Generate fresh risk alerts
            List<Alert> riskAlerts = analyzer.generateAllRiskAlerts(userId);

            // Save risk alerts to database
            for (Alert alert : riskAlerts) {
                // Only add if not already in recent alerts
                boolean exists = alerts.stream()
                    .anyMatch(a -> a.getMessage().equals(alert.getMessage()));
                if (!exists) {
                    alertDAO.addAlert(alert);
                    alerts.add(alert);
                }
            }

            request.setAttribute("alerts", alerts);
            request.setAttribute("unreadCount", alertDAO.getUnreadAlertCount(userId));

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading alerts");
        } finally {
            try {
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("alert.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            response.sendError(500, "Database connection failed");
            return;
        }

        AlertDAO alertDAO = new AlertDAO(connection);

        try {
            // Mark as read
            if ("read".equals(action)) {
                String alertIdStr = request.getParameter("alert_id");
                if (alertIdStr != null && !alertIdStr.isEmpty()) {
                    int alertId = Integer.parseInt(alertIdStr);
                    alertDAO.markAsRead(alertId);
                }
            }
            // Delete alert
            else if ("delete".equals(action)) {
                String alertIdStr = request.getParameter("alert_id");
                if (alertIdStr != null && !alertIdStr.isEmpty()) {
                    int alertId = Integer.parseInt(alertIdStr);
                    alertDAO.deleteAlert(alertId);
                }
            }

            // Redirect back to alerts page
            response.sendRedirect("alert");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error processing alert");
        } finally {
            try {
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
