package com.emovault.model;

import java.sql.Timestamp;

public class Habit {
    private int habitId;
    private int userId;
    private String name;
    private String description;
    private String suggestedByTag;
    private boolean isActive;
    private Timestamp createdDate;
    private int currentStreak;
    private double consistencyScore;

    // Constructor
    public Habit() {}

    public Habit(int habitId, int userId, String name, String description, String suggestedByTag, boolean isActive, Timestamp createdDate) {
        this.habitId = habitId;
        this.userId = userId;
        this.name = name;
        this.description = description;
        this.suggestedByTag = suggestedByTag;
        this.isActive = isActive;
        this.createdDate = createdDate;
        this.currentStreak = 0;
        this.consistencyScore = 0.0;
    }

    // Getters and Setters
    public int getHabitId() {
        return habitId;
    }

    public void setHabitId(int habitId) {
        this.habitId = habitId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSuggestedByTag() {
        return suggestedByTag;
    }

    public void setSuggestedByTag(String suggestedByTag) {
        this.suggestedByTag = suggestedByTag;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public int getCurrentStreak() {
        return currentStreak;
    }

    public void setCurrentStreak(int currentStreak) {
        this.currentStreak = currentStreak;
    }

    public double getConsistencyScore() {
        return consistencyScore;
    }

    public void setConsistencyScore(double consistencyScore) {
        this.consistencyScore = consistencyScore;
    }

    @Override
    public String toString() {
        return "Habit{" +
                "habitId=" + habitId +
                ", userId=" + userId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", suggestedByTag='" + suggestedByTag + '\'' +
                ", isActive=" + isActive +
                ", createdDate=" + createdDate +
                ", currentStreak=" + currentStreak +
                ", consistencyScore=" + consistencyScore +
                '}';
    }
}
