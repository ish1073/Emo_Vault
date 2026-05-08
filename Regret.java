package com.emovault.model;

import java.sql.Timestamp;

public class Regret {
    private int regretId;
    private int userId;
    private String description;
    private String lessonLearned;
    private String tag;
    private Timestamp createdDate;

    // Constructor
    public Regret() {}

    public Regret(int regretId, int userId, String description, String lessonLearned, String tag, Timestamp createdDate) {
        this.regretId = regretId;
        this.userId = userId;
        this.description = description;
        this.lessonLearned = lessonLearned;
        this.tag = tag;
        this.createdDate = createdDate;
    }

    // Getters and Setters
    public int getRegretId() {
        return regretId;
    }

    public void setRegretId(int regretId) {
        this.regretId = regretId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLessonLearned() {
        return lessonLearned;
    }

    public void setLessonLearned(String lessonLearned) {
        this.lessonLearned = lessonLearned;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "Regret{" +
                "regretId=" + regretId +
                ", userId=" + userId +
                ", description='" + description + '\'' +
                ", lessonLearned='" + lessonLearned + '\'' +
                ", tag='" + tag + '\'' +
                ", createdDate=" + createdDate +
                '}';
    }
}
