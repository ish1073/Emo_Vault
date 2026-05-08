package com.emovault.dao;

import com.emovault.model.Rule;
import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * RuleDAO - Data Access Object for Expert Rules
 */
public class RuleDAO {

    /**
     * Create rules table if it doesn't exist
     */
    public static void createRulesTable() {
        String sql = "CREATE TABLE IF NOT EXISTS rules (" +
                "rule_id INT AUTO_INCREMENT PRIMARY KEY," +
                "expert_id INT NOT NULL," +
                "title VARCHAR(255) NOT NULL," +
                "condition VARCHAR(100) NOT NULL," +
                "condition_value VARCHAR(50)," +
                "suggestion TEXT NOT NULL," +
                "trigger_emotion VARCHAR(50)," +
                "priority INT DEFAULT 5," +
                "active BOOLEAN DEFAULT TRUE," +
                "category VARCHAR(100)," +
                "times_applied INT DEFAULT 0," +
                "effectiveness DECIMAL(3,2) DEFAULT 0," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
                "FOREIGN KEY (expert_id) REFERENCES expert_users(id) ON DELETE CASCADE" +
                ")";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("✓ Rules table ready");
        } catch (SQLException e) {
            System.out.println("Error creating rules table: " + e.getMessage());
        }
    }

    /**
     * Create a new rule
     */
    public int createRule(Rule rule) {
        String sql = "INSERT INTO rules (expert_id, title, condition, condition_value, suggestion, trigger_emotion, priority, category, active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, rule.getExpertId());
            pstmt.setString(2, rule.getTitle());
            pstmt.setString(3, rule.getCondition());
            pstmt.setString(4, rule.getConditionValue());
            pstmt.setString(5, rule.getSuggestion());
            pstmt.setString(6, rule.getTriggerEmotion());
            pstmt.setInt(7, rule.getPriority());
            pstmt.setString(8, rule.getCategory());
            pstmt.setBoolean(9, rule.isActive());

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error creating rule: " + e.getMessage());
        }
        return -1;
    }

    /**
     * Get all active rules
     */
    public List<Rule> getAllActiveRules() {
        List<Rule> rules = new ArrayList<>();
        String sql = "SELECT * FROM rules WHERE active = TRUE ORDER BY priority DESC, created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                rules.add(mapRowToRule(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error fetching rules: " + e.getMessage());
        }
        return rules;
    }

    /**
     * Get rules by expert
     */
    public List<Rule> getRulesByExpert(int expertId) {
        List<Rule> rules = new ArrayList<>();
        String sql = "SELECT * FROM rules WHERE expert_id = ? ORDER BY priority DESC, created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, expertId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                rules.add(mapRowToRule(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error fetching expert rules: " + e.getMessage());
        }
        return rules;
    }

    /**
     * Get rule by ID
     */
    public Rule getRuleById(int ruleId) {
        String sql = "SELECT * FROM rules WHERE rule_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, ruleId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapRowToRule(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching rule: " + e.getMessage());
        }
        return null;
    }

    /**
     * Update a rule
     */
    public boolean updateRule(Rule rule) {
        String sql = "UPDATE rules SET title = ?, condition = ?, condition_value = ?, suggestion = ?, " +
                "trigger_emotion = ?, priority = ?, category = ?, active = ? WHERE rule_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, rule.getTitle());
            pstmt.setString(2, rule.getCondition());
            pstmt.setString(3, rule.getConditionValue());
            pstmt.setString(4, rule.getSuggestion());
            pstmt.setString(5, rule.getTriggerEmotion());
            pstmt.setInt(6, rule.getPriority());
            pstmt.setString(7, rule.getCategory());
            pstmt.setBoolean(8, rule.isActive());
            pstmt.setInt(9, rule.getRuleId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating rule: " + e.getMessage());
        }
        return false;
    }

    /**
     * Delete a rule
     */
    public boolean deleteRule(int ruleId, int expertId) {
        String sql = "DELETE FROM rules WHERE rule_id = ? AND expert_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, ruleId);
            pstmt.setInt(2, expertId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting rule: " + e.getMessage());
        }
        return false;
    }

    /**
     * Get statistics
     */
    public Map<String, Object> getSystemStatistics() {
        Map<String, Object> stats = new HashMap<>();

        try (Connection conn = DBConnection.getConnection()) {
            // Total users
            String userSql = "SELECT COUNT(*) as count FROM users";
            try (Statement stmt = conn.createStatement()) {
                ResultSet rs = stmt.executeQuery(userSql);
                if (rs.next()) {
                    stats.put("totalUsers", rs.getInt("count"));
                }
            }

            // Total rules
            String ruleSql = "SELECT COUNT(*) as count FROM rules WHERE active = TRUE";
            try (Statement stmt = conn.createStatement()) {
                ResultSet rs = stmt.executeQuery(ruleSql);
                if (rs.next()) {
                    stats.put("activeRules", rs.getInt("count"));
                }
            }

            // Most common emotion
            String emotionSql = "SELECT mood, COUNT(*) as freq FROM emotions WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) " +
                    "GROUP BY mood ORDER BY freq DESC LIMIT 1";
            try (Statement stmt = conn.createStatement()) {
                ResultSet rs = stmt.executeQuery(emotionSql);
                if (rs.next()) {
                    stats.put("commonEmotion", rs.getString("mood"));
                    stats.put("emotionFrequency", rs.getInt("freq"));
                }
            }

            // Total suggestions applied
            String suggestionSql = "SELECT SUM(times_applied) as total FROM rules";
            try (Statement stmt = conn.createStatement()) {
                ResultSet rs = stmt.executeQuery(suggestionSql);
                if (rs.next()) {
                    stats.put("suggestionsApplied", rs.getInt("total"));
                }
            }

        } catch (SQLException e) {
            System.out.println("Error getting statistics: " + e.getMessage());
        }

        return stats;
    }

    /**
     * Map ResultSet row to Rule object
     */
    private Rule mapRowToRule(ResultSet rs) throws SQLException {
        Rule rule = new Rule();
        rule.setRuleId(rs.getInt("rule_id"));
        rule.setExpertId(rs.getInt("expert_id"));
        rule.setTitle(rs.getString("title"));
        rule.setCondition(rs.getString("condition"));
        rule.setConditionValue(rs.getString("condition_value"));
        rule.setSuggestion(rs.getString("suggestion"));
        rule.setTriggerEmotion(rs.getString("trigger_emotion"));
        rule.setPriority(rs.getInt("priority"));
        rule.setActive(rs.getBoolean("active"));
        rule.setCategory(rs.getString("category"));
        rule.setTimesApplied(rs.getInt("times_applied"));
        rule.setEffectiveness(rs.getDouble("effectiveness"));
        rule.setCreatedAt(rs.getTimestamp("created_at"));
        rule.setUpdatedAt(rs.getTimestamp("updated_at"));
        return rule;
    }
}
