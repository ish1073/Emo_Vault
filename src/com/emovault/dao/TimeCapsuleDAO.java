package com.emovault.dao;

import com.emovault.model.TimeCapsule;
import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * TimeCapsule Data Access Object (DAO)
 * Handles time capsule database operations
 */
public class TimeCapsuleDAO {
    
    /**
     * Save a new time capsule
     */
    public int saveTimeCapsule(int userId, String message, String goal, String mood, Timestamp targetDate) {
        String query = "INSERT INTO time_capsules (user_id, message, goal, mood, target_date, opened) VALUES (?, ?, ?, ?, ?, 0)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, message);
            stmt.setString(3, goal != null && !goal.isEmpty() ? goal : null);
            stmt.setString(4, mood != null && !mood.isEmpty() ? mood : null);
            stmt.setTimestamp(5, targetDate);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    System.out.println("[TimeCapsuleDAO] Capsule saved for user " + userId + " with mood: " + mood);
                    return generatedKeys.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[TimeCapsuleDAO] DB Error saving capsule: " + e.getMessage());
        }
        
        return -1;
    }
    
    /**
     * Get all time capsules for a user
     */
    public List<TimeCapsule> getUserCapsules(int userId) {
        List<TimeCapsule> capsules = new ArrayList<>();
        String query = "SELECT * FROM time_capsules WHERE user_id = ? ORDER BY target_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                TimeCapsule capsule = new TimeCapsule();
                capsule.setCapsuleId(rs.getInt("capsule_id"));
                capsule.setUserId(rs.getInt("user_id"));
                capsule.setMessage(rs.getString("message"));
                capsule.setGoal(rs.getString("goal"));
                capsule.setMood(rs.getString("mood"));
                capsule.setTargetDate(rs.getTimestamp("target_date"));
                capsule.setOpened(rs.getBoolean("opened"));
                capsule.setReflection(rs.getString("reflection"));
                capsule.setReflectionMood(rs.getString("reflection_mood"));
                capsule.setAchievementStatus(rs.getString("achievement_status"));
                capsule.setCreatedAt(rs.getTimestamp("created_at"));
                capsule.setOpenedAt(rs.getTimestamp("opened_at"));
                
                capsules.add(capsule);
            }
            
        } catch (SQLException e) {
            System.err.println("[TimeCapsuleDAO] DB Error retrieving capsules: " + e.getMessage());
        }
        
        return capsules;
    }
    
    /**
     * Open a time capsule (mark as opened)
     */
    public boolean openCapsule(int capsuleId, int userId) {
        String query = "UPDATE time_capsules SET opened = 1, opened_at = NOW() WHERE capsule_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, capsuleId);
            stmt.setInt(2, userId);
            
            boolean result = stmt.executeUpdate() > 0;
            if (result) {
                System.out.println("[TimeCapsuleDAO] Capsule " + capsuleId + " opened");
            }
            return result;
            
        } catch (SQLException e) {
            System.err.println("[TimeCapsuleDAO] DB Error opening capsule: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Add reflection to opened capsule
     */
    public boolean addReflection(int capsuleId, int userId, String reflection, String achievementStatus, String reflectionMood) {
        String query = "UPDATE time_capsules SET reflection = ?, achievement_status = ?, reflection_mood = ? WHERE capsule_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, reflection);
            stmt.setString(2, achievementStatus);
            stmt.setString(3, reflectionMood != null && !reflectionMood.isEmpty() ? reflectionMood : null);
            stmt.setInt(4, capsuleId);
            stmt.setInt(5, userId);
            
            boolean result = stmt.executeUpdate() > 0;
            if (result) {
                System.out.println("[TimeCapsuleDAO] Reflection added to capsule " + capsuleId);
            }
            return result;
            
        } catch (SQLException e) {
            System.err.println("[TimeCapsuleDAO] DB Error adding reflection: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Get single capsule
     */
    public TimeCapsule getCapsule(int capsuleId, int userId) {
        String query = "SELECT * FROM time_capsules WHERE capsule_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, capsuleId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                TimeCapsule capsule = new TimeCapsule();
                capsule.setCapsuleId(rs.getInt("capsule_id"));
                capsule.setUserId(rs.getInt("user_id"));
                capsule.setMessage(rs.getString("message"));
                capsule.setGoal(rs.getString("goal"));
                capsule.setMood(rs.getString("mood"));
                capsule.setTargetDate(rs.getTimestamp("target_date"));
                capsule.setOpened(rs.getBoolean("opened"));
                capsule.setReflection(rs.getString("reflection"));
                capsule.setReflectionMood(rs.getString("reflection_mood"));
                capsule.setAchievementStatus(rs.getString("achievement_status"));
                capsule.setCreatedAt(rs.getTimestamp("created_at"));
                capsule.setOpenedAt(rs.getTimestamp("opened_at"));
                
                return capsule;
            }
            
        } catch (SQLException e) {
            System.err.println("[TimeCapsuleDAO] DB Error getting capsule: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Delete a time capsule
     */
    public boolean deleteCapsule(int capsuleId, int userId) {
        String query = "DELETE FROM time_capsules WHERE capsule_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, capsuleId);
            stmt.setInt(2, userId);
            
            boolean result = stmt.executeUpdate() > 0;
            if (result) {
                System.out.println("[TimeCapsuleDAO] Capsule " + capsuleId + " deleted");
            }
            return result;
            
        } catch (SQLException e) {
            System.err.println("[TimeCapsuleDAO] DB Error deleting capsule: " + e.getMessage());
        }
        
        return false;
    }
}
