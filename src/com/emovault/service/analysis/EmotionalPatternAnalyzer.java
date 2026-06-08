package com.emovault.service.analysis;

import com.emovault.util.DBConnection;
import java.sql.*;
import java.time.*;
import java.time.temporal.ChronoUnit;
import java.util.*;

/**
 * Emotional Pattern Analyzer
 * Detects patterns in user emotional data including:
 * - Repeated emotions
 * - Emotional frequency patterns
 * - Recurring stress indicators
 * - Confidence decline/improvement
 * - Emotional instability periods
 * - Time-based patterns (night vs day, weekday vs weekend)
 */
public class EmotionalPatternAnalyzer {
    
    // Negative emotions that indicate potential issues
    private static final Set<String> NEGATIVE_EMOTIONS = new HashSet<>(Arrays.asList(
        "Sad", "Stressed", "Angry", "Anxious", "Depressed", "Frustrated", 
        "Overwhelmed", "Lonely", "Fearful", "Guilty"
    ));
    
    // Positive emotions that indicate good state
    private static final Set<String> POSITIVE_EMOTIONS = new HashSet<>(Arrays.asList(
        "Happy", "Calm", "Excited", "Grateful", "Confident", "Peaceful",
        "Motivated", "Content", "Joyful", "Proud"
    ));
    
    /**
     * Analyze emotional patterns for a user over a given period
     */
    public static Map<String, Object> analyzePatterns(int userId, int daysPeriod) {
        Map<String, Object> patterns = new HashMap<>();
        
        List<Map<String, Object>> emotions = getEmotions(userId, daysPeriod);
        
        if (emotions.isEmpty()) {
            patterns.put("hasData", false);
            patterns.put("message", "No emotional data available for analysis");
            return patterns;
        }
        
        patterns.put("hasData", true);
        
        // Basic statistics
        patterns.put("emotionFrequency", calculateEmotionFrequency(emotions));
        patterns.put("intensityStats", calculateIntensityStats(emotions));
        
        // Pattern detection
        patterns.put("repeatedEmotions", detectRepeatedEmotions(emotions));
        patterns.put("stressIndicators", detectStressIndicators(emotions));
        patterns.put("emotionalTrends", detectEmotionalTrends(emotions));
        patterns.put("instabilityPeriods", detectInstabilityPeriods(emotions));
        patterns.put("timeBasedPatterns", detectTimeBasedPatterns(emotions));
        patterns.put("confidenceTrend", detectConfidenceTrend(emotions));
        
        // Summary
        patterns.put("summary", generatePatternSummary(patterns));
        
        return patterns;
    }
    
    /**
     * Calculate emotion frequency distribution
     */
    private static Map<String, Integer> calculateEmotionFrequency(List<Map<String, Object>> emotions) {
        Map<String, Integer> frequency = new HashMap<>();
        for (Map<String, Object> emotion : emotions) {
            String mood = (String) emotion.get("mood");
            frequency.put(mood, frequency.getOrDefault(mood, 0) + 1);
        }
        return frequency;
    }
    
    /**
     * Calculate intensity statistics
     */
    private static Map<String, Object> calculateIntensityStats(List<Map<String, Object>> emotions) {
        Map<String, Object> stats = new HashMap<>();
        
        double sum = 0;
        double max = 0;
        double min = 10;
        
        for (Map<String, Object> emotion : emotions) {
            double intensity = ((Number) emotion.get("intensity")).doubleValue();
            sum += intensity;
            max = Math.max(max, intensity);
            min = Math.min(min, intensity);
        }
        
        double avg = emotions.isEmpty() ? 0 : sum / emotions.size();
        
        stats.put("average", Math.round(avg * 10.0) / 10.0);
        stats.put("max", max);
        stats.put("min", min);
        stats.put("range", Math.round((max - min) * 10.0) / 10.0);
        
        return stats;
    }
    
    /**
     * Detect repeated emotions (emotions appearing 3+ times)
     */
    private static List<Map<String, Object>> detectRepeatedEmotions(List<Map<String, Object>> emotions) {
        Map<String, Integer> frequency = calculateEmotionFrequency(emotions);
        List<Map<String, Object>> repeated = new ArrayList<>();
        
        for (Map.Entry<String, Integer> entry : frequency.entrySet()) {
            if (entry.getValue() >= 3) {
                Map<String, Object> data = new HashMap<>();
                data.put("emotion", entry.getKey());
                data.put("count", entry.getValue());
                data.put("percentage", Math.round(entry.getValue() * 100.0 / emotions.size()));
                data.put("isNegative", NEGATIVE_EMOTIONS.contains(entry.getKey()));
                data.put("isPositive", POSITIVE_EMOTIONS.contains(entry.getKey()));
                repeated.add(data);
            }
        }
        
        repeated.sort((a, b) -> ((Number) b.get("count")).intValue() - ((Number) a.get("count")).intValue());
        return repeated;
    }
    
    /**
     * Detect stress indicators (high intensity, negative emotions clustering)
     */
    private static List<Map<String, Object>> detectStressIndicators(List<Map<String, Object>> emotions) {
        List<Map<String, Object>> indicators = new ArrayList<>();
        
        // Check for high intensity streak
        int highIntensityStreak = 0;
        int maxHighIntensityStreak = 0;
        for (Map<String, Object> emotion : emotions) {
            double intensity = ((Number) emotion.get("intensity")).doubleValue();
            if (intensity >= 7) {
                highIntensityStreak++;
                maxHighIntensityStreak = Math.max(maxHighIntensityStreak, highIntensityStreak);
            } else {
                highIntensityStreak = 0;
            }
        }
        
        if (maxHighIntensityStreak >= 3) {
            Map<String, Object> indicator = new HashMap<>();
            indicator.put("type", "sustained_high_intensity");
            indicator.put("description", "Sustained high emotional intensity (" + maxHighIntensityStreak + " entries ≥7/10)");
            indicator.put("severity", maxHighIntensityStreak >= 5 ? "high" : "medium");
            indicators.add(indicator);
        }
        
        // Check for negative emotion clustering
        int negativeStreak = 0;
        int maxNegativeStreak = 0;
        for (Map<String, Object> emotion : emotions) {
            String mood = (String) emotion.get("mood");
            if (NEGATIVE_EMOTIONS.contains(mood)) {
                negativeStreak++;
                maxNegativeStreak = Math.max(maxNegativeStreak, negativeStreak);
            } else {
                negativeStreak = 0;
            }
        }
        
        if (maxNegativeStreak >= 3) {
            Map<String, Object> indicator = new HashMap<>();
            indicator.put("type", "negative_emotion_clustering");
            indicator.put("description", "Consecutive negative emotions (" + maxNegativeStreak + " in a row)");
            indicator.put("severity", maxNegativeStreak >= 5 ? "high" : "medium");
            indicators.add(indicator);
        }
        
        // Check for specific stress-related emotions
        Map<String, Integer> stressEmotions = new HashMap<>();
        for (Map<String, Object> emotion : emotions) {
            String mood = (String) emotion.get("mood");
            if ("Stressed".equals(mood) || "Anxious".equals(mood) || "Overwhelmed".equals(mood)) {
                stressEmotions.put(mood, stressEmotions.getOrDefault(mood, 0) + 1);
            }
        }
        
        for (Map.Entry<String, Integer> entry : stressEmotions.entrySet()) {
            if (entry.getValue() >= 3) {
                Map<String, Object> indicator = new HashMap<>();
                indicator.put("type", "frequent_" + entry.getKey().toLowerCase());
                indicator.put("description", "Frequent " + entry.getKey().toLowerCase() + " emotions (" + entry.getValue() + " occurrences)");
                indicator.put("severity", entry.getValue() >= 5 ? "high" : "medium");
                indicators.add(indicator);
            }
        }
        
        return indicators;
    }
    
    /**
     * Detect emotional trends (improving, declining, stable)
     */
    private static Map<String, Object> detectEmotionalTrends(List<Map<String, Object>> emotions) {
        Map<String, Object> trends = new HashMap<>();
        
        if (emotions.size() < 4) {
            trends.put("trend", "insufficient_data");
            trends.put("description", "Need more data to detect trends");
            return trends;
        }
        
        // Split into first and second half
        int mid = emotions.size() / 2;
        List<Map<String, Object>> firstHalf = emotions.subList(mid, emotions.size()); // Older entries
        List<Map<String, Object>> secondHalf = emotions.subList(0, mid); // Newer entries
        
        double firstAvg = firstHalf.stream()
            .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
            .average().orElse(0);
        
        double secondAvg = secondHalf.stream()
            .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
            .average().orElse(0);
        
        double change = Math.round((secondAvg - firstAvg) * 10.0) / 10.0;
        
        // Count negative emotions in each half
        long firstNegative = firstHalf.stream()
            .filter(e -> NEGATIVE_EMOTIONS.contains(e.get("mood")))
            .count();
        
        long secondNegative = secondHalf.stream()
            .filter(e -> NEGATIVE_EMOTIONS.contains(e.get("mood")))
            .count();
        
        double firstNegativeRatio = firstHalf.isEmpty() ? 0 : (double) firstNegative / firstHalf.size();
        double secondNegativeRatio = secondHalf.isEmpty() ? 0 : (double) secondNegative / secondHalf.size();
        
        String trend;
        if (Math.abs(change) < 0.5) {
            trend = "stable";
        } else if (change < 0) {
            trend = "improving"; // Lower intensity is better
        } else {
            trend = "declining";
        }
        
        trends.put("trend", trend);
        trends.put("intensityChange", change);
        trends.put("firstHalfAvgIntensity", Math.round(firstAvg * 10.0) / 10.0);
        trends.put("secondHalfAvgIntensity", Math.round(secondAvg * 10.0) / 10.0);
        trends.put("negativeEmotionChange", Math.round((secondNegativeRatio - firstNegativeRatio) * 100.0) / 100.0);
        
        if ("improving".equals(trend)) {
            trends.put("description", "Emotional intensity is decreasing - positive trend");
        } else if ("declining".equals(trend)) {
            trends.put("description", "Emotional intensity is increasing - may need attention");
        } else {
            trends.put("description", "Emotional patterns are stable");
        }
        
        return trends;
    }
    
    /**
     * Detect periods of emotional instability
     */
    private static List<Map<String, Object>> detectInstabilityPeriods(List<Map<String, Object>> emotions) {
        List<Map<String, Object>> periods = new ArrayList<>();
        
        // Group emotions by date
        Map<String, List<Map<String, Object>>> byDate = new LinkedHashMap<>();
        for (Map<String, Object> emotion : emotions) {
            Timestamp ts = (Timestamp) emotion.get("created_at");
            String date = ts.toString().substring(0, 10);
            byDate.computeIfAbsent(date, k -> new ArrayList<>()).add(emotion);
        }
        
        // Find days with high emotional variance
        for (Map.Entry<String, List<Map<String, Object>>> entry : byDate.entrySet()) {
            List<Map<String, Object>> dayEmotions = entry.getValue();
            if (dayEmotions.size() >= 2) {
                double[] intensities = dayEmotions.stream()
                    .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
                    .toArray();
                
                double variance = calculateVariance(intensities);
                int moodChanges = countMoodChanges(dayEmotions);
                
                if (variance >= 4.0 || moodChanges >= 3) {
                    Map<String, Object> period = new HashMap<>();
                    period.put("date", entry.getKey());
                    period.put("entryCount", dayEmotions.size());
                    period.put("intensityVariance", Math.round(variance * 10.0) / 10.0);
                    period.put("moodChanges", moodChanges);
                    period.put("moods", dayEmotions.stream().map(e -> (String) e.get("mood")).distinct().toList());
                    periods.add(period);
                }
            }
        }
        
        return periods;
    }
    
    /**
     * Detect time-based patterns (night vs day, weekday vs weekend)
     */
    private static Map<String, Object> detectTimeBasedPatterns(List<Map<String, Object>> emotions) {
        Map<String, Object> patterns = new HashMap<>();
        
        List<Map<String, Object>> dayEmotions = new ArrayList<>();
        List<Map<String, Object>> nightEmotions = new ArrayList<>();
        List<Map<String, Object>> weekdayEmotions = new ArrayList<>();
        List<Map<String, Object>> weekendEmotions = new ArrayList<>();
        
        for (Map<String, Object> emotion : emotions) {
            Timestamp ts = (Timestamp) emotion.get("created_at");
            LocalTime time = ts.toLocalDateTime().toLocalTime();
            DayOfWeek day = ts.toLocalDateTime().getDayOfWeek();
            
            // Day (6am-6pm) vs Night (6pm-6am)
            if (time.isAfter(LocalTime.of(6, 0)) && time.isBefore(LocalTime.of(18, 0))) {
                dayEmotions.add(emotion);
            } else {
                nightEmotions.add(emotion);
            }
            
            // Weekday vs Weekend
            if (day == DayOfWeek.SATURDAY || day == DayOfWeek.SUNDAY) {
                weekendEmotions.add(emotion);
            } else {
                weekdayEmotions.add(emotion);
            }
        }
        
        Map<String, Object> timeAnalysis = new HashMap<>();
        timeAnalysis.put("dayCount", dayEmotions.size());
        timeAnalysis.put("nightCount", nightEmotions.size());
        timeAnalysis.put("dayAvgIntensity", dayEmotions.isEmpty() ? 0 : 
            Math.round(dayEmotions.stream().mapToDouble(e -> ((Number) e.get("intensity")).doubleValue()).average().orElse(0) * 10.0) / 10.0);
        timeAnalysis.put("nightAvgIntensity", nightEmotions.isEmpty() ? 0 :
            Math.round(nightEmotions.stream().mapToDouble(e -> ((Number) e.get("intensity")).doubleValue()).average().orElse(0) * 10.0) / 10.0);
        patterns.put("dayVsNight", timeAnalysis);
        
        Map<String, Object> weekAnalysis = new HashMap<>();
        weekAnalysis.put("weekdayCount", weekdayEmotions.size());
        weekAnalysis.put("weekendCount", weekendEmotions.size());
        weekAnalysis.put("weekdayAvgIntensity", weekdayEmotions.isEmpty() ? 0 :
            Math.round(weekdayEmotions.stream().mapToDouble(e -> ((Number) e.get("intensity")).doubleValue()).average().orElse(0) * 10.0) / 10.0);
        weekAnalysis.put("weekendAvgIntensity", weekendEmotions.isEmpty() ? 0 :
            Math.round(weekendEmotions.stream().mapToDouble(e -> ((Number) e.get("intensity")).doubleValue()).average().orElse(0) * 10.0) / 10.0);
        patterns.put("weekdayVsWeekend", weekAnalysis);
        
        // Determine if there's a significant pattern
        if (!nightEmotions.isEmpty() && !dayEmotions.isEmpty()) {
            double nightAvg = (Double) timeAnalysis.get("nightAvgIntensity");
            double dayAvg = (Double) timeAnalysis.get("dayAvgIntensity");
            if (nightAvg - dayAvg >= 1.5) {
                patterns.put("insight", "Negative emotions appear to be more intense at night");
            } else if (dayAvg - nightAvg >= 1.5) {
                patterns.put("insight", "Emotions tend to be more intense during the day");
            }
        }
        
        return patterns;
    }
    
    /**
     * Detect confidence trend based on emotions
     */
    private static Map<String, Object> detectConfidenceTrend(List<Map<String, Object>> emotions) {
        Map<String, Object> trend = new HashMap<>();
        
        // Count confident vs insecure emotions
        long confidentCount = emotions.stream()
            .filter(e -> "Confident".equals(e.get("mood")) || "Proud".equals(e.get("mood")))
            .count();
        
        long insecureCount = emotions.stream()
            .filter(e -> "Insecure".equals(e.get("mood")) || "Doubtful".equals(e.get("mood")) || 
                        "Guilty".equals(e.get("mood")) || "Ashamed".equals(e.get("mood")))
            .count();
        
        trend.put("confidentEntries", confidentCount);
        trend.put("insecureEntries", insecureCount);
        
        if (confidentCount > insecureCount * 2) {
            trend.put("status", "high_confidence");
            trend.put("description", "Confidence appears to be strong based on emotional patterns");
        } else if (insecureCount > confidentCount * 2) {
            trend.put("status", "low_confidence");
            trend.put("description", "Signs of declining confidence detected");
        } else if (confidentCount > 0 || insecureCount > 0) {
            trend.put("status", "mixed");
            trend.put("description", "Confidence levels appear mixed");
        } else {
            trend.put("status", "unknown");
            trend.put("description", "Insufficient confidence-related emotions to determine trend");
        }
        
        return trend;
    }
    
    /**
     * Generate a summary of all detected patterns
     */
    private static String generatePatternSummary(Map<String, Object> patterns) {
        StringBuilder summary = new StringBuilder();
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> repeated = (List<Map<String, Object>>) patterns.get("repeatedEmotions");
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> stress = (List<Map<String, Object>>) patterns.get("stressIndicators");
        @SuppressWarnings("unchecked")
        Map<String, Object> trends = (Map<String, Object>) patterns.get("emotionalTrends");
        
        if (repeated != null && !repeated.isEmpty()) {
            Map<String, Object> top = repeated.get(0);
            summary.append("Your most frequent emotion is ").append(top.get("emotion"))
                .append(" (").append(top.get("count")).append(" times");
            if ((Boolean) top.get("isNegative")) {
                summary.append(" - this is a negative emotion that may need attention");
            }
            summary.append("). ");
        }
        
        if (stress != null && !stress.isEmpty()) {
            summary.append("Detected ").append(stress.size()).append(" stress indicator(s). ");
        }
        
        if (trends != null && !"insufficient_data".equals(trends.get("trend"))) {
            summary.append("Emotional trend: ").append(trends.get("description"));
        }
        
        return summary.toString();
    }
    
    // Helper methods
    private static double calculateVariance(double[] values) {
        if (values.length < 2) return 0;
        double mean = Arrays.stream(values).average().orElse(0);
        double sum = 0;
        for (double v : values) {
            sum += (v - mean) * (v - mean);
        }
        return sum / (values.length - 1);
    }
    
    private static int countMoodChanges(List<Map<String, Object>> emotions) {
        if (emotions.size() < 2) return 0;
        int changes = 0;
        String prev = (String) emotions.get(0).get("mood");
        for (int i = 1; i < emotions.size(); i++) {
            String current = (String) emotions.get(i).get("mood");
            if (!prev.equals(current)) {
                changes++;
                prev = current;
            }
        }
        return changes;
    }
    
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
                emotion.put("entry_id", rs.getInt("entry_id"));
                emotion.put("mood", rs.getString("mood"));
                emotion.put("intensity", rs.getInt("intensity"));
                emotion.put("trigger", rs.getString("trigger"));
                emotion.put("response", rs.getString("response"));
                emotion.put("created_at", rs.getTimestamp("created_at"));
                emotions.add(emotion);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching emotions: " + e.getMessage());
        }
        
        return emotions;
    }
}