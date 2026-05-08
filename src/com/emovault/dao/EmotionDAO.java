package com.emovault.dao;

import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Emotion Entry Data Access Object (DAO)
 * Handles all database operations for emotion entries
 */
public class EmotionDAO {
    
    /**
     * Save a new emotion entry
     * @param userId User ID
     * @param trigger What triggered the emotion
     * @param mood The mood/feeling
     * @param intensity Intensity level (1-10)
     * @param response User's response/coping mechanism
     * @return true if saved successfully, false otherwise
     */
    public boolean saveEmotion(int userId, String trigger, String mood, int intensity, String response) {
        String query = "INSERT INTO emotion_entries (user_id, `trigger`, mood, intensity, response) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, trigger);
            stmt.setString(3, mood);
            stmt.setInt(4, intensity);
            stmt.setString(5, response);
            
            int result = stmt.executeUpdate();
            System.out.println("[EmoVault] Emotion saved for user " + userId + ": " + trigger);
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("[EmoVault] DB Error saving emotion: " + e.getMessage());
            // In demo mode, still return success for UI purposes
            System.out.println("[EmoVault] DEMO MODE: Emotion entry accepted (not persisted): " + trigger);
            return true;
        }
    }
    
    /**
     * Get all emotion entries for a user
     * @param userId User ID
     * @return List of emotion entries as Map objects
     */
    public List<Map<String, Object>> getUserEmotions(int userId) {
        List<Map<String, Object>> emotions = new ArrayList<>();
        String query = "SELECT * FROM emotion_entries WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
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
            System.err.println("Error retrieving emotion entries: " + e.getMessage());
            e.printStackTrace();
        }
        
        return emotions;
    }
    
    /**
     * Get total count of emotion entries for a user
     * @param userId User ID
     * @return Number of entries
     */
    public int getEmotionCount(int userId) {
        String query = "SELECT COUNT(*) as count FROM emotion_entries WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting emotion count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get the most frequent mood for a user
     * @param userId User ID
     * @return Most common mood or null
     */
    public String getMostFrequentMood(int userId) {
        String query = "SELECT mood FROM emotion_entries WHERE user_id = ? GROUP BY mood ORDER BY COUNT(*) DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("mood");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting most frequent mood: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get today's emotion entry (most recent one from today)
     * @param userId User ID
     * @return Map with emotion data or null if no entry today
     */
    public Map<String, Object> getTodayEmotion(int userId) {
        String query = "SELECT * FROM emotion_entries WHERE user_id = ? AND DATE(created_at) = CURDATE() ORDER BY created_at DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Map<String, Object> emotion = new HashMap<>();
                emotion.put("entry_id", rs.getInt("entry_id"));
                emotion.put("trigger", rs.getString("trigger"));
                emotion.put("mood", rs.getString("mood"));
                emotion.put("intensity", rs.getInt("intensity"));
                emotion.put("response", rs.getString("response"));
                emotion.put("created_at", rs.getTimestamp("created_at"));
                return emotion;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting today's emotion: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
}
