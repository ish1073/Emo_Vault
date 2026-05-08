package com.emovault.dao;

import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Analytics Data Access Object (DAO)
 * Retrieves data for emotional patterns, insights, and reports
 */
public class AnalyticsDAO {
    
    /**
     * Get emotional distribution (frequency of each mood)
     * @param userId User ID
     * @return Map with mood names and counts
     */
    public Map<String, Integer> getMoodDistribution(int userId) {
        Map<String, Integer> distribution = new LinkedHashMap<>();
        String query = "SELECT mood, COUNT(*) as count FROM emotion_entries WHERE user_id = ? GROUP BY mood ORDER BY count DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                distribution.put(rs.getString("mood"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting mood distribution: " + e.getMessage());
        }
        
        return distribution;
    }
    
    /**
     * Get mood trend data for last 30 days
     * @param userId User ID
     * @return List of maps with date and average intensity
     */
    public List<Map<String, Object>> getMoodTrend(int userId) {
        List<Map<String, Object>> trend = new ArrayList<>();
        String query = "SELECT DATE(created_at) as date, AVG(intensity) as avg_intensity, COUNT(*) as count " +
                      "FROM emotion_entries WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                      "GROUP BY DATE(created_at) ORDER BY DATE(created_at) ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("date", rs.getDate("date").toString());
                entry.put("intensity", Math.round(rs.getDouble("avg_intensity") * 10.0) / 10.0);
                entry.put("count", rs.getInt("count"));
                trend.add(entry);
            }
        } catch (SQLException e) {
            System.err.println("Error getting mood trend: " + e.getMessage());
        }
        
        return trend;
    }
    
    /**
     * Get most frequent emotion
     * @param userId User ID
     * @return Dominant mood string
     */
    public String getDominantMood(int userId) {
        String query = "SELECT mood FROM emotion_entries WHERE user_id = ? GROUP BY mood ORDER BY COUNT(*) DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("mood");
            }
        } catch (SQLException e) {
            System.err.println("Error getting dominant mood: " + e.getMessage());
        }
        
        return "Neutral";
    }
    
    /**
     * Get average emotional intensity (risk indicator)
     * @param userId User ID
     * @return Average intensity value 0-10
     */
    public double getAverageIntensity(int userId) {
        String query = "SELECT AVG(intensity) as avg FROM emotion_entries WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return Math.round(rs.getDouble("avg") * 10.0) / 10.0;
            }
        } catch (SQLException e) {
            System.err.println("Error getting average intensity: " + e.getMessage());
        }
        
        return 0.0;
    }
    
    /**
     * Determine risk level based on intensity and negative emotions
     * @param userId User ID
     * @return Risk level: "Low", "Medium", or "High"
     */
    public String getRiskLevel(int userId) {
        double avgIntensity = getAverageIntensity(userId);
        
        // Count negative emotions (last 7 days)
        String query = "SELECT COUNT(*) as count FROM emotion_entries WHERE user_id = ? " +
                      "AND mood IN ('Stressed', 'Anxious', 'Sad', 'Angry', 'Depressed', 'Frustrated') " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int negativeCount = rs.getInt("count");
                
                if (avgIntensity > 7 || negativeCount > 5) {
                    return "High";
                } else if (avgIntensity > 5 || negativeCount > 2) {
                    return "Medium";
                } else {
                    return "Low";
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting risk level: " + e.getMessage());
        }
        
        return "Low";
    }
    
    /**
     * Get most repeated regret/lesson
     * @param userId User ID
     * @return Most frequent regret lesson or null
     */
    public Map<String, Object> getMostRepeatedRegret(int userId) {
        Map<String, Object> result = new HashMap<>();
        String query = "SELECT lesson_learned, COUNT(*) as count FROM regrets WHERE user_id = ? " +
                      "AND lesson_learned IS NOT NULL AND lesson_learned != '' " +
                      "GROUP BY lesson_learned ORDER BY count DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                result.put("lesson", rs.getString("lesson_learned"));
                result.put("count", rs.getInt("count"));
                return result;
            }
        } catch (SQLException e) {
            System.err.println("Error getting repeated regret: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Get habit progress data
     * @param userId User ID
     * @return List of maps with habit data (title, streak, consistency)
     */
    public List<Map<String, Object>> getHabitProgress(int userId) {
        List<Map<String, Object>> habits = new ArrayList<>();
        String query = "SELECT title, streak, created_at FROM habits WHERE user_id = ? ORDER BY streak DESC LIMIT 3";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> habit = new HashMap<>();
                habit.put("title", rs.getString("title"));
                habit.put("streak", rs.getInt("streak"));
                
                // Calculate consistency score (0-100%)
                Timestamp created = rs.getTimestamp("created_at");
                long daysCreated = (System.currentTimeMillis() - created.getTime()) / (1000 * 60 * 60 * 24);
                int streak = rs.getInt("streak");
                double consistency = daysCreated > 0 ? (double) streak / daysCreated * 100 : 0;
                consistency = Math.round(consistency * 10.0) / 10.0;
                if (consistency > 100) consistency = 100;
                
                habit.put("consistency", consistency);
                habits.add(habit);
            }
        } catch (SQLException e) {
            System.err.println("Error getting habit progress: " + e.getMessage());
        }
        
        return habits;
    }
    
    /**
     * Get total emotion entries count
     * @param userId User ID
     * @return Total count
     */
    public int getTotalEmotionEntries(int userId) {
        String query = "SELECT COUNT(*) as count FROM emotion_entries WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total entries: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Get most common regret tag
     * @param userId User ID
     * @return Most frequent tag
     */
    public String getMostCommonTag(int userId) {
        String query = "SELECT tag, COUNT(*) as count FROM regrets WHERE user_id = ? AND tag IS NOT NULL AND tag != '' " +
                      "GROUP BY tag ORDER BY count DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("tag");
            }
        } catch (SQLException e) {
            System.err.println("Error getting common tag: " + e.getMessage());
        }
        
        return null;
    }
}
