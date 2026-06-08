package com.emovault.servlet;

import com.emovault.model.EmotionPattern;
import com.emovault.model.Habit;
import com.emovault.util.PatternDetector;
import com.emovault.util.DBConnection;
import com.emovault.dao.EmotionDAO;
import com.emovault.dao.HabitDAO;
import com.emovault.dao.DiaryDAO;
import com.emovault.dao.AnalyticsDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
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
        
        // Get user name from session
        String userName = (String) session.getAttribute("userName");
        if (userName == null || userName.isEmpty()) {
            userName = "User";
        }
        req.setAttribute("userName", userName);
        
        // Get today's date formatted
        String todayDate = LocalDate.now().format(DateTimeFormatter.ofPattern("MMMM d, yyyy"));
        req.setAttribute("todayDate", todayDate);
        
        // Get today's emotion
        Map<String, Object> todayEmotion = emotionDAO.getTodayEmotion(userId);
        if (todayEmotion != null) {
            req.setAttribute("lastMood", todayEmotion.get("mood"));
            req.setAttribute("todayMoodEmoji", getMoodEmoji((String) todayEmotion.get("mood")));
            req.setAttribute("todayIntensity", todayEmotion.get("intensity"));
            req.setAttribute("todayMoodText", getMoodDescription((String) todayEmotion.get("mood")));
        } else {
            req.setAttribute("lastMood", "Not logged yet");
            req.setAttribute("todayMoodEmoji", "😐");
            req.setAttribute("todayIntensity", 0);
            req.setAttribute("todayMoodText", "How are you feeling?");
        }
        
        // Get emotion count
        int emotionCount = emotionDAO.getEmotionCount(userId);
        req.setAttribute("emotionCount", emotionCount);
        
        // Get diary count
        int diaryCount = 0;
        try {
            DiaryDAO diaryDAO = new DiaryDAO();
            diaryCount = diaryDAO.getDiaryCount(userId);
        } catch (Exception e) {
            System.err.println("[DashboardServlet] Error getting diary count: " + e.getMessage());
        }
        req.setAttribute("diaryCount", diaryCount);
        
        // Load habits and calculate stats using centralized methods
        Connection habitConnection = null;
        try {
            habitConnection = DBConnection.getConnection();
            System.out.println("[DashboardServlet] Attempting to get connection for habits...");
            if (habitConnection != null) {
                System.out.println("[DashboardServlet] Connection successful");
                HabitDAO habitDAO = new HabitDAO(habitConnection);
                
                // Use centralized getTodaySummary for real-time data
                Map<String, Object> todaySummary = habitDAO.getTodaySummary(userId);
                
                int totalHabits = (int) todaySummary.getOrDefault("totalHabits", 0);
                int habitsCompletedToday = (int) todaySummary.getOrDefault("completedToday", 0);
                int bestHabitStreak = (int) todaySummary.getOrDefault("bestStreak", 0);
                double avgConsistency = (double) todaySummary.getOrDefault("avgConsistency", 0.0);
                
                System.out.println("[DashboardServlet] Today Summary - Total: " + totalHabits + 
                                  ", Completed: " + habitsCompletedToday + 
                                  ", Best Streak: " + bestHabitStreak +
                                  ", Avg Consistency: " + String.format("%.1f", avgConsistency));
                
                // Get detailed habit list for display
                List<Habit> habitsList = habitDAO.getHabitsWithStats(userId);
                Map<Integer, Boolean> habitsCompletedTodayMap = new HashMap<>();
                
                for (Habit habit : habitsList) {
                    boolean completedToday = habitDAO.isCompletedToday(habit.getHabitId());
                    habitsCompletedTodayMap.put(habit.getHabitId(), completedToday);
                }
                
                // Set all dashboard attributes
                req.setAttribute("habitStreak", bestHabitStreak);
                req.setAttribute("habitsCompletedToday", habitsCompletedToday);
                req.setAttribute("totalHabits", totalHabits);
                req.setAttribute("habitsList", habitsList);
                req.setAttribute("habitsCompletedTodayMap", habitsCompletedTodayMap);
                req.setAttribute("habitConsistency", Math.round(avgConsistency * 10.0) / 10.0);
                
                System.out.println("[DashboardServlet] Dashboard data loaded successfully");
            } else {
                System.err.println("[DashboardServlet] Database connection is null!");
                // Set default values
                req.setAttribute("habitStreak", 0);
                req.setAttribute("habitsCompletedToday", 0);
                req.setAttribute("totalHabits", 0);
                req.setAttribute("habitsList", new ArrayList<>());
                req.setAttribute("habitsCompletedTodayMap", new HashMap<>());
                req.setAttribute("habitConsistency", 0.0);
            }
        } catch (Exception e) {
            System.err.println("[DashboardServlet] Error loading habits: " + e.getMessage());
            e.printStackTrace();
            // Set default values on error
            req.setAttribute("habitStreak", 0);
            req.setAttribute("habitsCompletedToday", 0);
            req.setAttribute("totalHabits", 0);
            req.setAttribute("habitsList", new ArrayList<>());
            req.setAttribute("habitsCompletedTodayMap", new HashMap<>());
            req.setAttribute("habitConsistency", 0.0);
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
        
        // Get analytics data for dashboard
        try {
            AnalyticsDAO analyticsDAO = new AnalyticsDAO();
            // Get average mood intensity for today's mood score
            double avgIntensity = analyticsDAO.getAverageIntensity(userId);
            req.setAttribute("moodScore", Math.round(avgIntensity * 10.0) / 10.0);
        } catch (Exception e) {
            req.setAttribute("moodScore", 0.0);
        }
        
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
            case "excited": return "🤩";
            case "grateful": return "🙏";
            case "stressed": return "😫";
            case "tired": return "😴";
            default: return "😐";
        }
    }
    
    /**
     * Get mood description text
     */
    private String getMoodDescription(String mood) {
        if (mood == null) return "How are you feeling?";
        
        switch(mood.toLowerCase()) {
            case "happy": return "Happy & Joyful";
            case "calm": return "Calm & Focused";
            case "sad": return "Feeling Down";
            case "anxious": return "Anxious & Worried";
            case "angry": return "Frustrated";
            case "neutral": return "Neutral";
            case "excited": return "Excited & Energetic";
            case "grateful": return "Grateful & Blessed";
            case "stressed": return "Stressed Out";
            case "tired": return "Tired & Drained";
            default: return mood;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        // Redirect POST to GET
        doGet(req, resp);
    }
}
