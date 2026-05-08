package com.emovault.model;

import java.sql.Timestamp;

/**
 * Habit Model - Represents a user habit
 */
public class Habit {
    private int habitId;
    private int userId;
    private String name;
    private String description;
    private boolean active;
    private Timestamp createdDate;
    private int currentStreak;
    private int consistencyScore;

    public Habit() {
    }

    public Habit(int habitId, int userId, String name, String description, boolean active, Timestamp createdDate) {
        this.habitId = habitId;
        this.userId = userId;
        this.name = name;
        this.description = description;
        this.active = active;
        this.createdDate = createdDate;
        this.currentStreak = 0;
        this.consistencyScore = 0;
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

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
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

    public int getConsistencyScore() {
        return consistencyScore;
    }

    public void setConsistencyScore(int consistencyScore) {
        this.consistencyScore = consistencyScore;
    }

    @Override
    public String toString() {
        return "Habit{" +
                "habitId=" + habitId +
                ", userId=" + userId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", active=" + active +
                ", createdDate=" + createdDate +
                ", currentStreak=" + currentStreak +
                ", consistencyScore=" + consistencyScore +
                '}';
    }
}
