package com.emovault.model;

import java.sql.Timestamp;

/**
 * TimeCapsule Model Class
 * Represents a time capsule message to future self
 */
public class TimeCapsule {
    private int capsuleId;
    private int userId;
    private String message;
    private String goal;
    private String mood; // Mood when capsule was created
    private Timestamp targetDate;
    private boolean opened;
    private String reflection;
    private String achievementStatus; // "Achieved", "Not Achieved", null
    private String reflectionMood; // Mood at time of reflection
    private Timestamp createdAt;
    private Timestamp openedAt;
    
    // Constructor
    public TimeCapsule() {
    }
    
    // Getters and Setters
    public int getCapsuleId() { return capsuleId; }
    public void setCapsuleId(int capsuleId) { this.capsuleId = capsuleId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getGoal() { return goal; }
    public void setGoal(String goal) { this.goal = goal; }
    
    public String getMood() { return mood; }
    public void setMood(String mood) { this.mood = mood; }
    
    public Timestamp getTargetDate() { return targetDate; }
    public void setTargetDate(Timestamp targetDate) { this.targetDate = targetDate; }
    
    public boolean isOpened() { return opened; }
    public void setOpened(boolean opened) { this.opened = opened; }
    
    public String getReflection() { return reflection; }
    public void setReflection(String reflection) { this.reflection = reflection; }
    
    public String getAchievementStatus() { return achievementStatus; }
    public void setAchievementStatus(String achievementStatus) { this.achievementStatus = achievementStatus; }
    
    public String getReflectionMood() { return reflectionMood; }
    public void setReflectionMood(String reflectionMood) { this.reflectionMood = reflectionMood; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getOpenedAt() { return openedAt; }
    public void setOpenedAt(Timestamp openedAt) { this.openedAt = openedAt; }
    
    // Helper method to check if capsule can be opened
    public boolean canBeOpened() {
        return !opened && System.currentTimeMillis() >= targetDate.getTime();
    }
    
    // Helper method to get status
    public String getStatus() {
        if (opened) return "Opened";
        if (canBeOpened()) return "Ready";
        return "Locked";
    }
}
