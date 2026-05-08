package com.emovault.model;

import java.util.*;

/**
 * POJO representing behavior analysis results
 * Contains patterns, risk assessment, and suggestions
 */
public class BehaviorAnalysis {
    
    private int userId;
    private String dominantEmotion;
    private double emotionIntensityAverage;
    private String riskLevel; // Low, Medium, High
    private int negativeEmotionCount;
    private List<String> emotionFrequency; // Top emotions
    private String detectedBehaviorLoop; // e.g., "Stress → Procrastination → Regret"
    private List<String> suggestions; // Rule-based suggestions
    private int totalDataPoints; // Total emotions analyzed
    private int analysisDate;
    
    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getDominantEmotion() { return dominantEmotion; }
    public void setDominantEmotion(String dominantEmotion) { this.dominantEmotion = dominantEmotion; }
    
    public double getEmotionIntensityAverage() { return emotionIntensityAverage; }
    public void setEmotionIntensityAverage(double emotionIntensityAverage) { this.emotionIntensityAverage = emotionIntensityAverage; }
    
    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }
    
    public int getNegativeEmotionCount() { return negativeEmotionCount; }
    public void setNegativeEmotionCount(int negativeEmotionCount) { this.negativeEmotionCount = negativeEmotionCount; }
    
    public List<String> getEmotionFrequency() { return emotionFrequency; }
    public void setEmotionFrequency(List<String> emotionFrequency) { this.emotionFrequency = emotionFrequency; }
    
    public String getDetectedBehaviorLoop() { return detectedBehaviorLoop; }
    public void setDetectedBehaviorLoop(String detectedBehaviorLoop) { this.detectedBehaviorLoop = detectedBehaviorLoop; }
    
    public List<String> getSuggestions() { return suggestions; }
    public void setSuggestions(List<String> suggestions) { this.suggestions = suggestions; }
    
    public int getTotalDataPoints() { return totalDataPoints; }
    public void setTotalDataPoints(int totalDataPoints) { this.totalDataPoints = totalDataPoints; }
    
    public int getAnalysisDate() { return analysisDate; }
    public void setAnalysisDate(int analysisDate) { this.analysisDate = analysisDate; }
}
