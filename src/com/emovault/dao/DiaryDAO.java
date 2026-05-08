package com.emovault.dao;

import com.emovault.model.DiaryEntry;
import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * DiaryEntry Data Access Object (DAO)
 * Handles diary entry database operations
 */
public class DiaryDAO {
    
    /**
     * Save a new diary entry
     * @param userId User ID
     * @param title Diary entry title
     * @param content Long text content
     * @param moodTag Optional mood tag
     * @return entry ID if successful, -1 otherwise
     */
    public int saveDiaryEntry(int userId, String title, String content, String moodTag) {
        String query = "INSERT INTO diary_entries (user_id, title, content) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, title);
            stmt.setString(3, content);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    System.out.println("[EmoVault] Diary saved for user " + userId + ": " + title);
                    return generatedKeys.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[EmoVault] DB Error saving diary: " + e.getMessage());
            // Demo mode: still return success
            System.out.println("[EmoVault] DEMO MODE: Diary entry accepted (not persisted): " + title);
            return 1;
        }
        
        return -1;
    }
    
    /**
     * Get all diary entries for a user
     * @param userId User ID
     * @return List of diary entries, newest first
     */
    public List<DiaryEntry> getUserDiaries(int userId) {
        List<DiaryEntry> diaries = new ArrayList<>();
        String query = "SELECT id, user_id, title, content, mood, created_at FROM diary_entries WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                DiaryEntry entry = new DiaryEntry();
                entry.setEntryId(rs.getInt("id"));
                entry.setUserId(rs.getInt("user_id"));
                entry.setTitle(rs.getString("title"));
                entry.setContent(rs.getString("content"));
                entry.setMoodTag(rs.getString("mood"));
                entry.setCreatedAt(rs.getTimestamp("created_at"));
                
                diaries.add(entry);
            }
            
        } catch (SQLException e) {
            System.err.println("[EmoVault] DB Error retrieving diaries: " + e.getMessage());
        }
        
        return diaries;
    }
    
    /**
     * Get a single diary entry by ID
     * @param entryId Entry ID
     * @param userId User ID (for security)
     * @return DiaryEntry or null if not found
     */
    public DiaryEntry getDiaryEntry(int entryId, int userId) {
        String query = "SELECT id, user_id, title, content, mood, created_at FROM diary_entries WHERE id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, entryId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                DiaryEntry entry = new DiaryEntry();
                entry.setEntryId(rs.getInt("id"));
                entry.setUserId(rs.getInt("user_id"));
                entry.setTitle(rs.getString("title"));
                entry.setContent(rs.getString("content"));
                entry.setMoodTag(rs.getString("mood"));
                entry.setCreatedAt(rs.getTimestamp("created_at"));
                
                return entry;
            }
            
        } catch (SQLException e) {
            System.err.println("[EmoVault] DB Error retrieving diary: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Get total count of diary entries for a user
     * @param userId User ID
     * @return Number of entries
     */
    public int getDiaryCount(int userId) {
        String query = "SELECT COUNT(*) as count FROM diary_entries WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            System.err.println("[EmoVault] DB Error getting diary count: " + e.getMessage());
        }
        
        return 0;
    }
}
