package com.emovault.dao;

import com.emovault.model.Alert;
import java.sql.*;
import java.util.*;

public class AlertDAO {
    private Connection connection;

    public AlertDAO(Connection connection) {
        this.connection = connection;
    }

    // Create a new alert
    public boolean addAlert(Alert alert) {
        String query = "INSERT INTO alerts (user_id, alert_type, message, is_read) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, alert.getUserId());
            stmt.setString(2, alert.getAlertType());
            stmt.setString(3, alert.getMessage());
            stmt.setBoolean(4, alert.isRead());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all unread alerts for a user
    public List<Alert> getUnreadAlertsByUserId(int userId) {
        List<Alert> alerts = new ArrayList<>();
        String query = "SELECT * FROM alerts WHERE user_id = ? AND is_read = FALSE ORDER BY created_date DESC LIMIT 5";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Alert alert = new Alert(
                    rs.getInt("alert_id"),
                    rs.getInt("user_id"),
                    rs.getString("alert_type"),
                    rs.getString("message"),
                    rs.getBoolean("is_read"),
                    rs.getTimestamp("created_date")
                );
                alerts.add(alert);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return alerts;
    }

    // Get all alerts for a user
    public List<Alert> getAllAlertsByUserId(int userId) {
        List<Alert> alerts = new ArrayList<>();
        String query = "SELECT * FROM alerts WHERE user_id = ? ORDER BY created_date DESC";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Alert alert = new Alert(
                    rs.getInt("alert_id"),
                    rs.getInt("user_id"),
                    rs.getString("alert_type"),
                    rs.getString("message"),
                    rs.getBoolean("is_read"),
                    rs.getTimestamp("created_date")
                );
                alerts.add(alert);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return alerts;
    }

    // Mark alert as read
    public boolean markAsRead(int alertId) {
        String query = "UPDATE alerts SET is_read = TRUE WHERE alert_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, alertId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete an alert
    public boolean deleteAlert(int alertId) {
        String query = "DELETE FROM alerts WHERE alert_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, alertId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get count of unread alerts
    public int getUnreadAlertCount(int userId) {
        String query = "SELECT COUNT(*) as count FROM alerts WHERE user_id = ? AND is_read = FALSE";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
