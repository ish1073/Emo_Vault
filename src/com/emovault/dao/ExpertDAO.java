package com.emovault.dao;

import com.emovault.util.PasswordUtil;
import com.emovault.util.DBConnection;
import java.sql.*;

/**
 * ExpertDAO - Data Access Object for Expert System
 * Handles Expert authentication and credential management
 */
public class ExpertDAO {
    
    /**
     * Verify Expert credentials
     * @param expertId Expert ID
     * @param password Expert password (plain text)
     * @return Expert ID if valid, -1 if invalid
     */
    public int verifyExpertCredentials(String expertId, String password) {
        String query = "SELECT expert_id, password_hash FROM expert_accounts WHERE expert_uid = ? AND is_active = 1";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.err.println("[ExpertDAO] Database connection failed");
                return -1;
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, expertId);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");
                    
                    // Verify password
                    if (PasswordUtil.verifyPassword(password, storedHash)) {
                        System.out.println("[ExpertDAO] Expert login successful: " + expertId);
                        return rs.getInt("expert_id");
                    } else {
                        System.out.println("[ExpertDAO] Invalid password for expert: " + expertId);
                    }
                } else {
                    System.out.println("[ExpertDAO] Expert ID not found: " + expertId);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ExpertDAO] Error verifying expert credentials: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Get Expert details
     * @param expertId Expert ID
     * @return Expert name and role
     */
    public String[] getExpertInfo(int expertId) {
        String query = "SELECT expert_name, role FROM expert_accounts WHERE expert_id = ? AND is_active = 1";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                return null;
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, expertId);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    return new String[]{rs.getString("expert_name"), rs.getString("role")};
                }
            }
        } catch (SQLException e) {
            System.err.println("[ExpertDAO] Error getting expert info: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Check if Expert ID exists
     * @param expertId Expert ID
     * @return true if exists and active
     */
    public boolean expertExists(String expertId) {
        String query = "SELECT 1 FROM expert_accounts WHERE expert_id = ? AND is_active = 1";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                return false;
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, expertId);
                return stmt.executeQuery().next();
            }
        } catch (SQLException e) {
            System.err.println("[ExpertDAO] Error checking expert existence: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Log Expert activity
     * @param expertId Expert ID
     * @param action Activity action
     * @param details Activity details
     */
    public void logExpertActivity(int expertId, String action, String details) {
        String query = "INSERT INTO expert_activity_log (expert_id, action, details, created_date) VALUES (?, ?, ?, NOW())";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                return;
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, expertId);
                stmt.setString(2, action);
                stmt.setString(3, details != null ? details : "");
                stmt.executeUpdate();
                
                System.out.println("[ExpertDAO] Activity logged for expert " + expertId + ": " + action);
            }
        } catch (SQLException e) {
            System.err.println("[ExpertDAO] Error logging activity: " + e.getMessage());
        }
    }
    
    /**
     * Update Expert last login
     * @param expertId Expert ID
     */
    public void updateLastLogin(int expertId) {
        String query = "UPDATE expert_accounts SET last_login = NOW() WHERE expert_id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                return;
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, expertId);
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("[ExpertDAO] Error updating last login: " + e.getMessage());
        }
    }
}
