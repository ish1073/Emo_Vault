package com.emovault.service;

import com.emovault.util.DBConnection;
import java.sql.*;
import java.time.*;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Real-Time Behavior Pattern Analyzer
 * Analyzes actual user entries to detect behavioral patterns, not hardcoded insights
 */
public class BehaviorAnalyzer {
    
    /**
     * Analyze user behavior and return insights based on actual data
     */
    public static Map<String, Object> analyzeBehavior(int userId, int daysPeriod) {
        Map<String, Object> analysis = new HashMap<>();
        
        // Get raw data from past days
        List<Map<String, Object>> emotions = DataService.getUserEmotions(userId, daysPeriod);
        List<Map<String, Object>> regrets = getRecentRegrets(userId, daysPeriod);
        List<Map<String, Object>> diaryEntries = getDiaryEntries(userId, daysPeriod);
        List<Map<String, Object>> decisions = getDecisions(userId, daysPeriod);
        
        if (emotions.isEmpty() && regrets.isEmpty() && diaryEntries.isEmpty()) {
            analysis.put("dataAvailable", false);
            analysis.put("message", "Not enough data yet. Log more emotions to see insights.");
            return analysis;
        }
        
        analysis.put("dataAvailable", true);
        analysis.put("period", daysPeriod + " days");
        
        // Analyze each category
        analysis.put("emotionalPatterns", analyzeEmotionalTrends(emotions));
        analysis.put("triggersAndThemes", analyzeTriggersAndThemes(regrets, diaryEntries));
        analysis.put("decisionPatterns", analyzeDecisionPatterns(decisions));
        analysis.put("riskFactors", identifyRiskFactors(emotions, regrets, decisions));
        analysis.put("positiveTrends", identifyPositiveTrends(emotions, decisions));
        analysis.put("recommendations", generateRecommendations(analysis));
        
        return analysis;
    }
    
    /**
     * Analyze actual emotional trends from logged emotions
     */
    private static Map<String, Object> analyzeEmotionalTrends(List<Map<String, Object>> emotions) {
        Map<String, Object> trends = new HashMap<>();
        
        if (emotions.isEmpty()) {
            trends.put("summary", "No emotional data available");
            return trends;
        }
        
        // Count emotion frequency
        Map<String, Integer> emotionCounts = new HashMap<>();
        for (Map<String, Object> emotion : emotions) {
            String mood = emotion.get("mood").toString();
            emotionCounts.put(mood, emotionCounts.getOrDefault(mood, 0) + 1);
        }
        
        // Find dominant emotions
        String dominantMood = emotionCounts.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("Unknown");
        
        // Calculate intensity trend
        double[] intensities = emotions.stream()
                .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
                .toArray();
        
        double avgIntensity = Arrays.stream(intensities).average().orElse(0);
        double maxIntensity = Arrays.stream(intensities).max().orElse(0);
        double minIntensity = Arrays.stream(intensities).min().orElse(0);
        
        trends.put("summary", String.format(
            "You've experienced %d emotional entries. Dominant mood: %s",
            emotions.size(), dominantMood
        ));
        trends.put("dominantMood", dominantMood);
        trends.put("emotionFrequency", emotionCounts);
        trends.put("averageIntensity", Math.round(avgIntensity * 10.0) / 10.0);
        trends.put("intensityRange", String.format("%.0f-%.0f", minIntensity, maxIntensity));
        
        // Detect intensity trend (improving vs worsening)
        if (emotions.size() >= 2) {
            int firstHalf = (int) Math.ceil(emotions.size() / 2.0);
            double firstHalfAvg = emotions.subList(0, firstHalf).stream()
                    .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
                    .average().orElse(0);
            
            double secondHalfAvg = emotions.subList(firstHalf, emotions.size()).stream()
                    .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
                    .average().orElse(0);
            
            String trend = secondHalfAvg < firstHalfAvg ? "improving" : "increasing";
            double change = Math.abs(secondHalfAvg - firstHalfAvg);
            trends.put("intensityTrend", String.format(
                "Emotional intensity is %s (change: %.1f)",
                trend, change
            ));
        }
        
        return trends;
    }
    
    /**
     * Analyze triggers and themes from regrets and diary entries
     */
    private static Map<String, Object> analyzeTriggersAndThemes(
            List<Map<String, Object>> regrets,
            List<Map<String, Object>> diaryEntries) {
        
        Map<String, Object> analysis = new HashMap<>();
        Map<String, Integer> themes = new HashMap<>();
        Map<String, Integer> triggers = new HashMap<>();
        
        // Extract themes from regrets
        for (Map<String, Object> regret : regrets) {
            String tag = (String) regret.get("tag");
            if (tag != null) {
                themes.put(tag, themes.getOrDefault(tag, 0) + 1);
            }
        }
        
        // Extract themes from diary entries (by analyzing content)
        for (Map<String, Object> entry : diaryEntries) {
            String content = (String) entry.get("content");
            if (content != null) {
                // Simple keyword extraction
                String[] keywords = extractKeywords(content);
                for (String keyword : keywords) {
                    triggers.put(keyword, triggers.getOrDefault(keyword, 0) + 1);
                }
            }
        }
        
        // Sort by frequency
        Map<String, Integer> topThemes = themes.entrySet().stream()
                .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                .limit(5)
                .collect(Collectors.toLinkedHashMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue
                ));
        
        analysis.put("topThemes", topThemes);
        analysis.put("summary", formatThemeSummary(topThemes));
        
        return analysis;
    }
    
    /**
     * Simple keyword extraction from text
     */
    private static String[] extractKeywords(String text) {
        String[] commonWords = {"the", "a", "is", "in", "and", "or", "to", "for", "of", "with"};
        
        String[] words = text.toLowerCase().split("\\s+");
        return Arrays.stream(words)
                .filter(w -> w.length() > 3 && !Arrays.asList(commonWords).contains(w))
                .limit(5)
                .toArray(String[]::new);
    }
    
    /**
     * Format theme summary text
     */
    private static String formatThemeSummary(Map<String, Integer> themes) {
        if (themes.isEmpty()) {
            return "No recurring themes detected yet.";
        }
        
        String topTheme = themes.keySet().iterator().next();
        int topCount = themes.values().iterator().next();
        
        return String.format("Most frequent theme: '%s' mentioned %d times",
                topTheme, topCount);
    }
    
    /**
     * Analyze decision patterns and outcomes
     */
    private static Map<String, Object> analyzeDecisionPatterns(List<Map<String, Object>> decisions) {
        Map<String, Object> analysis = new HashMap<>();
        
        if (decisions.isEmpty()) {
            analysis.put("summary", "Log your decisions to see decision patterns.");
            return analysis;
        }
        
        // Count outcomes
        Map<String, Integer> outcomes = new HashMap<>();
        for (Map<String, Object> decision : decisions) {
            String outcome = (String) decision.get("outcome");
            if (outcome != null) {
                outcomes.put(outcome, outcomes.getOrDefault(outcome, 0) + 1);
            }
        }
        
        // Calculate success rate
        int positive = outcomes.getOrDefault("positive", 0);
        int negative = outcomes.getOrDefault("negative", 0);
        double successRate = (positive + negative) > 0 
            ? (positive * 100.0) / (positive + negative)
            : 0;
        
        analysis.put("totalDecisions", decisions.size());
        analysis.put("outcomes", outcomes);
        analysis.put("successRate", Math.round(successRate) + "%");
        analysis.put("summary", String.format(
            "You've made %d decisions. Success rate: %.0f%%",
            decisions.size(), successRate
        ));
        
        return analysis;
    }
    
    /**
     * Identify risk factors from user behavior
     */
    private static List<String> identifyRiskFactors(
            List<Map<String, Object>> emotions,
            List<Map<String, Object>> regrets,
            List<Map<String, Object>> decisions) {
        
        List<String> risks = new ArrayList<>();
        
        // Risk: High stress levels
        double avgIntensity = emotions.stream()
                .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
                .average().orElse(0);
        
        if (avgIntensity >= 7) {
            risks.add("High average stress level (" + Math.round(avgIntensity) + "/10)");
        }
        
        // Risk: Repeated regrets
        Map<String, Integer> regretTags = new HashMap<>();
        for (Map<String, Object> regret : regrets) {
            String tag = (String) regret.get("tag");
            if (tag != null) {
                regretTags.put(tag, regretTags.getOrDefault(tag, 0) + 1);
            }
        }
        
        for (String tag : regretTags.keySet()) {
            if (regretTags.get(tag) >= 3) {
                risks.add("Repeated pattern: " + tag);
            }
        }
        
        // Risk: Poor decision outcomes
        int negativeDecisions = (int) decisions.stream()
                .filter(d -> "negative".equals(d.get("outcome")))
                .count();
        
        if (negativeDecisions >= 2) {
            risks.add("Recent negative decision outcomes (" + negativeDecisions + ")");
        }
        
        return risks.isEmpty() ? List.of("No significant risk factors detected") : risks;
    }
    
    /**
     * Identify positive trends and strengths
     */
    private static List<String> identifyPositiveTrends(
            List<Map<String, Object>> emotions,
            List<Map<String, Object>> decisions) {
        
        List<String> strengths = new ArrayList<>();
        
        // Strength: Consistency in logging
        if (emotions.size() >= 10) {
            strengths.add("Strong self-awareness: You've logged " + emotions.size() + " emotions");
        }
        
        // Strength: Improving intensity
        if (emotions.size() >= 2) {
            int firstHalf = (int) Math.ceil(emotions.size() / 2.0);
            double firstAvg = emotions.subList(0, firstHalf).stream()
                    .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
                    .average().orElse(0);
            
            double secondAvg = emotions.subList(firstHalf, emotions.size()).stream()
                    .mapToDouble(e -> ((Number) e.get("intensity")).doubleValue())
                    .average().orElse(0);
            
            if (secondAvg < firstAvg) {
                strengths.add("Positive trend: Stress levels are decreasing");
            }
        }
        
        // Strength: Good decision outcomes
        int positiveDecisions = (int) decisions.stream()
                .filter(d -> "positive".equals(d.get("outcome")))
                .count();
        
        if (positiveDecisions >= 3) {
            strengths.add("Making good decisions: " + positiveDecisions + " positive outcomes");
        }
        
        return strengths.isEmpty() ? List.of("Keep logging to see positive trends") : strengths;
    }
    
    /**
     * Generate personalized recommendations based on analysis
     */
    private static List<String> generateRecommendations(Map<String, Object> analysis) {
        List<String> recommendations = new ArrayList<>();
        
        // Get risk factors
        @SuppressWarnings("unchecked")
        List<String> risks = (List<String>) analysis.get("riskFactors");
        
        if (risks != null && !risks.isEmpty()) {
            String firstRisk = risks.get(0);
            
            if (firstRisk.contains("stress")) {
                recommendations.add("Try a relaxation technique like deep breathing or meditation");
            } else if (firstRisk.contains("Repeated")) {
                recommendations.add("This pattern keeps repeating. Try a different approach next time");
            } else if (firstRisk.contains("decision")) {
                recommendations.add("Review recent decisions to understand what went wrong");
            }
        }
        
        // Get emotional trends
        @SuppressWarnings("unchecked")
        Map<String, Object> emotions = (Map<String, Object>) analysis.get("emotionalPatterns");
        if (emotions != null) {
            String dominantMood = (String) emotions.get("dominantMood");
            
            if ("happy".equalsIgnoreCase(dominantMood) || "calm".equalsIgnoreCase(dominantMood)) {
                recommendations.add("You're in a good place. Keep doing what works!");
            } else if ("sad".equalsIgnoreCase(dominantMood) || "anxious".equalsIgnoreCase(dominantMood)) {
                recommendations.add("Consider reaching out to someone you trust");
            }
        }
        
        // Get positive trends
        @SuppressWarnings("unchecked")
        List<String> positives = (List<String>) analysis.get("positiveTrends");
        if (positives != null && !positives.isEmpty()) {
            recommendations.add("Keep up your current habits - they're working!");
        }
        
        return recommendations.isEmpty() 
            ? List.of("Continue tracking your emotions and decisions for better insights")
            : recommendations;
    }
    
    /**
     * Get recent regrets from database
     */
    private static List<Map<String, Object>> getRecentRegrets(int userId, int days) {
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
                regret.put("regret_id", rs.getInt("regret_id"));
                regret.put("description", rs.getString("description"));
                regret.put("tag", rs.getString("tag"));
                regret.put("created_date", rs.getTimestamp("created_date"));
                regrets.add(regret);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching regrets: " + e.getMessage());
        }
        
        return regrets;
    }
    
    /**
     * Get diary entries from database
     */
    private static List<Map<String, Object>> getDiaryEntries(int userId, int days) {
        List<Map<String, Object>> entries = new ArrayList<>();
        String query = "SELECT * FROM diary WHERE user_id = ? " +
                      "AND created_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "ORDER BY created_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("diary_id", rs.getInt("diary_id"));
                entry.put("content", rs.getString("content"));
                entry.put("mood", rs.getString("mood"));
                entry.put("created_date", rs.getTimestamp("created_date"));
                entries.add(entry);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching diary entries: " + e.getMessage());
        }
        
        return entries;
    }
    
    /**
     * Get decisions from database
     */
    private static List<Map<String, Object>> getDecisions(int userId, int days) {
        List<Map<String, Object>> decisions = new ArrayList<>();
        String query = "SELECT * FROM decisions WHERE user_id = ? " +
                      "AND created_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "ORDER BY created_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> decision = new HashMap<>();
                decision.put("decision_id", rs.getInt("decision_id"));
                decision.put("description", rs.getString("description"));
                decision.put("outcome", rs.getString("outcome"));
                decision.put("created_date", rs.getTimestamp("created_date"));
                decisions.add(decision);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching decisions: " + e.getMessage());
        }
        
        return decisions;
    }
}
