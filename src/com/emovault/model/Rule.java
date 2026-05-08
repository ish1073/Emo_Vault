package com.emovault.model;

import java.sql.Timestamp;

/**
 * Rule Model - Represents a system rule for behavior analysis
 * Format: IF [condition] → THEN [suggestion]
 */
public class Rule {
    private int ruleId;
    private int expertId;
    private String title;
    private String condition;  // e.g., "stress_high"
    private String conditionValue;  // e.g., ">=7"
    private String suggestion;  // e.g., "Suggest meditation"
    private String triggerEmotion;  // e.g., "Stressed"
    private int priority;  // 1-10, higher = applied first
    private boolean active;
    private String category;  // e.g., "stress_management", "habit_building"
    private int timesApplied;
    private double effectiveness;  // 0-1 scale
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructor
    public Rule() {}

    public Rule(int expertId, String title, String condition, String conditionValue, 
                String suggestion, String triggerEmotion, int priority, String category) {
        this.expertId = expertId;
        this.title = title;
        this.condition = condition;
        this.conditionValue = conditionValue;
        this.suggestion = suggestion;
        this.triggerEmotion = triggerEmotion;
        this.priority = priority;
        this.category = category;
        this.active = true;
        this.timesApplied = 0;
        this.effectiveness = 0.0;
    }

    // Getters and Setters
    public int getRuleId() { return ruleId; }
    public void setRuleId(int ruleId) { this.ruleId = ruleId; }

    public int getExpertId() { return expertId; }
    public void setExpertId(int expertId) { this.expertId = expertId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCondition() { return condition; }
    public void setCondition(String condition) { this.condition = condition; }

    public String getConditionValue() { return conditionValue; }
    public void setConditionValue(String conditionValue) { this.conditionValue = conditionValue; }

    public String getSuggestion() { return suggestion; }
    public void setSuggestion(String suggestion) { this.suggestion = suggestion; }

    public String getTriggerEmotion() { return triggerEmotion; }
    public void setTriggerEmotion(String triggerEmotion) { this.triggerEmotion = triggerEmotion; }

    public int getPriority() { return priority; }
    public void setPriority(int priority) { this.priority = priority; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public int getTimesApplied() { return timesApplied; }
    public void setTimesApplied(int timesApplied) { this.timesApplied = timesApplied; }

    public double getEffectiveness() { return effectiveness; }
    public void setEffectiveness(double effectiveness) { this.effectiveness = effectiveness; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
