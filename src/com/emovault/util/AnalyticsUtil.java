package com.emovault.util;

import com.emovault.dao.*;
import com.emovault.model.*;
import java.sql.*;
import java.time.*;
import java.time.format.*;
import java.util.*;

/**
 * Analytics Utility - Processes and generates insights from user data
 */
public class AnalyticsUtil {
    
    /**
     * Get emotional distribution data
     */
    public static Map<String, Integer> getEmotionalDistribution(int userId) {
        Map<String, Integer> distribution = new HashMap<>();
        distribution.put("Stress", 0);
        distribution.put("Happy", 0);
        distribution.put("Sad", 0);
        distribution.put("Calm", 0);
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return distribution;
            
            String query = "SELECT emotion_type, COUNT(*) as count FROM emotions " +
                          "WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                          "GROUP BY emotion_type";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                
                while (rs.next()) {
                    String type = rs.getString("emotion_type");
                    int count = rs.getInt("count");
                    
                    if (distribution.containsKey(type)) {
                        distribution.put(type, count);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("[AnalyticsUtil] Error getting emotional distribution: " + e.getMessage());
        }
        
        return distribution;
    }
    
    /**
     * Get mood trend data (last 30 days)
     */
    public static List<Map<String, Object>> getMoodTrend(int userId) {
        List<Map<String, Object>> trend = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return trend;
            
            String query = "SELECT DATE(created_at) as date, AVG(intensity) as avg_intensity " +
                          "FROM emotions WHERE user_id = ? " +
                          "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                          "GROUP BY DATE(created_at) ORDER BY date ASC";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                
                while (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("date", rs.getString("date"));
                    data.put("intensity", Math.round(rs.getDouble("avg_intensity") * 10.0) / 10.0);
                    trend.add(data);
                }
            }
        } catch (SQLException e) {
            System.err.println("[AnalyticsUtil] Error getting mood trend: " + e.getMessage());
        }
        
        return trend;
    }
    
    /**
     * Get risk summary
     */
    public static Map<String, Integer> getRiskSummary(int userId) {
        Map<String, Integer> riskSummary = new HashMap<>();
        riskSummary.put("Low", 0);
        riskSummary.put("Medium", 0);
        riskSummary.put("High", 0);
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return riskSummary;
            
            String query = "SELECT risk_level, COUNT(*) as count FROM decisions " +
                          "WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                          "GROUP BY risk_level";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                
                while (rs.next()) {
                    String risk = rs.getString("risk_level");
                    int count = rs.getInt("count");
                    
                    if (riskSummary.containsKey(risk)) {
                        riskSummary.put(risk, count);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("[AnalyticsUtil] Error getting risk summary: " + e.getMessage());
        }
        
        return riskSummary;
    }
    
    /**
     * Get most frequent regret
     */
    public static String getMostFrequentRegret(int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return "No data";
            
            String query = "SELECT regret_type, COUNT(*) as count FROM regrets " +
                          "WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                          "GROUP BY regret_type ORDER BY count DESC LIMIT 1";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    return rs.getString("regret_type");
                }
            }
        } catch (SQLException e) {
            System.err.println("[AnalyticsUtil] Error getting most frequent regret: " + e.getMessage());
        }
        
        return "No data";
    }
    
    /**
     * Get repeated mistakes count
     */
    public static int getRepeatedMistakesCount(int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return 0;
            
            String query = "SELECT COUNT(*) as count FROM regrets " +
                          "WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            System.err.println("[AnalyticsUtil] Error getting repeated mistakes: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Get habit streak
     */
    public static int getHabitStreak(int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return 0;
            
            String query = "SELECT MAX(streak) as max_streak FROM habits " +
                          "WHERE user_id = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    int streak = rs.getInt("max_streak");
                    return streak > 0 ? streak : 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("[AnalyticsUtil] Error getting habit streak: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Get habit consistency (percentage of days with habit logged)
     */
    public static double getHabitConsistency(int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return 0.0;
            
            String query = "SELECT COUNT(DISTINCT DATE(created_at)) as habit_days, " +
                          "DATEDIFF(NOW(), MIN(created_at)) as total_days " +
                          "FROM habits WHERE user_id = ? " +
                          "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    int habitDays = rs.getInt("habit_days");
                    int totalDays = rs.getInt("total_days");
                    
                    if (totalDays > 0) {
                        return (habitDays * 100.0) / totalDays;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("[AnalyticsUtil] Error getting habit consistency: " + e.getMessage());
        }
        
        return 0.0;
    }
    
    /**
     * Generate final insight summary
     */
    public static String generateInsightSummary(int userId) {
        Map<String, Integer> emotions = getEmotionalDistribution(userId);
        String topEmotion = emotions.entrySet().stream()
            .max(Map.Entry.comparingByValue())
            .map(Map.Entry::getKey)
            .orElse("mixed emotions");
        
        String topRegret = getMostFrequentRegret(userId);
        int regretCount = getRepeatedMistakesCount(userId);
        int habitStreak = getHabitStreak(userId);
        double habitConsistency = getHabitConsistency(userId);
        
        StringBuilder insight = new StringBuilder();
        
        // Emotion insight
        insight.append("You frequently experience ").append(topEmotion.toLowerCase());
        
        // Regret insight
        if (!topRegret.equals("No data") && regretCount > 0) {
            insight.append(" and tend to ").append(topRegret.toLowerCase());
        }
        
        // Habit insight
        if (habitStreak > 0) {
            insight.append(". Your current streak is ").append(habitStreak).append(" days");
            if (habitConsistency > 70) {
                insight.append(" with excellent consistency.");
            } else if (habitConsistency > 50) {
                insight.append(" with good consistency.");
            } else {
                insight.append(". Consider building more consistency.");
            }
        } else {
            insight.append(". Focus on building consistent habits to improve your emotional well-being.");
        }
        
        return insight.toString();
    }
    
    /**
     * Get total statistics
     */
    public static Map<String, Integer> getTotalStatistics(int userId) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("totalEmotions", 0);
        stats.put("totalRegrets", 0);
        stats.put("totalHabits", 0);
        stats.put("totalDecisions", 0);
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return stats;
            
            // Total emotions
            try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT COUNT(*) as count FROM emotions WHERE user_id = ? " +
                "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) stats.put("totalEmotions", rs.getInt("count"));
            }
            
            // Total regrets
            try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT COUNT(*) as count FROM regrets WHERE user_id = ? " +
                "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) stats.put("totalRegrets", rs.getInt("count"));
            }
            
            // Total habits
            try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT COUNT(*) as count FROM habits WHERE user_id = ? " +
                "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) stats.put("totalHabits", rs.getInt("count"));
            }
            
            // Total decisions
            try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT COUNT(*) as count FROM decisions WHERE user_id = ? " +
                "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) stats.put("totalDecisions", rs.getInt("count"));
            }
        } catch (SQLException e) {
            System.err.println("[AnalyticsUtil] Error getting total statistics: " + e.getMessage());
        }
        
        return stats;
    }
}
