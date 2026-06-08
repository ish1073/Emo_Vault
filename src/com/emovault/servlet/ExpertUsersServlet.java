package com.emovault.servlet;

import com.emovault.service.DataService;
import com.emovault.service.ExpertAnalyticsService;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * ExpertUsersServlet - User monitoring module for experts
 * Allows experts to view detailed user emotional summaries and patterns
 */
@WebServlet("/expert/users")
public class ExpertUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ExpertAnalyticsService analyticsService = new ExpertAnalyticsService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if expert is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("expertId") == null) {
            response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("detail".equals(action)) {
            // View detailed user profile
            handleUserDetail(request, response);
        } else if ("emotions".equals(action)) {
            // View user's emotional history
            handleUserEmotions(request, response);
        } else if ("habits".equals(action)) {
            // View user's habit patterns
            handleUserHabits(request, response);
        } else {
            // Default: show all users overview
            handleUserList(request, response);
        }
    }
    
    /**
     * Show list of all users with risk indicators
     */
    private void handleUserList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get various user categories
        List<Map<String, Object>> highRiskUsers = analyticsService.getHighRiskUsers(15);
        List<Map<String, Object>> attentionUsers = analyticsService.getUsersNeedingAttention(15);
        List<Map<String, Object>> regretPatternUsers = analyticsService.getUsersWithRegretPatterns(10);
        List<Map<String, Object>> decliningHabitUsers = analyticsService.getDecliningHabitUsers(10);
        
        request.setAttribute("highRiskUsers", highRiskUsers);
        request.setAttribute("attentionUsers", attentionUsers);
        request.setAttribute("regretPatternUsers", regretPatternUsers);
        request.setAttribute("decliningHabitUsers", decliningHabitUsers);
        
        request.getRequestDispatcher("expert_users.jsp").forward(request, response);
    }
    
    /**
     * Show detailed user profile with all analytics
     */
    private void handleUserDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        // Get user's emotional data
        List<Map<String, Object>> emotions = DataService.getUserEmotions(userId, 30);
        Map<String, Integer> moodDistribution = DataService.getMoodDistribution(userId, 30);
        List<Map<String, Object>> moodTrends = DataService.getMoodTrends(userId, 30);
        
        // Get user's habit data
        List<Map<String, Object>> habits = DataService.getHabitStreaks(userId);
        
        // Get user's recent regrets
        List<Map<String, Object>> regrets = DataService.getRecentRegrets(userId, 30);
        
        // Get user's recent diary entries
        List<Map<String, Object>> diaryEntries = DataService.getRecentDiaryEntries(userId, 10);
        
        // Calculate risk indicators
        double avgIntensity = DataService.getAverageIntensity(userId, 7);
        String currentEmotion = DataService.getCurrentEmotionalState(userId);
        String commonTrigger = DataService.getMostCommonTrigger(userId, 30);
        
        request.setAttribute("userId", userId);
        request.setAttribute("emotions", emotions);
        request.setAttribute("moodDistribution", moodDistribution);
        request.setAttribute("moodTrends", moodTrends);
        request.setAttribute("habits", habits);
        request.setAttribute("regrets", regrets);
        request.setAttribute("diaryEntries", diaryEntries);
        request.setAttribute("avgIntensity", avgIntensity);
        request.setAttribute("currentEmotion", currentEmotion);
        request.setAttribute("commonTrigger", commonTrigger);
        
        request.getRequestDispatcher("expert_user_detail.jsp").forward(request, response);
    }
    
    /**
     * Show user's emotional history
     */
    private void handleUserEmotions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId"));
        int days = request.getParameter("days") != null ? 
                   Integer.parseInt(request.getParameter("days")) : 30;
        
        List<Map<String, Object>> emotions = DataService.getUserEmotions(userId, days);
        Map<String, Integer> moodDistribution = DataService.getMoodDistribution(userId, days);
        List<Map<String, Object>> moodTrends = DataService.getMoodTrends(userId, days);
        String commonTrigger = DataService.getMostCommonTrigger(userId, days);
        
        request.setAttribute("userId", userId);
        request.setAttribute("days", days);
        request.setAttribute("emotions", emotions);
        request.setAttribute("moodDistribution", moodDistribution);
        request.setAttribute("moodTrends", moodTrends);
        request.setAttribute("commonTrigger", commonTrigger);
        
        request.getRequestDispatcher("expert_user_emotions.jsp").forward(request, response);
    }
    
    /**
     * Show user's habit patterns
     */
    private void handleUserHabits(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        List<Map<String, Object>> habits = DataService.getHabitStreaks(userId);
        int longestStreak = DataService.getLongestHabitStreak(userId);
        
        request.setAttribute("userId", userId);
        request.setAttribute("habits", habits);
        request.setAttribute("longestStreak", longestStreak);
        
        request.getRequestDispatcher("expert_user_habits.jsp").forward(request, response);
    }
}