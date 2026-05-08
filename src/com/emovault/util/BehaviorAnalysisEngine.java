package com.emovault.util;

import com.emovault.dao.BehaviorAnalysisDAO;
import com.emovault.model.BehaviorAnalysis;
import java.util.*;

/**
 * Rule-based behavior analysis engine
 * Detects patterns, analyzes risk, identifies behavior loops, generates suggestions
 * NO machine learning - pure explainable rules
 */
public class BehaviorAnalysisEngine {
    
    /**
     * Main analysis method - orchestrates all analysis steps
     */
    public static BehaviorAnalysis analyzeBehavior(int userId) {
        BehaviorAnalysis analysis = new BehaviorAnalysis();
        analysis.setUserId(userId);
        
        // 1. Get data
        List<Map<String, Object>> emotionStats = BehaviorAnalysisDAO.getEmotionStats(userId);
        int negativeCount = BehaviorAnalysisDAO.countNegativeEmotions(userId);
        double avgIntensity = BehaviorAnalysisDAO.getAverageEmotionIntensity(userId);
        int regretCount = BehaviorAnalysisDAO.countRegrets(userId);
        List<String> regretDescriptions = BehaviorAnalysisDAO.getRegretDescriptions(userId);
        Map<String, Object> habitData = BehaviorAnalysisDAO.getHabitConsistency(userId);
        int emotionCount = BehaviorAnalysisDAO.getEmotionEntriesCount(userId);
        
        // 2. Pattern detection
        String dominantEmotion = detectDominantEmotion(emotionStats);
        analysis.setDominantEmotion(dominantEmotion);
        
        // 3. Risk analysis
        String riskLevel = analyzeRisk(avgIntensity, negativeCount, emotionCount);
        analysis.setRiskLevel(riskLevel);
        
        // 4. Behavior loop detection
        String behaviorLoop = detectBehaviorLoop(dominantEmotion, negativeCount, regretCount, regretDescriptions);
        analysis.setDetectedBehaviorLoop(behaviorLoop);
        
        // 5. Generate suggestions
        List<String> suggestions = generateSuggestions(dominantEmotion, riskLevel, regretCount, 
                                                        negativeCount, habitData, emotionCount);
        analysis.setSuggestions(suggestions);
        
        // 6. Set metadata
        analysis.setEmotionIntensityAverage(avgIntensity);
        analysis.setNegativeEmotionCount(negativeCount);
        analysis.setTotalDataPoints(emotionCount);
        analysis.setAnalysisDate((int) (System.currentTimeMillis() / 1000));
        
        return analysis;
    }
    
    /**
     * PATTERN DETECTION: Find dominant (most frequent) emotion
     */
    private static String detectDominantEmotion(List<Map<String, Object>> emotionStats) {
        if (emotionStats == null || emotionStats.isEmpty()) {
            return "Neutral"; // Default if no data
        }
        
        Map<String, Object> top = emotionStats.get(0);
        return (String) top.get("mood");
    }
    
    /**
     * RISK ANALYSIS: Determine Low/Medium/High based on:
     * - Average intensity (0-10 scale)
     * - Negative emotion frequency
     * - Total data points
     */
    private static String analyzeRisk(double avgIntensity, int negativeCount, int totalCount) {
        // Need minimum data to assess
        if (totalCount < 3) {
            return "Low"; // Insufficient data
        }
        
        // Calculate negative emotion ratio
        double negativeRatio = (double) negativeCount / totalCount;
        
        // Rule-based risk levels
        if (avgIntensity >= 7.0 || negativeCount >= 10 || negativeRatio >= 0.6) {
            return "High";
        } else if (avgIntensity >= 5.0 || negativeCount >= 5 || negativeRatio >= 0.4) {
            return "Medium";
        } else {
            return "Low";
        }
    }
    
    /**
     * BEHAVIOR LOOP DETECTION: Identify repeating cycles
     * Example: Stress → Procrastination → Regret
     */
    private static String detectBehaviorLoop(String dominantEmotion, int negativeCount, 
                                              int regretCount, List<String> regretDescriptions) {
        
        if (dominantEmotion == null) {
            return "No pattern detected";
        }
        
        StringBuilder loop = new StringBuilder();
        
        // Rule 1: Stress + Procrastination + Regret
        if (("Stressed".equals(dominantEmotion) || "Anxious".equals(dominantEmotion)) && 
            negativeCount >= 3 && regretCount >= 2) {
            
            // Check if regrets mention procrastination
            for (String regret : regretDescriptions) {
                if (regret.toLowerCase().contains("procrastin") || 
                    regret.toLowerCase().contains("delay") ||
                    regret.toLowerCase().contains("put off")) {
                    loop.append(dominantEmotion).append(" → Procrastination → Regret");
                    return loop.toString();
                }
            }
            loop.append(dominantEmotion).append(" → Lack of Action → Regret");
            return loop.toString();
        }
        
        // Rule 2: Sadness + Isolation
        if ("Sad".equals(dominantEmotion) && negativeCount >= 5) {
            loop.append("Sadness → Isolation → Low Energy");
            return loop.toString();
        }
        
        // Rule 3: Anger + Conflict + Regret
        if ("Angry".equals(dominantEmotion) && regretCount >= 2) {
            for (String regret : regretDescriptions) {
                if (regret.toLowerCase().contains("said") || 
                    regret.toLowerCase().contains("spoke") ||
                    regret.toLowerCase().contains("react")) {
                    loop.append("Anger → Reactive Response → Regret");
                    return loop.toString();
                }
            }
            loop.append("Anger → Conflict → Regret");
            return loop.toString();
        }
        
        // Rule 4: Generic negative loop
        if (negativeCount >= 5 && regretCount >= 1) {
            loop.append(dominantEmotion).append(" → Negative Action → Regret");
            return loop.toString();
        }
        
        // No strong pattern
        return "No significant pattern detected";
    }
    
    /**
     * RULE-BASED SUGGESTIONS: Generate actionable advice
     */
    private static List<String> generateSuggestions(String dominantEmotion, String riskLevel,
                                                      int regretCount, int negativeCount,
                                                      Map<String, Object> habitData, int emotionCount) {
        
        List<String> suggestions = new ArrayList<>();
        
        // Ensure we have data
        if (emotionCount < 3) {
            suggestions.add("Log more emotions to get personalized insights");
            return suggestions;
        }
        
        // Rule 1: High risk → Stress management
        if ("High".equals(riskLevel)) {
            suggestions.add("🧘 Your stress levels are elevated. Consider daily meditation or breathing exercises.");
            suggestions.add("📝 Set aside 10 minutes daily for reflective journaling to process emotions.");
        }
        
        // Rule 2: Dominant emotion specific suggestions
        if ("Stressed".equals(dominantEmotion) || "Anxious".equals(dominantEmotion)) {
            suggestions.add("⏰ Try the Pomodoro Technique: work 25 min, rest 5 min to reduce overwhelm.");
            suggestions.add("✅ Break large tasks into smaller, manageable steps.");
        } else if ("Sad".equals(dominantEmotion) || "Depressed".equals(dominantEmotion)) {
            suggestions.add("🌞 Spend 15 minutes outdoors daily to boost mood.");
            suggestions.add("👥 Reach out to a friend or loved one for connection.");
            suggestions.add("🎯 Engage in activities that previously brought you joy.");
        } else if ("Angry".equals(dominantEmotion)) {
            suggestions.add("⏸️ Practice the 10-second pause before responding in conflicts.");
            suggestions.add("💪 Physical activity (walk, exercise) helps release anger constructively.");
        } else if ("Happy".equals(dominantEmotion)) {
            suggestions.add("✨ Your mood is positive! Keep up with activities bringing you joy.");
        }
        
        // Rule 3: Regret reduction
        if (regretCount >= 3) {
            suggestions.add("🔄 You have frequent regrets. Try a 'corrective habit' - small actions to address past mistakes.");
        }
        
        // Rule 4: Habit consistency
        Integer totalHabits = (Integer) habitData.getOrDefault("total_habits", 0);
        Integer activeHabits = (Integer) habitData.getOrDefault("active_habits", 0);
        
        if (totalHabits > 0 && activeHabits == 0) {
            suggestions.add("🏗️ Reactivate a habit to build consistency and structure in your life.");
        } else if (totalHabits == 0) {
            suggestions.add("🎯 Start with 1 small habit (5 min daily) to create positive momentum.");
        }
        
        // Rule 5: Negative emotion frequency
        if (negativeCount >= 8) {
            suggestions.add("💭 Consider what triggers your negative emotions. Keep a trigger log.");
        }
        
        // Rule 6: Behavioral loop intervention
        if (negativeCount >= 5 && regretCount >= 2) {
            suggestions.add("🔗 You're in a cycle. Interrupt it by choosing ONE different action today.");
        }
        
        // Ensure at least 3 suggestions
        if (suggestions.isEmpty()) {
            suggestions.add("Continue tracking your emotions for deeper insights.");
            suggestions.add("Maintain consistency with your habits and journals.");
            suggestions.add("Practice self-compassion and celebrate small wins.");
        }
        
        return suggestions.subList(0, Math.min(suggestions.size(), 5)); // Max 5 suggestions
    }
}
