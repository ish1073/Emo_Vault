package com.emovault.service.analysis;

import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Risk Calculation Helper
 * Calculates dynamic emotional risk scores based on:
 * - Sadness frequency
 * - Anxiety repetition
 * - Regret recurrence
 * - Negative diary sentiment
 * - Inactivity periods
 * - Habit inconsistency
 * 
 * Returns a comprehensive risk assessment with actionable insights.
 */
public class RiskCalculationHelper {
    
    // Risk weight factors
    private static final double SADNESS_WEIGHT = 1.5;
    private static final double ANXIETY_WEIGHT = 1.8;
    private static final double REGRET_WEIGHT = 1.2;
    private static final double INACTIVITY_WEIGHT = 1.0;
    private static final double HABIT_INCONSISTENCY_WEIGHT = 0.8;
    private static final double HIGH_INTENSITY_WEIGHT = 1.3;
    private static final double NEGATIVE_TREND_WEIGHT = 1.4;
    
    /**
     * Calculate comprehensive risk score (0-100)
     */
    public static Map<String, Object> calculateRiskScore(int userId, int daysPeriod) {
        Map<String, Object> riskData = new HashMap<>();
        
        // Gather all data
        List<Map<String, Object>> emotions = getEmotions(userId, daysPeriod);
        List<Map<String, Object>> regrets = getRegrets(userId, daysPeriod);
        List<Map<String, Object>> diaryEntries = getDiaryEntries(userId, daysPeriod);
        Map<String, Object> habitData = getHabitData(userId);
        
        // Handle insufficient data
        int totalEntries = emotions.size() + diaryEntries.size() + regrets.size();
        if (totalEntries < 3) {
            riskData.put("riskScore", 0);
            riskData.put("riskLevel", "insufficient_data");
            riskData.put("message", "Not enough data to calculate risk. Continue logging your emotions and thoughts.");
            riskData.put("hasData", false);
            return riskData;
        }
        
        riskData.put("hasData", true);
        
        // Calculate individual risk factors
        double sadnessRisk = calculateSadnessRisk(emotions);
        double anxietyRisk = calculateAnxietyRisk(emotions);
        double regretRisk = calculateRegretRisk(regrets);
        double inactivityRisk = calculateInactivityRisk(emotions, diaryEntries, daysPeriod);
        double habitRisk = calculateHabitInconsistencyRisk(habitData);
        double intensityRisk = calculateHighIntensityRisk(emotions);
        double trendRisk = calculateNegativeTrendRisk(emotions);
        
        // Calculate weighted total risk score (0-100)
        double totalRisk = (sadnessRisk * SADNESS_WEIGHT) +
                          (anxietyRisk * ANXIETY_WEIGHT) +
                          (regretRisk * REGRET_WEIGHT) +
                          (inactivityRisk * INACTIVITY_WEIGHT) +
                          (habitRisk * HABIT_INCONSISTENCY_WEIGHT) +
                          (intensityRisk * HIGH_INTENSITY_WEIGHT) +
                          (trendRisk * NEGATIVE_TREND_WEIGHT);
        
        // Normalize to 0-100 scale
        double maxPossibleRisk = SADNESS_WEIGHT + ANXIETY_WEIGHT + REGRET_WEIGHT + 
                                INACTIVITY_WEIGHT + HABIT_INCONSISTENCY_WEIGHT + 
                                HIGH_INTENSITY_WEIGHT + NEGATIVE_TREND_WEIGHT;
        
        int riskScore = (int) Math.round((totalRisk / maxPossibleRisk) * 100);
        riskScore = Math.min(100, Math.max(0, riskScore));
        
        riskData.put("riskScore", riskScore);
        
        // Determine risk level
        String riskLevel;
        if (riskScore >= 70) {
            riskLevel = "high";
        } else if (riskScore >= 40) {
            riskLevel = "medium";
        } else {
            riskLevel = "low";
        }
        riskData.put("riskLevel", riskLevel);
        
        // Add individual factor scores - use longValue() explicitly to handle as Long
        riskData.put("factors", Map.of(
            "sadness", Long.valueOf(Math.round(sadnessRisk * 100.0)),
            "anxiety", Long.valueOf(Math.round(anxietyRisk * 100.0)),
            "regret", Long.valueOf(Math.round(regretRisk * 100.0)),
            "inactivity", Long.valueOf(Math.round(inactivityRisk * 100.0)),
            "habitInconsistency", Long.valueOf(Math.round(habitRisk * 100.0)),
            "highIntensity", Long.valueOf(Math.round(intensityRisk * 100.0)),
            "negativeTrend", Long.valueOf(Math.round(trendRisk * 100.0))
        ));
        
        // Generate risk insights
        riskData.put("insights", generateRiskInsights(riskData));
        
        return riskData;
    }
    
    /**
     * Calculate sadness risk based on frequency and recency
     */
    private static double calculateSadnessRisk(List<Map<String, Object>> emotions) {
        if (emotions.isEmpty()) return 0;
        
        long sadnessCount = emotions.stream()
            .filter(e -> "Sad".equals(e.get("mood")) || "Depressed".equals(e.get("mood")) || 
                        "Hopeless".equals(e.get("mood")))
            .count();
        
        double frequency = (double) sadnessCount / emotions.size();
        
        // Check recency (more recent = higher risk)
        boolean recentSadness = false;
        if (emotions.size() >= 1) {
            String recentMood = (String) emotions.get(0).get("mood");
            recentSadness = "Sad".equals(recentMood) || "Depressed".equals(recentMood);
        }
        
        double risk = frequency * 10; // Scale to 0-10
        if (recentSadness) risk *= 1.2; // 20% increase for recent sadness
        
        return Math.min(1.0, risk / 10.0);
    }
    
    /**
     * Calculate anxiety risk based on frequency and intensity
     */
    private static double calculateAnxietyRisk(List<Map<String, Object>> emotions) {
        if (emotions.isEmpty()) return 0;
        
        long anxietyCount = emotions.stream()
            .filter(e -> "Anxious".equals(e.get("mood")) || "Stressed".equals(e.get("mood")) || 
                        "Overwhelmed".equals(e.get("mood")) || "Fearful".equals(e.get("mood")))
            .count();
        
        double frequency = (double) anxietyCount / emotions.size();
        
        // Check average intensity of anxious emotions
        double avgAnxietyIntensity = emotions.stream()
            .filter(e -> "Anxious".equals(e.get("mood")) || "Stressed".equals(e.get("mood")))
            .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
            .average().orElse(0);
        
        double risk = frequency * 10;
        if (avgAnxietyIntensity >= 7) risk *= 1.3; // Higher risk for intense anxiety
        
        return Math.min(1.0, risk / 10.0);
    }
    
    /**
     * Calculate regret risk based on frequency and themes
     */
    private static double calculateRegretRisk(List<Map<String, Object>> regrets) {
        if (regrets.isEmpty()) return 0;
        
        int regretCount = regrets.size();
        
        // Check for repeated regret themes
        Map<String, Integer> themes = new HashMap<>();
        for (Map<String, Object> regret : regrets) {
            String tag = (String) regret.get("tag");
            if (tag != null) {
                themes.put(tag, themes.getOrDefault(tag, 0) + 1);
            }
        }
        
        // Repeated themes increase risk
        long repeatedThemes = themes.values().stream().filter(count -> count >= 2).count();
        
        double risk = Math.min(regretCount * 0.15, 1.0);
        if (repeatedThemes > 0) risk *= (1 + repeatedThemes * 0.1);
        
        return Math.min(1.0, risk);
    }
    
    /**
     * Calculate inactivity risk (gaps in logging)
     */
    private static double calculateInactivityRisk(List<Map<String, Object>> emotions, 
                                                   List<Map<String, Object>> diaryEntries, 
                                                   int daysPeriod) {
        int totalEntries = emotions.size() + diaryEntries.size();
        
        // Expected entries (at least 1 every 2 days is healthy)
        double expectedEntries = daysPeriod / 2.0;
        
        if (expectedEntries == 0) return 0;
        
        double ratio = totalEntries / expectedEntries;
        
        // Check for recent inactivity (no entries in last 3 days)
        boolean recentInactivity = true;
        if (!emotions.isEmpty()) {
            Timestamp latestEmotion = (Timestamp) emotions.get(0).get("created_at");
            long hoursSinceLast = (System.currentTimeMillis() - latestEmotion.getTime()) / (1000 * 60 * 60);
            recentInactivity = hoursSinceLast > 72;
        } else if (!diaryEntries.isEmpty()) {
            Timestamp latestDiary = (Timestamp) diaryEntries.get(0).get("created_at");
            long hoursSinceLast = (System.currentTimeMillis() - latestDiary.getTime()) / (1000 * 60 * 60);
            recentInactivity = hoursSinceLast > 72;
        }
        
        double risk = 0;
        if (ratio < 0.5) risk = 0.8; // Very low activity
        else if (ratio < 1.0) risk = 0.4; // Below expected
        else risk = 0.1; // Good activity
        
        if (recentInactivity) risk *= 1.5;
        
        return Math.min(1.0, risk);
    }
    
    /**
     * Calculate habit inconsistency risk
     */
    private static double calculateHabitInconsistencyRisk(Map<String, Object> habitData) {
        if (habitData.isEmpty()) return 0.3; // Neutral risk if no habits
        
        int totalHabits = getNumberValue(habitData.get("total_habits"));
        int activeHabits = getNumberValue(habitData.get("active_habits"));
        int weeklyCompletions = getNumberValue(habitData.get("weekly_completions"));
        
        if (totalHabits == 0) return 0.3;
        
        double activityRate = (double) activeHabits / totalHabits;
        double expectedWeekly = activeHabits * 7; // Daily habits
        double completionRate = expectedWeekly > 0 ? (double) weeklyCompletions / expectedWeekly : 0;
        
        double risk = 0;
        if (activityRate < 0.5) risk = 0.7;
        else if (completionRate < 0.3) risk = 0.6;
        else if (completionRate < 0.6) risk = 0.4;
        else risk = 0.1;
        
        return Math.min(1.0, risk);
    }
    
    /**
     * Calculate risk from high intensity emotions
     */
    private static double calculateHighIntensityRisk(List<Map<String, Object>> emotions) {
        if (emotions.isEmpty()) return 0;
        
        long highIntensityCount = emotions.stream()
            .filter(e -> ((Number) e.get("intensity")).doubleValue() >= 8)
            .count();
        
        double ratio = (double) highIntensityCount / emotions.size();
        
        return Math.min(1.0, ratio * 3); // Scale up the ratio
    }
    
    /**
     * Calculate risk from negative emotional trends
     */
    private static double calculateNegativeTrendRisk(List<Map<String, Object>> emotions) {
        if (emotions.size() < 4) return 0.3; // Neutral for insufficient data
        
        // Compare first half to second half (newer entries)
        int mid = emotions.size() / 2;
        List<Map<String, Object>> older = emotions.subList(mid, emotions.size());
        List<Map<String, Object>> newer = emotions.subList(0, mid);
        
        // Count negative emotions in each half
        long olderNegative = older.stream()
            .filter(e -> isNegativeEmotion((String) e.get("mood")))
            .count();
        
        long newerNegative = newer.stream()
            .filter(e -> isNegativeEmotion((String) e.get("mood")))
            .count();
        
        double olderRatio = (double) olderNegative / older.size();
        double newerRatio = (double) newerNegative / newer.size();
        
        // If negative emotions are increasing, higher risk
        double change = newerRatio - olderRatio;
        
        if (change > 0.3) return Math.min(1.0, change * 2);
        else if (change > 0.1) return 0.5;
        else return 0.2;
    }
    
    private static boolean isNegativeEmotion(String mood) {
        return "Sad".equals(mood) || "Stressed".equals(mood) || "Angry".equals(mood) ||
               "Anxious".equals(mood) || "Depressed".equals(mood) || "Frustrated".equals(mood) ||
               "Overwhelmed".equals(mood) || "Lonely".equals(mood) || "Fearful".equals(mood);
    }
    
    /**
     * Safely extract int value from Number objects (handles Long, Integer, etc.)
     * COUNT(*) and Math.round() return Long, not Integer
     */
    private static int getNumberValue(Object value) {
        if (value == null) return 0;
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        return 0;
    }
    
    /**
     * Generate insights based on risk factors
     */
    private static List<Map<String, Object>> generateRiskInsights(Map<String, Object> riskData) {
        List<Map<String, Object>> insights = new ArrayList<>();
        
        @SuppressWarnings("unchecked")
        Map<String, Object> factors = (Map<String, Object>) riskData.get("factors");
        
        if (factors == null) return insights;
        
        // Use safe number extraction - factors contain Long values from Math.round()
        if (getNumberValue(factors.get("sadness")) >= 60) {
            Map<String, Object> insight = new HashMap<>();
            insight.put("type", "sadness");
            insight.put("severity", "high");
            insight.put("message", "Frequent sadness detected. Consider reaching out to someone you trust or engaging in mood-boosting activities.");
            insights.add(insight);
        }
        
        if (getNumberValue(factors.get("anxiety")) >= 60) {
            Map<String, Object> insight = new HashMap<>();
            insight.put("type", "anxiety");
            insight.put("severity", "high");
            insight.put("message", "High anxiety levels detected. Try relaxation techniques like deep breathing or mindfulness.");
            insights.add(insight);
        }
        
        if (getNumberValue(factors.get("regret")) >= 60) {
            Map<String, Object> insight = new HashMap<>();
            insight.put("type", "regret");
            insight.put("severity", "medium");
            insight.put("message", "Recurring regrets detected. Focus on learning from past experiences rather than dwelling on them.");
            insights.add(insight);
        }
        
        if (getNumberValue(factors.get("inactivity")) >= 60) {
            Map<String, Object> insight = new HashMap<>();
            insight.put("type", "inactivity");
            insight.put("severity", "medium");
            insight.put("message", "Your logging has been inconsistent. Regular reflection helps track emotional patterns.");
            insights.add(insight);
        }
        
        if (getNumberValue(factors.get("habitInconsistency")) >= 60) {
            Map<String, Object> insight = new HashMap<>();
            insight.put("type", "habits");
            insight.put("severity", "medium");
            insight.put("message", "Habit inconsistency detected. Building consistent routines can improve emotional stability.");
            insights.add(insight);
        }
        
        if (insights.isEmpty()) {
            Map<String, Object> insight = new HashMap<>();
            insight.put("type", "positive");
            insight.put("severity", "low");
            insight.put("message", "Risk factors are low. Keep up your current self-care practices!");
            insights.add(insight);
        }
        
        return insights;
    }
    
    // Data access methods
    private static List<Map<String, Object>> getEmotions(int userId, int days) {
        List<Map<String, Object>> emotions = new ArrayList<>();
        String query = "SELECT * FROM emotion_entries WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> emotion = new HashMap<>();
                emotion.put("mood", rs.getString("mood"));
                emotion.put("intensity", rs.getInt("intensity"));
                emotion.put("created_at", rs.getTimestamp("created_at"));
                emotions.add(emotion);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching emotions: " + e.getMessage());
        }
        
        return emotions;
    }
    
    private static List<Map<String, Object>> getRegrets(int userId, int days) {
        List<Map<String, Object>> regrets = new ArrayList<>();
        String query = "SELECT * FROM regrets WHERE user_id = ? " +
                      "AND created_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "ORDER BY created_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> regret = new HashMap<>();
                regret.put("tag", rs.getString("tag"));
                regret.put("description", rs.getString("description"));
                regrets.add(regret);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching regrets: " + e.getMessage());
        }
        
        return regrets;
    }
    
    private static List<Map<String, Object>> getDiaryEntries(int userId, int days) {
        List<Map<String, Object>> entries = new ArrayList<>();
        String query = "SELECT * FROM diary_entries WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("content", rs.getString("content"));
                entry.put("mood_tag", rs.getString("mood_tag"));
                entries.add(entry);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching diary entries: " + e.getMessage());
        }
        
        return entries;
    }
    
    private static Map<String, Object> getHabitData(int userId) {
        Map<String, Object> data = new HashMap<>();
        
        String query = "SELECT " +
                      "(SELECT COUNT(*) FROM habits WHERE user_id = ?) as total_habits, " +
                      "(SELECT COUNT(*) FROM habits WHERE user_id = ? AND is_active = 1) as active_habits, " +
                      "(SELECT COUNT(*) FROM habit_logs hl JOIN habits h ON hl.habit_id = h.habit_id " +
                      "WHERE h.user_id = ? AND hl.is_completed = 1 AND hl.completed_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)) as weekly_completions";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Use getLong for COUNT(*) which returns Long
                data.put("total_habits", rs.getLong("total_habits"));
                data.put("active_habits", rs.getLong("active_habits"));
                data.put("weekly_completions", rs.getLong("weekly_completions"));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching habit data: " + e.getMessage());
        }
        
        return data;
    }
}