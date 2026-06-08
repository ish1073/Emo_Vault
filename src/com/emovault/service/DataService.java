package com.emovault.service;

import com.emovault.dao.*;
import com.emovault.model.*;
import com.emovault.util.DBConnection;

import java.sql.*;
import java.time.*;
import java.util.*;

/**
 * Centralized Data Service Layer
 * All modules use this for consistent, real-time data access
 * Eliminates hardcoded values and ensures single source of truth
 */
public class DataService {
    private static final int CACHE_DURATION_SECONDS = 60; // 1 minute cache
    private static Map<String, CachedData> cache = Collections.synchronizedMap(new HashMap<>());
    
    /**
     * Get all emotion entries for a user (last 30 days)
     */
    public static List<Map<String, Object>> getUserEmotions(int userId, int days) {
        String cacheKey = "emotions_" + userId + "_" + days;
        
        if (isCacheValid(cacheKey)) {
            return (List<Map<String, Object>>) getFromCache(cacheKey);
        }
        
        List<Map<String, Object>> emotions = new ArrayList<>();
        String query = "SELECT * FROM emotion_entries WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> emotion = new HashMap<>();
                emotion.put("entry_id", rs.getInt("entry_id"));
                emotion.put("trigger", rs.getString("trigger"));
                emotion.put("mood", rs.getString("mood"));
                emotion.put("intensity", rs.getInt("intensity"));
                emotion.put("response", rs.getString("response"));
                emotion.put("created_at", rs.getTimestamp("created_at"));
                emotions.add(emotion);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching emotions: " + e.getMessage());
        }
        
        cacheResult(cacheKey, emotions);
        return emotions;
    }
    
    /**
     * Get today's emotion entry
     */
    public static Map<String, Object> getTodayEmotion(int userId) {
        List<Map<String, Object>> emotions = getUserEmotions(userId, 1);
        return emotions.isEmpty() ? null : emotions.get(0);
    }
    
    /**
     * Get emotional distribution (mood counts)
     */
    public static Map<String, Integer> getMoodDistribution(int userId, int days) {
        String cacheKey = "moods_" + userId + "_" + days;
        
        if (isCacheValid(cacheKey)) {
            return (Map<String, Integer>) getFromCache(cacheKey);
        }
        
        Map<String, Integer> moodCounts = new LinkedHashMap<>();
        String query = "SELECT mood, COUNT(*) as count FROM emotion_entries " +
                      "WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "GROUP BY mood ORDER BY count DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                moodCounts.put(rs.getString("mood"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching mood distribution: " + e.getMessage());
        }
        
        cacheResult(cacheKey, moodCounts);
        return moodCounts;
    }
    
    /**
     * Get mood trends by date
     */
    public static List<Map<String, Object>> getMoodTrends(int userId, int days) {
        String cacheKey = "trends_" + userId + "_" + days;
        
        if (isCacheValid(cacheKey)) {
            return (List<Map<String, Object>>) getFromCache(cacheKey);
        }
        
        List<Map<String, Object>> trends = new ArrayList<>();
        String query = "SELECT DATE(created_at) as date, AVG(intensity) as avg_intensity, " +
                      "COUNT(*) as entry_count FROM emotion_entries " +
                      "WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "GROUP BY DATE(created_at) ORDER BY date ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> trend = new HashMap<>();
                trend.put("date", rs.getDate("date").toString());
                trend.put("intensity", rs.getDouble("avg_intensity"));
                trend.put("entries", rs.getInt("entry_count"));
                trends.add(trend);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching mood trends: " + e.getMessage());
        }
        
        cacheResult(cacheKey, trends);
        return trends;
    }
    
    /**
     * Get habit streaks for all user habits
     */
    public static List<Map<String, Object>> getHabitStreaks(int userId) {
        String cacheKey = "habit_streaks_" + userId;
        
        if (isCacheValid(cacheKey)) {
            return (List<Map<String, Object>>) getFromCache(cacheKey);
        }
        
        List<Map<String, Object>> habits = new ArrayList<>();
        String query = "SELECT h.habit_id, h.name, " +
                      "(SELECT COUNT(*) FROM habit_logs WHERE habit_id = h.habit_id " +
                      "AND is_completed = 1 AND completed_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) as monthly_count, " +
                      "(SELECT COUNT(*) FROM habit_logs hl WHERE hl.habit_id = h.habit_id " +
                      "AND hl.is_completed = 1 AND hl.completed_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)) as weekly_count, " +
                      "(SELECT COUNT(*) FROM habit_logs hl2 WHERE hl2.habit_id = h.habit_id " +
                      "AND hl2.completed_date = CURDATE() AND hl2.is_completed = 1) as today_completed " +
                      "FROM habits h WHERE h.user_id = ? AND h.is_active = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> habit = new HashMap<>();
                habit.put("habit_id", rs.getInt("habit_id"));
                habit.put("name", rs.getString("name"));
                habit.put("monthly_count", rs.getInt("monthly_count"));
                habit.put("weekly_count", rs.getInt("weekly_count"));
                habit.put("today_completed", rs.getInt("today_completed") > 0);
                habits.add(habit);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching habit streaks: " + e.getMessage());
        }
        
        cacheResult(cacheKey, habits);
        return habits;
    }
    
    /**
     * Get current longest habit streak
     */
    public static int getLongestHabitStreak(int userId) {
        String query = "SELECT h.habit_id, " +
                      "DATEDIFF(CURDATE(), MIN(CASE WHEN hl.is_completed = 0 THEN hl.completed_date END)) as streak " +
                      "FROM habits h LEFT JOIN habit_logs hl ON h.habit_id = hl.habit_id " +
                      "WHERE h.user_id = ? AND h.is_active = 1 " +
                      "GROUP BY h.habit_id ORDER BY streak DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("streak");
            }
        } catch (SQLException e) {
            System.err.println("Error fetching longest streak: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Get recent regrets with tags
     */
    public static List<Map<String, Object>> getRecentRegrets(int userId, int days) {
        List<Map<String, Object>> regrets = new ArrayList<>();
        String query = "SELECT * FROM regrets WHERE user_id = ? " +
                      "AND created_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "ORDER BY created_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> regret = new HashMap<>();
                regret.put("regret_id", rs.getInt("regret_id"));
                regret.put("description", rs.getString("description"));
                regret.put("lesson", rs.getString("lesson_learned"));
                regret.put("tag", rs.getString("tag"));
                regret.put("created_at", rs.getTimestamp("created_date"));
                regrets.add(regret);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching regrets: " + e.getMessage());
        }
        
        return regrets;
    }
    
    /**
     * Get recent diary entries
     */
    public static List<Map<String, Object>> getRecentDiaryEntries(int userId, int count) {
        List<Map<String, Object>> entries = new ArrayList<>();
        String query = "SELECT * FROM diary_entries WHERE user_id = ? " +
                      "ORDER BY created_at DESC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, count);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("entry_id", rs.getInt("entry_id"));
                entry.put("title", rs.getString("title"));
                entry.put("content", rs.getString("content"));
                entry.put("mood_tag", rs.getString("mood_tag"));
                entry.put("created_at", rs.getTimestamp("created_at"));
                entries.add(entry);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching diary entries: " + e.getMessage());
        }
        
        return entries;
    }
    
    /**
     * Count total emotion entries
     */
    public static int getEmotionCount(int userId) {
        String query = "SELECT COUNT(*) as count FROM emotion_entries WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("Error counting emotions: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Get most common emotional trigger
     */
    public static String getMostCommonTrigger(int userId, int days) {
        String query = "SELECT `trigger` FROM emotion_entries WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "GROUP BY `trigger` ORDER BY COUNT(*) DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("trigger");
            }
        } catch (SQLException e) {
            System.err.println("Error fetching trigger: " + e.getMessage());
        }
        
        return "General";
    }
    
    /**
     * Get current emotional state
     */
    public static String getCurrentEmotionalState(int userId) {
        Map<String, Object> today = getTodayEmotion(userId);
        if (today != null) {
            return (String) today.get("mood");
        }
        
        List<Map<String, Object>> emotions = getUserEmotions(userId, 7);
        if (!emotions.isEmpty()) {
            return (String) emotions.get(0).get("mood");
        }
        
        return "Neutral";
    }
    
    /**
     * Get average emotional intensity
     */
    public static double getAverageIntensity(int userId, int days) {
        String query = "SELECT AVG(intensity) as avg_intensity FROM emotion_entries " +
                      "WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                double avg = rs.getDouble("avg_intensity");
                return Double.isNaN(avg) ? 0 : avg;
            }
        } catch (SQLException e) {
            System.err.println("Error fetching average intensity: " + e.getMessage());
        }
        
        return 0;
    }
    
    // ==================== CACHE MANAGEMENT ====================
    
    private static void cacheResult(String key, Object data) {
        cache.put(key, new CachedData(data, System.currentTimeMillis()));
    }
    
    private static boolean isCacheValid(String key) {
        if (!cache.containsKey(key)) {
            return false;
        }
        
        CachedData cached = cache.get(key);
        long ageSeconds = (System.currentTimeMillis() - cached.timestamp) / 1000;
        
        if (ageSeconds > CACHE_DURATION_SECONDS) {
            cache.remove(key);
            return false;
        }
        
        return true;
    }
    
    private static Object getFromCache(String key) {
        CachedData cached = cache.get(key);
        return cached != null ? cached.data : null;
    }
    
    /**
     * Clear all caches (call after user actions)
     */
    public static void clearCache() {
        cache.clear();
    }
    
    /**
     * Clear specific user's cache
     */
    public static void clearUserCache(int userId) {
        cache.keySet().removeIf(key -> key.contains("_" + userId));
    }
    
    // ==================== HELPER CLASS ====================
    
    private static class CachedData {
        Object data;
        long timestamp;
        
        CachedData(Object data, long timestamp) {
            this.data = data;
            this.timestamp = timestamp;
        }
    }
}
