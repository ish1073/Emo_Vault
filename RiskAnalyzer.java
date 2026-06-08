package com.emovault.util;

import com.emovault.dao.*;
import com.emovault.model.*;
import java.sql.Connection;
import java.util.*;

public class RiskAnalyzer {
    private Connection connection;

    public RiskAnalyzer(Connection connection) {
        this.connection = connection;
    }

    // Analyze regrets and generate risk alerts
    public List<Alert> analyzeRegretRisks(int userId) {
        List<Alert> alerts = new ArrayList<>();
        RegretDAO regretDAO = new RegretDAO(connection);

        // Get tag frequency
        Map<String, Integer> tagFrequency = regretDAO.getTagFrequency(userId);

        // Check for repeated tags (more than 2 occurrences)
        for (Map.Entry<String, Integer> entry : tagFrequency.entrySet()) {
            if (entry.getValue() >= 3) {
                String tag = entry.getKey();
                String message = "⚠️ Risk of repeating " + tag + " behavior (" + entry.getValue() + " regrets)";
                Alert alert = new Alert();
                alert.setUserId(userId);
                alert.setAlertType("REGRET_PATTERN");
                alert.setMessage(message);
                alert.setRead(false);
                alerts.add(alert);
            }
        }

        return alerts;
    }

    // Analyze emotions and detect high stress
    public List<Alert> analyzeStressRisks(int userId) {
        List<Alert> alerts = new ArrayList<>();
        
        // This would be connected to EmotionEntry data
        // For now, we provide the framework
        try {
            String query = "SELECT COUNT(*) as stress_count FROM emotion_entries " +
                         "WHERE user_id = ? AND mood = 'sad' OR mood = 'anxious' " +
                         "AND created_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
            
            java.sql.PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, userId);
            java.sql.ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int stressCount = rs.getInt("stress_count");
                if (stressCount >= 5) {
                    String message = "⚠️ High stress detected (" + stressCount + " stressful emotions in last 7 days)";
                    Alert alert = new Alert();
                    alert.setUserId(userId);
                    alert.setAlertType("HIGH_STRESS");
                    alert.setMessage(message);
                    alert.setRead(false);
                    alerts.add(alert);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return alerts;
    }

    // Analyze habit consistency
    public List<Alert> analyzeHabitRisks(int userId) {
        List<Alert> alerts = new ArrayList<>();
        HabitDAO habitDAO = new HabitDAO(connection);

        // Get all active habits for user
        List<Habit> habits = habitDAO.getAllHabitsByUserId(userId);

        for (Habit habit : habits) {
            if (!habit.isActive()) continue;

            double consistencyScore = habit.getConsistencyScore();

            // Alert if consistency drops below 50%
            if (consistencyScore < 50 && consistencyScore > 0) {
                String message = "📉 Habit consistency is dropping for \"" + habit.getName() + "\" (" + 
                                String.format("%.0f", consistencyScore) + "%)";
                Alert alert = new Alert();
                alert.setUserId(userId);
                alert.setAlertType("HABIT_CONSISTENCY");
                alert.setMessage(message);
                alert.setRead(false);
                alerts.add(alert);
            }

            // Alert if streak is broken
            if (consistencyScore == 0 && habit.getCurrentStreak() == 0) {
                String message = "❌ Habit streak broken for \"" + habit.getName() + "\"";
                Alert alert = new Alert();
                alert.setUserId(userId);
                alert.setAlertType("HABIT_STREAK_BROKEN");
                alert.setMessage(message);
                alert.setRead(false);
                alerts.add(alert);
            }
        }

        return alerts;
    }

    // Generate all risk alerts
    public List<Alert> generateAllRiskAlerts(int userId) {
        List<Alert> allAlerts = new ArrayList<>();

        // Combine all risk analyses
        allAlerts.addAll(analyzeRegretRisks(userId));
        allAlerts.addAll(analyzeStressRisks(userId));
        allAlerts.addAll(analyzeHabitRisks(userId));

        return allAlerts;
    }

    // Get total regrets count for a user
    public int getRegretsCount(int userId) {
        try {
            String query = "SELECT COUNT(*) as count FROM regrets WHERE user_id = ?";
            java.sql.PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, userId);
            java.sql.ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get habit suggestions based on regret tags
    public List<String> suggestHabitsFromRegrets(int userId) {
        List<String> suggestions = new ArrayList<>();
        RegretDAO regretDAO = new RegretDAO(connection);

        // Get tag frequency
        Map<String, Integer> tagFrequency = regretDAO.getTagFrequency(userId);

        // Suggest habits based on top regret tags
        for (Map.Entry<String, Integer> entry : tagFrequency.entrySet()) {
            String tag = entry.getKey().toLowerCase();

            if (tag.contains("procrastination")) {
                suggestions.add("💪 Start tasks early - Begin work 30 minutes earlier than usual");
                suggestions.add("📅 Time blocking - Schedule specific time slots for tasks");
            } else if (tag.contains("stress")) {
                suggestions.add("🧘 Daily breathing exercise - Practice 5-minute deep breathing");
                suggestions.add("🚶 Daily walk - Take a 15-minute walk for mental clarity");
            } else if (tag.contains("communication")) {
                suggestions.add("💬 Speak up in meetings - Share one concern per meeting");
                suggestions.add("📞 Weekly check-in - Have one meaningful conversation daily");
            } else if (tag.contains("fear")) {
                suggestions.add("😨 Exposure practice - Face one small fear daily");
                suggestions.add("🎯 Goal setting - Break large goals into smaller steps");
            } else if (tag.contains("health")) {
                suggestions.add("🏃 Exercise - 20-minute daily movement");
                suggestions.add("🥗 Nutrition - Prepare one healthy meal daily");
            }
        }

        return suggestions;
    }
}
