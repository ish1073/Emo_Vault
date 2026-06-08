package com.emovault.servlet;

import com.emovault.service.ExpertAnalyticsService;
import com.emovault.service.DataService;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * ExpertAnalyticsServlet - Analytics & Trends module for experts
 * Provides comprehensive analytics on user emotional patterns and system-wide trends
 */
@WebServlet("/expert/analytics")
public class ExpertAnalyticsServlet extends HttpServlet {
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
        
        String timeframe = request.getParameter("timeframe");
        if (timeframe == null) {
            timeframe = "7";
        }
        
        int days = Integer.parseInt(timeframe);
        
        // Get system overview
        Map<String, Object> systemStats = analyticsService.getSystemOverview();
        
        // Get emotional trends
        Map<String, Object> trendSummary = analyticsService.getEmotionalTrendSummary();
        
        // Get most common emotions
        Map<String, Integer> commonEmotions = analyticsService.getMostCommonEmotions(days);
        
        // Get emotional distribution over time
        List<Map<String, Object>> weeklyTrends = getWeeklyTrends(days);
        
        // Get user engagement trends
        List<Map<String, Object>> engagementTrends = getUserEngagementTrends(days);
        
        // Get emotion intensity trends
        List<Map<String, Object>> intensityTrends = getIntensityTrends(days);
        
        // Get category-based analytics
        Map<String, Object> categoryAnalytics = getCategoryAnalytics(days);
        
        request.setAttribute("systemStats", systemStats);
        request.setAttribute("trendSummary", trendSummary);
        request.setAttribute("commonEmotions", commonEmotions);
        request.setAttribute("weeklyTrends", weeklyTrends);
        request.setAttribute("engagementTrends", engagementTrends);
        request.setAttribute("intensityTrends", intensityTrends);
        request.setAttribute("categoryAnalytics", categoryAnalytics);
        request.setAttribute("timeframe", days);
        
        request.getRequestDispatcher("expert_analytics.jsp").forward(request, response);
    }
    
    /**
     * Get weekly trends for emotions
     */
    private List<Map<String, Object>> getWeeklyTrends(int days) {
        List<Map<String, Object>> trends = new ArrayList<>();
        
        try {
            String query = "SELECT DATE(created_at) as date, mood, COUNT(*) as count " +
                          "FROM emotion_entries WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                          "GROUP BY DATE(created_at), mood ORDER BY date ASC";
            
            java.sql.Connection conn = com.emovault.util.DBConnection.getConnection();
            if (conn != null) {
                java.sql.PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, days);
                java.sql.ResultSet rs = stmt.executeQuery();
                
                while (rs.next()) {
                    Map<String, Object> trend = new HashMap<>();
                    trend.put("date", rs.getDate("date").toString());
                    trend.put("mood", rs.getString("mood"));
                    trend.put("count", rs.getInt("count"));
                    trends.add(trend);
                }
                
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Error getting weekly trends: " + e.getMessage());
        }
        
        return trends;
    }
    
    /**
     * Get user engagement trends
     */
    private List<Map<String, Object>> getUserEngagementTrends(int days) {
        List<Map<String, Object>> trends = new ArrayList<>();
        
        try {
            String query = "SELECT DATE(created_at) as date, " +
                          "COUNT(DISTINCT user_id) as active_users, " +
                          "COUNT(*) as total_entries " +
                          "FROM emotion_entries WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                          "GROUP BY DATE(created_at) ORDER BY date ASC";
            
            java.sql.Connection conn = com.emovault.util.DBConnection.getConnection();
            if (conn != null) {
                java.sql.PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, days);
                java.sql.ResultSet rs = stmt.executeQuery();
                
                while (rs.next()) {
                    Map<String, Object> trend = new HashMap<>();
                    trend.put("date", rs.getDate("date").toString());
                    trend.put("activeUsers", rs.getInt("active_users"));
                    trend.put("totalEntries", rs.getInt("total_entries"));
                    trends.add(trend);
                }
                
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Error getting engagement trends: " + e.getMessage());
        }
        
        return trends;
    }
    
    /**
     * Get emotion intensity trends
     */
    private List<Map<String, Object>> getIntensityTrends(int days) {
        List<Map<String, Object>> trends = new ArrayList<>();
        
        try {
            String query = "SELECT DATE(created_at) as date, " +
                          "AVG(intensity) as avg_intensity, " +
                          "MAX(intensity) as max_intensity, " +
                          "MIN(intensity) as min_intensity " +
                          "FROM emotion_entries WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                          "GROUP BY DATE(created_at) ORDER BY date ASC";
            
            java.sql.Connection conn = com.emovault.util.DBConnection.getConnection();
            if (conn != null) {
                java.sql.PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, days);
                java.sql.ResultSet rs = stmt.executeQuery();
                
                while (rs.next()) {
                    Map<String, Object> trend = new HashMap<>();
                    trend.put("date", rs.getDate("date").toString());
                    trend.put("avgIntensity", rs.getDouble("avg_intensity"));
                    trend.put("maxIntensity", rs.getDouble("max_intensity"));
                    trend.put("minIntensity", rs.getDouble("min_intensity"));
                    trends.add(trend);
                }
                
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Error getting intensity trends: " + e.getMessage());
        }
        
        return trends;
    }
    
    /**
     * Get category-based analytics
     */
    private Map<String, Object> getCategoryAnalytics(int days) {
        Map<String, Object> analytics = new HashMap<>();
        
        try {
            java.sql.Connection conn = com.emovault.util.DBConnection.getConnection();
            if (conn != null) {
                // Get emotion triggers
                String triggerQuery = "SELECT trigger, COUNT(*) as count FROM emotion_entries " +
                                     "WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                                     "AND trigger IS NOT NULL AND trigger != '' " +
                                     "GROUP BY trigger ORDER BY count DESC LIMIT 10";
                java.sql.PreparedStatement stmt = conn.prepareStatement(triggerQuery);
                stmt.setInt(1, days);
                java.sql.ResultSet rs = stmt.executeQuery();
                
                List<Map<String, Object>> triggers = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> trigger = new HashMap<>();
                    trigger.put("name", rs.getString("trigger"));
                    trigger.put("count", rs.getInt("count"));
                    triggers.add(trigger);
                }
                analytics.put("triggers", triggers);
                
                // Get time-based patterns
                String timeQuery = "SELECT HOUR(created_at) as hour, COUNT(*) as count " +
                                 "FROM emotion_entries WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                                 "GROUP BY HOUR(created_at) ORDER BY hour ASC";
                stmt = conn.prepareStatement(timeQuery);
                stmt.setInt(1, days);
                rs = stmt.executeQuery();
                
                List<Map<String, Object>> timePatterns = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> pattern = new HashMap<>();
                    pattern.put("hour", rs.getInt("hour"));
                    pattern.put("count", rs.getInt("count"));
                    timePatterns.add(pattern);
                }
                analytics.put("timePatterns", timePatterns);
                
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Error getting category analytics: " + e.getMessage());
        }
        
        return analytics;
    }
}