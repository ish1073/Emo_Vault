package com.emovault.servlet;

import com.emovault.dao.*;
import com.emovault.model.*;
import com.emovault.util.RiskAnalyzer;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class HabitServlet extends HttpServlet {
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
            request.getRequestDispatcher("habit.jsp").forward(request, response);
            return;
        }

        HabitDAO habitDAO = new HabitDAO(connection);
        RiskAnalyzer analyzer = new RiskAnalyzer(connection);

        try {
            // Get all habits for user
            List<Habit> habits = habitDAO.getAllHabitsByUserId(userId);
            request.setAttribute("habits", habits);

            // Get habit suggestions based on regrets
            List<String> suggestions = analyzer.suggestHabitsFromRegrets(userId);
            request.setAttribute("habitSuggestions", suggestions);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading habits");
        } finally {
            try {
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("habit.jsp").forward(request, response);
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

        HabitDAO habitDAO = new HabitDAO(connection);

        try {
            // Add new habit
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String suggestedByTag = request.getParameter("suggested_by_tag");

                if (name == null || name.isEmpty()) {
                    request.setAttribute("error", "Habit name is required");
                } else {
                    Habit habit = new Habit();
                    habit.setUserId(userId);
                    habit.setName(name);
                    habit.setDescription(description != null ? description : "");
                    habit.setSuggestedByTag(suggestedByTag != null ? suggestedByTag : "");
                    habit.setActive(true);

                    if (habitDAO.addHabit(habit)) {
                        request.setAttribute("success", "Habit added successfully");
                    } else {
                        request.setAttribute("error", "Failed to add habit");
                    }
                }
            }
            // Complete habit today
            else if ("complete".equals(action)) {
                String habitIdStr = request.getParameter("habit_id");
                if (habitIdStr != null && !habitIdStr.isEmpty()) {
                    int habitId = Integer.parseInt(habitIdStr);
                    if (habitDAO.completeHabitToday(habitId)) {
                        request.setAttribute("success", "Great! Habit completed today");
                    } else {
                        request.setAttribute("error", "Failed to complete habit");
                    }
                }
            }
            // Delete habit
            else if ("delete".equals(action)) {
                String habitIdStr = request.getParameter("habit_id");
                if (habitIdStr != null && !habitIdStr.isEmpty()) {
                    int habitId = Integer.parseInt(habitIdStr);
                    if (habitDAO.deleteHabit(habitId)) {
                        request.setAttribute("success", "Habit deleted successfully");
                    } else {
                        request.setAttribute("error", "Failed to delete habit");
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
