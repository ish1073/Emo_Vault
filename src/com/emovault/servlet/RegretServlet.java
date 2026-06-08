package com.emovault.servlet;

import com.emovault.dao.*;
import com.emovault.model.*;
import com.emovault.service.DataService;
import com.emovault.util.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class RegretServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Prevent caching to always show fresh data
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (connection == null) {
            request.getRequestDispatcher("regret.jsp").forward(request, response);
            return;
        }

        RegretDAO regretDAO = new RegretDAO(connection);

        // Get all regrets for user
        List<Regret> regrets = regretDAO.getAllRegretsByUserId(userId);
        request.setAttribute("regrets", regrets);

        // Get tag frequency for insights
        request.setAttribute("tagFrequency", regretDAO.getTagFrequency(userId));

        try {
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("regret.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (connection == null) {
            request.getRequestDispatcher("regret.jsp").forward(request, response);
            return;
        }

        RegretDAO regretDAO = new RegretDAO(connection);

        try {
            // Add new regret
            if ("add".equals(action)) {
                String description = request.getParameter("description");
                String lessonLearned = request.getParameter("lesson_learned");
                String tag = request.getParameter("tag");

                if (description == null || description.isEmpty() || tag == null || tag.isEmpty()) {
                    request.setAttribute("error", "Description and tag are required");
                } else {
                    Regret regret = new Regret();
                    regret.setUserId(userId);
                    regret.setDescription(description);
                    regret.setLessonLearned(lessonLearned != null ? lessonLearned : "");
                    regret.setTag(tag);

                    if (regretDAO.addRegret(regret)) {
                        // Clear cache to ensure fresh analysis data
                        DataService.clearUserCache(userId);
                        request.setAttribute("success", "Regret added successfully");
                    } else {
                        request.setAttribute("error", "Failed to add regret");
                    }
                }
            }
            // Delete regret
            else if ("delete".equals(action)) {
                String regretIdStr = request.getParameter("regret_id");
                if (regretIdStr != null && !regretIdStr.isEmpty()) {
                    int regretId = Integer.parseInt(regretIdStr);
                    if (regretDAO.deleteRegret(regretId)) {
                        // Clear cache to ensure fresh analysis data
                        DataService.clearUserCache(userId);
                        request.setAttribute("success", "Regret deleted successfully");
                    } else {
                        request.setAttribute("error", "Failed to delete regret");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Redirect back to get method to refresh the list
        doGet(request, response);
    }
}
