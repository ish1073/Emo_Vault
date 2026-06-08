package com.emovault.service;

import com.emovault.util.DBConnection;
import java.sql.*;
import java.time.*;
import java.util.*;

/**
 * Dynamic Notification/Alert Generator
 * Generates real alerts from actual user activity, not hardcoded demo data
 */
public class NotificationEngine {
    
    /**
     * Generate all active alerts for a user
     * Returns alerts based on real user activity and behavior
     */
    public static List<Map<String, Object>> generateUserAlerts(int userId) {
        List<Map<String, Object>> alerts = new ArrayList<>();
        
        // 1. Check for emotional risk warnings
        checkEmotionalRisk(userId, alerts);
        
        // 2. Check for broken habit streaks
        checkBrokenStreaks(userId, alerts);
        
        // 3. Check for repeated regret patterns
        checkRepeatedPatterns(userId, alerts);
        
        // 4. Check for positive milestones
        checkMilestones(userId, alerts);
        
        // 5. Check for time capsules ready to open
        checkTimeCapsules(userId, alerts);
        
        return alerts;
    }
    
    /**
     * Generate emotional risk alert if stress/negative emotions are high
     */
    private static void checkEmotionalRisk(int userId, List<Map<String, Object>> alerts) {
        List<Map<String, Object>> recent = DataService.getUserEmotions(userId, 3);
        
        if (recent.isEmpty()) return;
        
        // Calculate negative emotion count and average intensity
        int negativeCount = 0;
        double totalIntensity = 0;
        String[] negativeEmotions = {"sad", "anxious", "stressed", "angry", "frustrated", "depressed"};
        
        for (Map<String, Object> emotion : recent) {
            String mood = emotion.get("mood") != null ? emotion.get("mood").toString().toLowerCase() : "";
            Object intensityObj = emotion.get("intensity");
            int intensity = (intensityObj != null) ? ((Number) intensityObj).intValue() : 0;
            totalIntensity += intensity;
            
            for (String negMood : negativeEmotions) {
                if (mood.contains(negMood)) {
                    negativeCount++;
                    break;
                }
            }
        }
        
        double avgIntensity = totalIntensity / recent.size();
        
        // Generate alert if risk is detected
        if (avgIntensity >= 7 || negativeCount >= 2) {
            Map<String, Object> alert = new HashMap<>();
            alert.put("type", "EMOTIONAL_RISK");
            alert.put("priority", avgIntensity >= 8 ? "HIGH" : "MEDIUM");
            alert.put("icon", "⚠️");
            alert.put("title", "High Stress Detected");
            alert.put("message", String.format(
                "Your stress levels have been high (avg %.1f/10). Consider a coping strategy.",
                avgIntensity
            ));
            alert.put("actionUrl", "/EmoVault/emotion");
            alert.put("createdAt", LocalDateTime.now());
            
            if (!isDuplicateAlert(userId, "EMOTIONAL_RISK")) {
                alerts.add(alert);
                saveAlert(userId, alert);
            }
        }
    }
    
    /**
     * Check if any habit streaks have been broken
     */
    private static void checkBrokenStreaks(int userId, List<Map<String, Object>> alerts) {
        String query = "SELECT h.habit_id, h.name, " +
                      "DATEDIFF(CURDATE(), MAX(hl.completed_date)) as days_missed " +
                      "FROM habits h LEFT JOIN habit_logs hl ON h.habit_id = hl.habit_id " +
                      "WHERE h.user_id = ? AND h.is_active = 1 " +
                      "GROUP BY h.habit_id HAVING days_missed > 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String habitName = rs.getString("name");
                int daysMissed = rs.getInt("days_missed");
                
                if (daysMissed <= 7) { // Only alert for recent breaks
                    Map<String, Object> alert = new HashMap<>();
                    alert.put("type", "HABIT_DISRUPTION");
                    alert.put("priority", "MEDIUM");
                    alert.put("icon", "🔥");
                    alert.put("title", "Habit Streak Broken");
                    alert.put("message", String.format(
                        "Your '%s' streak was broken %d days ago. Ready to start fresh?",
                        habitName, daysMissed
                    ));
                    alert.put("actionUrl", "/EmoVault/habit");
                    alert.put("createdAt", LocalDateTime.now());
                    
                    if (!isDuplicateAlert(userId, "HABIT_DISRUPTION_" + habitName)) {
                        alerts.add(alert);
                        saveAlert(userId, alert);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking broken streaks: " + e.getMessage());
        }
    }
    
    /**
     * Check for repeated regret patterns (lessons not learned)
     */
    private static void checkRepeatedPatterns(int userId, List<Map<String, Object>> alerts) {
        String query = "SELECT tag, COUNT(*) as count FROM regrets " +
                      "WHERE user_id = ? AND created_date >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                      "GROUP BY tag HAVING count >= 3 ORDER BY count DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String tag = rs.getString("tag");
                int count = rs.getInt("count");
                
                Map<String, Object> alert = new HashMap<>();
                alert.put("type", "BEHAVIORAL_PATTERN");
                alert.put("priority", count >= 5 ? "HIGH" : "MEDIUM");
                alert.put("icon", "📊");
                alert.put("title", "Repeated Pattern Detected");
                alert.put("message", String.format(
                    "You've mentioned \"%s\" %d times this month. This might be worth exploring deeper.",
                    tag, count
                ));
                alert.put("actionUrl", "/EmoVault/diary");
                alert.put("createdAt", LocalDateTime.now());
                
                if (!isDuplicateAlert(userId, "PATTERN_" + tag)) {
                    alerts.add(alert);
                    saveAlert(userId, alert);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking patterns: " + e.getMessage());
        }
    }
    
    /**
     * Check for positive milestones (achievement alerts)
     */
    private static void checkMilestones(int userId, List<Map<String, Object>> alerts) {
        // Check for emotions milestone
        int emotionCount = DataService.getEmotionCount(userId);
        if (emotionCount > 0 && emotionCount % 10 == 0) {
            Map<String, Object> alert = new HashMap<>();
            alert.put("type", "MILESTONE");
            alert.put("priority", "LOW");
            alert.put("icon", "🎉");
            alert.put("title", "Milestone Reached!");
            alert.put("message", String.format(
                "You've logged %d emotions! Keep up the self-awareness journey.",
                emotionCount
            ));
            alert.put("actionUrl", "/EmoVault/analytics");
            alert.put("createdAt", LocalDateTime.now());
            
            if (!isDuplicateAlert(userId, "MILESTONE_EMOTIONS_" + emotionCount)) {
                alerts.add(alert);
                saveAlert(userId, alert);
            }
        }
        
        // Check for habit consistency
        List<Map<String, Object>> habits = DataService.getHabitStreaks(userId);
        for (Map<String, Object> habit : habits) {
            Object weeklyCountObj = habit.get("weekly_count");
            int weeklyCount = (weeklyCountObj != null) ? ((Number) weeklyCountObj).intValue() : 0;
            String habitName = (String) habit.get("name");
            
            if (weeklyCount >= 7) { // Full week completion
                Map<String, Object> alert = new HashMap<>();
                alert.put("type", "MILESTONE");
                alert.put("priority", "LOW");
                alert.put("icon", "🏆");
                alert.put("title", "Weekly Goal Achieved!");
                alert.put("message", String.format(
                    "You completed '%s' 7 days this week! Excellent consistency!",
                    habitName
                ));
                alert.put("actionUrl", "/EmoVault/habit");
                alert.put("createdAt", LocalDateTime.now());
                
                if (!isDuplicateAlert(userId, "WEEKLY_GOAL_" + habitName)) {
                    alerts.add(alert);
                    saveAlert(userId, alert);
                }
            }
        }
    }
    
    /**
     * Check for time capsules ready to open
     */
    private static void checkTimeCapsules(int userId, List<Map<String, Object>> alerts) {
        String query = "SELECT capsule_id, title FROM time_capsule " +
                      "WHERE user_id = ? AND unlock_date <= NOW() AND is_opened = 0";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String title = rs.getString("title");
                
                Map<String, Object> alert = new HashMap<>();
                alert.put("type", "TIME_SENSITIVE");
                alert.put("priority", "MEDIUM");
                alert.put("icon", "📬");
                alert.put("title", "Time Capsule Ready");
                alert.put("message", String.format(
                    "Your time capsule \"%s\" is ready to open!",
                    title
                ));
                alert.put("actionUrl", "/EmoVault/timecapsule");
                alert.put("createdAt", LocalDateTime.now());
                
                if (!isDuplicateAlert(userId, "CAPSULE_" + title)) {
                    alerts.add(alert);
                    saveAlert(userId, alert);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking capsules: " + e.getMessage());
        }
    }
    
    /**
     * Check if alert of this type already exists (avoid duplicates)
     */
    private static boolean isDuplicateAlert(int userId, String alertKey) {
        String query = "SELECT COUNT(*) as count FROM alerts " +
                      "WHERE user_id = ? AND message LIKE ? " +
                      "AND created_date >= DATE_SUB(NOW(), INTERVAL 24 HOUR)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, "%" + alertKey + "%");
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking duplicates: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Save alert to database
     */
    private static void saveAlert(int userId, Map<String, Object> alert) {
        String query = "INSERT INTO alerts (user_id, alert_type, message, is_read, created_date) " +
                      "VALUES (?, ?, ?, 0, NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, (String) alert.get("type"));
            stmt.setString(3, (String) alert.get("message"));
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error saving alert: " + e.getMessage());
        }
    }
    
    /**
     * Get saved alerts from database (max 10 most recent)
     */
    public static List<Map<String, Object>> getSavedAlerts(int userId, int limit) {
        List<Map<String, Object>> alerts = new ArrayList<>();
        String query = "SELECT * FROM alerts WHERE user_id = ? " +
                      "ORDER BY created_date DESC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> alert = new HashMap<>();
                alert.put("alert_id", rs.getInt("alert_id"));
                alert.put("type", rs.getString("alert_type"));
                alert.put("message", rs.getString("message"));
                alert.put("is_read", rs.getBoolean("is_read"));
                alert.put("created_at", rs.getTimestamp("created_date"));
                alerts.add(alert);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching alerts: " + e.getMessage());
        }
        
        return alerts;
    }
    
    /**
     * Mark alert as read
     */
    public static void markAlertAsRead(int alertId) {
        String query = "UPDATE alerts SET is_read = 1 WHERE alert_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, alertId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error marking alert as read: " + e.getMessage());
        }
    }
}
