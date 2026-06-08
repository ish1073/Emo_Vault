package com.emovault.dao;

import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * RecommendationDAO - Data Access Object for Expert Recommendations
 * Handles creating, storing, and retrieving expert recommendations for users
 */
public class RecommendationDAO {
    
    /**
     * Create recommendations table if it doesn't exist
     */
    public static void createRecommendationsTable() {
        String createTableSQL = """
            CREATE TABLE IF NOT EXISTS expert_recommendations (
                recommendation_id INT PRIMARY KEY AUTO_INCREMENT,
                expert_id INT NOT NULL,
                user_id INT NOT NULL,
                recommendation_type VARCHAR(50) NOT NULL,
                title VARCHAR(255) NOT NULL,
                content TEXT NOT NULL,
                category VARCHAR(50),
                priority INT DEFAULT 1,
                is_active BOOLEAN DEFAULT TRUE,
                is_viewed BOOLEAN DEFAULT FALSE,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                viewed_at TIMESTAMP NULL,
                FOREIGN KEY (expert_id) REFERENCES expert_accounts(expert_id),
                FOREIGN KEY (user_id) REFERENCES users(user_id),
                INDEX idx_user (user_id),
                INDEX idx_expert (expert_id),
                INDEX idx_active (is_active)
            )
            """;
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(createTableSQL);
            System.out.println("[RecommendationDAO] Recommendations table ready");
        } catch (SQLException e) {
            System.err.println("[RecommendationDAO] Error creating table: " + e.getMessage());
        }
    }
    
    /**
     * Create a new recommendation for a user
     */
    public int createRecommendation(int expertId, int userId, String type, String title, 
                                    String content, String category, int priority) {
        String query = "INSERT INTO expert_recommendations (expert_id, user_id, recommendation_type, " +
                      "title, content, category, priority) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, expertId);
            stmt.setInt(2, userId);
            stmt.setString(3, type);
            stmt.setString(4, title);
            stmt.setString(5, content);
            stmt.setString(6, category);
            stmt.setInt(7, priority);
            
            int affected = stmt.executeUpdate();
            
            if (affected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[RecommendationDAO] Error creating recommendation: " + e.getMessage());
        }
        
        return -1;
    }
    
    /**
     * Get recommendations for a specific user
     */
    public List<Map<String, Object>> getRecommendationsForUser(int userId, int limit) {
        List<Map<String, Object>> recommendations = new ArrayList<>();
        String query = "SELECT r.*, e.expert_name " +
                      "FROM expert_recommendations r " +
                      "JOIN expert_accounts e ON r.expert_id = e.expert_id " +
                      "WHERE r.user_id = ? AND r.is_active = TRUE " +
                      "ORDER BY r.priority ASC, r.created_at DESC " +
                      "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> rec = new HashMap<>();
                rec.put("recommendationId", rs.getInt("recommendation_id"));
                rec.put("expertId", rs.getInt("expert_id"));
                rec.put("expertName", rs.getString("expert_name"));
                rec.put("userId", rs.getInt("user_id"));
                rec.put("type", rs.getString("recommendation_type"));
                rec.put("title", rs.getString("title"));
                rec.put("content", rs.getString("content"));
                rec.put("category", rs.getString("category"));
                rec.put("priority", rs.getInt("priority"));
                rec.put("isActive", rs.getBoolean("is_active"));
                rec.put("isViewed", rs.getBoolean("is_viewed"));
                rec.put("createdAt", rs.getTimestamp("created_at"));
                rec.put("viewedAt", rs.getTimestamp("viewed_at"));
                recommendations.add(rec);
            }
            
        } catch (SQLException e) {
            System.err.println("[RecommendationDAO] Error fetching recommendations: " + e.getMessage());
        }
        
        return recommendations;
    }
    
    /**
     * Get all recommendations made by an expert
     */
    public List<Map<String, Object>> getRecommendationsByExpert(int expertId, int limit) {
        List<Map<String, Object>> recommendations = new ArrayList<>();
        String query = "SELECT r.*, u.username " +
                      "FROM expert_recommendations r " +
                      "JOIN users u ON r.user_id = u.user_id " +
                      "WHERE r.expert_id = ? " +
                      "ORDER BY r.created_at DESC " +
                      "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, expertId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> rec = new HashMap<>();
                rec.put("recommendationId", rs.getInt("recommendation_id"));
                rec.put("expertId", rs.getInt("expert_id"));
                rec.put("userId", rs.getInt("user_id"));
                rec.put("username", rs.getString("username"));
                rec.put("type", rs.getString("recommendation_type"));
                rec.put("title", rs.getString("title"));
                rec.put("content", rs.getString("content"));
                rec.put("category", rs.getString("category"));
                rec.put("priority", rs.getInt("priority"));
                rec.put("isActive", rs.getBoolean("is_active"));
                rec.put("isViewed", rs.getBoolean("is_viewed"));
                rec.put("createdAt", rs.getTimestamp("created_at"));
                rec.put("viewedAt", rs.getTimestamp("viewed_at"));
                recommendations.add(rec);
            }
            
        } catch (SQLException e) {
            System.err.println("[RecommendationDAO] Error fetching expert recommendations: " + e.getMessage());
        }
        
        return recommendations;
    }
    
    /**
     * Mark a recommendation as viewed
     */
    public boolean markAsViewed(int recommendationId) {
        String query = "UPDATE expert_recommendations SET is_viewed = TRUE, viewed_at = NOW() " +
                      "WHERE recommendation_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, recommendationId);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("[RecommendationDAO] Error marking as viewed: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Deactivate a recommendation
     */
    public boolean deactivateRecommendation(int recommendationId, int expertId) {
        String query = "UPDATE expert_recommendations SET is_active = FALSE " +
                      "WHERE recommendation_id = ? AND expert_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, recommendationId);
            stmt.setInt(2, expertId);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("[RecommendationDAO] Error deactivating recommendation: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Get recommendation statistics for an expert
     */
    public Map<String, Object> getRecommendationStats(int expertId) {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            
            // Total recommendations
            String totalQuery = "SELECT COUNT(*) as total FROM expert_recommendations WHERE expert_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(totalQuery)) {
                stmt.setInt(1, expertId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.put("total", rs.getInt("total"));
                }
            }
            
            // Viewed recommendations
            String viewedQuery = "SELECT COUNT(*) as viewed FROM expert_recommendations " +
                               "WHERE expert_id = ? AND is_viewed = TRUE";
            try (PreparedStatement stmt = conn.prepareStatement(viewedQuery)) {
                stmt.setInt(1, expertId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.put("viewed", rs.getInt("viewed"));
                }
            }
            
            // Active recommendations
            String activeQuery = "SELECT COUNT(*) as active FROM expert_recommendations " +
                               "WHERE expert_id = ? AND is_active = TRUE";
            try (PreparedStatement stmt = conn.prepareStatement(activeQuery)) {
                stmt.setInt(1, expertId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.put("active", rs.getInt("active"));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[RecommendationDAO] Error getting stats: " + e.getMessage());
        }
        
        return stats;
    }
    
    /**
     * Get recommendations by category for an expert
     */
    public List<Map<String, Object>> getRecommendationsByCategory(int expertId) {
        List<Map<String, Object>> categories = new ArrayList<>();
        String query = "SELECT category, COUNT(*) as count FROM expert_recommendations " +
                      "WHERE expert_id = ? AND category IS NOT NULL " +
                      "GROUP BY category ORDER BY count DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, expertId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> cat = new HashMap<>();
                cat.put("category", rs.getString("category"));
                cat.put("count", rs.getInt("count"));
                categories.add(cat);
            }
            
        } catch (SQLException e) {
            System.err.println("[RecommendationDAO] Error getting categories: " + e.getMessage());
        }
        
        return categories;
    }
}