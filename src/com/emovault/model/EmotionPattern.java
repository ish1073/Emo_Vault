package com.emovault.model;

import java.util.*;

/**
 * EmotionPattern Model Class
 * Holds emotion analysis insights and patterns
 */
public class EmotionPattern {
    private String frequentMood;
    private int frequentMoodCount;
    private int highStressCount;
    private int totalEmotions;
    private List<String> repeatedTriggers;
    private boolean overthinkinDetected;
    private List<String> insights;
    
    public EmotionPattern() {
        this.repeatedTriggers = new ArrayList<>();
        this.insights = new ArrayList<>();
    }
    
    // Getters and Setters
    public String getFrequentMood() {
        return frequentMood;
    }
    
    public void setFrequentMood(String frequentMood) {
        this.frequentMood = frequentMood;
    }
    
    public int getFrequentMoodCount() {
        return frequentMoodCount;
    }
    
    public void setFrequentMoodCount(int frequentMoodCount) {
        this.frequentMoodCount = frequentMoodCount;
    }
    
    public int getHighStressCount() {
        return highStressCount;
    }
    
    public void setHighStressCount(int highStressCount) {
        this.highStressCount = highStressCount;
    }
    
    public int getTotalEmotions() {
        return totalEmotions;
    }
    
    public void setTotalEmotions(int totalEmotions) {
        this.totalEmotions = totalEmotions;
    }
    
    public List<String> getRepeatedTriggers() {
        return repeatedTriggers;
    }
    
    public void setRepeatedTriggers(List<String> repeatedTriggers) {
        this.repeatedTriggers = repeatedTriggers;
    }
    
    public boolean isOverthinkinDetected() {
        return overthinkinDetected;
    }
    
    public void setOverthinkinDetected(boolean overthinkinDetected) {
        this.overthinkinDetected = overthinkinDetected;
    }
    
    public List<String> getInsights() {
        return insights;
    }
    
    public void setInsights(List<String> insights) {
        this.insights = insights;
    }
    
    public void addInsight(String insight) {
        this.insights.add(insight);
    }
}
