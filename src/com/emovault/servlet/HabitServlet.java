package com.emovault.servlet;

import com.emovault.dao.HabitDAO;
import com.emovault.model.Habit;
import com.emovault.util.DBConnection;
import com.emovault.util.Expert;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

/**
 * HabitServlet - Handles habit tracking and management
 * Integrates with Expert system for personalized recommendations
 */
public class HabitServlet extends HttpServlet {
    
    @Override
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
            
            if (connection == null) {
                request.setAttribute("error", "Database connection failed");
                request.getRequestDispatcher("habit.jsp").forward(request, response);
                return;
            }

            HabitDAO habitDAO = new HabitDAO(connection);
            List<Habit> habits = habitDAO.getAllHabitsByUserId(userId);
            
            // Populate streak and completion data for each habit
            for (Habit habit : habits) {
                int streak = habitDAO.getCurrentStreakSimple(habit.getHabitId());
                habit.setCurrentStreak(streak);
                
                boolean completedToday = habitDAO.isCompletedToday(habit.getHabitId());
                
                int totalCompletions = habitDAO.getTotalCompletions(habit.getHabitId());
                int consistency = (totalCompletions > 0) ? Math.min(100, totalCompletions * 10) : 0;
                habit.setConsistencyScore(consistency);
                
                System.out.println("[HabitServlet] Habit " + habit.getHabitId() + ": Streak=" + streak + ", CompletedToday=" + completedToday + ", Consistency=" + consistency);
            }
            
            // Create map of completed habits for JSP
            java.util.Map<Integer, Boolean> completedTodayMap = new java.util.HashMap<>();
            for (Habit habit : habits) {
                completedTodayMap.put(habit.getHabitId(), habitDAO.isCompletedToday(habit.getHabitId()));
            }
            request.setAttribute("completedTodayMap", completedTodayMap);
            
            request.setAttribute("habits", habits);
            
            // Generate expert suggestions for habit building
            Expert expert = new Expert();
            
            if (habits.isEmpty()) {
                String suggestion = expert.generateSuggestion("motivation");
                request.setAttribute("expertSuggestion", suggestion);
            } else {
                // Check total active habits and suggest building more if needed
                long activeHabits = habits.stream().filter(Habit::isActive).count();
                if (activeHabits >= 3) {
                    String suggestion = expert.generateSuggestion("procrastination");
                    request.setAttribute("expertSuggestion", suggestion);
                } else {
                    String suggestion = expert.generateSuggestion("habit building");
                    request.setAttribute("expertSuggestion", suggestion);
                }
            }
            
            // Add expert recommendations list
            request.setAttribute("expertRecommendations", expert.getRecommendations());
            
            System.out.println("[HabitServlet] Loaded " + habits.size() + " habits for user: " + userId);
            
        } catch (SQLException e) {
            System.err.println("[HabitServlet] SQL Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading habits: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("[HabitServlet] Unexpected Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred");
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    System.err.println("[HabitServlet] Error closing connection: " + e.getMessage());
                }
            }
        }

        request.getRequestDispatcher("habit.jsp").forward(request, response);
    }

    @Override
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
            
            if (connection == null) {
                response.sendRedirect(request.getContextPath() + "/habit");
                return;
            }

            HabitDAO habitDAO = new HabitDAO(connection);

            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                
                System.out.println("[HabitServlet] Creating habit - Name: " + name + ", Description: " + description);
                
                if (name != null && !name.trim().isEmpty()) {
                    Habit habit = new Habit();
                    habit.setUserId(userId);
                    habit.setName(name.trim());
                    habit.setDescription(description != null ? description.trim() : "");
                    habit.setActive(true);
                    
                    boolean success = habitDAO.addHabit(habit);
                    if (success) {
                        System.out.println("[HabitServlet] ✓ New habit added successfully: " + name + " (User: " + userId + ")");
                    } else {
                        System.out.println("[HabitServlet] ✗ Failed to add habit: " + name + " (User: " + userId + ")");
                    }
                } else {
                    System.out.println("[HabitServlet] ✗ Habit name is empty or null");
                }
            } else if ("complete".equals(action)) {
                try {
                    int habitId = Integer.parseInt(request.getParameter("habitId"));
                    System.out.println("[HabitServlet] Processing complete action for habit: " + habitId);
                    boolean isCompleted = habitDAO.completeHabitToday(habitId);
                    if (isCompleted) {
                        System.out.println("[HabitServlet] ✓ Habit marked complete: " + habitId);
                        int newStreak = habitDAO.getCurrentStreakSimple(habitId);
                        System.out.println("[HabitServlet] New streak after completion: " + newStreak);
                    } else {
                        System.out.println("[HabitServlet] ⚠ Habit completion may have failed or already completed today: " + habitId);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("[HabitServlet] Invalid habit ID: " + e.getMessage());
                    e.printStackTrace();
                }
            } else if ("delete".equals(action)) {
                try {
                    int habitId = Integer.parseInt(request.getParameter("habitId"));
                    if (habitDAO.deleteHabit(habitId)) {
                        System.out.println("[HabitServlet] Habit deleted: " + habitId);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("[HabitServlet] Invalid habit ID: " + e.getMessage());
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[HabitServlet] SQL Error in POST: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("[HabitServlet] Unexpected Error in POST: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    System.err.println("[HabitServlet] Error closing connection: " + e.getMessage());
                }
            }
        }

        // Redirect back to habit page
        response.sendRedirect(request.getContextPath() + "/habit");
    }
}
