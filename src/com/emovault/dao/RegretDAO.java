package com.emovault.dao;

import com.emovault.model.Regret;
import java.sql.*;
import java.util.*;

public class RegretDAO {
    private Connection connection;

    public RegretDAO(Connection connection) {
        this.connection = connection;
    }

    // Create a new regret
    public boolean addRegret(Regret regret) {
        String query = "INSERT INTO regrets (user_id, description, lesson_learned, tag) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, regret.getUserId());
            stmt.setString(2, regret.getDescription());
            stmt.setString(3, regret.getLessonLearned());
            stmt.setString(4, regret.getTag());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all regrets for a user
    public List<Regret> getAllRegretsByUserId(int userId) {
        List<Regret> regrets = new ArrayList<>();
        String query = "SELECT * FROM regrets WHERE user_id = ? ORDER BY created_date DESC";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Regret regret = new Regret(
                    rs.getInt("regret_id"),
                    rs.getInt("user_id"),
                    rs.getString("description"),
                    rs.getString("lesson_learned"),
                    rs.getString("tag"),
                    rs.getTimestamp("created_date")
                );
                regrets.add(regret);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return regrets;
    }

    // Get a regret by ID
    public Regret getRegretById(int regretId) {
        String query = "SELECT * FROM regrets WHERE regret_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, regretId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Regret(
                    rs.getInt("regret_id"),
                    rs.getInt("user_id"),
                    rs.getString("description"),
                    rs.getString("lesson_learned"),
                    rs.getString("tag"),
                    rs.getTimestamp("created_date")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update a regret
    public boolean updateRegret(Regret regret) {
        String query = "UPDATE regrets SET description = ?, lesson_learned = ?, tag = ? WHERE regret_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, regret.getDescription());
            stmt.setString(2, regret.getLessonLearned());
            stmt.setString(3, regret.getTag());
            stmt.setInt(4, regret.getRegretId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a regret
    public boolean deleteRegret(int regretId) {
        String query = "DELETE FROM regrets WHERE regret_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, regretId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get tag frequency for insights
    public Map<String, Integer> getTagFrequency(int userId) {
        Map<String, Integer> tagFrequency = new HashMap<>();
        String query = "SELECT tag, COUNT(*) as count FROM regrets WHERE user_id = ? GROUP BY tag ORDER BY count DESC";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                tagFrequency.put(rs.getString("tag"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            System.err.println("[RegretDAO] Error getting tag frequency: " + e.getMessage());
        }

        return tagFrequency;
    }

    // Get count of all regrets for a user
    public int countRegrets(int userId) {
        String query = "SELECT COUNT(*) as count FROM regrets WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("[RegretDAO] Error counting regrets: " + e.getMessage());
        }
        return 0;
    }
}
