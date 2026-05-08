package com.emovault.dao;

import com.emovault.util.DBConnection;
import com.emovault.util.PasswordUtil;
import java.sql.*;

/**
 * User Data Access Object (DAO)
 * Handles user registration, authentication, and profile operations
 */
public class UserDAO {
    
    /**
     * Register a new user
     * @param name User's full name
     * @param email User's email (must be unique)
     * @param password User's password
     * @return user_id on success, -1 on failure
     */
    public int registerUser(String name, String email, String password) {
        if (isEmailExists(email)) {
            return -1;  // Email already exists
        }
        
        String query = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, PasswordUtil.hashPassword(password));
            System.out.println("[UserDAO] Registering user: " + email + " with hash: " + PasswordUtil.hashPassword(password));
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error registering user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Authenticate user by email and password
     * @param email User's email
     * @param password Plain text password
     * @return user_id on success, -1 on failure
     */
    public int authenticateUser(String email, String password) {
        String query = "SELECT id, password FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String storedPasswordHash = rs.getString("password");
                System.out.println("[EmoVault] Found user: " + email + " | Hash: " + storedPasswordHash);
                
                // Verify password
                String inputHash = PasswordUtil.hashPassword(password);
                System.out.println("[EmoVault] Input hash: " + inputHash);
                
                if (PasswordUtil.verifyPassword(password, storedPasswordHash)) {
                    System.out.println("[EmoVault] Auth SUCCESS for: " + email);
                    return rs.getInt("id");
                } else {
                    System.out.println("[EmoVault] Auth FAILED - password mismatch");
                }
            } else {
                System.out.println("[EmoVault] User NOT FOUND: " + email);
            }
            
        } catch (SQLException e) {
            System.err.println("Error authenticating user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Get user's name by user ID
     * @param userId User's ID
     * @return User's name or null if not found
     */
    public String getUserName(int userId) {
        String query = "SELECT name FROM users WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("name");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting user name: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Check if email already exists
     * @param email Email to check
     * @return true if email exists, false otherwise
     */
    public boolean isEmailExists(String email) {
        String query = "SELECT COUNT(*) as count FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}
