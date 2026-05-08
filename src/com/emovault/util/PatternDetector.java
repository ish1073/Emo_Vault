package com.emovault.util;

import com.emovault.dao.EmotionDAO;
import com.emovault.model.EmotionPattern;
import java.sql.*;
import java.util.*;

/**
 * PatternDetector Class
 * Analyzes emotion data to detect patterns and insights
 * Integrates with Expert system for intelligent recommendations
 */
public class PatternDetector {
    
    private EmotionDAO emotionDAO;
    private EmotionPattern pattern;
    private Expert expert;
    
    public PatternDetector() {
        this.emotionDAO = new EmotionDAO();
        this.pattern = new EmotionPattern();
        this.expert = new Expert();
    }
    
    /**
     * Analyze all emotion patterns for a user
     * @param userId User ID
     * @return EmotionPattern with insights
     */
    public EmotionPattern analyzeEmotions(int userId) {
        pattern = new EmotionPattern();
        
        try {
            int totalEmotions = emotionDAO.getEmotionCount(userId);
            pattern.setTotalEmotions(totalEmotions);
            
            if (totalEmotions == 0) {
                pattern.addInsight("📊 Start logging emotions to see patterns emerge!");
                return pattern;
            }
            
            detectFrequentMood(userId);
            detectHighStress(userId);
            detectRepeatedTriggers(userId);
            detectOverthinking(userId);
            
            // Integrate Expert suggestions
            generateExpertInsights();
            
            System.out.println("[EmoVault] Pattern analysis complete for user " + userId);
            
        } catch (Exception e) {
            System.err.println("[EmoVault] Error analyzing patterns: " + e.getMessage());
            pattern.addInsight("⚠️ Unable to analyze patterns (demo mode)");
        }
        
        return pattern;
    }
    
    /**
     * Detect most frequent mood
     * @param userId User ID
     */
    private void detectFrequentMood(int userId) {
        try {
            String mostFrequentMood = emotionDAO.getMostFrequentMood(userId);
            
            if (mostFrequentMood != null && !mostFrequentMood.isEmpty()) {
                pattern.setFrequentMood(mostFrequentMood);
                
                // Query to get count
                String query = "SELECT COUNT(*) as count FROM emotion_entries WHERE user_id = ? AND mood = ?";
                Connection conn = DBConnection.getConnection();
                if (conn != null) {
                    try (PreparedStatement stmt = conn.prepareStatement(query)) {
                        stmt.setInt(1, userId);
                        stmt.setString(2, mostFrequentMood);
                        ResultSet rs = stmt.executeQuery();
                        
                        if (rs.next()) {
                            int count = rs.getInt("count");
                            pattern.setFrequentMoodCount(count);
                            pattern.addInsight("😊 Your most frequent mood is " + mostFrequentMood + 
                                             " (" + count + " times)");
                        }
                        conn.close();
                    }
                } else {
                    pattern.addInsight("😊 Your most frequent mood is " + mostFrequentMood);
                }
            }
        } catch (Exception e) {
            System.err.println("[EmoVault] Error detecting frequent mood: " + e.getMessage());
        }
    }
    
    /**
     * Detect high stress frequency (intensity > 7)
     * @param userId User ID
     */
    private void detectHighStress(int userId) {
        try {
            String query = "SELECT COUNT(*) as count FROM emotion_entries WHERE user_id = ? AND intensity > 7";
            Connection conn = DBConnection.getConnection();
            
            if (conn != null) {
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, userId);
                    ResultSet rs = stmt.executeQuery();
                    
                    if (rs.next()) {
                        int highStressCount = rs.getInt("count");
                        pattern.setHighStressCount(highStressCount);
                        
                        if (highStressCount > 0) {
                            if (highStressCount >= 5) {
                                pattern.addInsight("⚠️ High stress detected " + highStressCount + 
                                                 " times! Consider stress management techniques.");
                            } else if (highStressCount >= 3) {
                                pattern.addInsight("😰 You've experienced high stress " + highStressCount + 
                                                 " times recently.");
                            }
                        }
                    }
                    conn.close();
                }
            }
        } catch (Exception e) {
            System.err.println("[EmoVault] Error detecting high stress: " + e.getMessage());
        }
    }
    
    /**
     * Detect repeated triggers
     * @param userId User ID
     */
    private void detectRepeatedTriggers(int userId) {
        try {
            String query = "SELECT trigger, COUNT(*) as count FROM emotion_entries " +
                          "WHERE user_id = ? GROUP BY trigger HAVING count > 2 ORDER BY count DESC LIMIT 3";
            Connection conn = DBConnection.getConnection();
            
            if (conn != null) {
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, userId);
                    ResultSet rs = stmt.executeQuery();
                    
                    List<String> triggers = new ArrayList<>();
                    while (rs.next()) {
                        String trigger = rs.getString("trigger");
                        int count = rs.getInt("count");
                        triggers.add(trigger);
                        
                        pattern.addInsight("🔄 Repeated trigger: '" + trigger + 
                                         "' affects you " + count + " times");
                    }
                    pattern.setRepeatedTriggers(triggers);
                    conn.close();
                }
            }
        } catch (Exception e) {
            System.err.println("[EmoVault] Error detecting repeated triggers: " + e.getMessage());
        }
    }
    
    /**
     * Detect overthinking pattern (same negative mood repeated)
     * @param userId User ID
     */
    private void detectOverthinking(int userId) {
        try {
            String[] negativeModods = {"Sad", "Angry", "Anxious", "Frustrated"};
            String query = "SELECT mood, COUNT(*) as count FROM emotion_entries " +
                          "WHERE user_id = ? AND mood IN (?, ?, ?, ?) " +
                          "GROUP BY mood ORDER BY count DESC LIMIT 1";
            Connection conn = DBConnection.getConnection();
            
            if (conn != null) {
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, userId);
                    stmt.setString(2, negativeModods[0]);
                    stmt.setString(3, negativeModods[1]);
                    stmt.setString(4, negativeModods[2]);
                    // Note: Only 4 params in query but array has 4, adjust query
                    
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        int count = rs.getInt("count");
                        if (count >= 4) {
                            pattern.setOverthinkinDetected(true);
                            pattern.addInsight("💭 Overthinking pattern detected: " +
                                             "You may be dwelling on negative feelings. " +
                                             "Try mindfulness or breathing exercises!");
                        }
                    }
                    conn.close();
                }
            }
        } catch (Exception e) {
            System.err.println("[EmoVault] Error detecting overthinking: " + e.getMessage());
        }
    }
    
    /**
     * Generate Expert insights and suggestions based on detected patterns
     */
    private void generateExpertInsights() {
        try {
            // Add expert suggestions based on frequent mood
            if (pattern.getFrequentMood() != null && !pattern.getFrequentMood().isEmpty()) {
                String moodAdvice = expert.getQuickAdvice(pattern.getFrequentMood());
                if (moodAdvice != null) {
                    pattern.addInsight(moodAdvice);
                }
            }
            
            // Add expert suggestions based on high stress
            if (pattern.getInsights().stream().anyMatch(i -> i.contains("High stress"))) {
                String stressSuggestion = expert.generateSuggestion("stress");
                if (stressSuggestion != null) {
                    pattern.addInsight(stressSuggestion);
                }
                
                String riskAlert = expert.defineRiskRule("high stress repeated");
                if (riskAlert != null) {
                    pattern.addInsight(riskAlert);
                }
            }
            
            // Add expert suggestions based on overthinking
            if (pattern.getInsights().stream().anyMatch(i -> i.contains("Overthinking"))) {
                String overthinkinSuggestion = expert.generateSuggestion("overthinking");
                if (overthinkinSuggestion != null) {
                    pattern.addInsight(overthinkinSuggestion);
                }
            }
            
            System.out.println("[EmoVault] Expert insights added to pattern analysis");
            
        } catch (Exception e) {
            System.err.println("[EmoVault] Error generating expert insights: " + e.getMessage());
        }
    }
    
    public EmotionPattern getPattern() {
        return pattern;
    }
}
