package com.emovault.dao;

import com.emovault.model.BehaviorAnalysis;
import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * DAO for querying and aggregating data from emotion, diary, regret, and habit tables
 * Provides raw data needed for behavior analysis
 * Complete implementation with all necessary queries for Analytics & Reports
 */
public class BehaviorAnalysisDAO {
    
    /**
     * Get all emotions for a user (last 30 days)
     * Returns: {mood: intensity}
     */
    public static Map<String, Integer> getUserEmotions(int userId) {
        Map<String, Integer> emotions = new HashMap<>();
        String query = "SELECT mood, intensity FROM emotion_entries WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String mood = rs.getString("mood");
                int intensity = rs.getInt("intensity");
                emotions.put(mood, intensity); // Last entry for each mood
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return emotions;
    }
    
    /**
     * Get emotion frequency and intensity data
     * Returns: List of [mood, count, avg_intensity]
     */
    public static List<Map<String, Object>> getEmotionStats(int userId) {
        List<Map<String, Object>> stats = new ArrayList<>();
        String query = "SELECT mood, COUNT(*) as count, AVG(intensity) as avg_intensity " +
                      "FROM emotion_entries WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                      "GROUP BY mood ORDER BY count DESC LIMIT 5";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("mood", rs.getString("mood"));
                map.put("count", rs.getInt("count"));
                map.put("avg_intensity", rs.getDouble("avg_intensity"));
                stats.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    /**
     * Count negative emotions (Sad, Stressed, Angry, Anxious, etc.)
     */
    public static int countNegativeEmotions(int userId) {
        String query = "SELECT COUNT(*) as count FROM emotion_entries WHERE user_id = ? " +
                      "AND mood IN ('Sad', 'Stressed', 'Angry', 'Anxious', 'Depressed', 'Frustrated') " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Get average emotion intensity
     */
    public static double getAverageEmotionIntensity(int userId) {
        String query = "SELECT AVG(intensity) as avg_intensity FROM emotion_entries WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                double avg = rs.getDouble("avg_intensity");
                return avg > 0 ? avg : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Get diary entries with mood (for pattern detection)
     */
    public static List<Map<String, String>> getDiaryEntriesWithMood(int userId) {
        List<Map<String, String>> entries = new ArrayList<>();
        String query = "SELECT mood, content, created_at FROM diary_entries WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) ORDER BY created_at DESC LIMIT 20";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("mood", rs.getString("mood"));
                map.put("content", rs.getString("content"));
                map.put("created_at", rs.getString("created_at"));
                entries.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return entries;
    }
    
    /**
     * Count regret entries (for behavior loop detection)
     */
    public static int countRegrets(int userId) {
        String query = "SELECT COUNT(*) as count FROM regrets WHERE user_id = ? " +
                      "AND created_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Get regret descriptions (for pattern matching)
     */
    public static List<String> getRegretDescriptions(int userId) {
        List<String> regrets = new ArrayList<>();
        String query = "SELECT description FROM regrets WHERE user_id = ? " +
                      "AND created_date >= DATE_SUB(NOW(), INTERVAL 30 DAY) LIMIT 10";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                regrets.add(rs.getString("description"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return regrets;
    }
    
    /**
     * Get habit consistency (for habit-based suggestions)
     */
    public static Map<String, Object> getHabitConsistency(int userId) {
        Map<String, Object> map = new HashMap<>();
        String query = "SELECT COUNT(*) as total_habits, " +
                      "SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_habits " +
                      "FROM habits WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                map.put("total_habits", rs.getInt("total_habits"));
                map.put("active_habits", rs.getInt("active_habits"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
    
    /**
     * Get total emotion entries count
     */
    public static int getEmotionEntriesCount(int userId) {
        String query = "SELECT COUNT(*) as count FROM emotion_entries WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Analyze behavior and return comprehensive BehaviorAnalysis object
     */
    public BehaviorAnalysis analyzeBehavior(int userId) {
        BehaviorAnalysis analysis = new BehaviorAnalysis();
        
        // Get dominant emotion
        List<Map<String, Object>> stats = getEmotionStats(userId);
        if (!stats.isEmpty()) {
            analysis.setDominantEmotion((String) stats.get(0).get("mood"));
        }
        
        // Get behavior pattern based on diary entries
        List<Map<String, String>> diaryEntries = getDiaryEntriesWithMood(userId);
        if (!diaryEntries.isEmpty()) {
            analysis.setDetectedBehaviorLoop("User shows regular emotional tracking and self-reflection patterns");
        }
        
        return analysis;
    }
}
