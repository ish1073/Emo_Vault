package com.emovault.service.analysis;

import com.emovault.service.DataService;
import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.util.Date;

/**
 * Behavior Analysis Service
 * Central orchestration service for comprehensive behavior analysis.
 * 
 * This service:
 * - Coordinates all analysis components (patterns, risk, insights)
 * - Provides real-time analysis based on actual user data
 * - Handles cache invalidation for fresh data
 * - Supports configurable analysis periods
 */
public class BehaviorAnalysisService {
    
    /**
     * Perform comprehensive behavior analysis for a user
     * 
     * @param userId The user ID to analyze
     * @param daysPeriod The analysis period in days (7, 30, 90)
     * @return Comprehensive analysis results
     */
    public static Map<String, Object> analyzeBehavior(int userId, int daysPeriod) {
        Map<String, Object> analysis = new HashMap<>();
        
        // Set metadata
        analysis.put("userId", userId);
        analysis.put("period", daysPeriod);
        analysis.put("analysisDate", new Date().toString());
        
        // Gather raw data counts for context
        Map<String, Integer> dataCounts = getDataCounts(userId, daysPeriod);
        analysis.put("dataCounts", dataCounts);
        
        // Check if we have enough data
        int totalEntries = dataCounts.get("emotions") + 
                          dataCounts.get("diaryEntries") + 
                          dataCounts.get("regrets");
        
        if (totalEntries < 3) {
            analysis.put("dataAvailable", false);
            analysis.put("message", "Not enough data yet. Log more emotions, diary entries, and reflections to see insights.");
            analysis.put("emotionalPatterns", Map.of("summary", "Insufficient data"));
            analysis.put("triggersAndThemes", Map.of("summary", "Insufficient data"));
            analysis.put("decisionPatterns", Map.of("summary", "Insufficient data"));
            analysis.put("riskFactors", List.of("Continue logging to build your emotional history"));
            analysis.put("positiveTrends", List.of("Start your journey by logging your first emotion"));
            analysis.put("recommendations", List.of("Log your emotions regularly for personalized insights"));
            return analysis;
        }
        
        analysis.put("dataAvailable", true);
        
        // 1. Emotional Pattern Analysis
        Map<String, Object> emotionalPatterns = EmotionalPatternAnalyzer.analyzePatterns(userId, daysPeriod);
        analysis.put("emotionalPatterns", emotionalPatterns);
        
        // 2. Risk Analysis
        Map<String, Object> riskAnalysis = RiskCalculationHelper.calculateRiskScore(userId, daysPeriod);
        analysis.put("riskAnalysis", riskAnalysis);
        
        // 3. Insight Generation
        Map<String, Object> insights = InsightGenerationHelper.generateInsights(userId, daysPeriod);
        analysis.put("insights", insights);
        
        // 4. Triggers and Themes (from insights)
        @SuppressWarnings("unchecked")
        Map<String, Object> triggers = (Map<String, Object>) insights.get("triggerIdentification");
        analysis.put("triggersAndThemes", triggers != null ? triggers : Map.of("summary", "No triggers detected yet"));
        
        // 5. Decision Patterns
        Map<String, Object> decisionPatterns = analyzeDecisionPatterns(userId, daysPeriod);
        analysis.put("decisionPatterns", decisionPatterns);
        
        // 6. Extract risk factors for display
        List<String> riskFactors = extractRiskFactors(riskAnalysis, emotionalPatterns);
        analysis.put("riskFactors", riskFactors);
        
        // 7. Extract positive trends
        @SuppressWarnings("unchecked")
        List<String> positiveTrends = (List<String>) insights.get("positiveGrowthObservations");
        if (positiveTrends == null || positiveTrends.isEmpty()) {
            positiveTrends = extractPositiveTrends(emotionalPatterns);
        }
        analysis.put("positiveTrends", positiveTrends);
        
        // 8. Generate recommendations
        List<String> recommendations = generateRecommendations(analysis);
        analysis.put("recommendations", recommendations);
        
        return analysis;
    }
    
    /**
     * Analyze decision patterns for a user
     */
    private static Map<String, Object> analyzeDecisionPatterns(int userId, int daysPeriod) {
        Map<String, Object> patterns = new HashMap<>();
        
        List<Map<String, Object>> decisions = getDecisions(userId, daysPeriod);
        
        if (decisions.isEmpty()) {
            patterns.put("summary", "Log your decisions to see decision patterns and outcomes.");
            patterns.put("totalDecisions", 0);
            return patterns;
        }
        
        // Count outcomes
        Map<String, Integer> outcomes = new HashMap<>();
        for (Map<String, Object> decision : decisions) {
            String outcome = (String) decision.get("outcome");
            if (outcome != null) {
                outcomes.put(outcome, outcomes.getOrDefault(outcome, 0) + 1);
            }
        }
        
        int positive = outcomes.getOrDefault("positive", 0);
        int negative = outcomes.getOrDefault("negative", 0);
        int total = positive + negative;
        
        double successRate = total > 0 ? (positive * 100.0) / total : 0;
        
        patterns.put("summary", String.format(
            "You've made %d decisions with a %.0f%% positive outcome rate.",
            decisions.size(), successRate
        ));
        patterns.put("totalDecisions", decisions.size());
        patterns.put("outcomes", outcomes);
        patterns.put("successRate", Math.round(successRate) + "%");
        
        return patterns;
    }
    
    /**
     * Extract risk factors from analysis results
     */
    private static List<String> extractRiskFactors(Map<String, Object> riskAnalysis, 
                                                   Map<String, Object> emotionalPatterns) {
        List<String> factors = new ArrayList<>();
        
        // From risk analysis
        if (riskAnalysis.containsKey("hasData") && (Boolean) riskAnalysis.get("hasData")) {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> riskInsights = (List<Map<String, Object>>) riskAnalysis.get("insights");
            if (riskInsights != null) {
                for (Map<String, Object> insight : riskInsights) {
                    if (!"positive".equals(insight.get("type"))) {
                        factors.add((String) insight.get("message"));
                    }
                }
            }
        }
        
        // From emotional patterns - stress indicators
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> stressIndicators = (List<Map<String, Object>>) emotionalPatterns.get("stressIndicators");
        if (stressIndicators != null) {
            for (Map<String, Object> indicator : stressIndicators) {
                factors.add((String) indicator.get("description"));
            }
        }
        
        if (factors.isEmpty()) {
            factors.add("No significant risk factors detected");
        }
        
        return factors;
    }
    
    /**
     * Extract positive trends from emotional patterns
     */
    private static List<String> extractPositiveTrends(Map<String, Object> emotionalPatterns) {
        List<String> trends = new ArrayList<>();
        
        // Check emotional trend
        @SuppressWarnings("unchecked")
        Map<String, Object> trend = (Map<String, Object>) emotionalPatterns.get("emotionalTrends");
        if (trend != null && "improving".equals(trend.get("trend"))) {
            trends.add("Your emotional intensity is improving over time");
        }
        
        // Check confidence trend
        @SuppressWarnings("unchecked")
        Map<String, Object> confidence = (Map<String, Object>) emotionalPatterns.get("confidenceTrend");
        if (confidence != null && "high_confidence".equals(confidence.get("status"))) {
            trends.add((String) confidence.get("description"));
        }
        
        // Check for consistency - safely handle Number types
        @SuppressWarnings("unchecked")
        Map<String, Object> emotionFreq = (Map<String, Object>) emotionalPatterns.get("emotionFrequency");
        int entryCount = 0;
        if (emotionFreq != null) {
            for (Object value : emotionFreq.values()) {
                if (value instanceof Number) {
                    entryCount += ((Number) value).intValue();
                }
            }
        }
        if (entryCount >= 10) {
            trends.add("Strong self-awareness: You've logged " + entryCount + " emotions");
        }
        
        if (trends.isEmpty()) {
            trends.add("Keep tracking your emotions to identify positive patterns");
        }
        
        return trends;
    }
    
    /**
     * Generate personalized recommendations based on analysis
     */
    private static List<String> generateRecommendations(Map<String, Object> analysis) {
        List<String> recommendations = new ArrayList<>();
        
        // Get risk level
        @SuppressWarnings("unchecked")
        Map<String, Object> riskAnalysis = (Map<String, Object>) analysis.get("riskAnalysis");
        String riskLevel = riskAnalysis != null ? (String) riskAnalysis.get("riskLevel") : "low";
        
        // Get emotional patterns
        @SuppressWarnings("unchecked")
        Map<String, Object> emotionalPatterns = (Map<String, Object>) analysis.get("emotionalPatterns");
        
        // High risk recommendations
        if ("high".equals(riskLevel)) {
            recommendations.add("Consider practicing daily stress management techniques like meditation or deep breathing.");
            recommendations.add("Reach out to a trusted friend, family member, or professional for support.");
        }
        
        // Based on dominant emotion - safely handle Number values
        @SuppressWarnings("unchecked")
        Map<String, Object> emotionFreq = (Map<String, Object>) emotionalPatterns.get("emotionFrequency");
        if (emotionFreq != null && !emotionFreq.isEmpty()) {
            String dominantEmotion = emotionFreq.entrySet().stream()
                .max((e1, e2) -> {
                    int v1 = e1.getValue() instanceof Number ? ((Number) e1.getValue()).intValue() : 0;
                    int v2 = e2.getValue() instanceof Number ? ((Number) e2.getValue()).intValue() : 0;
                    return Integer.compare(v1, v2);
                })
                .map(Map.Entry::getKey)
                .orElse("");
            
            switch (dominantEmotion) {
                case "Stressed":
                case "Anxious":
                    recommendations.add("Try the Pomodoro Technique: work 25 minutes, rest 5 minutes to reduce overwhelm.");
                    recommendations.add("Break large tasks into smaller, manageable steps.");
                    break;
                case "Sad":
                case "Depressed":
                    recommendations.add("Spend 15 minutes outdoors daily to boost mood.");
                    recommendations.add("Engage in activities that previously brought you joy.");
                    break;
                case "Angry":
                    recommendations.add("Practice the 10-second pause before responding in conflicts.");
                    recommendations.add("Physical activity helps release anger constructively.");
                    break;
                case "Happy":
                case "Calm":
                    recommendations.add("You're in a good place! Keep doing what works for you.");
                    break;
            }
        }
        
        // Based on triggers
        @SuppressWarnings("unchecked")
        Map<String, Object> triggers = (Map<String, Object>) analysis.get("triggersAndThemes");
        if (triggers != null) {
            @SuppressWarnings("unchecked")
            List<String> triggerInsights = (List<String>) triggers.get("insights");
            if (triggerInsights != null) {
                for (String insight : triggerInsights) {
                    if (insight.contains("Work-related")) {
                        recommendations.add("Consider setting clearer work-life boundaries.");
                    } else if (insight.contains("Relationship")) {
                        recommendations.add("Focus on open and honest communication in relationships.");
                    }
                }
            }
        }
        
        // General recommendations if list is short
        if (recommendations.size() < 2) {
            recommendations.add("Continue tracking your emotions for deeper insights.");
            recommendations.add("Maintain consistency with your daily habits.");
        }
        
        // Limit to 5 recommendations
        return recommendations.subList(0, Math.min(recommendations.size(), 5));
    }
    
    /**
     * Get data counts for the analysis period
     */
    private static Map<String, Integer> getDataCounts(int userId, int daysPeriod) {
        Map<String, Integer> counts = new HashMap<>();
        
        counts.put("emotions", countEmotions(userId, daysPeriod));
        counts.put("diaryEntries", countDiaryEntries(userId, daysPeriod));
        counts.put("regrets", countRegrets(userId, daysPeriod));
        counts.put("decisions", countDecisions(userId, daysPeriod));
        counts.put("habits", countActiveHabits(userId));
        
        return counts;
    }
    
    /**
     * Clear analysis cache for a user (call after data changes)
     */
    public static void clearCache(int userId) {
        DataService.clearUserCache(userId);
    }
    
    // Data access methods
    
    private static int countEmotions(int userId, int days) {
        String query = "SELECT COUNT(*) as count FROM emotion_entries WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        return executeCountQuery(userId, days, query);
    }
    
    private static int countDiaryEntries(int userId, int days) {
        String query = "SELECT COUNT(*) as count FROM diary_entries WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        return executeCountQuery(userId, days, query);
    }
    
    private static int countRegrets(int userId, int days) {
        String query = "SELECT COUNT(*) as count FROM regrets WHERE user_id = ? " +
                      "AND created_date >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        return executeCountQuery(userId, days, query);
    }
    
    private static int countDecisions(int userId, int days) {
        String query = "SELECT COUNT(*) as count FROM decisions WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        return executeCountQuery(userId, days, query);
    }
    
    private static int countActiveHabits(int userId) {
        String query = "SELECT COUNT(*) as count FROM habits WHERE user_id = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("Error counting habits: " + e.getMessage());
        }
        return 0;
    }
    
    private static int executeCountQuery(int userId, int days, String query) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("Error executing count query: " + e.getMessage());
        }
        return 0;
    }
    
    private static List<Map<String, Object>> getDecisions(int userId, int days) {
        List<Map<String, Object>> decisions = new ArrayList<>();
        String query = "SELECT * FROM decisions WHERE user_id = ? " +
                      "AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                      "ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> decision = new HashMap<>();
                decision.put("decision_id", rs.getInt("decision_id"));
                decision.put("situation", rs.getString("situation"));
                decision.put("chosen_option", rs.getString("chosen_option"));
                decision.put("outcome", rs.getString("outcome"));
                decision.put("created_at", rs.getTimestamp("created_at"));
                decisions.add(decision);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching decisions: " + e.getMessage());
        }
        
        return decisions;
    }
}