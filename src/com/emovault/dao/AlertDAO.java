package com.emovault.dao;

import com.emovault.model.Alert;
import com.emovault.model.AlertType;
import com.emovault.model.AlertPriority;
import com.emovault.util.DBConnection;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

/**
 * AlertDAO - Data Access Object for Alert operations
 * Handles all database operations for the Alerts module
 */
public class AlertDAO {
    
    // Save a new alert
    public void saveAlert(Alert alert) {
        String sql = "INSERT INTO alerts (alert_id, user_id, alert_type, priority, title, " +
                     "message, related_data_id, action_url, created_at, is_dismissed) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, alert.getAlertId());
            stmt.setInt(2, alert.getUserId());
            stmt.setString(3, alert.getAlertType().name());
            stmt.setString(4, alert.getPriority().name());
            stmt.setString(5, alert.getTitle());
            stmt.setString(6, alert.getMessage());
            stmt.setString(7, alert.getRelatedDataId());
            stmt.setString(8, alert.getActionUrl());
            stmt.setTimestamp(9, Timestamp.valueOf(alert.getCreatedAt()));
            stmt.setBoolean(10, alert.isDismissed());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error saving alert: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Get unread alerts for a user
    public List<Alert> getUnreadAlerts(int userId) {
        String sql = "SELECT * FROM alerts WHERE user_id = ? AND is_dismissed = false " +
                     "ORDER BY created_at DESC";
        
        List<Alert> alerts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                alerts.add(mapResultSetToAlert(rs));
            }
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error getting unread alerts: " + e.getMessage());
        }
        
        return alerts;
    }
    
    // Get all alerts for a user
    public List<Alert> getAllAlerts(int userId) {
        String sql = "SELECT * FROM alerts WHERE user_id = ? ORDER BY created_at DESC";
        
        List<Alert> alerts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                alerts.add(mapResultSetToAlert(rs));
            }
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error getting all alerts: " + e.getMessage());
        }
        
        return alerts;
    }
    
    // Get alerts by priority
    public List<Alert> getAlertsByPriority(int userId, AlertPriority priority) {
        String sql = "SELECT * FROM alerts WHERE user_id = ? AND priority = ? " +
                     "AND is_dismissed = false ORDER BY created_at DESC";
        
        List<Alert> alerts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, priority.name());
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                alerts.add(mapResultSetToAlert(rs));
            }
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error getting alerts by priority: " + e.getMessage());
        }
        
        return alerts;
    }
    
    // Get alerts by type
    public List<Alert> getAlertsByType(int userId, AlertType type) {
        String sql = "SELECT * FROM alerts WHERE user_id = ? AND alert_type = ? " +
                     "AND is_dismissed = false ORDER BY created_at DESC";
        
        List<Alert> alerts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, type.name());
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                alerts.add(mapResultSetToAlert(rs));
            }
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error getting alerts by type: " + e.getMessage());
        }
        
        return alerts;
    }
    
    // Dismiss an alert
    public void dismissAlert(String alertId) {
        String sql = "UPDATE alerts SET is_dismissed = true, dismissed_at = ? " +
                     "WHERE alert_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(2, alertId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error dismissing alert: " + e.getMessage());
        }
    }
    
    // Dismiss all alerts of a type
    public void dismissAlertsByType(int userId, AlertType type) {
        String sql = "UPDATE alerts SET is_dismissed = true, dismissed_at = ? " +
                     "WHERE user_id = ? AND alert_type = ? AND is_dismissed = false";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(2, userId);
            stmt.setString(3, type.name());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error dismissing alerts by type: " + e.getMessage());
        }
    }
    
    // Get unread alert count for user
    public int getUnreadAlertCount(int userId) {
        String sql = "SELECT COUNT(*) as count FROM alerts WHERE user_id = ? AND is_dismissed = false";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error getting unread count: " + e.getMessage());
        }
        
        return 0;
    }
    
    // Check if alert exists (for duplicate suppression)
    public boolean alertExistsRecently(int userId, AlertType type, int minutesAgo) {
        String sql = "SELECT COUNT(*) as count FROM alerts " +
                     "WHERE user_id = ? AND alert_type = ? " +
                     "AND created_at > DATE_SUB(NOW(), INTERVAL ? MINUTE)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, type.name());
            stmt.setInt(3, minutesAgo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error checking recent alert: " + e.getMessage());
        }
        
        return false;
    }
    
    // Get alerts since timestamp
    public List<Alert> getAlertsSince(int userId, AlertType type, LocalDateTime since) {
        String sql = "SELECT * FROM alerts WHERE user_id = ? AND alert_type = ? " +
                     "AND created_at > ? ORDER BY created_at DESC";
        
        List<Alert> alerts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, type.name());
            stmt.setTimestamp(3, Timestamp.valueOf(since));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                alerts.add(mapResultSetToAlert(rs));
            }
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error getting alerts since: " + e.getMessage());
        }
        
        return alerts;
    }
    
    // Delete alert
    public void deleteAlert(String alertId) {
        String sql = "DELETE FROM alerts WHERE alert_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, alertId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error deleting alert: " + e.getMessage());
        }
    }
    
    // Get alert by ID
    public Alert getAlertById(String alertId) {
        String sql = "SELECT * FROM alerts WHERE alert_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, alertId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAlert(rs);
            }
        } catch (SQLException e) {
            System.err.println("[AlertDAO] Error getting alert by ID: " + e.getMessage());
        }
        
        return null;
    }
    
    // Helper method to map ResultSet to Alert object
    private Alert mapResultSetToAlert(ResultSet rs) throws SQLException {
        Alert alert = new Alert();
        alert.setAlertId(rs.getString("alert_id"));
        alert.setUserId(rs.getInt("user_id"));
        alert.setAlertType(AlertType.valueOf(rs.getString("alert_type")));
        alert.setPriority(AlertPriority.valueOf(rs.getString("priority")));
        alert.setTitle(rs.getString("title"));
        alert.setMessage(rs.getString("message"));
        alert.setRelatedDataId(rs.getString("related_data_id"));
        alert.setActionUrl(rs.getString("action_url"));
        
        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) {
            alert.setCreatedAt(createdTs.toLocalDateTime());
        }
        
        Timestamp dismissedTs = rs.getTimestamp("dismissed_at");
        if (dismissedTs != null) {
            alert.setDismissedAt(dismissedTs.toLocalDateTime());
        }
        
        alert.setIsDismissed(rs.getBoolean("is_dismissed"));
        
        return alert;
    }
}
