package com.emovault.servlet;

import com.emovault.dao.*;
import com.emovault.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class RegretServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            request.setAttribute("error", "Database connection failed");
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

        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String action = request.getParameter("action");

        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            request.setAttribute("error", "Database connection failed");
            doGet(request, response);
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
