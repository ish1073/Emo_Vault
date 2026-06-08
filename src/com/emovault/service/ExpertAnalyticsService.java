package com.emovault.service;

import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * ExpertAnalyticsService - Real-time analytics service for expert dashboard
 * Provides live data from actual user activity and emotional patterns
 */
public class ExpertAnalyticsService {
    
    /**
     * Get system-wide overview statistics
     */
    public Map<String, Object> getSystemOverview() {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return stats;
            
            // Total users
            String userQuery = "SELECT COUNT(*) as total FROM users WHERE is_active = 1";
            try (PreparedStatement stmt = conn.prepareStatement(userQuery)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.put("totalUsers", rs.getInt("total"));
                }
            }
            
            // Active users this week
            String activeQuery = "SELECT COUNT(DISTINCT user_id) as active FROM emotion_entries " +
                               "WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
            try (PreparedStatement stmt = conn.prepareStatement(activeQuery)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.put("activeWeek", rs.getInt("active"));
                }
            }
            
            // Total entries logged
            String entriesQuery = "SELECT " +
                "(SELECT COUNT(*) FROM emotion_entries) + " +
                "(SELECT COUNT(*) FROM diary_entries) + " +
                "(SELECT COUNT(*) FROM habit_logs) + " +
                "(SELECT COUNT(*) FROM regrets) as total";
            try (PreparedStatement stmt = conn.prepareStatement(entriesQuery)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.put("totalEntries", rs.getInt("total"));
                }
            }
            
            // Average daily check-in rate
            String avgQuery = "SELECT " +
                "COUNT(DISTINCT user_id) as active_users, " +
                "COUNT(DISTINCT DATE(created_at)) as active_days " +
                "FROM emotion_entries WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
            try (PreparedStatement stmt = conn.prepareStatement(avgQuery)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    int activeUsers = rs.getInt("active_users");
                    int activeDays = rs.getInt("active_days");
                    int avgCheckIn = activeUsers > 0 ? (activeDays * 100) / 30 : 0;
                    stats.put("avgCheckIn", avgCheckIn);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting system overview: " + e.getMessage());
        }
        
        return stats;
    }
    
    /**
     * Get users with high emotional risk scores
     */
    public List<Map<String, Object>> getHighRiskUsers(int limit) {
        List<Map<String, Object>> users = new ArrayList<>();
        
        String query = "SELECT u.user_id, u.username, u.email, " +
                      "COUNT(CASE WHEN e.intensity >= 8 THEN 1 END) as high_intensity_count, " +
                      "COUNT(CASE WHEN e.mood IN ('Sad', 'Anxious', 'Angry') THEN 1 END) as negative_emotion_count, " +
                      "AVG(e.intensity) as avg_intensity, " +
                      "MAX(e.created_at) as last_activity " +
                      "FROM users u " +
                      "LEFT JOIN emotion_entries e ON u.user_id = e.user_id " +
                      "WHERE u.is_active = 1 AND e.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) " +
                      "GROUP BY u.user_id " +
                      "HAVING high_intensity_count >= 3 OR negative_emotion_count >= 5 " +
                      "ORDER BY high_intensity_count DESC, negative_emotion_count DESC " +
                      "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("userId", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("highIntensityCount", rs.getInt("high_intensity_count"));
                user.put("negativeEmotionCount", rs.getInt("negative_emotion_count"));
                user.put("avgIntensity", rs.getDouble("avg_intensity"));
                user.put("lastActivity", rs.getTimestamp("last_activity"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting high risk users: " + e.getMessage());
        }
        
        return users;
    }
    
    /**
     * Get recent emotional spikes (sudden intensity increases)
     */
    public List<Map<String, Object>> getRecentEmotionalSpikes(int limit) {
        List<Map<String, Object>> spikes = new ArrayList<>();
        
        String query = "SELECT u.username, e.mood, e.intensity, e.trigger, e.created_at, " +
                      "(SELECT AVG(intensity) FROM emotion_entries " +
                      " WHERE user_id = e.user_id AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)) as user_avg_intensity " +
                      "FROM emotion_entries e " +
                      "JOIN users u ON e.user_id = u.user_id " +
                      "WHERE e.created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR) " +
                      "AND e.intensity >= 7 " +
                      "ORDER BY e.created_at DESC " +
                      "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> spike = new HashMap<>();
                spike.put("username", rs.getString("username"));
                spike.put("mood", rs.getString("mood"));
                spike.put("intensity", rs.getInt("intensity"));
                spike.put("trigger", rs.getString("trigger"));
                spike.put("createdAt", rs.getTimestamp("created_at"));
                spike.put("userAvgIntensity", rs.getDouble("user_avg_intensity"));
                spikes.add(spike);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting emotional spikes: " + e.getMessage());
        }
        
        return spikes;
    }
    
    /**
     * Get users with repeated regret patterns
     */
    public List<Map<String, Object>> getUsersWithRegretPatterns(int limit) {
        List<Map<String, Object>> users = new ArrayList<>();
        
        String query = "SELECT u.user_id, u.username, " +
                      "COUNT(r.regret_id) as regret_count, " +
                      "GROUP_CONCAT(DISTINCT r.tag) as common_tags, " +
                      "MAX(r.created_date) as last_regret " +
                      "FROM users u " +
                      "JOIN regrets r ON u.user_id = r.user_id " +
                      "WHERE r.created_date >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                      "GROUP BY u.user_id " +
                      "HAVING regret_count >= 3 " +
                      "ORDER BY regret_count DESC " +
                      "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("userId", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("regretCount", rs.getInt("regret_count"));
                user.put("commonTags", rs.getString("common_tags"));
                user.put("lastRegret", rs.getTimestamp("last_regret"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting regret patterns: " + e.getMessage());
        }
        
        return users;
    }
    
    /**
     * Get users with declining habit consistency
     */
    public List<Map<String, Object>> getDecliningHabitUsers(int limit) {
        List<Map<String, Object>> users = new ArrayList<>();
        
        String query = "SELECT u.user_id, u.username, " +
                      "COUNT(DISTINCT h.habit_id) as total_habits, " +
                      "SUM(CASE WHEN hl.completed_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) " +
                      "AND hl.is_completed = 1 THEN 1 ELSE 0 END) as recent_completions, " +
                      "SUM(CASE WHEN hl.completed_date >= DATE_SUB(CURDATE(), INTERVAL 14 DAY) " +
                      "AND hl.completed_date < DATE_SUB(CURDATE(), INTERVAL 7 DAY) " +
                      "AND hl.is_completed = 1 THEN 1 ELSE 0 END) as previous_completions " +
                      "FROM users u " +
                      "JOIN habits h ON u.user_id = h.user_id " +
                      "LEFT JOIN habit_logs hl ON h.habit_id = hl.habit_id " +
                      "WHERE u.is_active = 1 AND h.is_active = 1 " +
                      "AND hl.completed_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) " +
                      "GROUP BY u.user_id " +
                      "HAVING total_habits >= 2 AND recent_completions < previous_completions * 0.7 " +
                      "ORDER BY (previous_completions - recent_completions) DESC " +
                      "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("userId", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("totalHabits", rs.getInt("total_habits"));
                user.put("recentCompletions", rs.getInt("recent_completions"));
                user.put("previousCompletions", rs.getInt("previous_completions"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting declining habit users: " + e.getMessage());
        }
        
        return users;
    }
    
    /**
     * Get most common emotions across all users
     */
    public Map<String, Integer> getMostCommonEmotions(int days) {
        Map<String, Integer> emotions = new LinkedHashMap<>();
        
        String query = "SELECT mood, COUNT(*) as count FROM emotion_entries " +
                      "WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "GROUP BY mood ORDER BY count DESC LIMIT 6";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                emotions.put(rs.getString("mood"), rs.getInt("count"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting common emotions: " + e.getMessage());
        }
        
        return emotions;
    }
    
    /**
     * Get users needing immediate attention
     */
    public List<Map<String, Object>> getUsersNeedingAttention(int limit) {
        List<Map<String, Object>> users = new ArrayList<>();
        
        String query = "SELECT u.user_id, u.username, u.email, " +
                      "CASE WHEN DATEDIFF(NOW(), MAX(e.created_at)) >= 7 THEN 'Inactive' " +
                      "     WHEN AVG(e.intensity) >= 7 THEN 'High Intensity' " +
                      "     WHEN COUNT(CASE WHEN e.mood IN ('Sad', 'Anxious') THEN 1 END) >= 5 THEN 'Negative Pattern' " +
                      "     ELSE 'Monitoring' END as attention_reason, " +
                      "MAX(e.created_at) as last_activity, " +
                      "AVG(e.intensity) as avg_intensity " +
                      "FROM users u " +
                      "LEFT JOIN emotion_entries e ON u.user_id = e.user_id " +
                      "WHERE u.is_active = 1 " +
                      "GROUP BY u.user_id " +
                      "HAVING last_activity IS NOT NULL AND ( " +
                      "  DATEDIFF(NOW(), MAX(e.created_at)) >= 7 OR " +
                      "  AVG(e.intensity) >= 7 OR " +
                      "  COUNT(CASE WHEN e.mood IN ('Sad', 'Anxious') THEN 1 END) >= 5 " +
                      ") " +
                      "ORDER BY avg_intensity DESC, last_activity ASC " +
                      "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("userId", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("attentionReason", rs.getString("attention_reason"));
                user.put("lastActivity", rs.getTimestamp("last_activity"));
                user.put("avgIntensity", rs.getDouble("avg_intensity"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting users needing attention: " + e.getMessage());
        }
        
        return users;
    }
    
    /**
     * Get emotional trend summary for dashboard
     */
    public Map<String, Object> getEmotionalTrendSummary() {
        Map<String, Object> summary = new HashMap<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return summary;
            
            // Get trend direction
            String trendQuery = "SELECT " +
                "(SELECT AVG(intensity) FROM emotion_entries WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)) as current_week_avg, " +
                "(SELECT AVG(intensity) FROM emotion_entries WHERE created_at >= DATE_SUB(NOW(), INTERVAL 14 DAY) " +
                "AND created_at < DATE_SUB(NOW(), INTERVAL 7 DAY)) as previous_week_avg";
            
            try (PreparedStatement stmt = conn.prepareStatement(trendQuery)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    double currentAvg = rs.getDouble("current_week_avg");
                    double previousAvg = rs.getDouble("previous_week_avg");
                    String trend = currentAvg > previousAvg ? "increasing" : 
                                  currentAvg < previousAvg ? "decreasing" : "stable";
                    summary.put("trend", trend);
                    summary.put("currentAvgIntensity", currentAvg);
                    summary.put("previousAvgIntensity", previousAvg);
                }
            }
            
            // Get most active time
            String timeQuery = "SELECT HOUR(created_at) as hour, COUNT(*) as count " +
                             "FROM emotion_entries WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) " +
                             "GROUP BY HOUR(created_at) ORDER BY count DESC LIMIT 1";
            
            try (PreparedStatement stmt = conn.prepareStatement(timeQuery)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    int hour = rs.getInt("hour");
                    String timeOfDay = hour >= 6 && hour < 12 ? "Morning" :
                                     hour >= 12 && hour < 18 ? "Afternoon" :
                                     hour >= 18 && hour < 22 ? "Evening" : "Night";
                    summary.put("peakActivityTime", timeOfDay);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting trend summary: " + e.getMessage());
        }
        
        return summary;
    }
    
    /**
     * Get recent alerts for expert dashboard
     */
    public List<Map<String, Object>> getRecentAlerts(int limit) {
        List<Map<String, Object>> alerts = new ArrayList<>();
        
        // Use available columns from alerts table (alert_type, message, created_date, is_read)
        String query = "SELECT a.alert_id, a.user_id, u.username, a.alert_type, " +
                      "a.message, a.created_date, a.is_read " +
                      "FROM alerts a " +
                      "JOIN users u ON a.user_id = u.user_id " +
                      "WHERE a.created_date >= DATE_SUB(NOW(), INTERVAL 24 HOUR) " +
                      "ORDER BY a.created_date DESC " +
                      "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> alert = new HashMap<>();
                alert.put("alertId", rs.getInt("alert_id"));
                alert.put("userId", rs.getInt("user_id"));
                alert.put("username", rs.getString("username"));
                alert.put("alertType", rs.getString("alert_type"));
                // Map alert_type to severity for display
                String alertType = rs.getString("alert_type");
                String severity = "LOW";
                if (alertType != null) {
                    alertType = alertType.toUpperCase();
                    if (alertType.contains("RISK") || alertType.contains("HIGH")) {
                        severity = "HIGH";
                    } else if (alertType.contains("PATTERN") || alertType.contains("DISRUPTION")) {
                        severity = "MEDIUM";
                    }
                }
                alert.put("severity", severity);
                alert.put("message", rs.getString("message"));
                alert.put("createdAt", rs.getTimestamp("created_date"));
                alert.put("isResolved", rs.getBoolean("is_read"));
                alerts.add(alert);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting recent alerts: " + e.getMessage());
        }
        
        return alerts;
    }
}