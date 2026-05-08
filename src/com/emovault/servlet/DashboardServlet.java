package com.emovault.servlet;

import com.emovault.model.EmotionPattern;
import com.emovault.model.Habit;
import com.emovault.util.PatternDetector;
import com.emovault.util.DBConnection;
import com.emovault.dao.EmotionDAO;
import com.emovault.dao.HabitDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * DashboardServlet - Displays emotional pattern analysis
 * Analyzes user's emotion data and shows insights
 */
public class DashboardServlet extends HttpServlet {
    private PatternDetector patternDetector = new PatternDetector();
    private EmotionDAO emotionDAO = new EmotionDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Prevent caching to always show fresh data
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        
        // Check if user is logged in
        HttpSession session = req.getSession(false);
        Integer userId = (Integer) (session != null ? session.getAttribute("userId") : null);
        
        if (userId == null) {
            // Not logged in - redirect to login page with message to come back to dashboard
            resp.sendRedirect(req.getContextPath() + "/login.jsp?returnTo=dashboard");
            return;
        }
        
        // Get today's emotion
        Map<String, Object> todayEmotion = emotionDAO.getTodayEmotion(userId);
        if (todayEmotion != null) {
            req.setAttribute("lastMood", todayEmotion.get("mood"));
            req.setAttribute("todayMoodEmoji", getMoodEmoji((String) todayEmotion.get("mood")));
            req.setAttribute("todayIntensity", todayEmotion.get("intensity"));
        } else {
            req.setAttribute("lastMood", "Not logged yet");
            req.setAttribute("todayMoodEmoji", "😐");
            req.setAttribute("todayIntensity", 0);
        }
        
        // Get emotion count
        int emotionCount = emotionDAO.getEmotionCount(userId);
        req.setAttribute("emotionCount", emotionCount);
        
        // Load habits and calculate best streak
        int bestHabitStreak = 0;
        Connection habitConnection = null;
        try {
            habitConnection = DBConnection.getConnection();
            System.out.println("[DashboardServlet] Attempting to get connection for habits...");
            if (habitConnection != null) {
                System.out.println("[DashboardServlet] Connection successful");
                HabitDAO habitDAO = new HabitDAO(habitConnection);
                List<Habit> habits = habitDAO.getAllHabitsByUserId(userId);
                System.out.println("[DashboardServlet] Found " + habits.size() + " habits for user " + userId);
                
                if (habits.isEmpty()) {
                    System.out.println("[DashboardServlet] WARNING: No habits found for user " + userId);
                } else {
                    // Calculate best streak from all habits
                    for (Habit habit : habits) {
                        System.out.println("[DashboardServlet] Processing habit ID " + habit.getHabitId() + ": " + habit.getName());
                        int streak = habitDAO.getCurrentStreakSimple(habit.getHabitId());
                        System.out.println("[DashboardServlet] Habit '" + habit.getName() + "' (ID:" + habit.getHabitId() + ") streak: " + streak);
                        if (streak > bestHabitStreak) {
                            bestHabitStreak = streak;
                            System.out.println("[DashboardServlet] New best streak: " + bestHabitStreak);
                        }
                    }
                }
                System.out.println("[DashboardServlet] Best habit streak for user " + userId + ": " + bestHabitStreak);
            } else {
                System.err.println("[DashboardServlet] Database connection is null!");
            }
        } catch (SQLException e) {
            System.err.println("[DashboardServlet] Error loading habits: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (habitConnection != null) {
                try {
                    habitConnection.close();
                    System.out.println("[DashboardServlet] Connection closed");
                } catch (SQLException e) {
                    System.err.println("[DashboardServlet] Error closing connection: " + e.getMessage());
                }
            }
        }
        req.setAttribute("habitStreak", bestHabitStreak);
        System.out.println("[DashboardServlet] Setting habitStreak attribute to: " + bestHabitStreak);
        EmotionPattern pattern = patternDetector.analyzeEmotions(userId);
        
        // Set pattern object in request for JSP
        req.setAttribute("pattern", pattern);
        
        System.out.println("[EmoVault] Pattern Analysis for user " + userId + 
                          ": " + pattern.getInsights().size() + " insights generated");
        
        // Forward to dashboard page
        req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
    }
    
    /**
     * Get emoji for mood
     */
    private String getMoodEmoji(String mood) {
        if (mood == null) return "😐";
        
        switch(mood.toLowerCase()) {
            case "happy": return "😊";
            case "calm": return "😌";
            case "sad": return "😢";
            case "anxious": return "😰";
            case "angry": return "😠";
            case "neutral": return "😐";
            default: return "😐";
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        // Redirect POST to GET
        doGet(req, resp);
    }
}
