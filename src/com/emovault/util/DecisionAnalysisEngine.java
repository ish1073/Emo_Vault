package com.emovault.util;

import com.emovault.model.*;
import com.emovault.dao.*;
import java.util.*;
import java.sql.*;

public class DecisionAnalysisEngine {
    
    /**
     * Analyze decision by evaluating both options
     */
    public static Decision analyzeDecision(int userId, String situation, String optionA, String optionB) {
        Decision decision = new Decision(userId, situation, optionA, optionB);
        
        // Get context data
        String currentMood = getCurrentMood(userId);
        List<String> recentRegrets = getRecentRegrets(userId);
        List<String> positiveHabits = getPositiveHabits(userId);
        Map<String, Integer> emotionFrequency = getEmotionFrequency(userId);
        
        // Evaluate each option
        String riskA = evaluateRisk(optionA, recentRegrets, positiveHabits, currentMood);
        String riskB = evaluateRisk(optionB, recentRegrets, positiveHabits, currentMood);
        
        decision.setRiskLevelA(riskA);
        decision.setRiskLevelB(riskB);
        
        // Estimate emotional outcomes
        String outcomeA = estimateEmotionalOutcome(optionA, currentMood, emotionFrequency);
        String outcomeB = estimateEmotionalOutcome(optionB, currentMood, emotionFrequency);
        
        decision.setEmotionalOutcomeA(outcomeA);
        decision.setEmotionalOutcomeB(outcomeB);
        
        // Generate recommendation
        generateRecommendation(decision, riskA, riskB, recentRegrets, positiveHabits);
        
        return decision;
    }
    
    /**
     * Get current mood of user
     */
    private static String getCurrentMood(int userId) {
        try {
            Connection conn = DBConnection.getConnection();
            if (conn == null) return "Neutral";
            
            String query = "SELECT mood FROM emotions WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("mood");
            }
        } catch (Exception e) {
            System.out.println("Error getting current mood: " + e.getMessage());
        }
        return "Neutral";
    }
    
    /**
     * Get recent regrets (past 30 days)
     */
    private static List<String> getRecentRegrets(int userId) {
        List<String> regrets = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            if (conn == null) return regrets;
            
            RegretDAO regretDAO = new RegretDAO(conn);
            List<Regret> userRegrets = regretDAO.getAllRegretsByUserId(userId);
            for (Regret regret : userRegrets) {
                regrets.add(regret.getDescription().toLowerCase());
            }
        } catch (Exception e) {
            System.out.println("Error getting regrets: " + e.getMessage());
        }
        return regrets;
    }
    
    /**
     * Get positive habits
     */
    private static List<String> getPositiveHabits(int userId) {
        List<String> habits = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            if (conn == null) return habits;
            
            HabitDAO habitDAO = new HabitDAO(conn);
            List<Habit> userHabits = habitDAO.getAllHabitsByUserId(userId);
            for (Habit habit : userHabits) {
                if (habit.getConsistencyScore() >= 70) {
                    habits.add(habit.getName().toLowerCase());
                }
            }
        } catch (Exception e) {
            System.out.println("Error getting habits: " + e.getMessage());
        }
        return habits;
    }
    
    /**
     * Get emotion frequency distribution
     */
    private static Map<String, Integer> getEmotionFrequency(int userId) {
        Map<String, Integer> frequency = new HashMap<>();
        try {
            Connection conn = DBConnection.getConnection();
            if (conn == null) return frequency;
            
            String query = "SELECT mood FROM emotions WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String mood = rs.getString("mood");
                frequency.put(mood, frequency.getOrDefault(mood, 0) + 1);
            }
        } catch (Exception e) {
            System.out.println("Error getting emotion frequency: " + e.getMessage());
        }
        return frequency;
    }
    
    /**
     * Evaluate risk level for an option
     * Rule-based logic:
     * - High: Similar to past regrets OR conflicts with positive habits OR negative mood warning
     * - Medium: Neutral attributes but some caution recommended
     * - Low: Aligns with positive habits OR positive past choices
     */
    private static String evaluateRisk(String option, List<String> regrets, 
                                       List<String> habits, String currentMood) {
        String optionLower = option.toLowerCase();
        int riskScore = 0;
        
        // Rule 1: Check if option matches past regrets
        for (String regret : regrets) {
            if (hasSimilarity(optionLower, regret)) {
                riskScore += 30;
            }
        }
        
        // Rule 2: Check if option aligns with positive habits
        for (String habit : habits) {
            if (hasSimilarity(optionLower, habit)) {
                riskScore -= 20;
            }
        }
        
        // Rule 3: Warn if current mood is negative
        if (isNegativeMood(currentMood)) {
            riskScore += 15;
        }
        
        // Rule 4: Check for risk keywords
        if (containsRiskKeywords(optionLower)) {
            riskScore += 15;
        }
        
        // Rule 5: Check for safe keywords
        if (containsSafeKeywords(optionLower)) {
            riskScore -= 15;
        }
        
        // Convert risk score to level
        if (riskScore >= 40) {
            return "High";
        } else if (riskScore >= 15) {
            return "Medium";
        } else {
            return "Low";
        }
    }
    
    /**
     * Estimate emotional outcome based on current mood and patterns
     */
    private static String estimateEmotionalOutcome(String option, String currentMood, 
                                                   Map<String, Integer> emotionFrequency) {
        String optionLower = option.toLowerCase();
        
        // Rule 1: If stressed/anxious, relaxing options are better
        if ((currentMood.equalsIgnoreCase("Stressed") || 
             currentMood.equalsIgnoreCase("Anxious")) &&
            containsRelaxingKeywords(optionLower)) {
            return "Relief & Calm";
        }
        
        // Rule 2: If sad, engaging/social options are better
        if (currentMood.equalsIgnoreCase("Sad") && 
            containsSocialKeywords(optionLower)) {
            return "Connection & Joy";
        }
        
        // Rule 3: If neutral/good mood, consider growth options
        if ((currentMood.equalsIgnoreCase("Happy") || 
             currentMood.equalsIgnoreCase("Neutral")) &&
            containsGrowthKeywords(optionLower)) {
            return "Growth & Achievement";
        }
        
        // Default: Stable outcome
        return "Stable & Manageable";
    }
    
    /**
     * Generate recommendation based on risk levels
     */
    private static void generateRecommendation(Decision decision, String riskA, String riskB,
                                              List<String> regrets, List<String> habits) {
        String optionA = decision.getOptionA();
        String optionB = decision.getOptionB();
        String reasoning = "Based on your emotional patterns and history, both options have been evaluated.";
        String recommended = "A"; // Default to A if no clear winner
        
        // Ensure risk levels are not null
        if (riskA == null) riskA = "Medium";
        if (riskB == null) riskB = "Medium";
        
        // Ensure emotional outcomes are not null
        String outcomeA = decision.getEmotionalOutcomeA();
        String outcomeB = decision.getEmotionalOutcomeB();
        if (outcomeA == null) outcomeA = "Stable & Manageable";
        if (outcomeB == null) outcomeB = "Stable & Manageable";
        
        // Rule 1: If one option has high risk and other is low/medium, pick the safer one
        if (riskA.equals("High") && !riskB.equals("High")) {
            recommended = "B";
            reasoning = "Option B is safer. Option A has patterns similar to past regrets.";
        } else if (riskB.equals("High") && !riskA.equals("High")) {
            recommended = "A";
            reasoning = "Option A is safer. Option B has patterns similar to past regrets.";
        }
        // Rule 2: If both have same risk, check emotional outcomes
        else if (riskA.equals(riskB)) {
            if (outcomeA.contains("Growth") || outcomeA.contains("Joy")) {
                recommended = "A";
                reasoning = "Both options carry similar risk, but Option A offers better emotional benefits.";
            } else if (outcomeB.contains("Growth") || outcomeB.contains("Joy")) {
                recommended = "B";
                reasoning = "Both options carry similar risk, but Option B offers better emotional benefits.";
            } else {
                // Check which aligns better with habits
                if (isAlignedWithHabits(optionA, habits)) {
                    recommended = "A";
                    reasoning = "Option A aligns better with your positive habits.";
                } else {
                    recommended = "B";
                    reasoning = "Option B aligns better with your positive habits.";
                }
            }
        }
        // Rule 3: Medium vs Low risk
        else if (!riskA.equals(riskB)) {
            if (riskA.equals("Low")) {
                recommended = "A";
                reasoning = "Option A carries lower risk based on your patterns.";
            } else {
                recommended = "B";
                reasoning = "Option B carries lower risk based on your patterns.";
            }
        }
        
        decision.setRecommendedOption(recommended);
        decision.setRecommendation(reasoning);
    }
    
    /**
     * Check if option text is similar to habit/regret
     */
    private static boolean hasSimilarity(String option, String reference) {
        String[] optionWords = option.split("\\s+");
        String[] refWords = reference.split("\\s+");
        
        int matches = 0;
        for (String oWord : optionWords) {
            for (String rWord : refWords) {
                if (oWord.equalsIgnoreCase(rWord) || oWord.contains(rWord) || rWord.contains(oWord)) {
                    matches++;
                }
            }
        }
        
        return matches >= 2;
    }
    
    /**
     * Check if mood is negative
     */
    private static boolean isNegativeMood(String mood) {
        String lower = mood.toLowerCase();
        return lower.contains("sad") || lower.contains("stress") || 
               lower.contains("anxious") || lower.contains("angry") || 
               lower.contains("frustrated") || lower.contains("depressed");
    }
    
    /**
     * Check for risk-indicating keywords
     */
    private static boolean containsRiskKeywords(String text) {
        String[] keywords = {"avoid", "skip", "ignore", "postpone", "cancel", "quit", "give up"};
        for (String kw : keywords) {
            if (text.contains(kw)) return true;
        }
        return false;
    }
    
    /**
     * Check for safe/positive keywords
     */
    private static boolean containsSafeKeywords(String text) {
        String[] keywords = {"plan", "schedule", "prepare", "organize", "communicate", "discuss", "learn"};
        for (String kw : keywords) {
            if (text.contains(kw)) return true;
        }
        return false;
    }
    
    /**
     * Check for relaxing keywords
     */
    private static boolean containsRelaxingKeywords(String text) {
        String[] keywords = {"rest", "relax", "sleep", "meditate", "calm", "slow down", "break", "pause"};
        for (String kw : keywords) {
            if (text.contains(kw)) return true;
        }
        return false;
    }
    
    /**
     * Check for social keywords
     */
    private static boolean containsSocialKeywords(String text) {
        String[] keywords = {"talk", "meet", "call", "visit", "gather", "share", "connect", "spend time"};
        for (String kw : keywords) {
            if (text.contains(kw)) return true;
        }
        return false;
    }
    
    /**
     * Check for growth keywords
     */
    private static boolean containsGrowthKeywords(String text) {
        String[] keywords = {"learn", "practice", "exercise", "achieve", "goal", "improve", "develop", "grow"};
        for (String kw : keywords) {
            if (text.contains(kw)) return true;
        }
        return false;
    }
    
    /**
     * Check if option aligns with positive habits
     */
    private static boolean isAlignedWithHabits(String option, List<String> habits) {
        String optionLower = option.toLowerCase();
        for (String habit : habits) {
            if (hasSimilarity(optionLower, habit)) {
                return true;
            }
        }
        return false;
    }
}
