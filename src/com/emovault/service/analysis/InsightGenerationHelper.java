package com.emovault.service.analysis;

import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Insight Generation Helper
 * Generates dynamic behavioral insights based on actual user data:
 * - Emotional trend summaries
 * - Positive growth observations
 * - Recurring emotional warnings
 * - Emotional balance indicators
 * - Behavioral consistency insights
 * - Trigger identification
 */
public class InsightGenerationHelper {
    
    // Keywords for trigger detection
    private static final Map<String, List<String>> TRIGGER_CATEGORIES = Map.of(
        "work", Arrays.asList("work", "job", "deadline", "meeting", "boss", "project", "task", "presentation", "email"),
        "relationships", Arrays.asList("friend", "family", "partner", "relationship", "argument", "fight", "conversation", "social"),
        "health", Arrays.asList("health", "sick", "pain", "exercise", "diet", "sleep", "tired", "exhausted"),
        "finances", Arrays.asList("money", "bills", "debt", "expenses", "budget", "financial", "pay"),
        "self_improvement", Arrays.asList("learn", "study", "goal", "progress", "achieve", "success", "failure"),
        "environment", Arrays.asList("home", "noise", "crowd", "traffic", "weather", "messy")
    );
    
    /**
     * Generate comprehensive insights for a user
     */
    public static Map<String, Object> generateInsights(int userId, int daysPeriod) {
        Map<String, Object> insights = new HashMap<>();
        
        List<Map<String, Object>> emotions = getEmotions(userId, daysPeriod);
        List<Map<String, Object>> regrets = getRegrets(userId, daysPeriod);
        List<Map<String, Object>> diaryEntries = getDiaryEntries(userId, daysPeriod);
        
        int totalEntries = emotions.size() + regrets.size() + diaryEntries.size();
        if (totalEntries < 3) {
            insights.put("hasData", false);
            insights.put("message", "Log more emotions, diary entries, and reflections to receive personalized insights.");
            return insights;
        }
        
        insights.put("hasData", true);
        
        // Generate different types of insights
        insights.put("emotionalTrendSummary", generateEmotionalTrendSummary(emotions));
        insights.put("positiveGrowthObservations", generatePositiveGrowthObservations(emotions, regrets));
        insights.put("recurringWarnings", generateRecurringWarnings(emotions, regrets));
        insights.put("emotionalBalanceIndicator", calculateEmotionalBalance(emotions));
        insights.put("behavioralConsistencyInsights", generateConsistencyInsights(emotions, diaryEntries));
        insights.put("triggerIdentification", identifyTriggers(emotions, diaryEntries, regrets));
        
        // Generate overall summary
        insights.put("overallSummary", generateOverallSummary(insights));
        
        return insights;
    }
    
    /**
     * Generate emotional trend summary
     */
    private static Map<String, Object> generateEmotionalTrendSummary(List<Map<String, Object>> emotions) {
        Map<String, Object> summary = new HashMap<>();
        
        if (emotions.size() < 4) {
            summary.put("trend", "insufficient_data");
            summary.put("message", "Continue logging to see emotional trends.");
            return summary;
        }
        
        // Compare first half (older) to second half (newer)
        int mid = emotions.size() / 2;
        List<Map<String, Object>> older = emotions.subList(mid, emotions.size());
        List<Map<String, Object>> newer = emotions.subList(0, mid);
        
        double olderAvgIntensity = older.stream()
            .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
            .average().orElse(0);
        
        double newerAvgIntensity = newer.stream()
            .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
            .average().orElse(0);
        
        // Count positive emotions in each half
        long olderPositive = older.stream()
            .filter(e -> isPositiveEmotion((String) e.get("mood")))
            .count();
        
        long newerPositive = newer.stream()
            .filter(e -> isPositiveEmotion((String) e.get("mood")))
            .count();
        
        double olderPositiveRatio = (double) olderPositive / older.size();
        double newerPositiveRatio = (double) newerPositive / newer.size();
        
        // Determine trend direction
        String trend;
        List<String> observations = new ArrayList<>();
        
        if (newerAvgIntensity < olderAvgIntensity - 0.5) {
            trend = "improving";
            observations.add("Your emotional intensity is decreasing, suggesting better emotional regulation.");
        } else if (newerAvgIntensity > olderAvgIntensity + 0.5) {
            trend = "intensifying";
            observations.add("Your emotional responses are becoming more intense. Consider stress management techniques.");
        } else {
            trend = "stable";
            observations.add("Your emotional patterns are stable and consistent.");
        }
        
        if (newerPositiveRatio > olderPositiveRatio + 0.1) {
            observations.add("You're experiencing more positive emotions recently.");
        } else if (newerPositiveRatio < olderPositiveRatio - 0.1) {
            observations.add("Consider activities that boost your mood and well-being.");
        }
        
        summary.put("trend", trend);
        summary.put("observations", observations);
        summary.put("olderAvgIntensity", Math.round(olderAvgIntensity * 10.0) / 10.0);
        summary.put("newerAvgIntensity", Math.round(newerAvgIntensity * 10.0) / 10.0);
        summary.put("positiveEmotionChange", Math.round((newerPositiveRatio - olderPositiveRatio) * 100.0) / 100.0);
        
        return summary;
    }
    
    /**
     * Generate positive growth observations
     */
    private static List<String> generatePositiveGrowthObservations(List<Map<String, Object>> emotions, 
                                                                    List<Map<String, Object>> regrets) {
        List<String> observations = new ArrayList<>();
        
        // Check for emotional awareness
        if (emotions.size() >= 10) {
            observations.add("You've shown strong commitment to self-reflection with " + emotions.size() + " emotion entries.");
        }
        
        // Check for learning from regrets
        long regretsLessons = regrets.stream()
            .filter(r -> r.get("lesson") != null && !((String) r.get("lesson")).isEmpty())
            .count();
        
        if (regretsLessons > 0) {
            observations.add("You're actively learning from your experiences - " + regretsLessons + " lessons identified from regrets.");
        }
        
        // Check for positive emotion ratio
        long positiveCount = emotions.stream()
            .filter(e -> isPositiveEmotion((String) e.get("mood")))
            .count();
        
        double positiveRatio = emotions.isEmpty() ? 0 : (double) positiveCount / emotions.size();
        
        if (positiveRatio >= 0.5) {
            observations.add("More than half of your logged emotions are positive - great emotional balance!");
        } else if (positiveRatio >= 0.3) {
            observations.add("You maintain a reasonable balance of positive emotions.");
        }
        
        // Check for recovery patterns
        if (emotions.size() >= 4) {
            boolean hasRecovery = detectRecoveryPattern(emotions);
            if (hasRecovery) {
                observations.add("You show ability to recover from negative emotional states.");
            }
        }
        
        if (observations.isEmpty()) {
            observations.add("Keep tracking your emotions - patterns will emerge with more data.");
        }
        
        return observations;
    }
    
    /**
     * Generate recurring emotional warnings
     */
    private static List<String> generateRecurringWarnings(List<Map<String, Object>> emotions, 
                                                          List<Map<String, Object>> regrets) {
        List<String> warnings = new ArrayList<>();
        
        // Check for repeated negative emotions
        Map<String, Integer> negativeFreq = new HashMap<>();
        for (Map<String, Object> emotion : emotions) {
            String mood = (String) emotion.get("mood");
            if (isNegativeEmotion(mood)) {
                negativeFreq.put(mood, negativeFreq.getOrDefault(mood, 0) + 1);
            }
        }
        
        for (Map.Entry<String, Integer> entry : negativeFreq.entrySet()) {
            if (entry.getValue() >= 3) {
                warnings.add("Frequent '" + entry.getKey() + "' emotions detected (" + entry.getValue() + " times). Consider addressing underlying causes.");
            }
        }
        
        // Check for repeated regret themes
        Map<String, Integer> regretThemes = new HashMap<>();
        for (Map<String, Object> regret : regrets) {
            String tag = (String) regret.get("tag");
            if (tag != null) {
                regretThemes.put(tag, regretThemes.getOrDefault(tag, 0) + 1);
            }
        }
        
        for (Map.Entry<String, Integer> entry : regretThemes.entrySet()) {
            if (entry.getValue() >= 2) {
                warnings.add("Recurring regret theme: '" + entry.getKey() + "' (" + entry.getValue() + " times). This pattern may need attention.");
            }
        }
        
        // Check for high intensity streak
        int highIntensityStreak = 0;
        for (Map<String, Object> emotion : emotions) {
            double intensity = ((Number) emotion.get("intensity")).doubleValue();
            if (intensity >= 8) {
                highIntensityStreak++;
            }
        }
        
        if (highIntensityStreak >= 3) {
            warnings.add("Multiple high-intensity emotional states detected. Consider stress reduction techniques.");
        }
        
        return warnings;
    }
    
    /**
     * Calculate emotional balance indicator
     */
    private static Map<String, Object> calculateEmotionalBalance(List<Map<String, Object>> emotions) {
        Map<String, Object> balance = new HashMap<>();
        
        if (emotions.isEmpty()) {
            balance.put("status", "unknown");
            balance.put("message", "Log more emotions to assess your emotional balance.");
            return balance;
        }
        
        long positiveCount = emotions.stream()
            .filter(e -> isPositiveEmotion((String) e.get("mood")))
            .count();
        
        long negativeCount = emotions.stream()
            .filter(e -> isNegativeEmotion((String) e.get("mood")))
            .count();
        
        long neutralCount = emotions.size() - positiveCount - negativeCount;
        
        double positiveRatio = (double) positiveCount / emotions.size();
        double negativeRatio = (double) negativeCount / emotions.size();
        
        balance.put("positiveCount", positiveCount);
        balance.put("negativeCount", negativeCount);
        balance.put("neutralCount", neutralCount);
        balance.put("positiveRatio", Math.round(positiveRatio * 100.0) / 100.0);
        balance.put("negativeRatio", Math.round(negativeRatio * 100.0) / 100.0);
        
        // Determine balance status
        if (positiveRatio >= 0.6) {
            balance.put("status", "positive_dominant");
            balance.put("message", "Your emotional state is predominantly positive.");
        } else if (positiveRatio >= negativeRatio) {
            balance.put("status", "balanced_positive");
            balance.put("message", "You have a healthy emotional balance with more positive than negative emotions.");
        } else if (negativeRatio >= 0.5) {
            balance.put("status", "negative_dominant");
            balance.put("message", "Negative emotions are prevalent. Consider self-care strategies.");
        } else {
            balance.put("status", "mixed");
            balance.put("message", "Your emotions are mixed. This is normal, but monitor for patterns.");
        }
        
        return balance;
    }
    
    /**
     * Generate behavioral consistency insights
     */
    private static List<String> generateConsistencyInsights(List<Map<String, Object>> emotions, 
                                                            List<Map<String, Object>> diaryEntries) {
        List<String> insights = new ArrayList<>();
        
        int totalEntries = emotions.size() + diaryEntries.size();
        
        // Assess logging consistency
        if (totalEntries >= 14) {
            insights.add("Excellent consistency! You've maintained regular emotional tracking.");
        } else if (totalEntries >= 7) {
            insights.add("Good tracking consistency. Keep up the habit!");
        } else if (totalEntries >= 3) {
            insights.add("You're building the tracking habit. Try to log more consistently.");
        } else {
            insights.add("Start building consistency by logging your emotions daily.");
        }
        
        // Check for time-based patterns
        Map<String, Integer> dayVsNight = analyzeTimePatterns(emotions);
        if (dayVsNight.get("night") > dayVsNight.get("day") * 2) {
            insights.add("You tend to log emotions more at night. Ensure this doesn't interfere with sleep.");
        }
        
        // Check for emotional volatility
        if (emotions.size() >= 5) {
            double intensityVariance = calculateIntensityVariance(emotions);
            if (intensityVariance > 4.0) {
                insights.add("Your emotional intensity varies significantly. This may indicate emotional sensitivity.");
            } else {
                insights.add("Your emotional responses are consistent in intensity.");
            }
        }
        
        return insights;
    }
    
    /**
     * Identify triggers from user data
     */
    private static Map<String, Object> identifyTriggers(List<Map<String, Object>> emotions, 
                                                        List<Map<String, Object>> diaryEntries,
                                                        List<Map<String, Object>> regrets) {
        Map<String, Object> triggers = new HashMap<>();
        Map<String, Integer> triggerCounts = new HashMap<>();
        List<String> insights = new ArrayList<>();
        
        // Analyze emotion triggers
        for (Map<String, Object> emotion : emotions) {
            String trigger = (String) emotion.get("trigger");
            if (trigger != null && !trigger.isEmpty()) {
                String category = categorizeTrigger(trigger);
                triggerCounts.put(category, triggerCounts.getOrDefault(category, 0) + 1);
            }
        }
        
        // Analyze diary content for triggers
        for (Map<String, Object> entry : diaryEntries) {
            String content = (String) entry.get("content");
            if (content != null) {
                List<String> detectedTriggers = detectTriggersInText(content);
                for (String trigger : detectedTriggers) {
                    triggerCounts.put(trigger, triggerCounts.getOrDefault(trigger, 0) + 1);
                }
            }
        }
        
        // Analyze regret descriptions
        for (Map<String, Object> regret : regrets) {
            String description = (String) regret.get("description");
            if (description != null) {
                List<String> detectedTriggers = detectTriggersInText(description);
                for (String trigger : detectedTriggers) {
                    triggerCounts.put(trigger, triggerCounts.getOrDefault(trigger, 0) + 1);
                }
            }
        }
        
        triggers.put("categories", triggerCounts);
        
        // Generate trigger insights
        if (!triggerCounts.isEmpty()) {
            String topTrigger = triggerCounts.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("unknown");
            
            int topCount = triggerCounts.get(topTrigger);
            insights.add("Your most common trigger category is '" + topTrigger + "' (appears " + topCount + " times).");
            
            // Generate specific insights based on trigger category
            if ("work".equals(topTrigger) && topCount >= 3) {
                insights.add("Work-related stress is prominent. Consider work-life balance strategies.");
            } else if ("relationships".equals(topTrigger) && topCount >= 3) {
                insights.add("Relationship dynamics significantly impact your emotions. Focus on healthy communication.");
            } else if ("health".equals(topTrigger) && topCount >= 3) {
                insights.add("Health concerns are affecting your emotional state. Prioritize self-care.");
            }
        }
        
        // Check for stress after missed habits
        if (hasStressAfterInactivity(emotions, diaryEntries)) {
            insights.add("Stress appears to increase after periods of inactivity or missed routines.");
        }
        
        // Check for night-time negative emotions
        if (hasNightNegativePattern(emotions)) {
            insights.add("Negative emotions appear repeatedly at night. Consider evening relaxation routines.");
        }
        
        triggers.put("insights", insights);
        
        return triggers;
    }
    
    // Helper methods
    
    private static boolean isPositiveEmotion(String mood) {
        return "Happy".equals(mood) || "Calm".equals(mood) || "Excited".equals(mood) ||
               "Grateful".equals(mood) || "Confident".equals(mood) || "Peaceful".equals(mood) ||
               "Motivated".equals(mood) || "Content".equals(mood) || "Joyful".equals(mood);
    }
    
    private static boolean isNegativeEmotion(String mood) {
        return "Sad".equals(mood) || "Stressed".equals(mood) || "Angry".equals(mood) ||
               "Anxious".equals(mood) || "Depressed".equals(mood) || "Frustrated".equals(mood) ||
               "Overwhelmed".equals(mood) || "Lonely".equals(mood) || "Fearful".equals(mood) ||
               "Guilty".equals(mood);
    }
    
    private static boolean detectRecoveryPattern(List<Map<String, Object>> emotions) {
        // Look for patterns where negative emotion is followed by positive
        for (int i = 0; i < emotions.size() - 1; i++) {
            String current = (String) emotions.get(i).get("mood");
            String next = (String) emotions.get(i + 1).get("mood");
            
            if (isNegativeEmotion(current) && isPositiveEmotion(next)) {
                return true;
            }
        }
        return false;
    }
    
    private static Map<String, Integer> analyzeTimePatterns(List<Map<String, Object>> emotions) {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("day", 0);
        counts.put("night", 0);
        
        for (Map<String, Object> emotion : emotions) {
            Timestamp ts = (Timestamp) emotion.get("created_at");
            int hour = ts.toLocalDateTime().getHour();
            
            if (hour >= 6 && hour < 18) {
                counts.put("day", counts.get("day") + 1);
            } else {
                counts.put("night", counts.get("night") + 1);
            }
        }
        
        return counts;
    }
    
    private static double calculateIntensityVariance(List<Map<String, Object>> emotions) {
        double[] intensities = emotions.stream()
            .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
            .toArray();
        
        double mean = Arrays.stream(intensities).average().orElse(0);
        double sum = 0;
        for (double v : intensities) {
            sum += (v - mean) * (v - mean);
        }
        return sum / intensities.length;
    }
    
    private static String categorizeTrigger(String trigger) {
        String lower = trigger.toLowerCase();
        for (Map.Entry<String, List<String>> category : TRIGGER_CATEGORIES.entrySet()) {
            for (String keyword : category.getValue()) {
                if (lower.contains(keyword)) {
                    return category.getKey();
                }
            }
        }
        return "other";
    }
    
    private static List<String> detectTriggersInText(String text) {
        List<String> triggers = new ArrayList<>();
        String lower = text.toLowerCase();
        
        for (Map.Entry<String, List<String>> category : TRIGGER_CATEGORIES.entrySet()) {
            for (String keyword : category.getValue()) {
                if (lower.contains(keyword)) {
                    triggers.add(category.getKey());
                    break;
                }
            }
        }
        
        return triggers;
    }
    
    private static boolean hasStressAfterInactivity(List<Map<String, Object>> emotions, 
                                                    List<Map<String, Object>> diaryEntries) {
        // Simple heuristic: check if high intensity emotions follow gaps
        if (emotions.size() < 3) return false;
        
        for (int i = 1; i < emotions.size(); i++) {
            Timestamp current = (Timestamp) emotions.get(i).get("created_at");
            Timestamp previous = (Timestamp) emotions.get(i - 1).get("created_at");
            
            long hoursDiff = (current.getTime() - previous.getTime()) / (1000 * 60 * 60);
            double intensity = ((Number) emotions.get(i).get("intensity")).doubleValue();
            
            if (hoursDiff > 48 && intensity >= 7) {
                return true;
            }
        }
        return false;
    }
    
    private static boolean hasNightNegativePattern(List<Map<String, Object>> emotions) {
        int nightNegative = 0;
        int nightTotal = 0;
        
        for (Map<String, Object> emotion : emotions) {
            Timestamp ts = (Timestamp) emotion.get("created_at");
            int hour = ts.toLocalDateTime().getHour();
            
            if (hour >= 20 || hour < 6) { // Night time
                nightTotal++;
                if (isNegativeEmotion((String) emotion.get("mood"))) {
                    nightNegative++;
                }
            }
        }
        
        return nightTotal >= 3 && (double) nightNegative / nightTotal >= 0.7;
    }
    
    private static String generateOverallSummary(Map<String, Object> insights) {
        StringBuilder summary = new StringBuilder();
        
        // Emotional trend
        @SuppressWarnings("unchecked")
        Map<String, Object> trend = (Map<String, Object>) insights.get("emotionalTrendSummary");
        if (trend != null && !"insufficient_data".equals(trend.get("trend"))) {
            summary.append("Your emotional trend is ").append(trend.get("trend")).append(". ");
        }
        
        // Balance
        @SuppressWarnings("unchecked")
        Map<String, Object> balance = (Map<String, Object>) insights.get("emotionalBalanceIndicator");
        if (balance != null && !"unknown".equals(balance.get("status"))) {
            summary.append(balance.get("message")).append(" ");
        }
        
        // Warnings
        @SuppressWarnings("unchecked")
        List<String> warnings = (List<String>) insights.get("recurringWarnings");
        if (warnings != null && !warnings.isEmpty()) {
            summary.append("Pay attention to: ").append(warnings.get(0));
        }
        
        return summary.toString();
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
                emotion.put("trigger", rs.getString("trigger"));
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
                regret.put("lesson", rs.getString("lesson_learned"));
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
}