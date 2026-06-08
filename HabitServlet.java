package com.emovault.servlet;

import com.emovault.dao.*;
import com.emovault.model.*;
import com.emovault.util.RiskAnalyzer;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.util.*;

/**
 * HabitServlet - Handles habit tracking page requests with real data
 * Provides habit list, streak calculations, and completion tracking
 */
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
            // Get all habits for user with calculated stats
            List<Habit> habits = habitDAO.getHabitsWithStats(userId);
            request.setAttribute("habits", habits);

            // Get habit suggestions based on regrets
            List<String> suggestions = analyzer.suggestHabitsFromRegrets(userId);
            request.setAttribute("habitSuggestions", suggestions);

            // Build map of which habits are completed today
            Map<Integer, Boolean> completedTodayMap = new HashMap<>();
            for (Habit habit : habits) {
                boolean completedToday = habitDAO.isCompletedToday(habit.getHabitId());
                completedTodayMap.put(habit.getHabitId(), completedToday);
            }
            request.setAttribute("completedTodayMap", completedTodayMap);

            // Calculate aggregate stats for insights sidebar
            int totalHabits = habits.size();
            int activeHabits = 0;
            int totalStreak = 0;
            int maxStreak = 0;
            int totalConsistency = 0;

            for (Habit h : habits) {
                if (h.isActive()) activeHabits++;
                int streak = h.getCurrentStreak();
                totalStreak += streak;
                if (streak > maxStreak) maxStreak = streak;
                totalConsistency += h.getConsistencyScore();
            }

            double avgConsistency = totalHabits > 0 ? (double) totalConsistency / totalHabits : 0;
            double activePercentage = totalHabits > 0 ? (double) activeHabits / totalHabits * 100 : 0;

            request.setAttribute("totalHabits", totalHabits);
            request.setAttribute("activeHabits", activeHabits);
            request.setAttribute("totalStreak", totalStreak);
            request.setAttribute("maxStreak", maxStreak);
            request.setAttribute("avgConsistency", avgConsistency);
            request.setAttribute("activePercentage", activePercentage);

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
                    
                    // Verify the habit belongs to this user
                    Habit habit = habitDAO.getHabitById(habitId);
                    if (habit != null && habit.getUserId() == userId) {
                        if (habitDAO.completeHabitToday(habitId)) {
                            request.setAttribute("success", "Great! Habit completed today");
                        } else {
                            request.setAttribute("error", "Failed to complete habit");
                        }
                    } else {
                        request.setAttribute("error", "Habit not found or access denied");
                    }
                }
            }
            // Delete habit
            else if ("delete".equals(action)) {
                String habitIdStr = request.getParameter("habit_id");
                if (habitIdStr != null && !habitIdStr.isEmpty()) {
                    int habitId = Integer.parseInt(habitIdStr);
                    
                    // Verify the habit belongs to this user
                    Habit habit = habitDAO.getHabitById(habitId);
                    if (habit != null && habit.getUserId() == userId) {
                        if (habitDAO.deleteHabit(habitId)) {
                            request.setAttribute("success", "Habit deleted successfully");
                        } else {
                            request.setAttribute("error", "Failed to delete habit");
                        }
                    } else {
                        request.setAttribute("error", "Habit not found or access denied");
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