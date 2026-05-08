package com.emovault.dao;

import com.emovault.model.Decision;
import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

public class DecisionDAO {
    
    /**
     * Create decisions table if it doesn't exist
     */
    public static void createDecisionsTable() {
        String sql = "CREATE TABLE IF NOT EXISTS decisions (" +
                "decision_id INT AUTO_INCREMENT PRIMARY KEY," +
                "user_id INT NOT NULL," +
                "situation TEXT NOT NULL," +
                "option_a TEXT NOT NULL," +
                "option_b TEXT NOT NULL," +
                "chosen_option VARCHAR(1)," +
                "outcome TEXT," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
                "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE" +
                ")";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("✓ Decisions table ready");
        } catch (SQLException e) {
            System.out.println("Error creating decisions table: " + e.getMessage());
        }
    }
    
    /**
     * Save a new decision
     */
    public int saveDecision(int userId, String situation, String optionA, String optionB) {
        String sql = "INSERT INTO decisions (user_id, situation, option_a, option_b) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, userId);
            pstmt.setString(2, situation);
            pstmt.setString(3, optionA);
            pstmt.setString(4, optionB);
            
            pstmt.executeUpdate();
            
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error saving decision: " + e.getMessage());
        }
        return -1;
    }
    
    /**
     * Get all decisions for a user (last 30 days)
     */
    public List<Decision> getUserDecisions(int userId) {
        List<Decision> decisions = new ArrayList<>();
        String sql = "SELECT * FROM decisions WHERE user_id = ? " +
                "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                "ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Decision decision = mapRowToDecision(rs);
                decisions.add(decision);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving decisions: " + e.getMessage());
        }
        return decisions;
    }
    
    /**
     * Get decision by ID
     */
    public Decision getDecisionById(int decisionId, int userId) {
        String sql = "SELECT * FROM decisions WHERE decision_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, decisionId);
            pstmt.setInt(2, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapRowToDecision(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving decision: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Record chosen option
     */
    public boolean recordChoice(int decisionId, int userId, String chosenOption) {
        String sql = "UPDATE decisions SET chosen_option = ? WHERE decision_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, chosenOption);
            pstmt.setInt(2, decisionId);
            pstmt.setInt(3, userId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error recording choice: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Record outcome after decision
     */
    public boolean recordOutcome(int decisionId, int userId, String outcome) {
        String sql = "UPDATE decisions SET outcome = ? WHERE decision_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, outcome);
            pstmt.setInt(2, decisionId);
            pstmt.setInt(3, userId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error recording outcome: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Delete a decision
     */
    public boolean deleteDecision(int decisionId, int userId) {
        String sql = "DELETE FROM decisions WHERE decision_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, decisionId);
            pstmt.setInt(2, userId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting decision: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Helper: Map ResultSet row to Decision object
     */
    private Decision mapRowToDecision(ResultSet rs) throws SQLException {
        Decision decision = new Decision();
        decision.setDecisionId(rs.getInt("decision_id"));
        decision.setUserId(rs.getInt("user_id"));
        decision.setSituation(rs.getString("situation"));
        decision.setOptionA(rs.getString("option_a"));
        decision.setOptionB(rs.getString("option_b"));
        decision.setChosenOption(rs.getString("chosen_option"));
        decision.setOutcome(rs.getString("outcome"));
        decision.setCreatedAt(rs.getTimestamp("created_at"));
        decision.setUpdatedAt(rs.getTimestamp("updated_at"));
        return decision;
    }
}
